# LibHYPRE

The submodule `HYPRE.LibHYPRE` contains auto-generated[^1] bindings to the HYPRE library.
The module exports all `HYPRE_*` symbols. Function names and arguments are identical to the
C-library -- refer to the [HYPRE manual](https://hypre.readthedocs.io/) for details.

Functions from the `LibHYPRE` submodule can be used together with the "Julian" interface.
This is useful when you need some functionality from the library which can't be accessed
through the Julia interface. Many functions require passing a reference to a matrix/vector
or a solver. These can be obtained as follows:

| C type signature     | Argument to pass                     |
|:---------------------|:-------------------------------------|
| `HYPRE_IJMatrix`     | `A.ijmatrix`  where `A::HYPREMatrix` |
| `HYPRE_ParCSRMatrix` | `A.parmatrix` where `A::HYPREMatrix` |
| `HYPRE_IJVector`     | `b.ijvector`  where `b::HYPREVector` |
| `HYPRE_ParVector`    | `b.parvector` where `b::HYPREVector` |
| `HYPRE_Solver`       | `s.solver`    where `s::HYPRESolver` |

[^1]: Bindings are generated using
      [Clang.jl](https://github.com/JuliaInterop/Clang.jl), see
      [gen/generator.jl]
      (https://github.com/fredrikekre/HYPRE.jl/blob/master/gen/generator.jl).
