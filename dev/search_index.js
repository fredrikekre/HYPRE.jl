var documenterSearchIndex = {"docs":
[{"location":"hypre-matrix-vector/#Matrix/vector-representation","page":"Matrix/vector representation","title":"Matrix/vector representation","text":"","category":"section"},{"location":"hypre-matrix-vector/","page":"Matrix/vector representation","title":"Matrix/vector representation","text":"HYPRE.jl defines the structs HYPREMatrix and HYPREVector representing HYPREs datastructures. Specifically it uses the IJ System Interface which can be used for general sparse matrices.","category":"page"},{"location":"hypre-matrix-vector/","page":"Matrix/vector representation","title":"Matrix/vector representation","text":"HYPRE.jl defines conversion methods from standard Julia datastructures to HYPREMatrix and HYPREVector, respectively. See the following sections for details:","category":"page"},{"location":"hypre-matrix-vector/","page":"Matrix/vector representation","title":"Matrix/vector representation","text":"Pages = [\"hypre-matrix-vector.md\"]\nMinDepth = 2","category":"page"},{"location":"hypre-matrix-vector/#PartitionedArrays.jl-(multi-process)","page":"Matrix/vector representation","title":"PartitionedArrays.jl (multi-process)","text":"","category":"section"},{"location":"hypre-matrix-vector/","page":"Matrix/vector representation","title":"Matrix/vector representation","text":"HYPRE.jl integrates seemlessly with PSparseMatrix and PVector from the PartitionedArrays.jl package. These can be passed directly to solve and solve!. Internally this will construct a HYPREMatrix and HYPREVectors and then convert the solution back to a PVector.","category":"page"},{"location":"hypre-matrix-vector/","page":"Matrix/vector representation","title":"Matrix/vector representation","text":"The HYPREMatrix constructor support both SparseMatrixCSC and SparseMatrixCSR as storage backends for the PSparseMatrix. However, since HYPREs internal storage is also CSR based it can be slightly more resource efficient to use SparseMatrixCSR.","category":"page"},{"location":"hypre-matrix-vector/","page":"Matrix/vector representation","title":"Matrix/vector representation","text":"The constructors also support both PartitionedArrays.jl backends: When using the MPI backend the communicator of the PSparseMatrix/PVector is used also for the HYPREMatrix/HYPREVector, and when using the Sequential backend it is assumed to be a single-process setup, and the MPI.COMM_SELF communicator is used.","category":"page"},{"location":"hypre-matrix-vector/","page":"Matrix/vector representation","title":"Matrix/vector representation","text":"Example pseudocode","category":"page"},{"location":"hypre-matrix-vector/","page":"Matrix/vector representation","title":"Matrix/vector representation","text":"# Assemble linear system (see documentation for PartitionedArrays)\nA = PSparseMatrix(...)\nb = PVector(...)\n\n# Solve with zero initial guess\nx = solve(solver, A, b)\n\n# Inplace solve with x as initial guess\nx = PVector(...)\nsolve!(solver, x, A, b)","category":"page"},{"location":"hypre-matrix-vector/","page":"Matrix/vector representation","title":"Matrix/vector representation","text":"","category":"page"},{"location":"hypre-matrix-vector/","page":"Matrix/vector representation","title":"Matrix/vector representation","text":"It is also possible to construct the arrays explicitly. This can save some resources when performing multiple consecutive solves (multiple time steps, Newton iterations, etc). To copy data back and forth between PSparseMatrix/PVector and HYPREMatrix/HYPREVector use the copy! function.","category":"page"},{"location":"hypre-matrix-vector/","page":"Matrix/vector representation","title":"Matrix/vector representation","text":"Example pseudocode","category":"page"},{"location":"hypre-matrix-vector/","page":"Matrix/vector representation","title":"Matrix/vector representation","text":"A = PSparseMatrix(...)\nx = PVector(...)\nb = PVector(...)\n\n# Construct the HYPRE arrays\nA_h = HYPREMatrix(A)\nx_h = HYPREVector(x)\nb_h = HYPREVector(b)\n\n# Solve\nsolve!(solver, x_h, A_h, b_h)\n\n# Copy solution back to x\ncopy!(x, x_h)","category":"page"},{"location":"hypre-matrix-vector/#SparseMatrixCSC-/-SparseMatrixCSR-(single-process)","page":"Matrix/vector representation","title":"SparseMatrixCSC / SparseMatrixCSR (single-process)","text":"","category":"section"},{"location":"hypre-matrix-vector/","page":"Matrix/vector representation","title":"Matrix/vector representation","text":"HYPRE.jl also support working directly with SparseMatrixCSC (from the SparseArrays.jl standard library) and SparseMatrixCSR (from the SparseMatricesCSR.jl package). This makes it possible to use solvers and preconditioners even for single-process problems. When using these type of spars matrices it is assumed that the right hand side and solution vectors are regular Julia Vectors.","category":"page"},{"location":"hypre-matrix-vector/","page":"Matrix/vector representation","title":"Matrix/vector representation","text":"Just like when using the PartitionedArrays.jl package, it is possible to pass sparse matrices directly to solve and solve!, but it is also possible to create HYPREMatrix and HYPREVector explicitly, possibly saving some resources when doing multiple consecutive linear solves (see previous section).","category":"page"},{"location":"hypre-matrix-vector/","page":"Matrix/vector representation","title":"Matrix/vector representation","text":"Example pseudocode","category":"page"},{"location":"hypre-matrix-vector/","page":"Matrix/vector representation","title":"Matrix/vector representation","text":"A = SparseMatrixCSC(...)\nx = Vector(...)\nb = Vector(...)\n\n# Solve with zero initial guess\nx = solve(solver, A, b)\n\n# Inplace solve with x as initial guess\nx = zeros(length(b))\nsolve!(solver, x, A, b)","category":"page"},{"location":"hypre-matrix-vector/#SparseMatrixCSC-/-SparseMatrixCSR-(multi-process)","page":"Matrix/vector representation","title":"SparseMatrixCSC / SparseMatrixCSR (multi-process)","text":"","category":"section"},{"location":"hypre-matrix-vector/","page":"Matrix/vector representation","title":"Matrix/vector representation","text":"warning: Warning\nThis interface isn't finalized yet and is therefore not documented since it is subject to change.","category":"page"},{"location":"#HYPRE.jl","page":"Home","title":"HYPRE.jl","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"HYPRE.jl is a Julia wrapper for the HYPRE library, which provide parallel solvers for sparse linear systems.","category":"page"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"#High-level-interface","page":"Home","title":"High level interface","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"HYPRE.jl provide a high level interface to the HYPRE library. The goal of this interface is that the style and API should feel natural to most Julia programmers (it is \"Julian\"). In particular, you can use standard sparse matrices together with HYPRE's solvers through this interface.","category":"page"},{"location":"","page":"Home","title":"Home","text":"The high level interface does not (currently) provide access to all of HYPREs functionality, but it can easily be combined with the low level interface when necessary.","category":"page"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"#Low-level-interface","page":"Home","title":"Low level interface","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"HYPRE.jl also provide a low level interface for interacting with HYPRE. The goal of this interface is to stay close to the HYPRE C API. In fact, this interface is automatically generated based on HYPRE's header files, so this API maps one-to-one with the C API, see LibHYPRE C API for more details.","category":"page"},{"location":"libhypre/#LibHYPRE-C-API","page":"LibHYPRE C API","title":"LibHYPRE C API","text":"","category":"section"},{"location":"libhypre/","page":"LibHYPRE C API","title":"LibHYPRE C API","text":"The submodule HYPRE.LibHYPRE contains auto-generated bindings to the HYPRE library and give access to the HYPRE C API directly[1]. The module exports all HYPRE_* symbols. Function names and arguments are identical to the C-library – refer to the HYPRE manual for details.","category":"page"},{"location":"libhypre/","page":"LibHYPRE C API","title":"LibHYPRE C API","text":"The example program examples/ex5.jl is an (almost) line-to-line translation of the corresponding example program examples/ex5.c written in C, and showcases how HYPRE.jl can be used to interact with the HYPRE library directly.","category":"page"},{"location":"libhypre/","page":"LibHYPRE C API","title":"LibHYPRE C API","text":"Functions from the LibHYPRE submodule can be used together with the high level interface. This is useful when you need some functionality from the library which isn't exposed in the high level interface. Many functions require passing a reference to a matrix/vector or a solver. These can be obtained as follows:","category":"page"},{"location":"libhypre/","page":"LibHYPRE C API","title":"LibHYPRE C API","text":"C type signature Argument to pass\nHYPRE_IJMatrix A.ijmatrix  where A::HYPREMatrix\nHYPRE_ParCSRMatrix A.parmatrix where A::HYPREMatrix\nHYPRE_IJVector b.ijvector  where b::HYPREVector\nHYPRE_ParVector b.parvector where b::HYPREVector\nHYPRE_Solver s.solver    where s::HYPRESolver","category":"page"},{"location":"libhypre/","page":"LibHYPRE C API","title":"LibHYPRE C API","text":"[1]: Bindings are generated using   Clang.jl, see   gen/generator.jl.","category":"page"}]
}