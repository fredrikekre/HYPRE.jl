# HYPRE.jl

| **Documentation**         | **Build Status**                      |
|:------------------------- |:------------------------------------- |
| [![][docs-img]][docs-url] | [![][gh-actions-img]][gh-actions-url] |

[Julia][julia] interface to [HYPRE][hypre] ("high performance preconditioners and solvers
featuring multigrid methods for the solution of large, sparse linear systems of equations on
massively parallel computers").

While the main purpose of HYPRE is to solve problems on multiple cores, it can also be used
for single core problems. HYPRE.jl aims to make it easy to use both modes of operation, with
an interface that should be familiar to Julia programmers. This README includes some basic
examples -- refer to the [documentation][docs-url] for more details, and for information
about the included solvers and preconditioners and how to configure them.

## Installation

HYPRE.jl can be installed from the Pkg REPL (press `]` in the Julia REPL to enter):

```
(@v1) pkg> add HYPRE
```

To configure MPI, see the [documentation for MPI.jl][mpi-docs].

## Changes

All notable changes are documented in [CHANGELOG.md](CHANGELOG.md).

## Usage

Some basic usage examples are shown below. See the [documentation][docs-url] for details.

### Example: Single-core solve with standard sparse matrices

It is possible to use Julia's standard sparse arrays (`SparseMatrixCSC` from the
[SparseArrays.jl][sparse-stdlib] standard library, and `SparseMatrixCSR` from the
[SparseMatricesCSR.jl][sparsecsr] package) directly in HYPRE.jl. For example, to solve
`Ax = b` with conjugate gradients:

```julia
# Initialize linear system
A = SparseMatrixCSC(...)
b = Vector(...)

# Create a conjugate gradients solver
cg = HYPRE.PCG()

# Compute the solution
x = HYPRE.solve(cg, A, b)
```

### Example: Multi-core solve using PartitionedArrays.jl

For multi-core problems it is possible to use [PartitionedArrays.jl][partarrays] directly
with HYPRE.jl. Once the linear system is setup the solver interface is identical. For
example, to solve `Ax = b` with bi-conjugate gradients and an algebraic multigrid
preconditioner:

```julia
# Initialize linear system
A = PSparseMatrix(...)
b = PVector(...)

# Create preconditioner
precond = BoomerAMG()

# Create a bi-conjugate gradients solver
bicg = HYPRE.BiCGSTAB(; Precond = precond)

# Compute the solution
x = HYPRE.solve(bicg, A, b)
```


[julia]: https://julialang.org/
[hypre]: https://github.com/hypre-space/hypre
[mpi-docs]: https://juliaparallel.org/MPI.jl/
[sparse-stdlib]: https://github.com/JuliaSparse/SparseArrays.jl
[sparsecsr]: https://github.com/gridap/SparseMatricesCSR.jl
[partarrays]: https://github.com/fverdugo/PartitionedArrays.jl
[docs-img]: https://img.shields.io/badge/docs-stable%20release-blue.svg
[docs-url]: https://fredrikekre.github.io/HYPRE.jl/
[gh-actions-img]: https://github.com/fredrikekre/HYPRE.jl/workflows/CI/badge.svg
[gh-actions-url]: https://github.com/fredrikekre/HYPRE.jl/actions?query=workflow%3ACI
