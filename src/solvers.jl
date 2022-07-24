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
    solve(solver::HYPRESolver, A::HYPREMatrix, b::HYPREVector) -> HYPREVector

Solve the linear system `A x = b` using `solver` and return the approximate solution.

This method allocates an initial guess/output vector `x`, initialized to 0.

See also [`solve!`](@ref).
"""
solve(solver::HYPRESolver, A::HYPREMatrix, b::HYPREVector) = solve!(solver, zero(b), A, b)

"""
    solve!(solver::HYPRESolver, x::HYPREVector, A::HYPREMatrix, b::HYPREVector)

Solve the linear system `A x = b` using `solver` with `x` as the initial guess.
The approximate solution is stored in `x`.

See also [`solve`](@ref).
"""
solve!(pcg::HYPRESolver, x::HYPREVector, A::HYPREMatrix, ::HYPREVector)


######################################
# PartitionedArrays solver interface #
######################################

# TODO: Would it be useful with a method that copied the solution to b instead?

function solve(solver::HYPRESolver, A::PSparseMatrix, b::PVector)
    hypre_x = solve(solver, HYPREMatrix(A), HYPREVector(b))
    # TODO: This could be a HYPREVector -> PVector conversion
    x = copy!(copy(b), hypre_x)
    return x
end
function solve!(solver::HYPRESolver, x::PVector, A::PSparseMatrix, b::PVector)
    hypre_x = HYPREVector(x)
    solve!(solver, hypre_x, HYPREMatrix(A), HYPREVector(b))
    copy!(x, hypre_x)
    return x
end


#####################################
## Concrete solver implementations ##
#####################################


####################
# (ParCSR)BiCGSTAB #
####################

mutable struct BiCGSTAB <: HYPRESolver
    solver::HYPRE_Solver
    function BiCGSTAB(comm::MPI.Comm=MPI.COMM_WORLD; kwargs...)
        solver = new(C_NULL)
        solver_ref = Ref{HYPRE_Solver}(C_NULL)
        @check HYPRE_ParCSRBiCGSTABCreate(comm, solver_ref)
        solver.solver = solver_ref[]
        # Attach a finalizer
        finalizer(x -> HYPRE_ParCSRBiCGSTABDestroy(x.solver), solver)
        # Set the options
        Internals.set_options(solver, kwargs)
        return solver
    end
end

const ParCSRBiCGSTAB = BiCGSTAB

function solve!(bicg::BiCGSTAB, x::HYPREVector, A::HYPREMatrix, b::HYPREVector)
    @check HYPRE_ParCSRBiCGSTABSetup(bicg.solver, A.ParCSRMatrix, b.ParVector, x.ParVector)
    @check HYPRE_ParCSRBiCGSTABSolve(bicg.solver, A.ParCSRMatrix, b.ParVector, x.ParVector)
    return x
end

Internals.solve_func(::BiCGSTAB) = HYPRE_ParCSRBiCGSTABSolve
Internals.setup_func(::BiCGSTAB) = HYPRE_ParCSRBiCGSTABSetup

function Internals.set_precond(bicg::BiCGSTAB, p::HYPRESolver)
    solve_f = Internals.solve_func(p)
    setup_f = Internals.setup_func(p)
    @check HYPRE_ParCSRBiCGSTABSetPrecond(bicg.solver, solve_f, setup_f, p.solver)
    return nothing
end


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


#########
# GMRES #
#########

mutable struct GMRES <: HYPRESolver
    solver::HYPRE_Solver
    function GMRES(comm::MPI.Comm=MPI.COMM_WORLD; kwargs...)
        solver = new(C_NULL)
        solver_ref = Ref{HYPRE_Solver}(C_NULL)
        @check HYPRE_ParCSRGMRESCreate(comm, solver_ref)
        solver.solver = solver_ref[]
        # Attach a finalizer
        finalizer(x -> HYPRE_ParCSRGMRESDestroy(x.solver), solver)
        # Set the options
        Internals.set_options(solver, kwargs)
        return solver
    end
end

function solve!(gmres::GMRES, x::HYPREVector, A::HYPREMatrix, b::HYPREVector)
    @check HYPRE_ParCSRGMRESSetup(gmres.solver, A.ParCSRMatrix, b.ParVector, x.ParVector)
    @check HYPRE_ParCSRGMRESSolve(gmres.solver, A.ParCSRMatrix, b.ParVector, x.ParVector)
    return x
end

Internals.solve_func(::GMRES) = HYPRE_ParCSRGMRESSetup
Internals.setup_func(::GMRES) = HYPRE_ParCSRGMRESSolve

function Internals.set_precond(gmres::GMRES, p::HYPRESolver)
    solve_f = Internals.solve_func(p)
    setup_f = Internals.setup_func(p)
    @check HYPRE_ParCSRGMRESSetPrecond(gmres.solver, solve_f, setup_f, p.solver)
    return nothing
end


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
