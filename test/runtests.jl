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

include("test_utils.jl")

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

function default_local_values_csr(I,J,V,row_indices,col_indices)
    # Adapted from p_sparse_matrix.jl line 487
    m = local_length(row_indices)
    n = local_length(col_indices)
    sparsecsr(I,J,V,m,n)
end

function distribute_as_parray(parts, backend)
    if backend == :debug
        parts = DebugArray(parts)
    elseif backend == :mpi
        parts = distribute_with_mpi(parts)
    else
        @assert backend == :native
        parts = collect(parts)
    end
    return parts
end

@testset "HYPREMatrix(::PSparseMatrix)" begin
    function diag_data(parts)
        rows = uniform_partition(parts, 10)
        cols = uniform_partition(parts, 10)
        np = length(parts)
        IJV = map(parts) do p
            i = Int[]
            j = Int[]
            v = Float64[]
            if np == 1
                # MPI case is special, we only have one MPI process.
                @assert p == 1
                append!(i, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
                append!(j, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
                append!(v, [1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
            elseif p == 1
                @assert np == 2
                append!(i, [1, 2, 3, 4, 5, 6])
                append!(j, [1, 2, 3, 4, 5, 6])
                append!(v, [1, 2, 3, 4, 5, 6])
            else
                @assert np == 2
                @assert p == 2
                append!(i, [4, 5, 6, 7, 8, 9, 10])
                append!(j, [4, 5, 6, 7, 8, 9, 10])
                append!(v, [4, 5, 6, 7, 8, 9, 10])
            end
            return i, j, v
        end
        I, J, V = tuple_of_arrays(IJV)
        return I, J, V, rows, cols
    end

    for backend in [:native, :debug, :mpi]
        @testset "Backend=$backend" begin
            if backend == :mpi
                parts = 1:1
            else
                parts = 1:2
            end
            parts = distribute_as_parray(parts, backend)
            CSC = psparse!(diag_data(parts)...) |> fetch
            CSR = psparse!(default_local_values_csr, diag_data(parts)...) |> fetch

            for A in [CSC, CSR]
                map(local_values(A), A.row_partition, A.col_partition, parts) do values, rows, cols, p
                    hypre_data = Internals.to_hypre_data(values, rows, cols)
                    if backend == :mpi
                        @assert p == 1
                        nrows = 10
                        ncols = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
                        rows = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                        cols = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                        values = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                    elseif p == 1
                        nrows = 5
                        ncols = [1, 1, 1, 1, 1]
                        rows = [1, 2, 3, 4, 5]
                        cols = [1, 2, 3, 4, 5]
                        values = [1, 2, 3, 8, 10]
                    else
                        @assert p == 2
                        nrows = 5
                        ncols = [1, 1, 1, 1, 1]
                        rows = [6, 7, 8, 9, 10]
                        cols = [6, 7, 8, 9, 10]
                        values = [12, 7, 8, 9, 10]
                    end
                    @test hypre_data[1]::HYPRE_Int == nrows
                    @test hypre_data[2]::Vector{HYPRE_Int} == ncols
                    @test hypre_data[3]::Vector{HYPRE_BigInt} == rows
                    @test hypre_data[4]::Vector{HYPRE_BigInt} == cols
                    @test hypre_data[5]::Vector{HYPRE_Complex} == values    
                end
            end
        end
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
    for backend in [:native, :debug, :mpi]
        if backend == :mpi
            parts = distribute_as_parray(1:1, backend)
        else
            parts = distribute_as_parray(1:2, backend)
        end
        rows = uniform_partition(parts, 10)
        b = rand(10)
        IV = map(parts, rows) do p, owned
            if backend == :mpi
                row_indices = 1:10
            elseif p == 1
                row_indices = 1:6
            else # p == 2
                row_indices = 4:10
            end
            values = zeros(length(row_indices))
            for (i, row) in enumerate(row_indices)
                if row in owned
                    values[i] = b[row]
                end
            end
            return collect(row_indices), values
        end
        I, V = tuple_of_arrays(IV)
        pb = pvector!(I, V, rows) |> fetch
        H = HYPREVector(pb)
        # Check for valid vector
        @test H.ijvector != HYPRE_IJVector(C_NULL)
        @test H.parvector != HYPRE_ParVector(C_NULL)
        # Copy back, check if identical
        b_copy = copy!(similar(b), H)
        @test b_copy == b
        # Test copy to and from HYPREVector
        pb2 = 2 * pb
        H′ = copy!(H, pb2)
        @test H === H′
        pbc = similar(pb)
        copy!(pbc, H)
        @test pbc == 2*pb
    end
end

@testset "HYPRE(Matrix|Vector)?Assembler" begin
    comm = MPI.COMM_WORLD
    # Assembly HYPREMatrix from ::Matrix
    A = HYPREMatrix(comm, 1, 3)
    AM = zeros(3, 3)
    for i in 1:2
        assembler = HYPRE.start_assemble!(A)
        fill!(AM, 0)
        for idx in ([1, 2], [3, 1])
            a = rand(2, 2)
            HYPRE.assemble!(assembler, idx, idx, a)
            AM[idx, idx] += a
            ar = rand(1, 2)
            HYPRE.assemble!(assembler, [2], idx, ar)
            AM[[2], idx] += ar
        end
        f = HYPRE.finish_assemble!(assembler)
        @test f === A
        @test getindex_debug(A, 1:3, 1:3) == AM
    end
    # Assembly HYPREVector from ::Vector
    b = HYPREVector(comm, 1, 3)
    bv = zeros(3)
    for i in 1:2
        assembler = HYPRE.start_assemble!(b)
        fill!(bv, 0)
        for idx in ([1, 2], [3, 1])
            c = rand(2)
            HYPRE.assemble!(assembler, idx, c)
            bv[idx] += c
        end
        f = HYPRE.finish_assemble!(assembler)
        @test f === b
        @test getindex_debug(b, 1:3) == bv
    end
    # Assembly HYPREMatrix/HYPREVector from ::Array
    A = HYPREMatrix(comm, 1, 3)
    AM = zeros(3, 3)
    b = HYPREVector(comm, 1, 3)
    bv = zeros(3)
    for i in 1:2
        assembler = HYPRE.start_assemble!(A, b)
        fill!(AM, 0)
        fill!(bv, 0)
        for idx in ([1, 2], [3, 1])
            a = rand(2, 2)
            c = rand(2)
            HYPRE.assemble!(assembler, idx, a, c)
            AM[idx, idx] += a
            bv[idx] += c
        end
        F, f = HYPRE.finish_assemble!(assembler)
        @test F === A
        @test f === b
        @test getindex_debug(A, 1:3, 1:3) == AM
        @test getindex_debug(b, 1:3) == bv
    end
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
    # Test solver queries
    @test HYPRE.GetFinalRelativeResidualNorm(bicg) < tol
    @test HYPRE.GetNumIterations(bicg) > 0

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
    # Setup 1D FEM matrix
    I, J, V = Int[], Int[], Float64[]
    for i in 1:99
        k = (1 + rand()) * [1.0 -1.0; -1.0 1.0]
        append!(V, k)
        append!(I, [i, i+1, i, i+1]) # rows
        append!(J, [i, i, i+1, i+1]) # cols
    end
    A = sparse(I, J, V)
    A[:, 1] .= 0; A[1, :] .= 0; A[:, end] .= 0; A[end, :] .= 0;
    A[1, 1] = 2; A[end, end] = 2
    @test isposdef(A)
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
    @test (A * x ≈ b) atol = tol * norm(b) # default BoomerAMG criteria
    # Test result with direct solver
    @test (x ≈ A \ b) atol = tol * norm(b)
    # Test without passing initial guess
    x_h = HYPRE.solve(amg, A_h, b_h)
    copy!(x, x_h)
    @test x ≈ A \ b atol = tol * norm(b)
    # Test solver queries
    @test HYPRE.GetFinalRelativeResidualNorm(amg) < tol
    @test HYPRE.GetNumIterations(amg) > 0
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
    # Test solver queries
    @test HYPRE.GetFinalRelativeResidualNorm(gmres) < tol
    @test HYPRE.GetNumIterations(gmres) > 0

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
    # Test solver queries
    @test HYPRE.GetFinalRelativeResidualNorm(gmres) < tol
    @test HYPRE.GetNumIterations(gmres) > 0

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
    # Test solver queries
    @test HYPRE.GetFinalRelativeResidualNorm(hybrid) < tol
    @test HYPRE.GetNumIterations(hybrid) > 0

    # Solve with given preconditioner
    precond = HYPRE.BoomerAMG()
    hybrid = HYPRE.Hybrid(; Tol = tol, SolverType = 3, Precond = precond)
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
    # Test solver queries
    @test HYPRE.GetFinalRelativeResidualNorm(ilu) < tol
    @test HYPRE.GetNumIterations(ilu) > 0

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
    # Test solver queries (should error)
    @test_throws ArgumentError("cannot get residual norm for HYPRE.ParaSails") HYPRE.GetFinalRelativeResidualNorm(parasails)
    @test_throws ArgumentError("cannot get number of iterations for HYPRE.ParaSails") HYPRE.GetNumIterations(parasails)
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
    # Test solver queries
    @test HYPRE.GetFinalRelativeResidualNorm(pcg) < tol
    @test HYPRE.GetNumIterations(pcg) > 0

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

function topartitioned(x::Vector, A::SparseMatrixCSC, b::Vector, backend)
    parts = distribute_as_parray(1:1, backend)
    n = size(A, 1)
    rows = uniform_partition(parts, n)
    cols = uniform_partition(parts, n)
    tmp = map(parts) do _
        return findnz(A)..., b, x
    end
    II, JJ, VV, bb, xx = tuple_of_arrays(tmp)
    A_p = psparse!(II, JJ, VV, rows, cols) |> fetch
    b_p = PVector(bb, rows)
    x_p = PVector(xx, cols)
    return x_p, A_p, b_p
end

@testset "solve with PartitionedArrays" begin
    for backend in [:native, :debug, :mpi]
        # Setup
        A = sprand(100, 100, 0.05); A = A'A + 5I
        b = rand(100)
        x = zeros(100)
        x_p, A_p, b_p = topartitioned(x, A, b, :native)
        # Data is distributed over a single process. We can then check the following
        # as local_values is the entire matrix/vector.
        map(local_values(x_p)) do x_l
            @test x_l == x
        end
        map(local_values(b_p)) do b_l
            @test b_l == b
        end
        map(local_values(A_p)) do A_l
            @test A_l == A
        end

        # Solve
        tol = 1e-9
        pcg = HYPRE.PCG(; Tol = tol)
        ## solve!
        HYPRE.solve!(pcg, x_p, A_p, b_p)
        ref = A\b
        map(local_values(x_p)) do x
            @test x ≈ ref atol=tol
        end
        ## solve
        x_p = HYPRE.solve(pcg, A_p, b_p)
        map(local_values(x_p)) do x
            @test x ≈ ref atol=tol
        end
    end
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

@testset "MPI execution" begin
    testfiles = joinpath.(@__DIR__, [
        "test_assembler.jl",
    ])
    for file in testfiles
        mpiexec() do mpi
            r = run(ignorestatus(`$(mpi) -n 2 $(Base.julia_cmd()) $(file)`))
            @test r.exitcode == 0
        end
    end
end
