module HYPRE

module LibHYPRE
    include("../lib/LibHYPRE.jl")

    # Add manual methods for some ::Function signatures where the library wants function
    # pointers. Instead of creating function pointers to the Julia wrappers we can just look
    # up the pointer in the library and pass that.
    # TODO: Maybe this can be done automatically as post-process pass in Clang.jl

    import Libdl: dlsym

    function HYPRE_PCGSetPrecond(solver, precond::Function, precond_setup::Function, precond_solver)
        precond_ptr = dlsym(HYPRE_jll.libHYPRE_handle, Symbol(precond))
        precond_setup_ptr = dlsym(HYPRE_jll.libHYPRE_handle, Symbol(precond_setup))
        return HYPRE_PCGSetPrecond(solver, precond_ptr, precond_setup_ptr, precond_solver)
    end
    function HYPRE_GMRESSetPrecond(solver, precond::Function, precond_setup::Function, precond_solver)
        precond_ptr = dlsym(HYPRE_jll.libHYPRE_handle, Symbol(precond))
        precond_setup_ptr = dlsym(HYPRE_jll.libHYPRE_handle, Symbol(precond_setup))
        return HYPRE_GMRESSetPrecond(solver, precond_ptr, precond_setup_ptr, precond_solver)
    end
    function HYPRE_FlexGMRESSetPrecond(solver, precond::Function, precond_setup::Function, precond_solver)
        precond_ptr = dlsym(HYPRE_jll.libHYPRE_handle, Symbol(precond))
        precond_setup_ptr = dlsym(HYPRE_jll.libHYPRE_handle, Symbol(precond_setup))
        return HYPRE_FlexGMRESSetPrecond(solver, precond_ptr, precond_setup_ptr, precond_solver)
    end
    function HYPRE_LGMRESSetPrecond(solver, precond::Function, precond_setup::Function, precond_solver)
        precond_ptr = dlsym(HYPRE_jll.libHYPRE_handle, Symbol(precond))
        precond_setup_ptr = dlsym(HYPRE_jll.libHYPRE_handle, Symbol(precond_setup))
        return HYPRE_LGMRESSetPrecond(solver, precond_ptr, precond_setup_ptr, precond_solver)
    end
    function HYPRE_COGMRESSetPrecond(solver, precond::Function, precond_setup::Function, precond_solver)
        precond_ptr = dlsym(HYPRE_jll.libHYPRE_handle, Symbol(precond))
        precond_setup_ptr = dlsym(HYPRE_jll.libHYPRE_handle, Symbol(precond_setup))
        return HYPRE_COGMRESSetPrecond(solver, precond_ptr, precond_setup_ptr, precond_solver)
    end
    function HYPRE_BiCGSTABSetPrecond(solver, precond::Function, precond_setup::Function, precond_solver)
        precond_ptr = dlsym(HYPRE_jll.libHYPRE_handle, Symbol(precond))
        precond_setup_ptr = dlsym(HYPRE_jll.libHYPRE_handle, Symbol(precond_setup))
        return HYPRE_BiCGSTABSetPrecond(solver, precond_ptr, precond_setup_ptr, precond_solver)
    end
    function HYPRE_CGNRSetPrecond(solver, precond::Function, precondT::Function, precond_setup::Function, precond_solver)
        precond_ptr = dlsym(HYPRE_jll.libHYPRE_handle, Symbol(precond))
        precondT_ptr = dlsym(HYPRE_jll.libHYPRE_handle, Symbol(precondT))
        precond_setup_ptr = dlsym(HYPRE_jll.libHYPRE_handle, Symbol(precond_setup))
        return HYPRE_CGNRSetPrecond(solver, precond_ptr, precondT_ptr, precond_setup_ptr, precond_solver)
    end
    function HYPRE_LOBPCGSetPrecond(solver, precond::Function, precond_setup::Function, precond_solver)
        precond_ptr = dlsym(HYPRE_jll.libHYPRE_handle, Symbol(precond))
        precond_setup_ptr = dlsym(HYPRE_jll.libHYPRE_handle, Symbol(precond_setup))
        return HYPRE_LOBPCGSetPrecond(solver, precond_ptr, precond_setup_ptr, precond_solver)
    end


    # Export everything with HYPRE_ prefix
    for name in names(@__MODULE__; all=true)
        if startswith(string(name), "HYPRE_")
            @eval export $name
        end
    end
end

using SparseArrays: SparseArrays, SparseMatrixCSC, nnz, rowvals, nonzeros, nzrange
using SparseMatricesCSR: SparseMatrixCSR, colvals
using MPI: MPI
using .LibHYPRE

module Internals
    function check_n_rows end
    function to_hypre_data end
end

function Internals.check_n_rows(A, ilower, iupper)
    if size(A, 1) != (iupper - ilower + 1)
        throw(ArgumentError("number of rows in matrix does not match global start/end rows ilower and iupper"))
    end
end

function Internals.to_hypre_data(A::SparseMatrixCSC, ilower, iupper)
    Internals.check_n_rows(A, ilower, iupper)
    nnz = SparseArrays.nnz(A)
    A_rows = rowvals(A)
    A_vals = nonzeros(A)

    # Initialize data as HYPRE expects
    nrows = HYPRE_Int(iupper - ilower + 1)      # Total number of rows
    ncols = zeros(HYPRE_Int, nrows)             # Number of colums for each row
    rows = collect(HYPRE_BigInt, ilower:iupper) # The row indices
    cols = Vector{HYPRE_BigInt}(undef, nnz)     # The column indices
    values = Vector{HYPRE_Complex}(undef, nnz)  # The values

    # First pass to count nnz per row
    @inbounds for j in 1:size(A, 2)
        for i in nzrange(A, j)
            row = A_rows[i]
            ncols[row] += 1
        end
    end

    # Keep track of the last index used for every row
    lastinds = zeros(Int, nrows)
    cumsum!((@view lastinds[2:end]), (@view ncols[1:end-1]))

    # Second pass to populate the output
    @inbounds for j in 1:size(A, 2)
        for i in nzrange(A, j)
            row = A_rows[i]
            k = lastinds[row] += 1
            val = A_vals[i]
            cols[k] = j
            values[k] = val
        end
    end
    return nrows, ncols, rows, cols, values
end

function Internals.to_hypre_data(A::SparseMatrixCSR, ilower, iupper)
    Internals.check_n_rows(A, ilower, iupper)
    nnz = SparseArrays.nnz(A)
    A_cols = colvals(A)
    A_vals = nonzeros(A)

    # Initialize data as HYPRE expects
    nrows = HYPRE_Int(iupper - ilower + 1)      # Total number of rows
    ncols = Vector{HYPRE_Int}(undef, nrows)     # Number of colums for each row
    rows = collect(HYPRE_BigInt, ilower:iupper) # The row indices
    cols = Vector{HYPRE_BigInt}(undef, nnz)     # The column indices
    values = Vector{HYPRE_Complex}(undef, nnz)  # The values

    # Loop over the rows and collect all values
    k = 0
    @inbounds for i in 1:size(A, 1)
        nzr = nzrange(A, i)
        ncols[i] = length(nzr)
        for j in nzr
            k += 1
            col = A_cols[j]
            val = A_vals[j]
            cols[k] = col
            values[k] = val
        end
    end
    @assert nnz == k
    return nrows, ncols, rows, cols, values
end

mutable struct HYPREMatrix # <: AbstractMatrix{HYPRE_Complex}
    IJMatrix::HYPRE_IJMatrix
    ParCSRMatrix::HYPRE_ParCSRMatrix
    HYPREMatrix() = new(C_NULL, C_NULL)
end

function HYPREMatrix(B::Union{SparseMatrixCSC,SparseMatrixCSR}, ilower, iupper, comm::MPI.Comm=MPI.COMM_WORLD)
    # Compute indices/values in the format SetValues expect
    nrows, ncols, rows, cols, values =  Internals.to_hypre_data(B, ilower, iupper)
    # Create the IJ matrix
    A = HYPREMatrix()
    IJMatrixRef = Ref{HYPRE_IJMatrix}(C_NULL)
    HYPRE_IJMatrixCreate(comm, ilower, iupper, ilower, iupper, IJMatrixRef)
    A.IJMatrix = IJMatrixRef[]
    # Attach a finalizer
    finalizer(x -> HYPRE_IJMatrixDestroy(x.IJMatrix), A)
    # Set storage type
    HYPRE_IJMatrixSetObjectType(A.IJMatrix, HYPRE_PARCSR)
    # Initialize to make ready for setting values
    HYPRE_IJMatrixInitialize(A.IJMatrix)
    # Set all the values
    HYPRE_IJMatrixSetValues(A.IJMatrix, nrows, ncols, rows, cols, values)
    # Finalize
    HYPRE_IJMatrixAssemble(A.IJMatrix)
    # Fetch the assembled CSR matrix
    ParCSRMatrixRef = Ref{Ptr{Cvoid}}(C_NULL)
    HYPRE_IJMatrixGetObject(A.IJMatrix, ParCSRMatrixRef)
    A.ParCSRMatrix = convert(Ptr{HYPRE_ParCSRMatrix}, ParCSRMatrixRef[])
    return A
end

mutable struct HYPREVector # <: AbstractVector{HYPRE_Complex}
    IJVector::HYPRE_IJVector
    ParVector::HYPRE_ParVector
    HYPREVector() = new(C_NULL, C_NULL)
end

function Internals.to_hypre_data(x::Vector, ilower, iupper)
    Internals.check_n_rows(x, ilower, iupper)
    indices = collect(HYPRE_BigInt, ilower:iupper)
    values = convert(Vector{HYPRE_Complex}, x)
    return HYPRE_Int(length(indices)), indices, values
end

function HYPREVector(x::Vector, ilower, iupper, comm=MPI.COMM_WORLD)
    nvalues, indices, values = Internals.to_hypre_data(x, ilower, iupper)
    b = HYPREVector()
    b_ref = Ref{HYPRE_IJVector}(C_NULL)
    HYPRE_IJVectorCreate(comm, ilower, iupper, b_ref)
    b.IJVector = b_ref[]
    finalizer(x -> HYPRE_IJVectorDestroy(x.IJVector), b) # Set storage type
    HYPRE_IJVectorSetObjectType(b.IJVector, HYPRE_PARCSR)
    # Initialize to make ready for setting values
    HYPRE_IJVectorInitialize(b.IJVector)
    # Set the values
    HYPRE_IJVectorSetValues(b.IJVector, nvalues, indices, values)
    # Finalize
    HYPRE_IJVectorAssemble(b.IJVector)
    # Fetch the assembled object
    par_b_ref = Ref{Ptr{Cvoid}}(C_NULL)
    HYPRE_IJVectorGetObject(b.IJVector, par_b_ref)
    b.ParVector = convert(Ptr{HYPRE_ParVector}, par_b_ref[])
    return b
end

end # module HYPRE
