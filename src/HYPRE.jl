# SPDX-License-Identifier: MIT

module HYPRE

using MPI: MPI
using PartitionedArrays: IndexRange, MPIData, PSparseMatrix, PVector, PartitionedArrays,
    SequentialData, map_parts
using SparseArrays: SparseArrays, SparseMatrixCSC, nnz, nonzeros, nzrange, rowvals
using SparseMatricesCSR: SparseMatrixCSR, colvals, getrowptr

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
        atexit(HYPRE_Finalize)
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

function HYPREMatrix(comm::MPI.Comm, ilower::Integer,        iupper::Integer,
                                     jlower::Integer=ilower, jupper::Integer=iupper)
    # Create the IJ matrix
    A = HYPREMatrix(comm, ilower, iupper, jlower, jupper, C_NULL, C_NULL)
    ijmatrix_ref = Ref{HYPRE_IJMatrix}(C_NULL)
    @check HYPRE_IJMatrixCreate(comm, ilower, iupper, ilower, iupper, ijmatrix_ref)
    A.ijmatrix = ijmatrix_ref[]
    # Attach a finalizer
    finalizer(x -> HYPRE_IJMatrixDestroy(x.ijmatrix), A)
    # Set storage type
    @check HYPRE_IJMatrixSetObjectType(A.ijmatrix, HYPRE_PARCSR)
    # Initialize to make ready for setting values
    @check HYPRE_IJMatrixInitialize(A.ijmatrix)
    return A
end

# Finalize the matrix and fetch the assembled matrix
# This should be called after setting all the values
function Internals.assemble_matrix(A::HYPREMatrix)
    # Finalize after setting all values
    @check HYPRE_IJMatrixAssemble(A.ijmatrix)
    # Fetch the assembled CSR matrix
    parmatrix_ref = Ref{Ptr{Cvoid}}(C_NULL)
    @check HYPRE_IJMatrixGetObject(A.ijmatrix, parmatrix_ref)
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

function HYPREVector(comm::MPI.Comm, ilower::Integer, iupper::Integer)
    # Create the IJ vector
    b = HYPREVector(comm, ilower, iupper, C_NULL, C_NULL)
    ijvector_ref = Ref{HYPRE_IJVector}(C_NULL)
    @check HYPRE_IJVectorCreate(comm, ilower, iupper, ijvector_ref)
    b.ijvector = ijvector_ref[]
    # Attach a finalizer
    finalizer(x -> HYPRE_IJVectorDestroy(x.ijvector), b)
    # Set storage type
    @check HYPRE_IJVectorSetObjectType(b.ijvector, HYPRE_PARCSR)
    # Initialize to make ready for setting values
    @check HYPRE_IJVectorInitialize(b.ijvector)
    return b
end

function Internals.assemble_vector(b::HYPREVector)
    # Finalize after setting all values
    @check HYPRE_IJVectorAssemble(b.ijvector)
    # Fetch the assembled vector
    parvector_ref = Ref{Ptr{Cvoid}}(C_NULL)
    @check HYPRE_IJVectorGetObject(b.ijvector, parvector_ref)
    b.parvector = convert(Ptr{HYPRE_ParVector}, parvector_ref[])
    return b
end

function Internals.get_proc_rows(b::HYPREVector)
    # ilower_ref = Ref{HYPRE_BigInt}()
    # iupper_ref = Ref{HYPRE_BigInt}()
    # @check HYPRE_IJVectorGetLocalRange(b.ijvector, ilower_ref, iupper_ref)
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
    @check HYPRE_IJVectorSetValues(x.ijvector, nvalues, indices, values)
    # Finalize and return
    Internals.assemble_vector(x)
    return x
end

######################################
# SparseMatrixCS(C|R) -> HYPREMatrix #
######################################

function Internals.check_n_rows(A, ilower, iupper)
    if size(A, 1) != (iupper - ilower + 1)
        throw(ArgumentError("number of rows in matrix does not match global start/end rows ilower and iupper"))
    end
end

function Internals.to_hypre_data(A::SparseMatrixCSC, ilower, iupper)
    Internals.check_n_rows(A, ilower, iupper)
    nnz = SparseArrays.nnz(A)
    A_rows = rowvals(A)
    A_vals = nonzeros(A)

    # Initialize the data buffers HYPRE wants
    nrows = HYPRE_Int(iupper - ilower + 1)      # Total number of rows
    ncols = zeros(HYPRE_Int, nrows)             # Number of colums for each row
    rows = collect(HYPRE_BigInt, ilower:iupper) # The row indices
    cols = Vector{HYPRE_BigInt}(undef, nnz)     # The column indices
    values = Vector{HYPRE_Complex}(undef, nnz)  # The values

    # First pass to count nnz per row
    @inbounds for j in 1:size(A, 2)
        for i in nzrange(A, j)
            row = A_rows[i]
            ncols[row] += 1
        end
    end

    # Keep track of the last index used for every row
    lastinds = zeros(Int, nrows)
    cumsum!((@view lastinds[2:end]), (@view ncols[1:end-1]))

    # Second pass to populate the output
    @inbounds for j in 1:size(A, 2)
        for i in nzrange(A, j)
            row = A_rows[i]
            k = lastinds[row] += 1
            val = A_vals[i]
            cols[k] = j
            values[k] = val
        end
    end
    return nrows, ncols, rows, cols, values
end

function Internals.to_hypre_data(A::SparseMatrixCSR, ilower, iupper)
    Internals.check_n_rows(A, ilower, iupper)
    nnz = SparseArrays.nnz(A)
    A_cols = colvals(A)
    A_vals = nonzeros(A)

    # Initialize the data buffers HYPRE wants
    nrows = HYPRE_Int(iupper - ilower + 1)      # Total number of rows
    ncols = Vector{HYPRE_Int}(undef, nrows)     # Number of colums for each row
    rows = collect(HYPRE_BigInt, ilower:iupper) # The row indices
    cols = Vector{HYPRE_BigInt}(undef, nnz)     # The column indices
    values = Vector{HYPRE_Complex}(undef, nnz)  # The values

    # Loop over the rows and collect all values
    k = 0
    @inbounds for i in 1:size(A, 1)
        nzr = nzrange(A, i)
        ncols[i] = length(nzr)
        for j in nzr
            k += 1
            col = A_cols[j]
            val = A_vals[j]
            cols[k] = col
            values[k] = val
        end
    end
    @assert nnz == k
    return nrows, ncols, rows, cols, values
end

function HYPREMatrix(comm::MPI.Comm, B::Union{SparseMatrixCSC,SparseMatrixCSR}, ilower, iupper)
    A = HYPREMatrix(comm, ilower, iupper)
    nrows, ncols, rows, cols, values = Internals.to_hypre_data(B, ilower, iupper)
    @check HYPRE_IJMatrixSetValues(A.ijmatrix, nrows, ncols, rows, cols, values)
    Internals.assemble_matrix(A)
    return A
end

HYPREMatrix(B::Union{SparseMatrixCSC,SparseMatrixCSR}, ilower=1, iupper=size(B, 1)) =
    HYPREMatrix(MPI.COMM_SELF, B, ilower, iupper)

#########################
# Vector -> HYPREVector #
#########################

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
    @check HYPRE_IJVectorSetValues(b.ijvector, nvalues, indices, values)
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
    @check HYPRE_IJVectorGetValues(src.ijvector, nvalues, indices, dst)
    return dst
end

function Base.copy!(dst::HYPREVector, src::Vector{HYPRE_Complex})
    ilower, iupper = Internals.get_proc_rows(dst)
    nvalues = iupper - ilower + 1
    if length(src) != nvalues
        throw(ArgumentError("length of dst and src does not match"))
    end
    # Re-initialize the vector
    @check HYPRE_IJVectorInitialize(dst.ijvector)
    # Set all the values
    indices = collect(HYPRE_BigInt, ilower:iupper)
    @check HYPRE_IJVectorSetValues(dst.ijvector, nvalues, indices, src)
    # TODO: It shouldn't be necessary to assemble here since we only set owned rows (?)
    # @check HYPRE_IJVectorAssemble(dst.ijvector)
    # TODO: Necessary to recreate the ParVector? Running some examples it seems like it is
    # not needed.
    return dst
end

##################################################
# PartitionedArrays.PSparseMatrix -> HYPREMatrix #
##################################################

# TODO: This has some duplicated code with to_hypre_data(::SparseMatrixCSC, ilower, iupper)
function Internals.to_hypre_data(A::SparseMatrixCSC, r::IndexRange, c::IndexRange)
    @assert r.oid_to_lid isa UnitRange && r.oid_to_lid.start == 1

    ilower = r.lid_to_gid[r.oid_to_lid.start]
    iupper = r.lid_to_gid[r.oid_to_lid.stop]
    a_rows = rowvals(A)
    a_vals = nonzeros(A)

    # Initialize the data buffers HYPRE wants
    nrows = HYPRE_Int(iupper - ilower + 1)      # Total number of rows
    ncols = zeros(HYPRE_Int, nrows)             # Number of colums for each row
    rows = collect(HYPRE_BigInt, ilower:iupper) # The row indices
    # cols = Vector{HYPRE_BigInt}(undef, nnz)     # The column indices
    # values = Vector{HYPRE_Complex}(undef, nnz)  # The values

    # First pass to count nnz per row (note that the fact that columns are permuted
    # doesn't matter for this pass)
    a_rows = rowvals(A)
    a_vals = nonzeros(A)
    @inbounds for j in 1:size(A, 2)
        for i in nzrange(A, j)
            row = a_rows[i]
            row > r.oid_to_lid.stop && continue # Skip ghost rows
            # grow = r.lid_to_gid[lrow]
            ncols[row] += 1
        end
    end

    # Initialize remaining buffers now that nnz is known
    nnz = sum(ncols)
    cols = Vector{HYPRE_BigInt}(undef, nnz)
    values = Vector{HYPRE_Complex}(undef, nnz)

    # Keep track of the last index used for every row
    lastinds = zeros(Int, nrows)
    cumsum!((@view lastinds[2:end]), (@view ncols[1:end-1]))

    # Second pass to populate the output -- here we need to take care of the permutation
    # of columns. TODO: Problem that they are not sorted?
    @inbounds for j in 1:size(A, 2)
        for i in nzrange(A, j)
            row = a_rows[i]
            row > r.oid_to_lid.stop && continue # Skip ghost rows
            k = lastinds[row] += 1
            val = a_vals[i]
            cols[k] = c.lid_to_gid[j]
            values[k] = val
        end
    end
    return nrows, ncols, rows, cols, values
end

# TODO: Possibly this can be optimized if it is possible to pass overlong vectors to HYPRE.
#       At least values should be possible to directly share, but cols needs to translated
#       to global ids.
function Internals.to_hypre_data(A::SparseMatrixCSR, r::IndexRange, c::IndexRange)
    @assert r.oid_to_lid isa UnitRange && r.oid_to_lid.start == 1

    ilower = r.lid_to_gid[r.oid_to_lid.start]
    iupper = r.lid_to_gid[r.oid_to_lid.stop]
    a_cols = colvals(A)
    a_vals = nonzeros(A)
    nnz = getrowptr(A)[r.oid_to_lid.stop + 1] - 1

    # Initialize the data buffers HYPRE wants
    nrows = HYPRE_Int(iupper - ilower + 1)      # Total number of rows
    ncols = zeros(HYPRE_Int, nrows)             # Number of colums for each row
    rows = collect(HYPRE_BigInt, ilower:iupper) # The row indices
    cols = Vector{HYPRE_BigInt}(undef, nnz)     # The column indices
    values = Vector{HYPRE_Complex}(undef, nnz)  # The values

    # Loop over the (owned) rows and collect all values
    k = 0
    @inbounds for i in r.oid_to_lid
        nzr = nzrange(A, i)
        ncols[i] = length(nzr)
        for j in nzr
            k += 1
            col = a_cols[j]
            val = a_vals[j]
            cols[k] = c.lid_to_gid[col]
            values[k] = val
        end
    end
    @assert nnz == k
    return nrows, ncols, rows, cols, values
end

function Internals.get_comm(A::Union{PSparseMatrix{<:Any,<:M}, PVector{<:Any,<:M}}) where M <: MPIData
    return A.rows.partition.comm
end
Internals.get_comm(_::Union{PSparseMatrix,PVector}) = MPI.COMM_SELF

function Internals.get_proc_rows(A::Union{PSparseMatrix{<:Any,<:M}, PVector{<:Any,<:M}}) where M <: MPIData
    r = A.rows.partition.part
    ilower::HYPRE_BigInt = r.lid_to_gid[r.oid_to_lid[1]]
    iupper::HYPRE_BigInt = r.lid_to_gid[r.oid_to_lid[end]]
    return ilower, iupper
end
function Internals.get_proc_rows(A::Union{PSparseMatrix{<:Any,<:S}, PVector{<:Any,<:S}}) where S <: SequentialData
    ilower::HYPRE_BigInt = typemax(HYPRE_BigInt)
    iupper::HYPRE_BigInt = typemin(HYPRE_BigInt)
    for r in A.rows.partition.parts
        ilower = min(r.lid_to_gid[r.oid_to_lid[1]], ilower)
        iupper = max(r.lid_to_gid[r.oid_to_lid[end]], iupper)
    end
    return ilower, iupper
end

function HYPREMatrix(B::PSparseMatrix)
    # Use the same communicator as the matrix
    comm = Internals.get_comm(B)
    # Fetch rows owned by this process
    ilower, iupper = Internals.get_proc_rows(B)
    # Create the IJ matrix
    A = HYPREMatrix(comm, ilower, iupper)
    # Set all the values
    map_parts(B.values, B.rows.partition, B.cols.partition) do Bv, Br, Bc
        nrows, ncols, rows, cols, values = Internals.to_hypre_data(Bv, Br, Bc)
        @check HYPRE_IJMatrixSetValues(A.ijmatrix, nrows, ncols, rows, cols, values)
        return nothing
    end
    # Finalize
    Internals.assemble_matrix(A)
    return A
end

############################################
# PartitionedArrays.PVector -> HYPREVector #
############################################

function HYPREVector(v::PVector)
    # Use the same communicator as the matrix
    comm = Internals.get_comm(v)
    # Fetch rows owned by this process
    ilower, iupper = Internals.get_proc_rows(v)
    # Create the IJ vector
    b = HYPREVector(comm, ilower, iupper)
    # Set all the values
    map_parts(v.values, v.owned_values, v.rows.partition) do _, vo, vr
        ilower_part = vr.lid_to_gid[vr.oid_to_lid.start]
        iupper_part = vr.lid_to_gid[vr.oid_to_lid.stop]

        # Option 1: Set all values
        nvalues = HYPRE_Int(iupper_part - ilower_part + 1)
        indices = collect(HYPRE_BigInt, ilower_part:iupper_part)
        # TODO: Could probably just pass the full vector even if it is too long
        # values = convert(Vector{HYPRE_Complex}, vv)
        values = collect(HYPRE_Complex, vo)

        # # Option 2: Set only non-zeros
        # indices = HYPRE_BigInt[]
        # values = HYPRE_Complex[]
        # for (i, vi) in zip(ilower_part:iupper_part, vo)
        #     if !iszero(vi)
        #         push!(indices, i)
        #         push!(values, vi)
        #     end
        # end
        # nvalues = length(indices)

        @check HYPRE_IJVectorSetValues(b.ijvector, nvalues, indices, values)
        return nothing
    end
    # Finalize
    Internals.assemble_vector(b)
    return b
end

function Internals.copy_check(dst::HYPREVector, src::PVector)
    il_dst, iu_dst = Internals.get_proc_rows(dst)
    il_src, iu_src = Internals.get_proc_rows(src)
    if il_dst != il_src && iu_dst != iu_src
        # TODO: Why require this?
        throw(ArgumentError(
            "row owner mismatch between dst ($(il_dst:iu_dst)) and src ($(il_dst:iu_dst))"
        ))
    end
end

# TODO: Other eltypes could be support by using a intermediate buffer
function Base.copy!(dst::PVector{HYPRE_Complex}, src::HYPREVector)
    Internals.copy_check(src, dst)
    map_parts(dst.values, dst.owned_values, dst.rows.partition) do vv, _, vr
        il_src_part = vr.lid_to_gid[vr.oid_to_lid.start]
        iu_src_part = vr.lid_to_gid[vr.oid_to_lid.stop]
        nvalues = HYPRE_Int(iu_src_part - il_src_part + 1)
        indices = collect(HYPRE_BigInt, il_src_part:iu_src_part)

        # Assumption: the dst vector is assembled, and should thus have 0s on the ghost
        # entries (??). If this is not true, we must call fill!(vv, 0) here. This should be
        # fairly cheap anyway, so might as well do it...
        fill!(vv, 0)

        # TODO: Safe to use vv here? Owned values are always first?
        @check HYPRE_IJVectorGetValues(src.ijvector, nvalues, indices, vv)
    end
    return dst
end

function Base.copy!(dst::HYPREVector, src::PVector{HYPRE_Complex})
    Internals.copy_check(dst, src)
    # Re-initialize the vector
    @check HYPRE_IJVectorInitialize(dst.ijvector)
    map_parts(src.values, src.owned_values, src.rows.partition) do vv, _, vr
        ilower_src_part = vr.lid_to_gid[vr.oid_to_lid.start]
        iupper_src_part = vr.lid_to_gid[vr.oid_to_lid.stop]
        nvalues = HYPRE_Int(iupper_src_part - ilower_src_part + 1)
        indices = collect(HYPRE_BigInt, ilower_src_part:iupper_src_part)
        # TODO: Safe to use vv here? Owned values are always first?
        @check HYPRE_IJVectorSetValues(dst.ijvector, nvalues, indices, vv)
    end
    # TODO: It shouldn't be necessary to assemble here since we only set owned rows (?)
    # @check HYPRE_IJVectorAssemble(dst.ijvector)
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
        @check HYPRE_IJMatrixSetConstantValues(A.ijmatrix, 0)
    end
    @check HYPRE_IJMatrixInitialize(A.ijmatrix)
    return HYPREMatrixAssembler(A, HYPRE_Int[], HYPRE_BigInt[], HYPRE_BigInt[], HYPRE_Complex[])
end

function start_assemble!(b::HYPREVector)
    if b.parvector != C_NULL
        # This vector have been assembled before, reset to 0
        # See https://github.com/hypre-space/hypre/pull/689
        # @check HYPRE_IJVectorSetConstantValues(b.ijvector, 0)
    end
    @check HYPRE_IJVectorInitialize(b.ijvector)
    if b.parvector != C_NULL
        nvalues = HYPRE_Int(b.iupper - b.ilower + 1)
        indices = collect(HYPRE_BigInt, b.ilower:b.iupper)
        values = zeros(HYPRE_Complex, nvalues)
        @check HYPRE_IJVectorSetValues(b.ijvector, nvalues, indices, values)
        # TODO: Do I need to assemble here?
    end
    return HYPREVectorAssembler(b, HYPRE_BigInt[], HYPRE_Complex[])
end

function start_assemble!(A::HYPREMatrix, b::HYPREVector)
    return HYPREAssembler(start_assemble!(A), start_assemble!(b))
end

"""
    HYPRE.assemble!(A::HYPREMatrixAssembler, ij, a::Matrix)
    HYPRE.assemble!(A::HYPREVectorAssembler, ij, b::Vector)
    HYPRE.assemble!(A::HYPREAssembler,       ij, a::Matrix, b::Vector)

Assemble (by adding) matrix contribution `a`, vector contribution `b`, into the underlying
array(s) of the assembler at global row and column indices `ij`.

This is roughly equivalent to:
```julia
# A.A::HYPREMatrix
A.A[ij, ij] += a

# A.b::HYPREVector
A.b[ij] += b
```

See also: [`HYPRE.start_assemble!`](@ref), [`HYPRE.finish_assemble!`](@ref).
"""
assemble!

function assemble!(A::HYPREMatrixAssembler, ij::Vector, a::Matrix)
    nrows, ncols, rows, cols, values = Internals.to_hypre_data(A, a, ij, ij)
    @check HYPRE_IJMatrixAddToValues(A.A.ijmatrix, nrows, ncols, rows, cols, values)
    return A
end

function assemble!(A::HYPREVectorAssembler, ij::Vector, a::Vector)
    nvalues, indices, values = Internals.to_hypre_data(A, a, ij)
    @check HYPRE_IJVectorAddToValues(A.b.ijvector, nvalues, indices, values)
    return A
end

function assemble!(A::HYPREAssembler, ij::Vector, a::Matrix, b::Vector)
    assemble!(A.A, ij, a)
    assemble!(A.b, ij, b)
    return A
end

function Internals.to_hypre_data(A::HYPREMatrixAssembler, a::Matrix, I::Vector, J::Vector)
    size(a, 1) == length(I) || error("mismatching number of rows")
    size(a, 2) == length(J) || error("mismatch number of cols")
    nrows = HYPRE_Int(length(I))
    # Resize cache vectors
    ncols = resize!(A.ncols, nrows)
    rows = resize!(A.rows, length(a))
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
