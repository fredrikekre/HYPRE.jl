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

----

##### Low level interface

HYPRE.jl also provide a low level interface for interacting with HYPRE. The goal of this
interface is to stay close to the HYPRE C API. In fact, this interface is automatically
generated based on HYPRE's header files, so this API maps one-to-one with the C API, see
[LibHYPRE C API](@ref) for more details.
