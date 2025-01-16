# SPDX-License-Identifier: MIT

"""
    HYPRESolver

Abstract super type of all the wrapped HYPRE solvers.
"""
abstract type HYPRESolver end

function Internals.safe_finalizer(Destroy, solver)
    # Add the solver to object tracker for possible atexit finalizing
    push!(Internals.HYPRE_OBJECTS, solver => nothing)
    # Add a finalizer that only calls Destroy if pointer not C_NULL
    finalizer(solver) do s
        if s.solver != C_NULL
            Destroy(s)
            s.solver = C_NULL
        end
    end
    return
end

# Defining unsafe_convert enables ccall to automatically convert solver::HYPRESolver to
# HYPRE_Solver while also making sure solver won't be GC'd and finalized.
Base.unsafe_convert(::Type{HYPRE_Solver}, solver::HYPRESolver) = solver.solver

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
    precond::Union{HYPRESolver, Nothing}
    function BiCGSTAB(comm::MPI.Comm = MPI.COMM_NULL; kwargs...)
        # comm defaults to COMM_NULL since it is unused in HYPRE_ParCSRBiCGSTABCreate
        solver = new(comm, C_NULL, nothing)
        solver_ref = Ref{HYPRE_Solver}(C_NULL)
        @check HYPRE_ParCSRBiCGSTABCreate(comm, solver_ref)
        solver.solver = solver_ref[]
        # Attach a finalizer
        Internals.safe_finalizer(HYPRE_ParCSRBiCGSTABDestroy, solver)
        # Set the options
        Internals.set_options(solver, kwargs)
        return solver
    end
end

const ParCSRBiCGSTAB = BiCGSTAB

function solve!(bicg::BiCGSTAB, x::HYPREVector, A::HYPREMatrix, b::HYPREVector)
    @check HYPRE_ParCSRBiCGSTABSetup(bicg, A, b, x)
    @check HYPRE_ParCSRBiCGSTABSolve(bicg, A, b, x)
    return x
end

Internals.setup_func(::BiCGSTAB) = HYPRE_ParCSRBiCGSTABSetup
Internals.solve_func(::BiCGSTAB) = HYPRE_ParCSRBiCGSTABSolve

function Internals.set_precond(bicg::BiCGSTAB, p::HYPRESolver)
    bicg.precond = p
    solve_f = Internals.solve_func(p)
    setup_f = Internals.setup_func(p)
    @check HYPRE_ParCSRBiCGSTABSetPrecond(bicg, solve_f, setup_f, p)
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
        Internals.safe_finalizer(HYPRE_BoomerAMGDestroy, solver)
        # Set the options
        Internals.set_options(solver, kwargs)
        return solver
    end
end

function solve!(amg::BoomerAMG, x::HYPREVector, A::HYPREMatrix, b::HYPREVector)
    @check HYPRE_BoomerAMGSetup(amg, A, b, x)
    @check HYPRE_BoomerAMGSolve(amg, A, b, x)
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
    precond::Union{HYPRESolver, Nothing}
    function FlexGMRES(comm::MPI.Comm = MPI.COMM_NULL; kwargs...)
        # comm defaults to COMM_NULL since it is unused in HYPRE_ParCSRFlexGMRESCreate
        solver = new(comm, C_NULL, nothing)
        solver_ref = Ref{HYPRE_Solver}(C_NULL)
        @check HYPRE_ParCSRFlexGMRESCreate(comm, solver_ref)
        solver.solver = solver_ref[]
        # Attach a finalizer
        Internals.safe_finalizer(HYPRE_ParCSRFlexGMRESDestroy, solver)
        # Set the options
        Internals.set_options(solver, kwargs)
        return solver
    end
end

function solve!(flex::FlexGMRES, x::HYPREVector, A::HYPREMatrix, b::HYPREVector)
    @check HYPRE_ParCSRFlexGMRESSetup(flex, A, b, x)
    @check HYPRE_ParCSRFlexGMRESSolve(flex, A, b, x)
    return x
end

Internals.setup_func(::FlexGMRES) = HYPRE_ParCSRFlexGMRESSetup
Internals.solve_func(::FlexGMRES) = HYPRE_ParCSRFlexGMRESSolve

function Internals.set_precond(flex::FlexGMRES, p::HYPRESolver)
    flex.precond = p
    solve_f = Internals.solve_func(p)
    setup_f = Internals.setup_func(p)
    @check HYPRE_ParCSRFlexGMRESSetPrecond(flex, solve_f, setup_f, p)
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
#    @check HYPRE_FSAISetup(fsai, A, b, x)
#    @check HYPRE_FSAISolve(fsai, A, b, x)
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
    precond::Union{HYPRESolver, Nothing}
    function GMRES(comm::MPI.Comm = MPI.COMM_NULL; kwargs...)
        # comm defaults to COMM_NULL since it is unused in HYPRE_ParCSRGMRESCreate
        solver = new(comm, C_NULL, nothing)
        solver_ref = Ref{HYPRE_Solver}(C_NULL)
        @check HYPRE_ParCSRGMRESCreate(comm, solver_ref)
        solver.solver = solver_ref[]
        # Attach a finalizer
        Internals.safe_finalizer(HYPRE_ParCSRGMRESDestroy, solver)
        # Set the options
        Internals.set_options(solver, kwargs)
        return solver
    end
end

function solve!(gmres::GMRES, x::HYPREVector, A::HYPREMatrix, b::HYPREVector)
    @check HYPRE_ParCSRGMRESSetup(gmres, A, b, x)
    @check HYPRE_ParCSRGMRESSolve(gmres, A, b, x)
    return x
end

Internals.setup_func(::GMRES) = HYPRE_ParCSRGMRESSetup
Internals.solve_func(::GMRES) = HYPRE_ParCSRGMRESSolve

function Internals.set_precond(gmres::GMRES, p::HYPRESolver)
    gmres.precond = p
    solve_f = Internals.solve_func(p)
    setup_f = Internals.setup_func(p)
    @check HYPRE_ParCSRGMRESSetPrecond(gmres, solve_f, setup_f, p)
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
    precond::Union{HYPRESolver, Nothing}
    function Hybrid(; kwargs...)
        solver = new(C_NULL, nothing)
        solver_ref = Ref{HYPRE_Solver}(C_NULL)
        @check HYPRE_ParCSRHybridCreate(solver_ref)
        solver.solver = solver_ref[]
        # Attach a finalizer
        Internals.safe_finalizer(HYPRE_ParCSRHybridDestroy, solver)
        # Set the options
        Internals.set_options(solver, kwargs)
        return solver
    end
end

function solve!(hybrid::Hybrid, x::HYPREVector, A::HYPREMatrix, b::HYPREVector)
    @check HYPRE_ParCSRHybridSetup(hybrid, A, b, x)
    @check HYPRE_ParCSRHybridSolve(hybrid, A, b, x)
    return x
end

Internals.setup_func(::Hybrid) = HYPRE_ParCSRHybridSetup
Internals.solve_func(::Hybrid) = HYPRE_ParCSRHybridSolve

function Internals.set_precond(hybrid::Hybrid, p::HYPRESolver)
    hybrid.precond = p
    solve_f = Internals.solve_func(p)
    setup_f = Internals.setup_func(p)
    # Deactivate the finalizer of p since the HYBRIDDestroy function does this,
    # see https://github.com/hypre-space/hypre/issues/699
    finalizer(x -> (x.solver = C_NULL), p)
    @check HYPRE_ParCSRHybridSetPrecond(hybrid, solve_f, setup_f, p)
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
        Internals.safe_finalizer(HYPRE_ILUDestroy, solver)
        # Set the options
        Internals.set_options(solver, kwargs)
        return solver
    end
end

function solve!(ilu::ILU, x::HYPREVector, A::HYPREMatrix, b::HYPREVector)
    @check HYPRE_ILUSetup(ilu, A, b, x)
    @check HYPRE_ILUSolve(ilu, A, b, x)
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
    function ParaSails(comm::MPI.Comm = MPI.COMM_WORLD; kwargs...)
        # Note: comm is used in this solver so default to COMM_WORLD
        solver = new(comm, C_NULL)
        solver_ref = Ref{HYPRE_Solver}(C_NULL)
        @check HYPRE_ParCSRParaSailsCreate(comm, solver_ref)
        solver.solver = solver_ref[]
        # Attach a finalizer
        Internals.safe_finalizer(HYPRE_ParCSRParaSailsDestroy, solver)
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
    precond::Union{HYPRESolver, Nothing}
    function PCG(comm::MPI.Comm = MPI.COMM_NULL; kwargs...)
        # comm defaults to COMM_NULL since it is unused in HYPRE_ParCSRPCGCreate
        solver = new(comm, C_NULL, nothing)
        solver_ref = Ref{HYPRE_Solver}(C_NULL)
        @check HYPRE_ParCSRPCGCreate(comm, solver_ref)
        solver.solver = solver_ref[]
        # Attach a finalizer
        Internals.safe_finalizer(HYPRE_ParCSRPCGDestroy, solver)
        # Set the options
        Internals.set_options(solver, kwargs)
        return solver
    end
end

const ParCSRPCG = PCG

function solve!(pcg::PCG, x::HYPREVector, A::HYPREMatrix, b::HYPREVector)
    @check HYPRE_ParCSRPCGSetup(pcg, A, b, x)
    @check HYPRE_ParCSRPCGSolve(pcg, A, b, x)
    return x
end

Internals.setup_func(::PCG) = HYPRE_ParCSRPCGSetup
Internals.solve_func(::PCG) = HYPRE_ParCSRPCGSolve

function Internals.set_precond(pcg::PCG, p::HYPRESolver)
    pcg.precond = p
    solve_f = Internals.solve_func(p)
    setup_f = Internals.setup_func(p)
    @check HYPRE_ParCSRPCGSetPrecond(pcg, solve_f, setup_f, p)
    return nothing
end


##########################################################
# Extracting information about the solution from solvers #
##########################################################

"""
    HYPRE.GetFinalRelativeResidualNorm(s::HYPRESolver)

Return the final relative residual norm from the last solve with solver `s`.

This function dispatches on the solver to the corresponding C API wrapper
`LibHYPRE.HYPRE_\$(Solver)GetFinalRelativeResidualNorm`.
"""
function GetFinalRelativeResidualNorm(s::HYPRESolver)
    r = Ref{HYPRE_Real}()
    if s isa BiCGSTAB
        @check HYPRE_ParCSRBiCGSTABGetFinalRelativeResidualNorm(s, r)
    elseif s isa BoomerAMG
        @check HYPRE_BoomerAMGGetFinalRelativeResidualNorm(s, r)
    elseif s isa FlexGMRES
        @check HYPRE_ParCSRFlexGMRESGetFinalRelativeResidualNorm(s, r)
    elseif s isa GMRES
        @check HYPRE_ParCSRGMRESGetFinalRelativeResidualNorm(s, r)
    elseif s isa Hybrid
        @check HYPRE_ParCSRHybridGetFinalRelativeResidualNorm(s, r)
    elseif s isa ILU
        @check HYPRE_ILUGetFinalRelativeResidualNorm(s, r)
    elseif s isa PCG
        @check HYPRE_ParCSRPCGGetFinalRelativeResidualNorm(s, r)
    else
        throw(ArgumentError("cannot get residual norm for $(typeof(s))"))
    end
    return r[]
end

"""
    HYPRE.GetNumIterations(s::HYPRESolver)

Return number of iterations during the last solve with solver `s`.

This function dispatches on the solver to the corresponding C API wrapper
`LibHYPRE.HYPRE_\$(Solver)GetNumIterations`.
"""
function GetNumIterations(s::HYPRESolver)
    r = Ref{HYPRE_Int}()
    if s isa BiCGSTAB
        @check HYPRE_ParCSRBiCGSTABGetNumIterations(s, r)
    elseif s isa BoomerAMG
        @check HYPRE_BoomerAMGGetNumIterations(s, r)
    elseif s isa FlexGMRES
        @check HYPRE_ParCSRFlexGMRESGetNumIterations(s, r)
    elseif s isa GMRES
        @check HYPRE_ParCSRGMRESGetNumIterations(s, r)
    elseif s isa Hybrid
        @check HYPRE_ParCSRHybridGetNumIterations(s, r)
    elseif s isa ILU
        @check HYPRE_ILUGetNumIterations(s, r)
    elseif s isa PCG
        @check HYPRE_ParCSRPCGGetNumIterations(s, r)
    else
        throw(ArgumentError("cannot get number of iterations for $(typeof(s))"))
    end
    return r[]
end
