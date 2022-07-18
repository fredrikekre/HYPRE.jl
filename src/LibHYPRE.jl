module LibHYPRE

using Libdl: dlsym

# Clang.jl auto-generated bindings
include("../lib/LibHYPRE.jl")

# Add manual methods for some ::Function signatures where the library wants function
# pointers. Instead of creating function pointers to the Julia wrappers we can just look
# up the pointer in the library and pass that.
# TODO: Maybe this can be done automatically as post-process pass in Clang.jl
function HYPRE_PCGSetPrecond(solver, precond::Function, precond_setup::Function, precond_solver)
    precond_ptr = dlsym(HYPRE_jll.libHYPRE_handle, Symbol(precond))
    precond_setup_ptr = dlsym(HYPRE_jll.libHYPRE_handle, Symbol(precond_setup))
    return HYPRE_PCGSetPrecond(solver, precond_ptr, precond_setup_ptr, precond_solver)
end
function HYPRE_GMRESSetPrecond(solver, precond::Function, precond_setup::Function, precond_solver)
    precond_ptr = dlsym(HYPRE_jll.libHYPRE_handle, Symbol(precond))
    precond_setup_ptr = dlsym(HYPRE_jll.libHYPRE_handle, Symbol(precond_setup))
    return HYPRE_GMRESSetPrecond(solver, precond_ptr, precond_setup_ptr, precond_solver)
end
function HYPRE_FlexGMRESSetPrecond(solver, precond::Function, precond_setup::Function, precond_solver)
    precond_ptr = dlsym(HYPRE_jll.libHYPRE_handle, Symbol(precond))
    precond_setup_ptr = dlsym(HYPRE_jll.libHYPRE_handle, Symbol(precond_setup))
    return HYPRE_FlexGMRESSetPrecond(solver, precond_ptr, precond_setup_ptr, precond_solver)
end
function HYPRE_LGMRESSetPrecond(solver, precond::Function, precond_setup::Function, precond_solver)
    precond_ptr = dlsym(HYPRE_jll.libHYPRE_handle, Symbol(precond))
    precond_setup_ptr = dlsym(HYPRE_jll.libHYPRE_handle, Symbol(precond_setup))
    return HYPRE_LGMRESSetPrecond(solver, precond_ptr, precond_setup_ptr, precond_solver)
end
function HYPRE_COGMRESSetPrecond(solver, precond::Function, precond_setup::Function, precond_solver)
    precond_ptr = dlsym(HYPRE_jll.libHYPRE_handle, Symbol(precond))
    precond_setup_ptr = dlsym(HYPRE_jll.libHYPRE_handle, Symbol(precond_setup))
    return HYPRE_COGMRESSetPrecond(solver, precond_ptr, precond_setup_ptr, precond_solver)
end
function HYPRE_BiCGSTABSetPrecond(solver, precond::Function, precond_setup::Function, precond_solver)
    precond_ptr = dlsym(HYPRE_jll.libHYPRE_handle, Symbol(precond))
    precond_setup_ptr = dlsym(HYPRE_jll.libHYPRE_handle, Symbol(precond_setup))
    return HYPRE_BiCGSTABSetPrecond(solver, precond_ptr, precond_setup_ptr, precond_solver)
end
function HYPRE_CGNRSetPrecond(solver, precond::Function, precondT::Function, precond_setup::Function, precond_solver)
    precond_ptr = dlsym(HYPRE_jll.libHYPRE_handle, Symbol(precond))
    precondT_ptr = dlsym(HYPRE_jll.libHYPRE_handle, Symbol(precondT))
    precond_setup_ptr = dlsym(HYPRE_jll.libHYPRE_handle, Symbol(precond_setup))
    return HYPRE_CGNRSetPrecond(solver, precond_ptr, precondT_ptr, precond_setup_ptr, precond_solver)
end
function HYPRE_LOBPCGSetPrecond(solver, precond::Function, precond_setup::Function, precond_solver)
    precond_ptr = dlsym(HYPRE_jll.libHYPRE_handle, Symbol(precond))
    precond_setup_ptr = dlsym(HYPRE_jll.libHYPRE_handle, Symbol(precond_setup))
    return HYPRE_LOBPCGSetPrecond(solver, precond_ptr, precond_setup_ptr, precond_solver)
end

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
