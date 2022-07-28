# Solvers and preconditioners

HYPRE.jl wraps most of HYPREs [ParCSR solvers and
preconditioners](https://hypre.readthedocs.io/en/latest/api-sol-parcsr.html).

The synopsis for HYPRE.jl's wrappers is the same for all solvers:

```julia
# Setup up linear system (see previous section)
A = HYPREMatrix(...)
b = HYPREVector(...)

# Create a solver
solver = HYPRESolver(; settings...)

# Solve A x = b
x = HYPRE.solve(solver, A, b)
```

Settings are passed as keyword arguments, with the names matching directly to
`HYPRE_SolverSetXXX` calls from the HYPRE C API (see example below). Most settings are
passed directly to HYPRE, for example `Tol = 1e-9` would be passed directly to
`HYPRE_SolverSetTol` for the correponding solver.

Setting a preconditioner can be done by passing a `HYPRESolver` directly with the `Precond`
keyword argument, without any need to also pass the corresponding `HYPRE_SolverSetup` and
`HYPRE_SolverSolve` as must be done in the C API. In addition, solvers that have required
settings when used as a preconditioner will have those applied automatically.

HYPRE.jl adds finalizers to the solvers, which takes care of calling the their respective
`HYPRE_SolverDestroy` function when the solver is garbage collected.

#### Example: Conjugate gradient with algebraic multigrid preconditioner

Here is an example of creating a `PCG` (conjugate gradient) solver with `BoomerAMG`
(algebraic multigrid) as preconditioner:

```julia
# Setup up linear system
A = HYPREMatrix(...)
b = HYPREVector(...)

# Preconditioner
precond = HYPRE.BoomerAMG(; RelaxType = 6, CoarsenType = 6)

# Solver
solver = HYPRE.PCG(; MaxIter = 1000, Tol = 1e-9, Precond = precond)

# Solve
x = HYPRE.solve(solver, A, b)
```

Note that `Tol = 0.0` and `MaxIter = 1` are required settings when using `BoomerAMG` as a
preconditioner. These settings are added automatically since it is passed as a
preconditioner to the `PCG` solver.

!!! not "Corresponding C code"
    For comparison, here is the corresponding C code for setting up the solver above:
    ```c
    /* Setup linear system */
    HYPRE_IJMatrix A;
    HYPRE_IJVector b, x;

    /* Preconditioner */
    HYPRE_Solver precond;
    HYPRE_BoomerAMGCreate(&precond);
    HYPRE_BoomerAMGSetCoarsenType(precond, 6);
    HYPRE_BoomerAMGSetRelaxType(precond, 6);
    HYPRE_BoomerAMGSetTol(precond, 0.0);
    HYPRE_BoomerAMGSetMaxIter(precond, 1);

    /* Solver */
    HYPRE_Solver solver;
    HYPRE_ParCSRPCGCreate(MPI_COMM_WORLD, &solver);
    HYPRE_PCGSetMaxIter(solver, 1000);

    /* Add preconditioner */
    HYPRE_PCGSetPrecond(solver, (HYPRE_PtrToSolverFcn) HYPRE_BoomerAMGSolve,
                                (HYPRE_PtrToSolverFcn) HYPRE_BoomerAMGSetup, precond);

    /* Solve */
    HYPRE_ParCSRPCGSetup(solver, A, b, x);
    HYPRE_ParCSRPCGSolve(solver, A, b, x);
    ```
