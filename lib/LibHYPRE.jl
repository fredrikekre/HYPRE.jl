# Compat against MPI
import MPI: MPI_Comm
import MPI.API: MPI_INT, MPI_DOUBLE

# Compat against C enum type
using CEnum 

# HYPRE artifact
using HYPRE_jll

# Generated API
include("./LibHYPRECommon.jl")
include("./LibHYPREAPI.jl")
