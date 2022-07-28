# SPDX-License-Identifier: MIT

"""
    HYPRESolver

Abstract super type of all the wrapped HYPRE solvers.
"""
abstract type HYPRESolver end

function Internals.safe_finalizer(Destroy)
    # Only calls the Destroy if pointer not C_NULL
    return function(solver)
        if solver.solver != C_NULL
            Destroy(solver.solver)
            solver.solver = C_NULL
        end
    end
end

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

"""
    BiCGSTAB(; settings...)

Create a `BiCGSTAB` solver. See HYPRE API reference for details and supported settings.

**External links**
 - [BiCGSTAB API reference](https://hypre.readthedocs.io/en/latest/api-sol-parcsr.html#breathe-section-title-parcsr-bicgstab-solver)
"""
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
        finalizer(Internals.safe_finalizer(HYPRE_ParCSRBiCGSTABDestroy), solver)
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

"""
    BoomerAMG(; settings...)

Create a `BoomerAMG` solver/preconditioner. See HYPRE API reference for details and
supported settings.

**External links**
 - [BoomerAMG documentation](https://hypre.readthedocs.io/en/latest/solvers-boomeramg.html)
 - [BoomerAMG API reference](https://hypre.readthedocs.io/en/latest/api-sol-parcsr.html#breathe-section-title-parcsr-boomeramg-solver-and-preconditioner)
"""
mutable struct BoomerAMG <: HYPRESolver
    solver::HYPRE_Solver
    function BoomerAMG(; kwargs...)
        solver = new(C_NULL)
        solver_ref = Ref{HYPRE_Solver}(C_NULL)
        @check HYPRE_BoomerAMGCreate(solver_ref)
        solver.solver = solver_ref[]
        # Attach a finalizer
        finalizer(Internals.safe_finalizer(HYPRE_BoomerAMGDestroy), solver)
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


#############
# FlexGMRES #
#############

"""
    FlexGMRES(; settings...)

Create a `FlexGMRES` solver. See HYPRE API reference for details and supported settings.

**External links**
 - [FlexGMRES API reference](https://hypre.readthedocs.io/en/latest/api-sol-parcsr.html#breathe-section-title-parcsr-flexgmres-solver)
"""
mutable struct FlexGMRES <: HYPRESolver
    comm::MPI.Comm
    solver::HYPRE_Solver
    function FlexGMRES(comm::MPI.Comm=MPI.COMM_NULL; kwargs...)
        # comm defaults to COMM_NULL since it is unused in HYPRE_ParCSRFlexGMRESCreate
        solver = new(comm, C_NULL)
        solver_ref = Ref{HYPRE_Solver}(C_NULL)
        @check HYPRE_ParCSRFlexGMRESCreate(comm, solver_ref)
        solver.solver = solver_ref[]
        # Attach a finalizer
        finalizer(Internals.safe_finalizer(HYPRE_ParCSRFlexGMRESDestroy), solver)
        # Set the options
        Internals.set_options(solver, kwargs)
        return solver
    end
end

function solve!(flex::FlexGMRES, x::HYPREVector, A::HYPREMatrix, b::HYPREVector)
    @check HYPRE_ParCSRFlexGMRESSetup(flex.solver, A.parmatrix, b.parvector, x.parvector)
    @check HYPRE_ParCSRFlexGMRESSolve(flex.solver, A.parmatrix, b.parvector, x.parvector)
    return x
end

Internals.setup_func(::FlexGMRES) = HYPRE_ParCSRFlexGMRESSetup
Internals.solve_func(::FlexGMRES) = HYPRE_ParCSRFlexGMRESSolve

function Internals.set_precond(flex::FlexGMRES, p::HYPRESolver)
    solve_f = Internals.solve_func(p)
    setup_f = Internals.setup_func(p)
    @check HYPRE_ParCSRFlexGMRESSetPrecond(flex.solver, solve_f, setup_f, p.solver)
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

"""
    GMRES(; settings...)

Create a `GMRES` solver. See HYPRE API reference for details and supported settings.

**External links**
 - [GMRES API reference](https://hypre.readthedocs.io/en/latest/api-sol-parcsr.html#breathe-section-title-parcsr-gmres-solver)
"""
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
        finalizer(Internals.safe_finalizer(HYPRE_ParCSRGMRESDestroy), solver)
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


##########
# Hybrid #
##########

"""
    Hybrid(; settings...)

Create a `Hybrid` solver. See HYPRE API reference for details and supported settings.

**External links**
 - [Hybrid documentation](https://hypre.readthedocs.io/en/latest/solvers-hybrid.html)
 - [Hybrid API reference](https://hypre.readthedocs.io/en/latest/api-sol-parcsr.html#breathe-section-title-parcsr-hybrid-solver)
"""
mutable struct Hybrid <: HYPRESolver
    solver::HYPRE_Solver
    function Hybrid(; kwargs...)
        solver = new(C_NULL)
        solver_ref = Ref{HYPRE_Solver}(C_NULL)
        @check HYPRE_ParCSRHybridCreate(solver_ref)
        solver.solver = solver_ref[]
        # Attach a finalizer
        finalizer(Internals.safe_finalizer(HYPRE_ParCSRHybridDestroy), solver)
        # Set the options
        Internals.set_options(solver, kwargs)
        return solver
    end
end

function solve!(hybrid::Hybrid, x::HYPREVector, A::HYPREMatrix, b::HYPREVector)
    @check HYPRE_ParCSRHybridSetup(hybrid.solver, A.parmatrix, b.parvector, x.parvector)
    @check HYPRE_ParCSRHybridSolve(hybrid.solver, A.parmatrix, b.parvector, x.parvector)
    return x
end

Internals.setup_func(::Hybrid) = HYPRE_ParCSRHybridSetup
Internals.solve_func(::Hybrid) = HYPRE_ParCSRHybridSolve

function Internals.set_precond(hybrid::Hybrid, p::HYPRESolver)
    solve_f = Internals.solve_func(p)
    setup_f = Internals.setup_func(p)
    # Deactivate the finalizer of p since the HYBRIDDestroy function does this,
    # see https://github.com/hypre-space/hypre/issues/699
    finalizer(x -> (x.solver = C_NULL), p)
    @check HYPRE_ParCSRHybridSetPrecond(hybrid.solver, solve_f, setup_f, p.solver)
    return nothing
end


#######
# ILU #
#######

"""
    ILU(; settings...)

Create a `ILU` solver/preconditioner. See HYPRE API reference for details and supported
settings.

**External links**
 - [ILU documentation](https://hypre.readthedocs.io/en/latest/solvers-hypre-ilu.html)
 - [ILU API reference](https://hypre.readthedocs.io/en/latest/api-sol-parcsr.html#breathe-section-title-parcsr-ilu-solver)
"""
mutable struct ILU <: HYPRESolver
    solver::HYPRE_Solver
    function ILU(; kwargs...)
        solver = new(C_NULL)
        solver_ref = Ref{HYPRE_Solver}(C_NULL)
        @check HYPRE_ILUCreate(solver_ref)
        solver.solver = solver_ref[]
        # Attach a finalizer
        finalizer(Internals.safe_finalizer(HYPRE_ILUDestroy), solver)
        # Set the options
        Internals.set_options(solver, kwargs)
        return solver
    end
end

function solve!(ilu::ILU, x::HYPREVector, A::HYPREMatrix, b::HYPREVector)
    @check HYPRE_ILUSetup(ilu.solver, A.parmatrix, b.parvector, x.parvector)
    @check HYPRE_ILUSolve(ilu.solver, A.parmatrix, b.parvector, x.parvector)
    return x
end

Internals.setup_func(::ILU) = HYPRE_ILUSetup
Internals.solve_func(::ILU) = HYPRE_ILUSolve

function Internals.set_precond_defaults(ilu::ILU)
    defaults = (; Tol = 0.0, MaxIter = 1)
    Internals.set_options(ilu, pairs(defaults))
    return nothing
end


#####################
# (ParCSR)ParaSails #
#####################

"""
    ParaSails(comm=MPI.COMM_WORLD; settings...)

Create a `ParaSails` preconditioner. See HYPRE API reference for details and supported
settings.

**External links**
 - [ParaSails documentation](https://hypre.readthedocs.io/en/latest/solvers-parasails.html)
 - [ParaSails API reference](https://hypre.readthedocs.io/en/latest/api-sol-parcsr.html#breathe-section-title-parcsr-parasails-preconditioner)
"""
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
        finalizer(Internals.safe_finalizer(HYPRE_ParCSRParaSailsDestroy), solver)
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

"""
    PCG(; settings...)

Create a `PCG` solver. See HYPRE API reference for details and supported settings.

**External links**
 - [PCG API reference](https://hypre.readthedocs.io/en/latest/api-sol-parcsr.html#breathe-section-title-parcsr-pcg-solver)
"""
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
        finalizer(Internals.safe_finalizer(HYPRE_ParCSRPCGDestroy), solver)
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
