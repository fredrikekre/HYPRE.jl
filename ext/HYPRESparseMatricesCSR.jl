module HYPRESparseMatricesCSR

using HYPRE.LibHYPRE: @check, HYPRE_BigInt, HYPRE_Complex, HYPRE_Int
using HYPRE: HYPRE, HYPREMatrix, HYPRESolver, HYPREVector, HYPRE_IJMatrixSetValues, Internals
using MPI: MPI
using SparseArrays: SparseArrays, nonzeros, nzrange
using SparseMatricesCSR: SparseMatrixCSR, colvals


##################################
# SparseMatrixCSR -> HYPREMatrix #
##################################

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
    @assert nrows == length(ncols) == length(rows)
    return nrows, ncols, rows, cols, values
end


# Note: keep in sync with the SparseMatrixCSC method
function HYPRE.HYPREMatrix(comm::MPI.Comm, B::SparseMatrixCSR, ilower, iupper)
    A = HYPREMatrix(comm, ilower, iupper)
    nrows, ncols, rows, cols, values = Internals.to_hypre_data(B, ilower, iupper)
    @check HYPRE_IJMatrixSetValues(A, nrows, ncols, rows, cols, values)
    Internals.assemble_matrix(A)
    return A
end

# Note: keep in sync with the SparseMatrixCSC method
function HYPRE.HYPREMatrix(B::SparseMatrixCSR, ilower = 1, iupper = size(B, 1))
    return HYPREMatrix(MPI.COMM_SELF, B, ilower, iupper)
end


####################################
# SparseMatrixCSR solver interface #
####################################

# Note: keep in sync with the SparseMatrixCSC method
function HYPRE.solve(solver::HYPRESolver, A::SparseMatrixCSR, b::Vector)
    hypre_x = HYPRE.solve(solver, HYPREMatrix(A), HYPREVector(b))
    x = copy!(similar(b, HYPRE_Complex), hypre_x)
    return x
end

# Note: keep in sync with the SparseMatrixCSC method
function HYPRE.solve!(solver::HYPRESolver, x::Vector, A::SparseMatrixCSR, b::Vector)
    hypre_x = HYPREVector(x)
    HYPRE.solve!(solver, hypre_x, HYPREMatrix(A), HYPREVector(b))
    copy!(x, hypre_x)
    return x
end

end # module HYPRESparseMatricesCSR
