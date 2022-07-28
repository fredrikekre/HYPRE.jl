# SPDX-License-Identifier: MIT

"""
    HYPRESolver

Abstract super type of all the wrapped HYPRE solvers.
"""
abstract type HYPRESolver end

# Fallback for the solvers that doesn't have required defaults
Internals.set_precond_defaults(::HYPRESolver) = nothing

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
    x = copy!(similar(b, HYPRE_Complex), hypre_x)
    return x
end
function solve!(solver::HYPRESolver, x::PVector, A::PSparseMatrix, b::PVector)
    hypre_x = HYPREVector(x)
    solve!(solver, hypre_x, HYPREMatrix(A), HYPREVector(b))
    copy!(x, hypre_x)
    return x
end

########################################
# SparseMatrixCS(C|R) solver interface #
########################################

# TODO: This could use the HYPRE compile flag for sequential mode to avoid MPI overhead

function solve(solver::HYPRESolver, A::Union{SparseMatrixCSC,SparseMatrixCSR}, b::Vector)
    hypre_x = solve(solver, HYPREMatrix(A), HYPREVector(b))
    x = copy!(similar(b, HYPRE_Complex), hypre_x)
    return x
end
function solve!(solver::HYPRESolver, x::Vector, A::Union{SparseMatrixCSC,SparseMatrixCSR}, b::Vector)
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
    comm::MPI.Comm
    solver::HYPRE_Solver
    function BiCGSTAB(comm::MPI.Comm=MPI.COMM_NULL; kwargs...)
        # comm defaults to COMM_NULL since it is unused in HYPRE_ParCSRBiCGSTABCreate
        solver = new(comm, C_NULL)
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
    @check HYPRE_ParCSRBiCGSTABSetup(bicg.solver, A.parmatrix, b.parvector, x.parvector)
    @check HYPRE_ParCSRBiCGSTABSolve(bicg.solver, A.parmatrix, b.parvector, x.parvector)
    return x
end

Internals.setup_func(::BiCGSTAB) = HYPRE_ParCSRBiCGSTABSetup
Internals.solve_func(::BiCGSTAB) = HYPRE_ParCSRBiCGSTABSolve

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
    @check HYPRE_BoomerAMGSetup(amg.solver, A.parmatrix, b.parvector, x.parvector)
    @check HYPRE_BoomerAMGSolve(amg.solver, A.parmatrix, b.parvector, x.parvector)
    return x
end

Internals.setup_func(::BoomerAMG) = HYPRE_BoomerAMGSetup
Internals.solve_func(::BoomerAMG) = HYPRE_BoomerAMGSolve

function Internals.set_precond_defaults(amg::BoomerAMG)
    defaults = (; Tol = 0.0, MaxIter = 1)
    Internals.set_options(amg, pairs(defaults))
    return nothing
end


#########
## FSAI #
#########

# Requires version 2.25

#mutable struct FSAI <: HYPRESolver
#    solver::HYPRE_Solver
#    function FSAI(; kwargs...)
#        solver = new(C_NULL)
#        solver_ref = Ref{HYPRE_Solver}(C_NULL)
#        @check HYPRE_FSAICreate(solver_ref)
#        solver.solver = solver_ref[]
#        # Attach a finalizer
#        finalizer(x -> HYPRE_FSAIDestroy(x.solver), solver)
#        # Set the options
#        Internals.set_options(solver, kwargs)
#        return solver
#    end
#end

#function solve!(fsai::FSAI, x::HYPREVector, A::HYPREMatrix, b::HYPREVector)
#    @check HYPRE_FSAISetup(fsai.solver, A.parmatrix, b.parvector, x.parvector)
#    @check HYPRE_FSAISolve(fsai.solver, A.parmatrix, b.parvector, x.parvector)
#    return x
#end

#Internals.setup_func(::FSAI) = HYPRE_FSAISetup
#Internals.solve_func(::FSAI) = HYPRE_FSAISolve

#function Internals.set_precond_defaults(fsai::FSAI)
#    defaults = (; Tolerance = 0.0)
#    Internals.set_options(fsai, pairs(defaults))
#    return nothing
#end


#########
# GMRES #
#########

mutable struct GMRES <: HYPRESolver
    comm::MPI.Comm
    solver::HYPRE_Solver
    function GMRES(comm::MPI.Comm=MPI.COMM_NULL; kwargs...)
        # comm defaults to COMM_NULL since it is unused in HYPRE_ParCSRGMRESCreate
        solver = new(comm, C_NULL)
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
    @check HYPRE_ParCSRGMRESSetup(gmres.solver, A.parmatrix, b.parvector, x.parvector)
    @check HYPRE_ParCSRGMRESSolve(gmres.solver, A.parmatrix, b.parvector, x.parvector)
    return x
end

Internals.setup_func(::GMRES) = HYPRE_ParCSRGMRESSetup
Internals.solve_func(::GMRES) = HYPRE_ParCSRGMRESSolve

function Internals.set_precond(gmres::GMRES, p::HYPRESolver)
    solve_f = Internals.solve_func(p)
    setup_f = Internals.setup_func(p)
    @check HYPRE_ParCSRGMRESSetPrecond(gmres.solver, solve_f, setup_f, p.solver)
    return nothing
end


#####################
# (ParCSR)ParaSails #
#####################

mutable struct ParaSails <: HYPRESolver
    comm::MPI.Comm
    solver::HYPRE_Solver
    function ParaSails(comm::MPI.Comm=MPI.COMM_WORLD; kwargs...)
        # Note: comm is used in this solver so default to COMM_WORLD
        solver = new(comm, C_NULL)
        solver_ref = Ref{HYPRE_Solver}(C_NULL)
        @check HYPRE_ParCSRParaSailsCreate(comm, solver_ref)
        solver.solver = solver_ref[]
        # Attach a finalizer
        finalizer(x -> HYPRE_ParCSRParaSailsDestroy(x.solver), solver)
        # Set the options
        Internals.set_options(solver, kwargs)
        return solver
    end
end

const ParCSRParaSails = ParaSails

Internals.setup_func(::ParaSails) = HYPRE_ParCSRParaSailsSetup
Internals.solve_func(::ParaSails) = HYPRE_ParCSRParaSailsSolve


###############
# (ParCSR)PCG #
###############

mutable struct PCG <: HYPRESolver
    comm::MPI.Comm
    solver::HYPRE_Solver
    function PCG(comm::MPI.Comm=MPI.COMM_NULL; kwargs...)
        # comm defaults to COMM_NULL since it is unused in HYPRE_ParCSRPCGCreate
        solver = new(comm, C_NULL)
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
    @check HYPRE_ParCSRPCGSetup(pcg.solver, A.parmatrix, b.parvector, x.parvector)
    @check HYPRE_ParCSRPCGSolve(pcg.solver, A.parmatrix, b.parvector, x.parvector)
    return x
end

Internals.setup_func(::PCG) = HYPRE_ParCSRPCGSetup
Internals.solve_func(::PCG) = HYPRE_ParCSRPCGSolve

function Internals.set_precond(pcg::PCG, p::HYPRESolver)
    solve_f = Internals.solve_func(p)
    setup_f = Internals.setup_func(p)
    @check HYPRE_ParCSRPCGSetPrecond(pcg.solver, solve_f, setup_f, p.solver)
    return nothing
end
