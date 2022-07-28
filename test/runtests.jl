# SPDX-License-Identifier: MIT

using HYPRE
using HYPRE.Internals
using HYPRE.LibHYPRE
using LinearAlgebra
using MPI
using PartitionedArrays
using SparseArrays
using SparseMatricesCSR
using Test

# Init HYPRE and MPI
HYPRE.Init()

@testset "LibHYPRE" begin
    @test LibHYPRE.VERSION > VERSION # :)
    @test LibHYPRE.VERSION.major == 2
end

@testset "HYPREMatrix" begin
    H = HYPREMatrix(MPI.COMM_WORLD, 1, 5)
    @test H.ijmatrix != HYPRE_IJMatrix(C_NULL)
    @test H.parmatrix == HYPRE_ParCSRMatrix(C_NULL)
    Internals.assemble_matrix(H)
    @test H.ijmatrix != HYPRE_IJMatrix(C_NULL)
    @test H.parmatrix != HYPRE_ParCSRMatrix(C_NULL)
end

@testset "HYPREMatrix(::SparseMatrixCS(C|R))" begin
    ilower, iupper = 4, 6
    CSC = convert(SparseMatrixCSC{HYPRE_Complex, HYPRE_Int}, sparse([
        1 2 0 0 3
        0 4 0 5 0
        0 6 7 0 8
    ]))
    CSR = sparsecsr(findnz(CSC)..., size(CSC)...)
    @test CSC == CSR
    csc = Internals.to_hypre_data(CSC, ilower, iupper)
    csr = Internals.to_hypre_data(CSR, ilower, iupper)
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

    @test_throws ArgumentError Internals.to_hypre_data(CSC, ilower, iupper-1)
    @test_throws ArgumentError Internals.to_hypre_data(CSR, ilower, iupper+1)

    ilower, iupper = 6, 10
    CSC = sprand(5, 10, 0.3)
    CSR = sparsecsr(findnz(CSC)..., size(CSC)...)
    @test CSC == CSR

    H = HYPREMatrix(CSC, ilower, iupper)
    @test H.ijmatrix != HYPRE_IJMatrix(C_NULL)
    @test H.parmatrix != HYPRE_ParCSRMatrix(C_NULL)
    H = HYPREMatrix(MPI.COMM_WORLD, CSC, ilower, iupper)
    @test H.ijmatrix != HYPRE_IJMatrix(C_NULL)
    @test H.parmatrix != HYPRE_ParCSRMatrix(C_NULL)

    H = HYPREMatrix(CSR, ilower, iupper)
    @test H.ijmatrix != HYPRE_IJMatrix(C_NULL)
    @test H.parmatrix != HYPRE_ParCSRMatrix(C_NULL)
    H = HYPREMatrix(MPI.COMM_WORLD, CSR, ilower,  iupper)
    @test H.ijmatrix != HYPRE_IJMatrix(C_NULL)
    @test H.parmatrix != HYPRE_ParCSRMatrix(C_NULL)

    # Default to owning all rows
    CSC = sprand(10, 10, 0.3)
    CSR = sparsecsr(findnz(CSC)..., size(CSC)...)
    H = HYPREMatrix(CSC)
    @test H.ijmatrix != HYPRE_IJMatrix(C_NULL)
    @test H.parmatrix != HYPRE_ParCSRMatrix(C_NULL)
    @test H.comm == MPI.COMM_SELF
    @test H.ilower == H.jlower == 1
    @test H.iupper == H.jupper == 10
    H = HYPREMatrix(CSR)
    @test H.ijmatrix != HYPRE_IJMatrix(C_NULL)
    @test H.parmatrix != HYPRE_ParCSRMatrix(C_NULL)
    @test H.comm == MPI.COMM_SELF
    @test H.ilower == H.jlower == 1
    @test H.iupper == H.jupper == 10
end

function tomain(x)
    g = gather(copy(x))
    be = get_backend(g.values)
    if be isa SequentialBackend
        return g.values.parts[1]
    else # if be isa MPIBackend
        return g.values.part
    end
end

@testset "HYPREMatrix(::PSparseMatrix)" begin
    # Sequential backend
    function diag_data(backend, parts)
        is_seq = backend isa SequentialBackend
        rows = PRange(parts, 10)
        cols = PRange(parts, 10)
        I, J, V = map_parts(parts) do p
            i = Int[]
            j = Int[]
            v = Float64[]
            if (is_seq && p == 1) || !is_seq
                append!(i, [1, 2, 3, 4, 5, 6])
                append!(j, [1, 2, 3, 4, 5, 6])
                append!(v, [1, 2, 3, 4, 5, 6])
            end
            if (is_seq && p == 2) || !is_seq
                append!(i, [4, 5, 6, 7, 8, 9, 10])
                append!(j, [4, 5, 6, 7, 8, 9, 10])
                append!(v, [4, 5, 6, 7, 8, 9, 10])
            end
            return i, j, v
        end
        add_gids!(rows, I)
        assemble!(I, J, V, rows)
        add_gids!(cols, J)
        return I, J, V, rows, cols
    end

    backend = SequentialBackend()
    parts = get_part_ids(backend, 2)
    CSC = PSparseMatrix(diag_data(backend, parts)...; ids=:global)
    CSR = PSparseMatrix(sparsecsr, diag_data(backend, parts)...; ids=:global)

    @test tomain(CSC) == tomain(CSR) ==
        Diagonal([1, 2, 3, 8, 10, 12, 7, 8, 9, 10])

    map_parts(CSC.values, CSC.rows.partition, CSC.cols.partition,
              CSR.values, CSR.rows.partition, CSR.cols.partition, parts) do args...
        cscvalues, cscrows, csccols, csrvalues, csrrows, csrcols, p = args
        csc = Internals.to_hypre_data(cscvalues, cscrows, csccols)
        csr = Internals.to_hypre_data(csrvalues, csrrows, csrcols)
        if p == 1
            nrows = 5
            ncols = [1, 1, 1, 1, 1]
            rows = [1, 2, 3, 4, 5]
            cols = [1, 2, 3, 4, 5]
            values = [1, 2, 3, 8, 10]
        else # if p == 1
            nrows = 5
            ncols = [1, 1, 1, 1, 1]
            rows = [6, 7, 8, 9, 10]
            cols = [6, 7, 8, 9, 10]
            values = [12, 7, 8, 9, 10]
        end
        @test csc[1]::HYPRE_Int == csr[1]::HYPRE_Int == nrows
        @test csc[2]::Vector{HYPRE_Int} == csr[2]::Vector{HYPRE_Int} == ncols
        @test csc[3]::Vector{HYPRE_BigInt} == csr[3]::Vector{HYPRE_BigInt} == rows
        @test csc[4]::Vector{HYPRE_BigInt} == csr[4]::Vector{HYPRE_BigInt} == cols
        @test csc[5]::Vector{HYPRE_Complex} == csr[5]::Vector{HYPRE_Complex} == values
    end

    # MPI backend
    backend = MPIBackend()
    parts = MPIData(1, MPI.COMM_WORLD, (1,)) # get_part_ids duplicates the comm
    CSC = PSparseMatrix(diag_data(backend, parts)...; ids=:global)
    CSR = PSparseMatrix(sparsecsr, diag_data(backend, parts)...; ids=:global)

    @test tomain(CSC) == tomain(CSR) ==
        Diagonal([1, 2, 3, 8, 10, 12, 7, 8, 9, 10])

    map_parts(CSC.values, CSC.rows.partition, CSC.cols.partition,
              CSR.values, CSR.rows.partition, CSR.cols.partition, parts) do args...
        cscvalues, cscrows, csccols, csrvalues, csrrows, csrcols, p = args
        csc = Internals.to_hypre_data(cscvalues, cscrows, csccols)
        csr = Internals.to_hypre_data(csrvalues, csrrows, csrcols)
        nrows = 10
        ncols = fill(1, 10)
        rows = collect(1:10)
        cols = collect(1:10)
        values = [1, 2, 3, 8, 10, 12, 7, 8, 9, 10]
        @test csc[1]::HYPRE_Int == csr[1]::HYPRE_Int == nrows
        @test csc[2]::Vector{HYPRE_Int} == csr[2]::Vector{HYPRE_Int} == ncols
        @test csc[3]::Vector{HYPRE_BigInt} == csr[3]::Vector{HYPRE_BigInt} == rows
        @test csc[4]::Vector{HYPRE_BigInt} == csr[4]::Vector{HYPRE_BigInt} == cols
        @test csc[5]::Vector{HYPRE_Complex} == csr[5]::Vector{HYPRE_Complex} == values
    end

end

@testset "HYPREVector" begin
    h = HYPREVector(MPI.COMM_WORLD, 1, 5)
    @test h.ijvector != HYPRE_IJVector(C_NULL)
    @test h.parvector == HYPRE_ParVector(C_NULL)
    Internals.assemble_vector(h)
    @test h.ijvector != HYPRE_IJVector(C_NULL)
    @test h.parvector != HYPRE_ParVector(C_NULL)

    # Base.zero(::HYPREVector) and Base.copy!(::Vector, HYPREVector)
    b = rand(10)
    h = HYPREVector(b, 1, 10)
    z = zero(h)
    b′ = copy!(b, z)
    @test b === b′
    @test iszero(b)
end

@testset "HYPREVector(::Vector)" begin
    ilower, iupper = 1, 10
    b = rand(HYPRE_Complex, 10)
    h = HYPREVector(b, ilower, iupper)
    @test h.ijvector != HYPRE_IJVector(C_NULL)
    @test h.parvector != HYPRE_ParVector(C_NULL)
    h = HYPREVector(MPI.COMM_WORLD, b, ilower, iupper)
    @test h.ijvector != HYPRE_IJVector(C_NULL)
    @test h.parvector != HYPRE_ParVector(C_NULL)
    @test_throws ArgumentError HYPREVector([1, 2], ilower, iupper)
    # Default to owning all rows
    h = HYPREVector(b)
    @test h.ijvector != HYPRE_IJVector(C_NULL)
    @test h.parvector != HYPRE_ParVector(C_NULL)
    @test h.comm == MPI.COMM_SELF
    @test h.ilower == 1
    @test h.iupper == 10

    ilower, iupper = 1, 10
    b = rand(HYPRE_Complex, 10)
    nvalues, indices, values = Internals.to_hypre_data(b, ilower, iupper)
    @test nvalues::HYPRE_Int == 10
    @test indices::Vector{HYPRE_Int} == collect(1:10)
    @test values::Vector{HYPRE_Complex} === b # === for correct eltype

    b = rand(1:10, 10)
    nvalues, indices, values = Internals.to_hypre_data(b, ilower, iupper)
    @test nvalues::HYPRE_Int == 10
    @test indices::Vector{HYPRE_Int} == collect(1:10)
    @test values::Vector{HYPRE_Complex} == b # == for other eltype
    @test_throws ArgumentError Internals.to_hypre_data([1, 2], ilower, iupper)

    # Copying Vector -> HYPREVector
    b = rand(10)
    b2 = zeros(10)
    h = HYPREVector(b2)
    h′ = copy!(h, b)
    @test h === h′
    copy!(b2, h)
    @test b == b2
end

@testset "HYPREVector(::PVector)" begin
    # Sequential backend
    backend = SequentialBackend()
    parts = get_part_ids(backend, 2)
    rows = PRange(parts, 10)
    b = rand(10)
    I, V = map_parts(parts) do p
        if p == 1
            return collect(1:6), b[1:6]
        else # p == 2
            return collect(4:10), b[4:10]
        end
    end
    add_gids!(rows, I)
    pb = PVector(I, V, rows; ids=:global)
    assemble!(pb)
    @test tomain(pb) == [i in 4:6 ? 2x : x for (i, x) in zip(eachindex(b), b)]
    H = HYPREVector(pb)
    @test H.ijvector != HYPRE_IJVector(C_NULL)
    @test H.parvector != HYPRE_ParVector(C_NULL)
    pbc = fill!(copy(pb), 0)
    copy!(pbc, H)
    @test tomain(pbc) == tomain(pb)

    pb2 = 2 * pb
    H′ = copy!(H, pb2)
    @test H === H′
    copy!(pbc, H)
    @test tomain(pbc) == 2 * tomain(pb)

    # MPI backend
    backend = MPIBackend()
    parts = get_part_ids(backend, 1)
    rows = PRange(parts, 10)
    I, V = map_parts(parts) do p
        return collect(1:10), b
    end
    add_gids!(rows, I)
    pb = PVector(I, V, rows; ids=:global)
    assemble!(pb)
    @test tomain(pb) == b
    H = HYPREVector(pb)
    @test H.ijvector != HYPRE_IJVector(C_NULL)
    @test H.parvector != HYPRE_ParVector(C_NULL)
    pbc = fill!(copy(pb), 0)
    copy!(pbc, H)
    @test tomain(pbc) == tomain(pb)
end

@testset "BiCGSTAB" begin
    # Solver constructor and options
    @test_throws(
        ArgumentError("unknown option UnknownOption for HYPRE.BiCGSTAB"),
        HYPRE.BiCGSTAB(; UnknownOption = 1)
    )
    # Setup
    A = sprand(100, 100, 0.05); A = A'A + 5I
    b = rand(100)
    x = zeros(100)
    A_h = HYPREMatrix(A)
    b_h = HYPREVector(b)
    x_h = HYPREVector(x)
    # Solve
    tol = 1e-9
    bicg = HYPRE.BiCGSTAB(; Tol = tol)
    HYPRE.solve!(bicg, x_h, A_h, b_h)
    copy!(x, x_h)
    # Test result with direct solver
    @test x ≈ A \ b atol=tol
    # Test without passing initial guess
    x_h = HYPRE.solve(bicg, A_h, b_h)
    copy!(x, x_h)
    @test x ≈ A \ b atol=tol

    # Solve with preconditioner
    precond = HYPRE.BoomerAMG(; MaxIter = 1, Tol = 0.0)
    bicg = HYPRE.BiCGSTAB(; Tol = tol, Precond = precond)
    x_h = HYPREVector(zeros(100))
    HYPRE.solve!(bicg, x_h, A_h, b_h)
    copy!(x, x_h)
    # Test result with direct solver
    @test x ≈ A \ b atol=tol
    # Test without passing initial guess
    x_h = HYPRE.solve(bicg, A_h, b_h)
    copy!(x, x_h)
    @test x ≈ A \ b atol=tol
    # Tests Internals.set_precond_defaults for BoomerAMG
    precond = HYPRE.BoomerAMG()
    bicg = HYPRE.BiCGSTAB(; Tol = tol, Precond = precond)
    x_h = HYPREVector(zeros(100))
    HYPRE.solve!(bicg, x_h, A_h, b_h)
    copy!(x, x_h)
    # Test result with direct solver
    @test x ≈ A \ b atol=tol
end

@testset "BoomerAMG" begin
    # Solver constructor and options
    @test_throws(
        ArgumentError("unknown option UnknownOption for HYPRE.BoomerAMG"),
        HYPRE.BoomerAMG(; UnknownOption = 1)
    )
    # Setup
    A = sprand(100, 100, 0.05); A = A'A + 5I
    b = rand(100)
    x = zeros(100)
    ilower, iupper = 1, size(A, 1)
    A_h = HYPREMatrix(A, ilower, iupper)
    b_h = HYPREVector(b, ilower, iupper)
    x_h = HYPREVector(b, ilower, iupper)
    # Solve
    tol = 1e-9
    amg = HYPRE.BoomerAMG(; Tol = tol)
    HYPRE.solve!(amg, x_h, A_h, b_h)
    copy!(x, x_h)
    # Test result with direct solver
    @test x ≈ A \ b atol=tol
    # Test without passing initial guess
    x_h = HYPRE.solve(amg, A_h, b_h)
    copy!(x, x_h)
    @test x ≈ A \ b atol=tol
end

@testset "FlexGMRES" begin
    # Solver constructor and options
    @test_throws(
        ArgumentError("unknown option UnknownOption for HYPRE.FlexGMRES"),
        HYPRE.FlexGMRES(; UnknownOption = 1)
    )
    # Setup
    A = sprand(100, 100, 0.05); A = A'A + 5I
    b = rand(100)
    x = zeros(100)
    A_h = HYPREMatrix(A)
    b_h = HYPREVector(b)
    x_h = HYPREVector(x)
    # Solve
    tol = 1e-9
    gmres = HYPRE.FlexGMRES(; Tol = tol)
    HYPRE.solve!(gmres, x_h, A_h, b_h)
    copy!(x, x_h)
    # Test result with direct solver
    @test x ≈ A \ b atol=tol
    # Test without passing initial guess
    x_h = HYPRE.solve(gmres, A_h, b_h)
    copy!(x, x_h)
    @test x ≈ A \ b atol=tol

    # Solve with preconditioner
    precond = HYPRE.BoomerAMG()
    gmres = HYPRE.FlexGMRES(; Tol = tol, Precond = precond)
    x_h = HYPREVector(zeros(100))
    HYPRE.solve!(gmres, x_h, A_h, b_h)
    copy!(x, x_h)
    # Test result with direct solver
    @test x ≈ A \ b atol=tol
    # Test without passing initial guess
    x_h = HYPRE.solve(gmres, A_h, b_h)
    copy!(x, x_h)
    @test x ≈ A \ b atol=tol
end


@testset "GMRES" begin
    # Solver constructor and options
    @test_throws(
        ArgumentError("unknown option UnknownOption for HYPRE.GMRES"),
        HYPRE.GMRES(; UnknownOption = 1)
    )
    # Setup
    A = sprand(100, 100, 0.05); A = A'A + 5I
    b = rand(100)
    x = zeros(100)
    A_h = HYPREMatrix(A)
    b_h = HYPREVector(b)
    x_h = HYPREVector(x)
    # Solve
    tol = 1e-9
    gmres = HYPRE.GMRES(; Tol = tol)
    HYPRE.solve!(gmres, x_h, A_h, b_h)
    copy!(x, x_h)
    # Test result with direct solver
    @test x ≈ A \ b atol=tol
    # Test without passing initial guess
    x_h = HYPRE.solve(gmres, A_h, b_h)
    copy!(x, x_h)
    @test x ≈ A \ b atol=tol

    # Solve with preconditioner
    precond = HYPRE.BoomerAMG(; MaxIter = 1, Tol = 0.0)
    gmres = HYPRE.GMRES(; Tol = tol, Precond = precond)
    x_h = HYPREVector(zeros(100))
    HYPRE.solve!(gmres, x_h, A_h, b_h)
    copy!(x, x_h)
    # Test result with direct solver
    @test x ≈ A \ b atol=tol
    # Test without passing initial guess
    x_h = HYPRE.solve(gmres, A_h, b_h)
    copy!(x, x_h)
    @test x ≈ A \ b atol=tol
end

@testset "Hybrid" begin
    # Solver constructor and options
    @test_throws(
        ArgumentError("unknown option UnknownOption for HYPRE.Hybrid"),
        HYPRE.Hybrid(; UnknownOption = 1)
    )
    # Setup
    A = sprand(100, 100, 0.05); A = A'A + 5I
    b = rand(100)
    x = zeros(100)
    A_h = HYPREMatrix(A)
    b_h = HYPREVector(b)
    x_h = HYPREVector(x)
    # Solve
    tol = 1e-9
    hybrid = HYPRE.Hybrid(; Tol = tol)
    HYPRE.solve!(hybrid, x_h, A_h, b_h)
    copy!(x, x_h)
    # Test result with direct solver
    @test x ≈ A \ b atol=tol
    # Test without passing initial guess
    x_h = HYPRE.solve(hybrid, A_h, b_h)
    copy!(x, x_h)
    @test x ≈ A \ b atol=tol

    # Solve with given preconditioner
    # XXX: https://github.com/hypre-space/hypre/issues/699
    precond = HYPRE.BoomerAMG()
    hybrid = HYPRE.Hybrid(; Tol = tol, SolverType = 3, #= Precond = precond =#)
    x_h = HYPREVector(zeros(100))
    HYPRE.solve!(hybrid, x_h, A_h, b_h)
    copy!(x, x_h)
    # Test result with direct solver
    @test x ≈ A \ b atol=tol
    # Test without passing initial guess
    x_h = HYPRE.solve(hybrid, A_h, b_h)
    copy!(x, x_h)
    @test x ≈ A \ b atol=tol
end


@testset "ILU" begin
    # Solver constructor and options
    @test_throws(
        ArgumentError("unknown option UnknownOption for HYPRE.ILU"),
        HYPRE.ILU(; UnknownOption = 1)
    )
    # Setup
    A = sprand(100, 100, 0.05); A = A'A + 5I
    b = rand(100)
    x = zeros(100)
    A_h = HYPREMatrix(A)
    b_h = HYPREVector(b)
    x_h = HYPREVector(x)
    # Solve
    tol = 1e-9
    ilu = HYPRE.ILU(; Tol = tol)
    HYPRE.solve!(ilu, x_h, A_h, b_h)
    copy!(x, x_h)
    # Test result with direct solver
    @test x ≈ A \ b atol=tol
    # Test without passing initial guess
    x_h = HYPRE.solve(ilu, A_h, b_h)
    copy!(x, x_h)
    @test x ≈ A \ b atol=tol

    # Use as preconditioner to PCG
    precond = HYPRE.ILU()
    pcg = HYPRE.PCG(; Tol = tol, Precond = precond)
    x_h = HYPREVector(zeros(100))
    HYPRE.solve!(pcg, x_h, A_h, b_h)
    copy!(x, x_h)
    # Test result with direct solver
    @test x ≈ A \ b atol=tol
    # Test without passing initial guess
    x_h = HYPRE.solve(pcg, A_h, b_h)
    copy!(x, x_h)
    @test x ≈ A \ b atol=tol
end


@testset "(ParCSR)ParaSails" begin
    # Solver constructor and options
    @test_throws(
        ArgumentError("unknown option UnknownOption for HYPRE.ParaSails"),
        HYPRE.ParaSails(; UnknownOption = 1)
    )
    # Setup
    A = sprand(100, 100, 0.05); A = A'A + 5I
    b = rand(100)
    x = zeros(100)
    ilower, iupper = 1, size(A, 1)
    A_h = HYPREMatrix(A, ilower, iupper)
    b_h = HYPREVector(b, ilower, iupper)
    x_h = HYPREVector(b, ilower, iupper)
    # Solve with ParaSails as preconditioner
    tol = 1e-9
    parasails = HYPRE.ParaSails()
    pcg = HYPRE.PCG(; Tol = tol, Precond = parasails)
    HYPRE.solve!(pcg, x_h, A_h, b_h)
    copy!(x, x_h)
    # Test result with direct solver
    @test x ≈ A \ b atol=tol
end

@testset "(ParCSR)PCG" begin
    # Solver constructor and options
    @test_throws(
        ArgumentError("unknown option UnknownOption for HYPRE.PCG"),
        HYPRE.PCG(; UnknownOption = 1)
    )
    # Setup
    A = sprand(100, 100, 0.05); A = A'A + 5I
    b = rand(100)
    x = zeros(100)
    ilower, iupper = 1, size(A, 1)
    A_h = HYPREMatrix(A, ilower, iupper)
    b_h = HYPREVector(b, ilower, iupper)
    x_h = HYPREVector(b, ilower, iupper)
    # Solve
    tol = 1e-9
    pcg = HYPRE.PCG(; Tol = tol)
    HYPRE.solve!(pcg, x_h, A_h, b_h)
    copy!(x, x_h)
    # Test result with direct solver
    @test x ≈ A \ b atol=tol
    # Test without passing initial guess
    x_h = HYPRE.solve(pcg, A_h, b_h)
    copy!(x, x_h)
    @test x ≈ A \ b atol=tol
    # Solve with AMG preconditioner
    precond = HYPRE.BoomerAMG(; MaxIter = 1, Tol = 0.0)
    pcg = HYPRE.PCG(; Tol = tol, Precond = precond)
    x_h = HYPREVector(zeros(100))
    HYPRE.solve!(pcg, x_h, A_h, b_h)
    copy!(x, x_h)
    # Test result with direct solver
    @test x ≈ A \ b atol=tol
    # Test without passing initial guess
    x_h = HYPRE.solve(pcg, A_h, b_h)
    copy!(x, x_h)
    @test x ≈ A \ b atol=tol
end

function topartitioned(x::Vector, A::SparseMatrixCSC, b::Vector)
    parts = get_part_ids(SequentialBackend(), 1)
    rows = PRange(parts, size(A, 1))
    cols = PRange(parts, size(A, 2))
    II, JJ, VV, bb, xx = map_parts(parts) do _
        return findnz(A)..., b, x
    end
    add_gids!(rows, II)
    assemble!(II, JJ, VV, rows)
    add_gids!(cols, JJ)
    A_p = PSparseMatrix(II, JJ, VV, rows, cols; ids = :global)
    b_p = PVector(bb, rows)
    x_p = PVector(xx, cols)
    return x_p, A_p, b_p
end

@testset "solve with PartitionedArrays" begin
    # Setup
    A = sprand(100, 100, 0.05); A = A'A + 5I
    b = rand(100)
    x = zeros(100)
    x_p, A_p, b_p = topartitioned(x, A, b)
    @test A == tomain(A_p)
    @test b == tomain(b_p)
    @test x == tomain(x_p)
    # Solve
    tol = 1e-9
    pcg = HYPRE.PCG(; Tol = tol)
    ## solve!
    HYPRE.solve!(pcg, x_p, A_p, b_p)
    @test tomain(x_p) ≈ A \ b atol=tol
    ## solve
    x_p = HYPRE.solve(pcg, A_p, b_p)
    @test tomain(x_p) ≈ A \ b atol=tol
end

@testset "solve with SparseMatrixCS(C|R)" begin
    # Setup
    A = sprand(100, 100, 0.05); A = A'A + 5I
    b = rand(100)
    x = zeros(100)
    # Solve
    tol = 1e-9
    pcg = HYPRE.PCG(; Tol = tol)
    ## solve!
    HYPRE.solve!(pcg, x, A, b)
    @test x ≈ A \ b atol=tol
    ## solve
    x = HYPRE.solve(pcg, A, b)
    @test x ≈ A \ b atol=tol
end
