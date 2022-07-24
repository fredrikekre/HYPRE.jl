module LibHYPRE

using Libdl: dlsym

# Clang.jl auto-generated bindings
include("../lib/LibHYPRE.jl")

# Add manual methods for some ::Function signatures where the library wants function
# pointers. Instead of creating function pointers to the Julia wrappers we can just look
# up the pointer in the library and pass that.
# TODO: Maybe this can be done automatically as post-process pass in Clang.jl

macro setprecond(fn)
    for idx in 3:4
        fn.args[idx] = Expr(:(::), fn.args[idx], :Function)
    end
    block = quote
        precond_ptr = dlsym(HYPRE_jll.libHYPRE_handle, Symbol(precond))
        precond_setup_ptr = dlsym(HYPRE_jll.libHYPRE_handle, Symbol(precond_setup))
        return $(fn.args[1])(solver, precond_ptr, precond_setup_ptr, precond_solver)
    end
    r = Expr(:function, fn, block)
    return r
end

@setprecond HYPRE_BiCGSTABSetPrecond(solver, precond, precond_setup, precond_solver)
# @setprecond HYPRE_CGNRSetPrecond(solver, precond, precondT, precond_setup, precond_solver)
@setprecond HYPRE_COGMRESSetPrecond(solver, precond, precond_setup, precond_solver)
@setprecond HYPRE_FlexGMRESSetPrecond(solver, precond, precond_setup, precond_solver)
@setprecond HYPRE_GMRESSetPrecond(solver, precond, precond_setup, precond_solver)
@setprecond HYPRE_LGMRESSetPrecond(solver, precond, precond_setup, precond_solver)
@setprecond HYPRE_LOBPCGSetPrecond(solver, precond, precond_setup, precond_solver)
@setprecond HYPRE_PCGSetPrecond(solver, precond, precond_setup, precond_solver)
@setprecond HYPRE_ParCSRBiCGSTABSetPrecond(solver, precond, precond_setup, precond_solver)
# @setprecond HYPRE_ParCSRCGNRSetPrecond(solver, precond, precondT, precond_setup, precond_solver)
@setprecond HYPRE_ParCSRCOGMRESSetPrecond(solver, precond, precond_setup, precond_solver)
@setprecond HYPRE_ParCSRFlexGMRESSetPrecond(solver, precond, precond_setup, precond_solver)
@setprecond HYPRE_ParCSRGMRESSetPrecond(solver, precond, precond_setup, precond_solver)
@setprecond HYPRE_ParCSRHybridSetPrecond(solver, precond, precond_setup, precond_solver)
@setprecond HYPRE_ParCSRLGMRESSetPrecond(solver, precond, precond_setup, precond_solver)
@setprecond HYPRE_ParCSRPCGSetPrecond(solver, precond, precond_setup, precond_solver)


# Macro for checking LibHYPRE return codes
macro check(arg)
    Meta.isexpr(arg, :call) || throw(ArgumentError("wrong usage of @check"))
    msg = "LibHYPRE.$(arg.args[1]) returned non-zero return code: "
    return quote
        r = $(esc(arg))
        if r != 0
            error(string($msg, r))
        end
        r
    end
end

# Export everything with HYPRE_ prefix
for name in names(@__MODULE__; all=true)
    if startswith(string(name), "HYPRE_")
        @eval export $name
    end
end

end
