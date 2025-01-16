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


struct HYPREError <: Exception
    fn::Symbol
    ierr::HYPRE_Int
end

# See HYPRE_DescribeError(HYPRE_Int ierr, char *msg)
function Base.showerror(io::IO, h::HYPREError)
    print(io, "LibHYPRE.$(h.fn) returned error code $(h.ierr):")
    if (h.ierr & HYPRE_ERROR_GENERIC) != 0
        print(io, " [Generic error]")
    end
    if (h.ierr & HYPRE_ERROR_MEMORY) != 0
        print(io, " [Memory error]")
    end
    if (h.ierr & HYPRE_ERROR_ARG) != 0
        arg = h.ierr >> 3 & 31 # See HYPRE_GetErrorArg()
        print(io, " [Error in argument $arg]")
    end
    if (h.ierr & HYPRE_ERROR_CONV) != 0
        print(io, " [Method did not converge]")
    end
    return nothing
end

# Macro for checking LibHYPRE return codes
macro check(arg)
    Meta.isexpr(arg, :call) || throw(ArgumentError("wrong usage of @check"))
    return quote
        r = $(esc(arg))
        if r != 0
            # Since we throw here we can clear the errors (I think?)
            HYPRE_ClearAllErrors()
            throw(HYPREError($(QuoteNode(arg.args[1])), r))
        end
        r
    end
end

# Export everything with HYPRE_ prefix
for name in names(@__MODULE__; all = true)
    if startswith(string(name), "HYPRE_")
        @eval export $name
    end
end

function __init__()
    major_ref = Ref{HYPRE_Int}(-1)
    minor_ref = Ref{HYPRE_Int}(-1)
    patch_ref = Ref{HYPRE_Int}(-1)
    @check HYPRE_VersionNumber(major_ref, minor_ref, patch_ref, C_NULL)
    global VERSION = VersionNumber(major_ref[], minor_ref[], patch_ref[])
    return
end

end
