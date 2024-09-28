# API

## Initialization and configuration

```@docs
HYPRE.Init
```

## Matrix/vector creation

```@docs
HYPRE.start_assemble!
HYPRE.assemble!
HYPRE.finish_assemble!
```

## Solvers and preconditioners

```@docs
HYPRE.solve!
HYPRE.solve
```

```@docs
HYPRE.HYPRESolver
HYPRE.BiCGSTAB
HYPRE.BoomerAMG
HYPRE.FlexGMRES
HYPRE.GMRES
HYPRE.Hybrid
HYPRE.ILU
HYPRE.PCG
HYPRE.ParaSails
```

```@docs
HYPRE.GetNumIterations
HYPRE.GetFinalRelativeResidualNorm
```
