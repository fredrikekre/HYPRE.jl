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


###############
# (ParCSR)PCG #
###############

mutable struct PCG <: HYPRESolver
    solver::HYPRE_Solver
    function PCG(comm::MPI.Comm=MPI.COMM_WORLD; kwargs...)
        solver = new(C_NULL)
        solver_ref = Ref{HYPRE_Solver}(C_NULL)
        @check HYPRE_ParCSRPCGCreate(comm, solver_ref)
        solver.solver = solver_ref[]
        # Attach a finalizer
        finalizer(x -> HYPRE_ParCSRPCGDestroy(x.solver), solver)
        # Set the options
        Internals.set_options(solver, kwargs)
        return solver
    end
end

const ParCSRPCG = PCG

function solve!(pcg::PCG, x::HYPREVector, A::HYPREMatrix, b::HYPREVector)
    @check HYPRE_ParCSRPCGSetup(pcg.solver, A.ParCSRMatrix, b.ParVector, x.ParVector)
    @check HYPRE_ParCSRPCGSolve(pcg.solver, A.ParCSRMatrix, b.ParVector, x.ParVector)
    return x
end

Internals.solve_func(::PCG) = HYPRE_ParCSRPCGSolve
Internals.setup_func(::PCG) = HYPRE_ParCSRPCGSetup

function Internals.set_precond(pcg::PCG, p::HYPRESolver)
    solve_f = Internals.solve_func(p)
    setup_f = Internals.setup_func(p)
    @check HYPRE_ParCSRPCGSetPrecond(pcg.solver, solve_f, setup_f, p.solver)
    return nothing
end
