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
    IJMatrix::HYPRE_IJMatrix
    ParCSRMatrix::HYPRE_ParCSRMatrix
end

function HYPREMatrix(comm::MPI.Comm, ilower::Integer,        iupper::Integer,
                                     jlower::Integer=ilower, jupper::Integer=iupper)
    # Create the IJ matrix
    A = HYPREMatrix(comm, ilower, iupper, jlower, jupper, C_NULL, C_NULL)
    IJMatrixRef = Ref{HYPRE_IJMatrix}(C_NULL)
    @check HYPRE_IJMatrixCreate(comm, ilower, iupper, ilower, iupper, IJMatrixRef)
    A.IJMatrix = IJMatrixRef[]
    # Attach a finalizer
    finalizer(x -> HYPRE_IJMatrixDestroy(x.IJMatrix), A)
    # Set storage type
    @check HYPRE_IJMatrixSetObjectType(A.IJMatrix, HYPRE_PARCSR)
    # Initialize to make ready for setting values
    @check HYPRE_IJMatrixInitialize(A.IJMatrix)
    return A
end

# Finalize the matrix and fetch the assembled matrix
# This should be called after setting all the values
function Internals.assemble_matrix(A::HYPREMatrix)
    # Finalize after setting all values
    @check HYPRE_IJMatrixAssemble(A.IJMatrix)
    # Fetch the assembled CSR matrix
    ParCSRMatrixRef = Ref{Ptr{Cvoid}}(C_NULL)
    @check HYPRE_IJMatrixGetObject(A.IJMatrix, ParCSRMatrixRef)
    A.ParCSRMatrix = convert(Ptr{HYPRE_ParCSRMatrix}, ParCSRMatrixRef[])
    return A
end

###############
# HYPREVector #
###############

mutable struct HYPREVector # <: AbstractVector{HYPRE_Complex}
    #= const =# comm::MPI.Comm
    #= const =# ilower::HYPRE_BigInt
    #= const =# iupper::HYPRE_BigInt
    IJVector::HYPRE_IJVector
    ParVector::HYPRE_ParVector
end

function HYPREVector(comm::MPI.Comm, ilower::Integer, iupper::Integer)
    # Create the IJ vector
    b = HYPREVector(comm, ilower, iupper, C_NULL, C_NULL)
    b_ref = Ref{HYPRE_IJVector}(C_NULL)
    @check HYPRE_IJVectorCreate(comm, ilower, iupper, b_ref)
    b.IJVector = b_ref[]
    # Attach a finalizer
    finalizer(x -> HYPRE_IJVectorDestroy(x.IJVector), b) # Set storage type
    # Set storage type
    @check HYPRE_IJVectorSetObjectType(b.IJVector, HYPRE_PARCSR)
    # Initialize to make ready for setting values
    @check HYPRE_IJVectorInitialize(b.IJVector)
    return b
end

function Internals.assemble_vector(b::HYPREVector)
    # Finalize after setting all values
    @check HYPRE_IJVectorAssemble(b.IJVector)
    # Fetch the assembled vector
    par_b_ref = Ref{Ptr{Cvoid}}(C_NULL)
    @check HYPRE_IJVectorGetObject(b.IJVector, par_b_ref)
    b.ParVector = convert(Ptr{HYPRE_ParVector}, par_b_ref[])
    return b
end

function Internals.get_proc_rows(b::HYPREVector)
    # ilower_ref = Ref{HYPRE_BigInt}()
    # iupper_ref = Ref{HYPRE_BigInt}()
    # @check HYPRE_IJVectorGetLocalRange(b.IJVector, ilower_ref, iupper_ref)
    # ilower = ilower_ref[]
    # iupper = iupper_ref[]
    # return ilower, iupper
    return b.ilower, b.iupper
end

function Internals.get_comm(b::HYPREVector)
    # # The MPI communicator is (currently) the first field of the struct:
    # # https://github.com/hypre-space/hypre/blob/48de53e675af0e23baf61caa73d89fd9f478f453/src/IJ_mv/IJ_vector.h#L23
    # # Fingers crossed this doesn't change!
    # @assert b.IJVector != C_NULL
    # comm = unsafe_load(Ptr{MPI.Comm}(b.IJVector))
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
    @check HYPRE_IJVectorSetValues(x.IJVector, nvalues, indices, values)
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
    @check HYPRE_IJMatrixSetValues(A.IJMatrix, nrows, ncols, rows, cols, values)
    Internals.assemble_matrix(A)
    return A
end

HYPREMatrix(B::Union{SparseMatrixCSC,SparseMatrixCSR}, ilower=1, iupper=size(B, 1)) =
    HYPREMatrix(MPI.COMM_WORLD, B, ilower, iupper)

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
    @check HYPRE_IJVectorSetValues(b.IJVector, nvalues, indices, values)
    Internals.assemble_vector(b)
    return b
end

HYPREVector(x::Vector, ilower=1, iupper=length(x)) =
    HYPREVector(MPI.COMM_WORLD, x, ilower, iupper)

# TODO: Other eltypes could be support by using a intermediate buffer
function Base.copyto!(x::Vector{HYPRE_Complex}, h::HYPREVector)
    ilower, iupper = Internals.get_proc_rows(h)
    nvalues = iupper - ilower + 1
    if length(x) != nvalues
        # TODO: This isn't required by the copyto! interface, only that there is enough room
        throw(ArgumentError("length(dst) != length(src)"))
    end
    indices = collect(HYPRE_BigInt, ilower:iupper)
    @check HYPRE_IJVectorGetValues(h.IJVector, nvalues, indices, x)
    return x
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
Internals.get_comm(_::Union{PSparseMatrix,PVector}) = MPI.COMM_WORLD

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
        @check HYPRE_IJMatrixSetValues(A.IJMatrix, nrows, ncols, rows, cols, values)
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

        @check HYPRE_IJVectorSetValues(b.IJVector, nvalues, indices, values)
        return nothing
    end
    # Finalize
    Internals.assemble_vector(b)
    return b
end

# TODO: Other eltypes could be support by using a intermediate buffer
function Base.copyto!(v::PVector{HYPRE_Complex}, h::HYPREVector)
    ilower_v, iupper_v = Internals.get_proc_rows(v)
    ilower_h, iupper_h = Internals.get_proc_rows(h)
    if ilower_v != ilower_h && iupper_v != iupper_h
        # TODO: Why require this?
        throw(ArgumentError("mismatch in owned rows"))
    end
    map_parts(v.values, v.owned_values, v.rows.partition) do vv, _, vr
        ilower_v_part = vr.lid_to_gid[vr.oid_to_lid.start]
        iupper_v_part = vr.lid_to_gid[vr.oid_to_lid.stop]
        nvalues = HYPRE_Int(iupper_v_part - ilower_v_part + 1)
        indices = collect(HYPRE_BigInt, ilower_v_part:iupper_v_part)

        # TODO: Safe to use vv here? Owned values are always first?
        @check HYPRE_IJVectorGetValues(h.IJVector, nvalues, indices, vv)
    end
    return v
end

# Solver interface
include("solvers.jl")
include("solver_options.jl")

end # module HYPRE
