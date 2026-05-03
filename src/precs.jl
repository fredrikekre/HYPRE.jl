struct BoomerAMGPrecWrapper{MatType}
    P::BoomerAMG
    A::MatType
end

function LinearAlgebra.ldiv!(y::AbstractVector, prec::BoomerAMGPrecWrapper, x::AbstractVector)
    fill!(y, eltype(y)(0.0))
    return solve!(prec.P, y, prec.A, x)
end

"""
    HYPRE.BoomerAMGPrecBuilder(settings_fun; kwargs...)

LinearSolve.jl compatible constructor for BoomerAMG preconditioners.
Here `settings_fun(bamg::HYPRE.BoomerAMG, A::AbstractMatrix, p)` will be called on construction to
allow users setting options directly in BoomerAMG via the internal interface. The `kwargs` will be
passed into the BoomerAMG constructor.

## Example

```julia
function set_debug_printlevel(bamg, A, p)
    HYPRE.HYPRE_BoomerAMGSetPrintLevel(bamg, 3)
end
bamg = HYPRE.BoomerAMGPrecBuilder(
    set_debug_printlevel;
    Tol = 1e-9,
)
```
"""
struct BoomerAMGPrecBuilder{SFun, Tk}
    settings_fun!::SFun
    kwargs::Tk
end

# Syntactic sugar wth some defaults
function BoomerAMGPrecBuilder(settings_fun! = (amg, A, p) -> nothing; kwargs...)
    return BoomerAMGPrecBuilder(settings_fun!, kwargs)
end

function (b::BoomerAMGPrecBuilder)(A, p)
    amg = BoomerAMG(; b.kwargs...)
    Internals.set_precond_defaults(amg)
    b.settings_fun!(amg, A, p)
    return (BoomerAMGPrecWrapper(amg, A), LinearAlgebra.I)
end
