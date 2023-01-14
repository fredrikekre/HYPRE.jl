# LibHYPRE C API

The submodule `HYPRE.LibHYPRE` contains auto-generated bindings to the HYPRE library and
give access to the HYPRE C API directly[^1]. The module exports all `HYPRE_*` symbols.
Function names and arguments are identical to the C-library -- refer to the [HYPRE
manual](https://hypre.readthedocs.io/) for details.

The example program
[`examples/ex5.jl`](https://github.com/fredrikekre/HYPRE.jl/blob/master/examples/ex5.jl) is
an (almost) line-to-line translation of the corresponding example program
[`examples/ex5.c`](https://github.com/hypre-space/hypre/blob/ac9d7d0d7b43cd3d0c7f24ec5d64b58fbf900097/src/examples/ex5.c)
written in C, and showcases how HYPRE.jl can be used to interact with the HYPRE library
directly.

Functions from the `LibHYPRE` submodule can be used together with the high level interface.
This is useful when you need some functionality from the library which isn't exposed in the
high level interface. Many functions require passing a reference to a matrix/vector or a
solver. HYPRE.jl defines the appropriate conversion methods used by `ccall` such that
 - `A::HYPREMatrix` can be passed to `HYPRE_*` functions with `HYPRE_IJMatrix` or
   `HYPRE_ParCSRMatrix` in the signature
 - `b::HYPREVector` can be passed to `HYPRE_*` functions with `HYPRE_IJVector` or
   `HYPRE_ParVector` in the signature
 - `s::HYPRESolver` can be passed to `HYPRE_*` functions with `HYPRE_Solver` in the
   signature

[^1]: Bindings are generated using
      [Clang.jl](https://github.com/JuliaInterop/Clang.jl), see
      [gen/generator.jl]
      (https://github.com/fredrikekre/HYPRE.jl/blob/master/gen/generator.jl).
