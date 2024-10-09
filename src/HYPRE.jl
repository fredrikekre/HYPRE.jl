# SPDX-License-Identifier: MIT

module HYPRE

using MPI: MPI

export HYPREMatrix, HYPREVector


# Clang.jl auto-generated bindings and some manual methods
include("LibHYPRE.jl")
using .LibHYPRE
using .LibHYPRE: @check

# Internal namespace to hide utility functions
include("Internals.jl")


"""
    Init(; finalize_atexit=true)

Wrapper around `HYPRE_Init`. If `finalize_atexit` is `true` a Julia exit hook is added,
which calls `HYPRE_Finalize`. This method will also call `MPI.Init` unless MPI is already
initialized.

**Note**: This function *must* be called before using HYPRE functions.
"""
function Init(; finalize_atexit=true)
    if !(MPI.Initialized())
        MPI.Init()
    end
    # TODO: Check if already initialized?
    HYPRE_Init()
    if finalize_atexit
        # TODO: MPI only calls the finalizer if not exiting due to a Julia exeption. Does
        #       the same reasoning apply here?
        atexit() do
            # Finalize any HYPRE objects that are still alive
            foreach(finalize, keys(Internals.HYPRE_OBJECTS))
            # Finalize the library
            HYPRE_Finalize()
        end
    end
    return nothing
end


###############
# HYPREMatrix #
###############

mutable struct HYPREMatrix # <: AbstractMatrix{HYPRE_Complex}
    #= const =# comm::MPI.Comm
    #= const =# ilower::HYPRE_BigInt
    #= const =# iupper::HYPRE_BigInt
    #= const =# jlower::HYPRE_BigInt
    #= const =# jupper::HYPRE_BigInt
    ijmatrix::HYPRE_IJMatrix
    parmatrix::HYPRE_ParCSRMatrix
end

# Defining unsafe_convert enables ccall to automatically convert A::HYPREMatrix to
# HYPRE_IJMatrix and HYPRE_ParCSRMatrix while also making sure A won't be GC'd and
# finalized.
Base.unsafe_convert(::Type{HYPRE_IJMatrix}, A::HYPREMatrix) = A.ijmatrix
Base.unsafe_convert(::Type{HYPRE_ParCSRMatrix}, A::HYPREMatrix) = A.parmatrix

function HYPREMatrix(comm::MPI.Comm, ilower::Integer,        iupper::Integer,
                                     jlower::Integer=ilower, jupper::Integer=iupper)
    # Create the IJ matrix
    A = HYPREMatrix(comm, ilower, iupper, jlower, jupper, C_NULL, C_NULL)
    ijmatrix_ref = Ref{HYPRE_IJMatrix}(C_NULL)
    @check HYPRE_IJMatrixCreate(comm, ilower, iupper, ilower, iupper, ijmatrix_ref)
    A.ijmatrix = ijmatrix_ref[]
    # Attach a finalizer
    finalizer(A) do x
        if x.ijmatrix != C_NULL
            HYPRE_IJMatrixDestroy(x)
            x.ijmatrix = x.parmatrix = C_NULL
        end
    end
    push!(Internals.HYPRE_OBJECTS, A => nothing)
    # Set storage type
    @check HYPRE_IJMatrixSetObjectType(A, HYPRE_PARCSR)
    # Initialize to make ready for setting values
    @check HYPRE_IJMatrixInitialize(A)
    return A
end

# Finalize the matrix and fetch the assembled matrix
# This should be called after setting all the values
function Internals.assemble_matrix(A::HYPREMatrix)
    # Finalize after setting all values
    @check HYPRE_IJMatrixAssemble(A)
    # Fetch the assembled CSR matrix
    parmatrix_ref = Ref{Ptr{Cvoid}}(C_NULL)
    @check HYPRE_IJMatrixGetObject(A, parmatrix_ref)
    A.parmatrix = convert(Ptr{HYPRE_ParCSRMatrix}, parmatrix_ref[])
    return A
end

###############
# HYPREVector #
###############

mutable struct HYPREVector # <: AbstractVector{HYPRE_Complex}
    #= const =# comm::MPI.Comm
    #= const =# ilower::HYPRE_BigInt
    #= const =# iupper::HYPRE_BigInt
    ijvector::HYPRE_IJVector
    parvector::HYPRE_ParVector
end

# Defining unsafe_convert enables ccall to automatically convert b::HYPREVector to
# HYPRE_IJVector and HYPRE_ParVector while also making sure b won't be GC'd and finalized.
Base.unsafe_convert(::Type{HYPRE_IJVector}, b::HYPREVector) = b.ijvector
Base.unsafe_convert(::Type{HYPRE_ParVector}, b::HYPREVector) = b.parvector

function HYPREVector(comm::MPI.Comm, ilower::Integer, iupper::Integer)
    # Create the IJ vector
    b = HYPREVector(comm, ilower, iupper, C_NULL, C_NULL)
    ijvector_ref = Ref{HYPRE_IJVector}(C_NULL)
    @check HYPRE_IJVectorCreate(comm, ilower, iupper, ijvector_ref)
    b.ijvector = ijvector_ref[]
    # Attach a finalizer
    finalizer(b) do x
        if x.ijvector != C_NULL
            HYPRE_IJVectorDestroy(x)
            x.ijvector = x.parvector = C_NULL
        end
    end
    push!(Internals.HYPRE_OBJECTS, b => nothing)
    # Set storage type
    @check HYPRE_IJVectorSetObjectType(b, HYPRE_PARCSR)
    # Initialize to make ready for setting values
    @check HYPRE_IJVectorInitialize(b)
    return b
end

function Internals.assemble_vector(b::HYPREVector)
    # Finalize after setting all values
    @check HYPRE_IJVectorAssemble(b)
    # Fetch the assembled vector
    parvector_ref = Ref{Ptr{Cvoid}}(C_NULL)
    @check HYPRE_IJVectorGetObject(b, parvector_ref)
    b.parvector = convert(Ptr{HYPRE_ParVector}, parvector_ref[])
    return b
end

function Internals.get_proc_rows(b::HYPREVector)
    # ilower_ref = Ref{HYPRE_BigInt}()
    # iupper_ref = Ref{HYPRE_BigInt}()
    # @check HYPRE_IJVectorGetLocalRange(b, ilower_ref, iupper_ref)
    # ilower = ilower_ref[]
    # iupper = iupper_ref[]
    # return ilower, iupper
    return b.ilower, b.iupper
end

function Internals.get_comm(b::HYPREVector)
    # # The MPI communicator is (currently) the first field of the struct:
    # # https://github.com/hypre-space/hypre/blob/48de53e675af0e23baf61caa73d89fd9f478f453/src/IJ_mv/IJ_vector.h#L23
    # # Fingers crossed this doesn't change!
    # @assert b.ijvector != C_NULL
    # comm = unsafe_load(Ptr{MPI.Comm}(b.ijvector))
    # return comm
    return b.comm
end

function Base.zero(b::HYPREVector)
    jlower, jupper = Internals.get_proc_rows(b)
    comm = Internals.get_comm(b)
    x = HYPREVector(comm, jlower, jupper)
    # TODO All values 0 by default? Looks like it... Work in progress patch to hypre to
    #      support IJVectorSetConstantValues analoguous to IJMatrixSetConstantValues.
    nvalues = jupper - jlower + 1
    indices = collect(HYPRE_BigInt, jlower:jupper)
    values = zeros(HYPRE_Complex, nvalues)
    @check HYPRE_IJVectorSetValues(x, nvalues, indices, values)
    # Finalize and return
    Internals.assemble_vector(x)
    return x
end


#########################
# Vector -> HYPREVector #
#########################

function Internals.check_n_rows(A, ilower, iupper)
    if size(A, 1) != (iupper - ilower + 1)
        throw(ArgumentError("number of rows in matrix does not match global start/end rows ilower and iupper"))
    end
end

function Internals.to_hypre_data(x::Vector, ilower, iupper)
    Internals.check_n_rows(x, ilower, iupper)
    indices = collect(HYPRE_BigInt, ilower:iupper)
    values = convert(Vector{HYPRE_Complex}, x)
    return HYPRE_Int(length(indices)), indices, values
end
# TODO: Internals.to_hypre_data(x::SparseVector, ilower, iupper) (?)

function HYPREVector(comm::MPI.Comm, x::Vector, ilower, iupper)
    b = HYPREVector(comm, ilower, iupper)
    nvalues, indices, values = Internals.to_hypre_data(x, ilower, iupper)
    @check HYPRE_IJVectorSetValues(b, nvalues, indices, values)
    Internals.assemble_vector(b)
    return b
end

HYPREVector(x::Vector, ilower=1, iupper=length(x)) =
    HYPREVector(MPI.COMM_SELF, x, ilower, iupper)

# TODO: Other eltypes could be support by using a intermediate buffer
function Base.copy!(dst::Vector{HYPRE_Complex}, src::HYPREVector)
    ilower, iupper = Internals.get_proc_rows(src)
    nvalues = iupper - ilower + 1
    if length(dst) != nvalues
        throw(ArgumentError("length of dst and src does not match"))
    end
    indices = collect(HYPRE_BigInt, ilower:iupper)
    @check HYPRE_IJVectorGetValues(src, nvalues, indices, dst)
    return dst
end

function Base.copy!(dst::HYPREVector, src::Vector{HYPRE_Complex})
    ilower, iupper = Internals.get_proc_rows(dst)
    nvalues = iupper - ilower + 1
    if length(src) != nvalues
        throw(ArgumentError("length of dst and src does not match"))
    end
    # Re-initialize the vector
    @check HYPRE_IJVectorInitialize(dst)
    # Set all the values
    indices = collect(HYPRE_BigInt, ilower:iupper)
    @check HYPRE_IJVectorSetValues(dst, nvalues, indices, src)
    # TODO: It shouldn't be necessary to assemble here since we only set owned rows (?)
    # @check HYPRE_IJVectorAssemble(dst)
    # TODO: Necessary to recreate the ParVector? Running some examples it seems like it is
    # not needed.
    return dst
end


####################
## HYPREAssembler ##
####################

struct HYPREMatrixAssembler
    A::HYPREMatrix
    ncols::Vector{HYPRE_Int}
    rows::Vector{HYPRE_BigInt}
    cols::Vector{HYPRE_BigInt}
    values::Vector{HYPRE_Complex}
end

struct HYPREVectorAssembler
    b::HYPREVector
    indices::Vector{HYPRE_BigInt}
    values::Vector{HYPRE_Complex}
end

struct HYPREAssembler
    A::HYPREMatrixAssembler
    b::HYPREVectorAssembler
end

"""
    HYPRE.start_assemble!(A::HYPREMatrix)                 -> HYPREMatrixAssembler
    HYPRE.start_assemble!(b::HYPREVector)                 -> HYPREVectorAssembler
    HYPRE.start_assemble!(A::HYPREMatrix, b::HYPREVector) -> HYPREAssembler

Initialize a new assembly for matrix `A`, vector `b`, or for both. This zeroes out any
previous data in the arrays. Return a `HYPREAssembler` with allocated data buffers needed to
perform the assembly efficiently.

See also: [`HYPRE.assemble!`](@ref), [`HYPRE.finish_assemble!`](@ref).
"""
start_assemble!

function start_assemble!(A::HYPREMatrix)
    if A.parmatrix != C_NULL
        # This matrix have been assembled before, reset to 0
        @check HYPRE_IJMatrixSetConstantValues(A, 0)
    end
    @check HYPRE_IJMatrixInitialize(A)
    return HYPREMatrixAssembler(A, HYPRE_Int[], HYPRE_BigInt[], HYPRE_BigInt[], HYPRE_Complex[])
end

function start_assemble!(b::HYPREVector)
    if b.parvector != C_NULL
        # This vector have been assembled before, reset to 0
        # See https://github.com/hypre-space/hypre/pull/689
        # @check HYPRE_IJVectorSetConstantValues(b, 0)
    end
    @check HYPRE_IJVectorInitialize(b)
    if b.parvector != C_NULL
        nvalues = HYPRE_Int(b.iupper - b.ilower + 1)
        indices = collect(HYPRE_BigInt, b.ilower:b.iupper)
        values = zeros(HYPRE_Complex, nvalues)
        @check HYPRE_IJVectorSetValues(b, nvalues, indices, values)
        # TODO: Do I need to assemble here?
    end
    return HYPREVectorAssembler(b, HYPRE_BigInt[], HYPRE_Complex[])
end

function start_assemble!(A::HYPREMatrix, b::HYPREVector)
    return HYPREAssembler(start_assemble!(A), start_assemble!(b))
end

"""
    HYPRE.assemble!(A::HYPREMatrixAssembler, i, j, a::Matrix)
    HYPRE.assemble!(A::HYPREVectorAssembler, i,    b::Vector)
    HYPRE.assemble!(A::HYPREAssembler,       ij,   a::Matrix, b::Vector)

Assemble (by adding) matrix contribution `a`, vector contribution `b`, into the underlying
array(s) of the assembler at global row indices `i` and column indices `j`.

This is roughly equivalent to:
```julia
# A.A::HYPREMatrix
A.A[i, j] += a

# A.b::HYPREVector
A.b[i] += b
```

See also: [`HYPRE.start_assemble!`](@ref), [`HYPRE.finish_assemble!`](@ref).
"""
assemble!

function assemble!(A::HYPREMatrixAssembler, i::Vector, j::Vector, a::Matrix)
    nrows, ncols, rows, cols, values = Internals.to_hypre_data(A, a, i, j)
    @check HYPRE_IJMatrixAddToValues(A.A, nrows, ncols, rows, cols, values)
    return A
end
@deprecate assemble!(A::HYPREMatrixAssembler, ij::Vector, a::Matrix) assemble!(A, ij, ij, a) false

function assemble!(A::HYPREVectorAssembler, ij::Vector, a::Vector)
    nvalues, indices, values = Internals.to_hypre_data(A, a, ij)
    @check HYPRE_IJVectorAddToValues(A.b, nvalues, indices, values)
    return A
end

function assemble!(A::HYPREAssembler, ij::Vector, a::Matrix, b::Vector)
    assemble!(A.A, ij, ij, a)
    assemble!(A.b, ij, b)
    return A
end

function Internals.to_hypre_data(A::HYPREMatrixAssembler, a::Matrix, I::Vector, J::Vector)
    size(a, 1) == length(I) || error("mismatching number of rows")
    size(a, 2) == length(J) || error("mismatching number of cols")
    nrows = HYPRE_Int(length(I))
    # Resize cache vectors
    ncols = resize!(A.ncols, nrows)
    rows = resize!(A.rows, nrows)
    cols = resize!(A.cols, length(a))
    values = resize!(A.values, length(a))
    # Fill vectors
    ncols = fill!(ncols, HYPRE_Int(length(J)))
    copyto!(rows, I)
    idx = 0
    for i in 1:length(I), j in 1:length(J)
        idx += 1
        cols[idx] = J[j]
        values[idx] = a[i, j]
    end
    @assert idx == length(a)
    @assert nrows == length(ncols) == length(rows)
    return nrows, ncols, rows, cols, values
end

function Internals.to_hypre_data(A::HYPREVectorAssembler, b::Vector, I::Vector)
    length(b) == length(I) || error("mismatching number of entries")
    nvalues = HYPRE_Int(length(I))
    # Resize cache vectors
    indices = resize!(A.indices, nvalues)
    values = resize!(A.values, nvalues)
    # Fill vectors
    copyto!(indices, I)
    copyto!(values, b)
    return nvalues, indices, values
end

"""
    HYPRE.finish_assemble!(A::HYPREMatrixAssembler)
    HYPRE.finish_assemble!(A::HYPREVectorAssembler)
    HYPRE.finish_assemble!(A::HYPREAssembler)

Finish the assembly. This synchronizes the data between processors.
"""
finish_assemble!

function finish_assemble!(A::HYPREMatrixAssembler)
    Internals.assemble_matrix(A.A)
    return A.A
end

function finish_assemble!(A::HYPREVectorAssembler)
    Internals.assemble_vector(A.b)
    return A.b
end

function finish_assemble!(A::HYPREAssembler)
    return finish_assemble!(A.A), finish_assemble!(A.b)
end


######################
## Solver interface ##
######################

include("solvers.jl")
include("solver_options.jl")

end # module HYPRE
