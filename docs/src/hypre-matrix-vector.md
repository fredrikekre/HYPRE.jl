# Matrix/vector representation

HYPRE.jl defines the structs `HYPREMatrix` and `HYPREVector` representing HYPREs
datastructures. Specifically it uses the [IJ System
Interface](https://hypre.readthedocs.io/en/latest/api-int-ij.html) which can be used for
general sparse matrices.

HYPRE.jl defines conversion methods from standard Julia datastructures to `HYPREMatrix` and
`HYPREVector`, respectively.

## PartitionedArrays.jl (multi-process)

HYPRE.jl integrates seemlessly with `PSparseMatrix` and `PVector` from the
[PartitionedArrays.jl](https://github.com/fverdugo/PartitionedArrays.jl) package. These can
be passed directly to `solve` and `solve!`. Internally this will construct a `HYPREMatrix`
and `HYPREVector`s and then convert the solution back to a `PVector`.

The `HYPREMatrix` constructor supports both `SparseMatrixCSC` and `SparseMatrixCSR` as
storage backends for the `PSparseMatrix`. However, since HYPREs internal storage is also CSR
based it can be *slightly* more resource efficient to use `SparseMatrixCSR`.

The constructors also supports both PartitionedArrays.jl backends: When using the `MPI`
backend the communicator of the `PSparseMatrix`/`PVector` is used also for the
`HYPREMatrix`/`HYPREVector`, and when using the `Sequential` backend it is assumed to be a
single-process setup, and the global communicator `MPI.COMM_WORLD` is used.

**Example pseudocode**

```julia
# Assemble linear system (see documentation for PartitionedArrays)
A = PSparseMatrix(...)
b = PVector(...)

# Solve with zero initial guess
x = solve(solver, A, b)

# Inplace solve with x as initial guess
x = PVector(...)
solve!(solver, x, A, b)
```

---

It is also possible to construct the arrays explicitly. This can save some resources when
performing multiple consecutive solves (multiple time steps, Newton iterations, etc). To
copy data back and forth between `PSparseMatrix`/`PVector` and `HYPREMatrix`/`HYPREVector`
use the `copy!` function.

**Example pseudocode**

```julia
A = PSparseMatrix(...)
x = PVector(...)
b = PVector(...)

# Construct the HYPRE arrays
A_h = HYPREMatrix(A)
x_h = HYPREVector(x)
b_h = HYPREVector(b)

# Solve
solve!(solver, x_h, A_h, b_h)

# Copy solution back to x
copy!(x, x_h)
```


## `SparseMatrixCSC` / `SparseMatrixCSR` (single-process)


## `SparseMatrixCSC` / `SparseMatrixCSR` (multi-process)

!!! warning
    This interface isn't finalized yet and is subject to change.

