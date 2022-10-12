# SPDX-License-Identifier: MIT

using HYPRE
using HYPRE.LibHYPRE
using HYPRE.LibHYPRE: @check

function getindex_debug(A::HYPREMatrix, i::AbstractVector, j::AbstractVector)
    nrows = HYPRE_Int(length(i))
    ncols = fill(HYPRE_Int(length(j)), length(i))
    rows = convert(Vector{HYPRE_BigInt}, i)
    cols = convert(Vector{HYPRE_BigInt}, repeat(j, length(i)))
    values = Vector{HYPRE_Complex}(undef, length(i) * length(j))
    @check HYPRE_IJMatrixGetValues(A.ijmatrix, nrows, ncols, rows, cols, values)
    return permutedims(reshape(values, (length(j), length(i))))
end

function getindex_debug(b::HYPREVector, i::AbstractVector)
    nvalues = HYPRE_Int(length(i))
    indices = convert(Vector{HYPRE_BigInt}, i)
    values = Vector{HYPRE_Complex}(undef, length(i))
    @check HYPRE_IJVectorGetValues(b.ijvector, nvalues, indices, values)
    return values
end
