# SPDX-License-Identifier: MIT

using HYPRE
using MPI
using Test

MPI.Init()
HYPRE.Init()

include("test_utils.jl")

comm = MPI.COMM_WORLD
comm_rank = MPI.Comm_rank(comm)
comm_size = MPI.Comm_size(comm)

if comm_size != 2
    error("Must run with 2 ranks.")
end

if comm_rank == 0
    ilower = 1
    iupper = 10
    N = 2:10
else
    ilower = 11
    iupper = 20
    N = 11:19
end

function values_and_indices(n)
    idx = [n - 1, n, n + 1]
    a = Float64[
        # runic: off
          n  -2n   -n
        -2n    n  -2n
         -n  -2n    n
        # runic: on
    ]
    b = Float64[n, n / 2, n / 3]
    return idx, a, b
end

##########################
## HYPREMatrixAssembler ##
##########################

# Dense local matrix

A = HYPREMatrix(comm, ilower, iupper)
AM = zeros(20, 20)
for i in 1:2
    assembler = HYPRE.start_assemble!(A)
    fill!(AM, 0)
    for n in N
        idx, a, _ = values_and_indices(n)
        HYPRE.assemble!(assembler, idx, idx, a)
        AM[idx, idx] += a
    end
    f = HYPRE.finish_assemble!(assembler)
    @test f === A
    MPI.Allreduce!(AM, +, comm)
    @test getindex_debug(A, ilower:iupper, 1:20) == AM[ilower:iupper, 1:20]
    MPI.Barrier(comm)
end

##########################
## HYPREVectorAssembler ##
##########################

# Dense local vector

b = HYPREVector(comm, ilower, iupper)
bv = zeros(20)
for i in 1:2
    assembler = HYPRE.start_assemble!(b)
    fill!(bv, 0)
    for n in N
        idx, _, a = values_and_indices(n)
        HYPRE.assemble!(assembler, idx, a)
        bv[idx] += a
    end
    f = HYPRE.finish_assemble!(assembler)
    @test f === b
    MPI.Allreduce!(bv, +, comm)
    @test getindex_debug(b, ilower:iupper) == bv[ilower:iupper]
    MPI.Barrier(comm)
end

####################
## HYPREAssembler ##
####################

# Dense local arrays

A = HYPREMatrix(comm, ilower, iupper)
AM = zeros(20, 20)
b = HYPREVector(comm, ilower, iupper)
bv = zeros(20)
for i in 1:2
    assembler = HYPRE.start_assemble!(A, b)
    fill!(AM, 0)
    fill!(bv, 0)
    for n in N
        idx, a, c = values_and_indices(n)
        HYPRE.assemble!(assembler, idx, a, c)
        AM[idx, idx] += a
        bv[idx] += c
    end
    F, f = HYPRE.finish_assemble!(assembler)
    @test F === A
    @test f === b
    MPI.Allreduce!(AM, +, comm)
    MPI.Allreduce!(bv, +, comm)
    @test getindex_debug(A, ilower:iupper, 1:20) == AM[ilower:iupper, 1:20]
    @test getindex_debug(b, ilower:iupper) == bv[ilower:iupper]
    MPI.Barrier(comm)
end
