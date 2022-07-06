using HYPRE
using HYPRE.LibHYPRE
using Test
using SparseArrays
using SparseMatricesCSR

using MPI
MPI.Init()

@testset "HYPREMatrix" begin
    H = HYPREMatrix()
    @test H.IJMatrix == HYPRE_IJMatrix(C_NULL)
    @test H.ParCSRMatrix == HYPRE_ParCSRMatrix(C_NULL)

    ilower, iupper = 4, 6
    CSC = convert(SparseMatrixCSC{HYPRE_Complex, HYPRE_Int}, sparse([
        1 2 0 0 3
        0 4 0 5 0
        0 6 7 0 8
    ]))
    CSR = sparsecsr(findnz(CSC)..., size(CSC)...)
    @test CSC == CSR
    csc = HYPRE.Internals.to_hypre_data(CSC, ilower, iupper)
    csr = HYPRE.Internals.to_hypre_data(CSR, ilower, iupper)
    @test csc[1]::HYPRE_Int == csr[1]::HYPRE_Int == 3 # nrows
    @test csc[2]::Vector{HYPRE_Int} == csr[2]::Vector{HYPRE_Int} == [3, 2, 3] # ncols
    @test csc[3]::Vector{HYPRE_BigInt} == csr[3]::Vector{HYPRE_BigInt} == [4, 5, 6] # rows
    @test csc[4]::Vector{HYPRE_BigInt} == csr[4]::Vector{HYPRE_BigInt} == [1, 2, 5, 2, 4, 2, 3, 5] # cols
    @test csc[5]::Vector{HYPRE_Complex} == csr[5]::Vector{HYPRE_Complex} == 1:8 # values

    # Optimizations for CSR matrix
    @test csr[4] == CSR.colval
    @test_broken csr[4] === CSR.colval
    @test csr[5] == CSR.nzval
    @test_broken csr[5]::Vector{HYPRE_Complex} === CSR.nzval

    @test_throws ArgumentError HYPRE.Internals.to_hypre_data(CSC, ilower, iupper-1)
    @test_throws ArgumentError HYPRE.Internals.to_hypre_data(CSR, ilower, iupper+1)

    # Converting SparseMatrixCS(C|R) to HYPREMatrix
    ilower, iupper = 6, 10
    CSC = sprand(5, 10, 0.3)
    CSR = sparsecsr(findnz(CSC)..., size(CSC)...)
    @test CSC == CSR
    H = HYPREMatrix(CSC, ilower,  iupper)
    @test H.IJMatrix != HYPRE_IJMatrix(C_NULL)
    @test H.ParCSRMatrix != HYPRE_ParCSRMatrix(C_NULL)
    H = HYPREMatrix(CSR, ilower,  iupper)
    @test H.IJMatrix != HYPRE_IJMatrix(C_NULL)
    @test H.ParCSRMatrix != HYPRE_ParCSRMatrix(C_NULL)
end

@testset "HYPREVector" begin
    h = HYPREVector()
    @test h.IJVector == HYPRE_IJVector(C_NULL)
    @test h.ParVector == HYPRE_ParVector(C_NULL)

    ilower, iupper = 1, 10
    b = rand(HYPRE_Complex, 10)
    nvalues, indices, values = HYPRE.Internals.to_hypre_data(b, ilower, iupper)
    @test nvalues::HYPRE_Int == 10
    @test indices::Vector{HYPRE_Int} == collect(1:10)
    @test values::Vector{HYPRE_Complex} === b # === for correct eltype

    b = rand(1:10, 10)
    nvalues, indices, values = HYPRE.Internals.to_hypre_data(b, ilower, iupper)
    @test nvalues::HYPRE_Int == 10
    @test indices::Vector{HYPRE_Int} == collect(1:10)
    @test values::Vector{HYPRE_Complex} == b # == for other eltype
    @test_throws ArgumentError HYPRE.Internals.to_hypre_data([1, 2], ilower, iupper)

    # Converting Vector to HYPREVector
    b = rand(HYPRE_Complex, 10)
    h = HYPREVector(b, ilower, iupper)
    @test h.IJVector != HYPRE_IJVector(C_NULL)
    @test h.ParVector != HYPRE_ParVector(C_NULL)
    @test_throws ArgumentError HYPREVector([1, 2], ilower, iupper)
end
