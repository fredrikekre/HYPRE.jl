module HYPREPartitionedArrays

using HYPRE.LibHYPRE: @check, HYPRE_BigInt, HYPRE_Complex, HYPRE_IJMatrixSetValues,
    HYPRE_IJVectorGetValues, HYPRE_IJVectorInitialize, HYPRE_IJVectorSetValues, HYPRE_Int
using HYPRE: HYPRE, HYPREMatrix, HYPRESolver, HYPREVector, Internals
using MPI: MPI
using PartitionedArrays: PartitionedArrays, AbstractLocalIndices, MPIArray, PSparseMatrix,
    PVector, SplitMatrix, ghost_to_global, local_values, own_to_global, own_values,
    partition
using SparseArrays: SparseArrays, SparseMatrixCSC, nonzeros, nzrange, rowvals
using SparseMatricesCSR: SparseMatrixCSR, colvals

##################################################
# PartitionedArrays.PSparseMatrix -> HYPREMatrix #
##################################################

function Internals.to_hypre_data(
        A::SplitMatrix{<:SparseMatrixCSC}, r::AbstractLocalIndices, c::AbstractLocalIndices
    )
    # Own/ghost to global index mappings
    own_to_global_row = own_to_global(r)
    own_to_global_col = own_to_global(c)
    ghost_to_global_col = ghost_to_global(c)

    # HYPRE requires contiguous row indices
    ilower = own_to_global_row[1]
    iupper = own_to_global_row[end]
    @assert iupper - ilower + 1 == length(own_to_global_row)

    # Extract sparse matrices from the SplitMatrix. We are only interested in the owned
    # rows, so only consider own-own and own-ghost blocks.
    Aoo = A.blocks.own_own::SparseMatrixCSC
    Aoo_rows = rowvals(Aoo)
    Aoo_vals = nonzeros(Aoo)
    Aog = A.blocks.own_ghost::SparseMatrixCSC
    Aog_rows = rowvals(Aog)
    Aog_vals = nonzeros(Aog)
    @assert size(Aoo, 1) == size(Aog, 1) == length(own_to_global_row)

    # Initialize the data buffers HYPRE wants
    nrows = HYPRE_Int(length(own_to_global_row)) # Total number of rows
    ncols = zeros(HYPRE_Int, nrows)              # Number of colums for each row
    rows = collect(HYPRE_BigInt, ilower:iupper)  # The row indices
    # cols = Vector{HYPRE_BigInt}(undef, nnz)     # The column indices
    # values = Vector{HYPRE_Complex}(undef, nnz)  # The values

    # First pass to count nnz per row (note that global column indices and column
    # permutation doesn't matter for this pass)
    @inbounds for own_col in 1:size(Aoo, 2)
        for k in nzrange(Aoo, own_col)
            own_row = Aoo_rows[k]
            ncols[own_row] += 1
        end
    end
    @inbounds for ghost_col in 1:size(Aog, 2)
        for k in nzrange(Aog, ghost_col)
            own_row = Aog_rows[k]
            ncols[own_row] += 1
        end
    end

    # Initialize remaining buffers now that nnz is known
    nnz = sum(ncols)
    cols = Vector{HYPRE_BigInt}(undef, nnz)
    values = Vector{HYPRE_Complex}(undef, nnz)

    # Keep track of the last index used for every row
    lastinds = zeros(Int, nrows)
    cumsum!((@view lastinds[2:end]), (@view ncols[1:(end - 1)]))

    # Second pass to populate the output. Here we need to map column
    # indices from own/ghost to global
    @inbounds for own_col in 1:size(Aoo, 2)
        for k in nzrange(Aoo, own_col)
            own_row = Aoo_rows[k]
            i = lastinds[own_row] += 1
            values[i] = Aoo_vals[k]
            cols[i] = own_to_global_col[own_col]
        end
    end
    @inbounds for ghost_col in 1:size(Aog, 2)
        for k in nzrange(Aog, ghost_col)
            own_row = Aog_rows[k]
            i = lastinds[own_row] += 1
            values[i] = Aog_vals[k]
            cols[i] = ghost_to_global_col[ghost_col]
        end
    end

    # Sanity checks and return
    @assert nrows == length(ncols) == length(rows)
    return nrows, ncols, rows, cols, values
end

function Internals.to_hypre_data(
        A::SplitMatrix{<:SparseMatrixCSR}, r::AbstractLocalIndices, c::AbstractLocalIndices
    )
    # Own/ghost to global index mappings
    own_to_global_row = own_to_global(r)
    own_to_global_col = own_to_global(c)
    ghost_to_global_col = ghost_to_global(c)

    # HYPRE requires contiguous row indices
    ilower = own_to_global_row[1]
    iupper = own_to_global_row[end]
    @assert iupper - ilower + 1 == length(own_to_global_row)

    # Extract sparse matrices from the SplitMatrix. We are only interested in the owned
    # rows, so only consider own-own and own-ghost blocks.
    Aoo = A.blocks.own_own::SparseMatrixCSR
    Aoo_cols = colvals(Aoo)
    Aoo_vals = nonzeros(Aoo)
    Aog = A.blocks.own_ghost::SparseMatrixCSR
    Aog_cols = colvals(Aog)
    Aog_vals = nonzeros(Aog)
    @assert size(Aoo, 1) == size(Aog, 1) == length(own_to_global_row)

    # Initialize the data buffers HYPRE wants
    nnz = SparseArrays.nnz(Aoo) + SparseArrays.nnz(Aog)
    nrows = HYPRE_Int(iupper - ilower + 1)      # Total number of rows
    ncols = zeros(HYPRE_Int, nrows)             # Number of columns for each row
    rows = collect(HYPRE_BigInt, ilower:iupper) # The row indices
    cols = Vector{HYPRE_BigInt}(undef, nnz)     # The column indices
    values = Vector{HYPRE_Complex}(undef, nnz)  # The values

    # For CSR we only need a single pass to over the owned rows to collect everything
    i = 0
    for own_row in 1:size(Aoo, 1)
        nzro = nzrange(Aoo, own_row)
        nzrg = nzrange(Aog, own_row)
        ncols[own_row] = length(nzro) + length(nzrg)
        for k in nzro
            i += 1
            own_col = Aoo_cols[k]
            cols[i] = own_to_global_col[own_col]
            values[i] = Aoo_vals[k]
        end
        for k in nzrg
            i += 1
            ghost_col = Aog_cols[k]
            cols[i] = ghost_to_global_col[ghost_col]
            values[i] = Aog_vals[k]
        end
    end

    # Sanity checks and return
    @assert nnz == i
    @assert nrows == length(ncols) == length(rows)
    return nrows, ncols, rows, cols, values
end

function Internals.get_comm(A::Union{PSparseMatrix{<:Any, <:M}, PVector{<:Any, <:M}}) where {M <: MPIArray}
    return partition(A).comm
end

Internals.get_comm(_::Union{PSparseMatrix, PVector}) = MPI.COMM_SELF

function Internals.get_proc_rows(A::Union{PSparseMatrix, PVector})
    ilower::HYPRE_BigInt = typemax(HYPRE_BigInt)
    iupper::HYPRE_BigInt = typemin(HYPRE_BigInt)
    map(partition(axes(A, 1))) do a
        # This is a map over the local process' owned indices. For MPI it will
        # be a single value but for DebugArray / Array it will have multiple
        # values.
        o_to_g = own_to_global(a)
        ilower_part = o_to_g[1]
        iupper_part = o_to_g[end]
        ilower = min(ilower, convert(HYPRE_BigInt, ilower_part))
        iupper = max(iupper, convert(HYPRE_BigInt, iupper_part))
    end
    return ilower, iupper
end

function HYPRE.HYPREMatrix(B::PSparseMatrix)
    # Use the same communicator as the matrix
    comm = Internals.get_comm(B)
    # Fetch rows owned by this process
    ilower, iupper = Internals.get_proc_rows(B)
    # Create the IJ matrix
    A = HYPREMatrix(comm, ilower, iupper)
    # Set all the values
    map(local_values(B), partition(axes(B, 1)), partition(axes(B, 2))) do Bv, Br, Bc
        nrows, ncols, rows, cols, values = Internals.to_hypre_data(Bv, Br, Bc)
        @check HYPRE_IJMatrixSetValues(A, nrows, ncols, rows, cols, values)
        return nothing
    end
    # Finalize
    Internals.assemble_matrix(A)
    return A
end

############################################
# PartitionedArrays.PVector -> HYPREVector #
############################################

function HYPRE.HYPREVector(v::PVector)
    # Use the same communicator as the matrix
    comm = Internals.get_comm(v)
    # Fetch rows owned by this process
    ilower, iupper = Internals.get_proc_rows(v)
    # Create the IJ vector
    b = HYPREVector(comm, ilower, iupper)
    # Set all the values
    map(own_values(v), partition(axes(v, 1))) do vo, vr
        o_to_g = own_to_global(vr)

        ilower_part = o_to_g[1]
        iupper_part = o_to_g[end]

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

        @check HYPRE_IJVectorSetValues(b, nvalues, indices, values)
        return nothing
    end
    # Finalize
    Internals.assemble_vector(b)
    return b
end

function copy_check(dst::HYPREVector, src::PVector)
    il_dst, iu_dst = Internals.get_proc_rows(dst)
    il_src, iu_src = Internals.get_proc_rows(src)
    if il_dst != il_src && iu_dst != iu_src
        # TODO: Why require this?
        msg = "row owner mismatch between dst ($(il_dst:iu_dst)) and src ($(il_src:iu_src))"
        throw(ArgumentError(msg))
    end
    return
end

# TODO: Other eltypes could be support by using a intermediate buffer
function Base.copy!(dst::PVector{<:AbstractVector{HYPRE_Complex}}, src::HYPREVector)
    copy_check(src, dst)
    map(own_values(dst), partition(axes(dst, 1))) do ov, vr
        o_to_g = own_to_global(vr)
        il_src_part = o_to_g[1]
        iu_src_part = o_to_g[end]
        nvalues = HYPRE_Int(iu_src_part - il_src_part + 1)
        indices = collect(HYPRE_BigInt, il_src_part:iu_src_part)
        values = ov
        @check HYPRE_IJVectorGetValues(src, nvalues, indices, values)
    end
    return dst
end

function Base.copy!(dst::HYPREVector, src::PVector{<:AbstractVector{HYPRE_Complex}})
    copy_check(dst, src)
    # Re-initialize the vector
    @check HYPRE_IJVectorInitialize(dst)
    map(own_values(src), partition(axes(src, 1))) do ov, vr
        o_to_g = own_to_global(vr)
        ilower_src_part = o_to_g[1]
        iupper_src_part = o_to_g[end]
        nvalues = HYPRE_Int(iupper_src_part - ilower_src_part + 1)
        indices = collect(HYPRE_BigInt, ilower_src_part:iupper_src_part)
        values = ov
        @check HYPRE_IJVectorSetValues(dst, nvalues, indices, values)
    end
    # TODO: It shouldn't be necessary to assemble here since we only set owned rows (?)
    # @check HYPRE_IJVectorAssemble(dst)
    # TODO: Necessary to recreate the ParVector? Running some examples it seems like it is
    # not needed.
    return dst
end

######################################
# PartitionedArrays solver interface #
######################################

# TODO: Would it be useful with a method that copied the solution to b instead?

function HYPRE.solve(solver::HYPRESolver, A::PSparseMatrix, b::PVector)
    hypre_x = HYPRE.solve(solver, HYPREMatrix(A), HYPREVector(b))
    x = copy!(similar(b, HYPRE_Complex), hypre_x)
    return x
end
function HYPRE.solve!(solver::HYPRESolver, x::PVector, A::PSparseMatrix, b::PVector)
    hypre_x = HYPREVector(x)
    HYPRE.solve!(solver, hypre_x, HYPREMatrix(A), HYPREVector(b))
    copy!(x, hypre_x)
    return x
end

end # module HYPREPartitionedArrays
