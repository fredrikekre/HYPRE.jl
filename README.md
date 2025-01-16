# HYPRE.jl

[![Documentation](https://img.shields.io/badge/docs-latest%20release-blue.svg)](https://fredrikekre.github.io/HYPRE.jl/)
[![Test](https://github.com/fredrikekre/HYPRE.jl/actions/workflows/Test.yml/badge.svg?branch=master&event=push)](https://github.com/fredrikekre/HYPRE.jl/actions/workflows/Test.yml)
[![Codecov](https://codecov.io/github/fredrikekre/HYPRE.jl/graph/badge.svg)](https://codecov.io/github/fredrikekre/HYPRE.jl)
[![code style: runic](https://img.shields.io/badge/code_style-%E1%9A%B1%E1%9A%A2%E1%9A%BE%E1%9B%81%E1%9A%B2-black)](https://github.com/fredrikekre/Runic.jl)

[Julia](https://julialang.org) interface to [HYPRE](https://github.com/hypre-space/hypre)
("high performance preconditioners and solvers featuring multigrid methods for the solution
of large, sparse linear systems of equations on massively parallel computers").

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

To configure MPI, see the [documentation for MPI.jl](https://juliaparallel.org/MPI.jl/).

## Changes

All notable changes are documented in [CHANGELOG.md](CHANGELOG.md).

## Usage

Some basic usage examples are shown below. See the [documentation][docs-url] for details.

### Example: Single-core solve with standard sparse matrices

It is possible to use Julia's standard sparse arrays (`SparseMatrixCSC` from the
[SparseArrays.jl](https://github.com/JuliaSparse/SparseArrays.jl) standard library, and
`SparseMatrixCSR` from the
[SparseMatricesCSR.jl](https://github.com/gridap/SparseMatricesCSR.jl) package) directly in
HYPRE.jl. For example, to solve `Ax = b` with conjugate gradients:

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

For multi-core problems it is possible to use
[PartitionedArrays.jl](https://github.com/fverdugo/PartitionedArrays.jl) directly with
HYPRE.jl. Once the linear system is setup the solver interface is identical. For example, to
solve `Ax = b` with bi-conjugate gradients and an algebraic multigrid preconditioner:

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
