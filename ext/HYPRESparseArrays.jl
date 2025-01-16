module HYPRESparseArrays

using HYPRE.LibHYPRE: @check, HYPRE_BigInt, HYPRE_Complex, HYPRE_Int
using HYPRE:
    HYPRE, HYPREMatrix, HYPRESolver, HYPREVector, HYPRE_IJMatrixSetValues, Internals
using MPI: MPI
using SparseArrays: SparseArrays, SparseMatrixCSC, nonzeros, nzrange, rowvals

##################################
# SparseMatrixCSC -> HYPREMatrix #
##################################

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
    cumsum!((@view lastinds[2:end]), (@view ncols[1:(end - 1)]))

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
    @assert nrows == length(ncols) == length(rows)
    return nrows, ncols, rows, cols, values
end

# Note: keep in sync with the SparseMatrixCSR method
function HYPRE.HYPREMatrix(comm::MPI.Comm, B::SparseMatrixCSC, ilower, iupper)
    A = HYPREMatrix(comm, ilower, iupper)
    nrows, ncols, rows, cols, values = Internals.to_hypre_data(B, ilower, iupper)
    @check HYPRE_IJMatrixSetValues(A, nrows, ncols, rows, cols, values)
    Internals.assemble_matrix(A)
    return A
end

# Note: keep in sync with the SparseMatrixCSC method
function HYPRE.HYPREMatrix(B::SparseMatrixCSC, ilower = 1, iupper = size(B, 1))
    return HYPREMatrix(MPI.COMM_SELF, B, ilower, iupper)
end


####################################
# SparseMatrixCSC solver interface #
####################################

# Note: keep in sync with the SparseMatrixCSR method
function HYPRE.solve(solver::HYPRESolver, A::SparseMatrixCSC, b::Vector)
    hypre_x = HYPRE.solve(solver, HYPREMatrix(A), HYPREVector(b))
    x = copy!(similar(b, HYPRE_Complex), hypre_x)
    return x
end

# Note: keep in sync with the SparseMatrixCSR method
function HYPRE.solve!(solver::HYPRESolver, x::Vector, A::SparseMatrixCSC, b::Vector)
    hypre_x = HYPREVector(x)
    HYPRE.solve!(solver, hypre_x, HYPREMatrix(A), HYPREVector(b))
    copy!(x, hypre_x)
    return x
end

end # module HYPRESparseMatricesCSR
