###########################
## Start gen/prologue.jl ##
###########################

using MPI: MPI, MPI_Comm

if isdefined(MPI, :API)
    # MPI >= 0.20.0
    using MPI.API: MPI_INT, MPI_DOUBLE
else
    # MPI < 0.20.0
    using MPI: MPI_INT, MPI_DOUBLE
end

#########################
## End gen/prologue.jl ##
#########################
