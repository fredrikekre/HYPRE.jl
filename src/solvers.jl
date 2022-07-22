# SPDX-License-Identifier: MIT

"""
    HYPRESolver

Abstract super type of all the wrapped HYPRE solvers.
"""
abstract type HYPRESolver end

#############
# BoomerAMG #
#############

mutable struct BoomerAMG <: HYPRESolver
    solver::HYPRE_Solver
    function BoomerAMG(; kwargs...)
        solver = new(C_NULL)
        solver_ref = Ref{HYPRE_Solver}(C_NULL)
        @check HYPRE_BoomerAMGCreate(solver_ref)
        solver.solver = solver_ref[]
        # Attach a finalizer
        finalizer(x -> HYPRE_BoomerAMGDestroy(x.solver), solver)
        # Set the options
        Internals.set_options(solver, kwargs)
        return solver
    end
end

function solve!(amg::BoomerAMG, x::HYPREVector, A::HYPREMatrix, b::HYPREVector)
    @check HYPRE_BoomerAMGSetup(amg.solver, A.ParCSRMatrix, b.ParVector, x.ParVector)
    @check HYPRE_BoomerAMGSolve(amg.solver, A.ParCSRMatrix, b.ParVector, x.ParVector)
    return x
end

Internals.solve_func(::BoomerAMG) = HYPRE_BoomerAMGSolve
Internals.setup_func(::BoomerAMG) = HYPRE_BoomerAMGSetup
