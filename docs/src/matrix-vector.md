# Matrix/vector representation

HYPRE.jl defines the structs `HYPREMatrix` and `HYPREVector` representing HYPREs
datastructures. Specifically it uses the [IJ System
Interface](https://hypre.readthedocs.io/en/latest/api-int-ij.html) which can be used for
general sparse matrices.

`HYPREMatrix` and `HYPREVector` can be constructed either by assembling directly, or by
first assembling into a Julia datastructure and the converting it. These various methods are
outlined in the following sections:

```@contents
Pages = ["matrix-vector.md"]
Depth = 2:2
```


## Direct assembly (multi-/single-process)

Creating `HYPREMatrix` and/or `HYPREVector` directly is possible by first creating an
assembler which is used to add all individual contributions to the matrix/vector. The
required steps are:

  1. Create a new matrix and/or vector using the constructor.
  2. Create an assembler and initialize the assembling procedure using
     [`HYPRE.start_assemble!`](@ref).
  3. Assemble all non-zero contributions (e.g. element matrix/vector in a finite element
     simulation) using [`HYPRE.assemble!`](@ref).
  4. Finalize the assembly using [`HYPRE.finish_assemble!`](@ref).

After these steps the matrix and vector are ready to pass to the solver. In case of multiple
consecutive solves with the same sparsity pattern (e.g. multiple Newton steps, multiple time
steps, ...) it is possible to reuse the same matrix by simply skipping the first step above.

**Example pseudocode**

```julia
# MPI communicator
comm = MPI.COMM_WORLD # MPI.COMM_SELF for single-process setups

# Create empty matrix and vector -- this process owns rows ilower to iupper
A = HYPREMatrix(comm, ilower, iupper)
b = HYPREVector(comm, ilower, iupper)

# Create assembler
assembler = HYPRE.start_assemble!(A, b)

# Assemble contributions from all elements owned by this process
for element in owned_elements
    Ae, be = compute_element_contribution(...)
    global_indices = get_global_indices(...)
    HYPRE.assemble!(assembler, global_indices, Ae, be)
end

# Finalize the assembly
A, b = HYPRE.finish_assemble!(assembler)
```


## Create from PartitionedArrays.jl (multi-process)

HYPRE.jl integrates seemlessly with `PSparseMatrix` and `PVector` from the
[PartitionedArrays.jl](https://github.com/fverdugo/PartitionedArrays.jl) package. These can
be passed directly to `solve` and `solve!`. Internally this will construct a `HYPREMatrix`
and `HYPREVector`s and then convert the solution back to a `PVector`.

The `HYPREMatrix` constructor support both `SparseMatrixCSC` and `SparseMatrixCSR` as
storage backends for the `PSparseMatrix`. However, since HYPREs internal storage is also CSR
based it can be *slightly* more resource efficient to use `SparseMatrixCSR`.

The constructors also support both PartitionedArrays.jl backends: When using the `MPI`
backend the communicator of the `PSparseMatrix`/`PVector` is used also for the
`HYPREMatrix`/`HYPREVector`, and when using the `Sequential` backend it is assumed to be a
single-process setup, and the `MPI.COMM_SELF` communicator is used.

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


## Create from `SparseMatrixCSC` / `SparseMatrixCSR` (single-process)

HYPRE.jl also support working directly with `SparseMatrixCSC` (from the
[SparseArrays.jl](https://github.com/JuliaSparse/SparseArrays.jl) standard library) and
`SparseMatrixCSR` (from the
[SparseMatricesCSR.jl](https://github.com/gridap/SparseMatricesCSR.jl) package). This makes
it possible to use solvers and preconditioners even for single-process problems. When using
these type of spars matrices it is assumed that the right hand side and solution vectors are
regular Julia `Vector`s.

Just like when using the PartitionedArrays.jl package, it is possible to pass sparse
matrices directly to `solve` and `solve!`, but it is also possible to create `HYPREMatrix`
and `HYPREVector` explicitly, possibly saving some resources when doing multiple consecutive
linear solves (see previous section).

**Example pseudocode**

```julia
A = SparseMatrixCSC(...)
x = Vector(...)
b = Vector(...)

# Solve with zero initial guess
x = solve(solver, A, b)

# Inplace solve with x as initial guess
x = zeros(length(b))
solve!(solver, x, A, b)
```
