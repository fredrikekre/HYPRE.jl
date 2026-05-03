# HYPRE.jl

HYPRE.jl is a Julia wrapper for the [HYPRE library](https://github.com/hypre-space/hypre),
which provide parallel solvers for sparse linear systems.

----

##### High level interface

HYPRE.jl provide a high level interface to the HYPRE library. The goal of this interface is
that the style and API should feel natural to most Julia programmers (it is "Julian"). In
particular, you can use standard sparse matrices together with HYPRE's solvers through this
interface.

The high level interface does not (currently) provide access to all of HYPREs functionality,
but it can easily be combined with the low level interface when necessary.

BoomerAMG can also be used as preconditioner for Julia iterative solvers via LinearSolve.jl as follows:

```julia
using HYPRE, LinearSolve

# Helper to set BoomerAMG options after construction
function set_debug_printlevel(amg, A, p)
    HYPRE.HYPRE_BoomerAMGSetPrintLevel(amg, 3)
end

# kwargs will be passed into the BoomerAMG constructor
bamg = HYPRE.BoomerAMGPrecBuilder(
    set_debug_printlevel;
    Tol = 1e-9,
)

# Setup and solve linear problem via LinearSolve as usual
prob = LinearProblem(A, b)
solver = KrylovJL_CG(precs = bamg)
x = solve(prob, solver, atol=1.0e-14)
```

----

##### Low level interface

HYPRE.jl also provide a low level interface for interacting with HYPRE. The goal of this
interface is to stay close to the HYPRE C API. In fact, this interface is automatically
generated based on HYPRE's header files, so this API maps one-to-one with the C API, see
[LibHYPRE C API](@ref) for more details.
