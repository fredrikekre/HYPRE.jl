# SPDX-License-Identifier: MIT

"""
    HYPRESolver

Abstract super type of all the wrapped HYPRE solvers.
"""
abstract type HYPRESolver end

# Generic fallback allocating a zero vector as initial guess
# TODO: This should allocate x using the owned cols instead of rows of A/b, but currently
#       it is assumed these are always equivalent.
"""
    solve(solver::HYPRESolver, A::HYPREMatrix, b::HYPREVector)

Solve the linear system `A x = b` using `solver` and return the solution vector.

This method allocates the initial guess/output vector `x`, initialized to 0.

See also [`solve!`](@ref).
"""
solve(solver::HYPRESolver, A::HYPREMatrix, b::HYPREVector) = solve!(solver, zero(b), A, b)

"""
    solve!(solver::HYPRESolver, x::HYPREVector, A::HYPREMatrix, b::HYPREVector)

Solve the linear system `A x = b` using `solver` with `x` as the initial guess.

See also [`solve`](@ref).
"""
solve!(pcg::HYPRESolver, x::HYPREVector, A::HYPREMatrix, ::HYPREVector)


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
    @check HYPRE_PCGSetPrecond(pcg.solver, Internals.solve_func(p), Internals.setup_func(p), p.solver)
    return nothing
end
