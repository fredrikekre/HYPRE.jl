using HYPRE_jll
export HYPRE_jll

using CEnum

using MPI: MPI, MPI_Comm
if isdefined(MPI, :API) # MPI >= 0.20.0
    using MPI.API: MPI_INT, MPI_DOUBLE
else # MPI < 0.20.0
    using MPI: MPI_INT, MPI_DOUBLE
end


mutable struct ADIOI_FileD end

const HYPRE_BigInt = Cint

const HYPRE_Int = Cint

const HYPRE_Real = Cdouble

const HYPRE_Complex = HYPRE_Real

# no prototype is found for this function at HYPRE_utilities.h:116:11, please use with caution
function HYPRE_Init()
    ccall((:HYPRE_Init, libHYPRE), HYPRE_Int, ())
end

# no prototype is found for this function at HYPRE_utilities.h:117:11, please use with caution
function HYPRE_Finalize()
    ccall((:HYPRE_Finalize, libHYPRE), HYPRE_Int, ())
end

# no prototype is found for this function at HYPRE_utilities.h:124:11, please use with caution
function HYPRE_GetError()
    ccall((:HYPRE_GetError, libHYPRE), HYPRE_Int, ())
end

function HYPRE_CheckError(hypre_ierr, hypre_error_code)
    ccall((:HYPRE_CheckError, libHYPRE), HYPRE_Int, (HYPRE_Int, HYPRE_Int), hypre_ierr, hypre_error_code)
end

# no prototype is found for this function at HYPRE_utilities.h:131:11, please use with caution
function HYPRE_GetErrorArg()
    ccall((:HYPRE_GetErrorArg, libHYPRE), HYPRE_Int, ())
end

function HYPRE_DescribeError(hypre_ierr, descr)
    ccall((:HYPRE_DescribeError, libHYPRE), Cvoid, (HYPRE_Int, Ptr{Cchar}), hypre_ierr, descr)
end

# no prototype is found for this function at HYPRE_utilities.h:137:11, please use with caution
function HYPRE_ClearAllErrors()
    ccall((:HYPRE_ClearAllErrors, libHYPRE), HYPRE_Int, ())
end

function HYPRE_ClearError(hypre_error_code)
    ccall((:HYPRE_ClearError, libHYPRE), HYPRE_Int, (HYPRE_Int,), hypre_error_code)
end

# no prototype is found for this function at HYPRE_utilities.h:143:11, please use with caution
function HYPRE_PrintDeviceInfo()
    ccall((:HYPRE_PrintDeviceInfo, libHYPRE), HYPRE_Int, ())
end

function HYPRE_Version(version_ptr)
    ccall((:HYPRE_Version, libHYPRE), HYPRE_Int, (Ptr{Ptr{Cchar}},), version_ptr)
end

function HYPRE_VersionNumber(major_ptr, minor_ptr, patch_ptr, single_ptr)
    ccall((:HYPRE_VersionNumber, libHYPRE), HYPRE_Int, (Ptr{HYPRE_Int}, Ptr{HYPRE_Int}, Ptr{HYPRE_Int}, Ptr{HYPRE_Int}), major_ptr, minor_ptr, patch_ptr, single_ptr)
end

# no prototype is found for this function at HYPRE_utilities.h:174:11, please use with caution
function HYPRE_AssumedPartitionCheck()
    ccall((:HYPRE_AssumedPartitionCheck, libHYPRE), HYPRE_Int, ())
end

@cenum _HYPRE_MemoryLocation::Int32 begin
    HYPRE_MEMORY_UNDEFINED = -1
    HYPRE_MEMORY_HOST = 0
    HYPRE_MEMORY_DEVICE = 1
end

const HYPRE_MemoryLocation = _HYPRE_MemoryLocation

function HYPRE_SetMemoryLocation(memory_location)
    ccall((:HYPRE_SetMemoryLocation, libHYPRE), HYPRE_Int, (HYPRE_MemoryLocation,), memory_location)
end

function HYPRE_GetMemoryLocation(memory_location)
    ccall((:HYPRE_GetMemoryLocation, libHYPRE), HYPRE_Int, (Ptr{HYPRE_MemoryLocation},), memory_location)
end

@cenum _HYPRE_ExecutionPolicy::Int32 begin
    HYPRE_EXEC_UNDEFINED = -1
    HYPRE_EXEC_HOST = 0
    HYPRE_EXEC_DEVICE = 1
end

const HYPRE_ExecutionPolicy = _HYPRE_ExecutionPolicy

function HYPRE_SetExecutionPolicy(exec_policy)
    ccall((:HYPRE_SetExecutionPolicy, libHYPRE), HYPRE_Int, (HYPRE_ExecutionPolicy,), exec_policy)
end

function HYPRE_GetExecutionPolicy(exec_policy)
    ccall((:HYPRE_GetExecutionPolicy, libHYPRE), HYPRE_Int, (Ptr{HYPRE_ExecutionPolicy},), exec_policy)
end

function HYPRE_SetStructExecutionPolicy(exec_policy)
    ccall((:HYPRE_SetStructExecutionPolicy, libHYPRE), HYPRE_Int, (HYPRE_ExecutionPolicy,), exec_policy)
end

function HYPRE_GetStructExecutionPolicy(exec_policy)
    ccall((:HYPRE_GetStructExecutionPolicy, libHYPRE), HYPRE_Int, (Ptr{HYPRE_ExecutionPolicy},), exec_policy)
end

function HYPRE_SetUmpireDevicePoolSize(nbytes)
    ccall((:HYPRE_SetUmpireDevicePoolSize, libHYPRE), HYPRE_Int, (Csize_t,), nbytes)
end

function HYPRE_SetUmpireUMPoolSize(nbytes)
    ccall((:HYPRE_SetUmpireUMPoolSize, libHYPRE), HYPRE_Int, (Csize_t,), nbytes)
end

function HYPRE_SetUmpireHostPoolSize(nbytes)
    ccall((:HYPRE_SetUmpireHostPoolSize, libHYPRE), HYPRE_Int, (Csize_t,), nbytes)
end

function HYPRE_SetUmpirePinnedPoolSize(nbytes)
    ccall((:HYPRE_SetUmpirePinnedPoolSize, libHYPRE), HYPRE_Int, (Csize_t,), nbytes)
end

function HYPRE_SetUmpireDevicePoolName(pool_name)
    ccall((:HYPRE_SetUmpireDevicePoolName, libHYPRE), HYPRE_Int, (Ptr{Cchar},), pool_name)
end

function HYPRE_SetUmpireUMPoolName(pool_name)
    ccall((:HYPRE_SetUmpireUMPoolName, libHYPRE), HYPRE_Int, (Ptr{Cchar},), pool_name)
end

function HYPRE_SetUmpireHostPoolName(pool_name)
    ccall((:HYPRE_SetUmpireHostPoolName, libHYPRE), HYPRE_Int, (Ptr{Cchar},), pool_name)
end

function HYPRE_SetUmpirePinnedPoolName(pool_name)
    ccall((:HYPRE_SetUmpirePinnedPoolName, libHYPRE), HYPRE_Int, (Ptr{Cchar},), pool_name)
end

function HYPRE_SetGPUMemoryPoolSize(bin_growth, min_bin, max_bin, max_cached_bytes)
    ccall((:HYPRE_SetGPUMemoryPoolSize, libHYPRE), HYPRE_Int, (HYPRE_Int, HYPRE_Int, HYPRE_Int, Csize_t), bin_growth, min_bin, max_bin, max_cached_bytes)
end

function HYPRE_SetSpGemmUseCusparse(use_cusparse)
    ccall((:HYPRE_SetSpGemmUseCusparse, libHYPRE), HYPRE_Int, (HYPRE_Int,), use_cusparse)
end

function HYPRE_SetUseGpuRand(use_curand)
    ccall((:HYPRE_SetUseGpuRand, libHYPRE), HYPRE_Int, (HYPRE_Int,), use_curand)
end

mutable struct hypre_IJMatrix_struct end

const HYPRE_IJMatrix = Ptr{hypre_IJMatrix_struct}

function HYPRE_IJMatrixCreate(comm, ilower, iupper, jlower, jupper, matrix)
    ccall((:HYPRE_IJMatrixCreate, libHYPRE), HYPRE_Int, (MPI_Comm, HYPRE_BigInt, HYPRE_BigInt, HYPRE_BigInt, HYPRE_BigInt, Ptr{HYPRE_IJMatrix}), comm, ilower, iupper, jlower, jupper, matrix)
end

function HYPRE_IJMatrixDestroy(matrix)
    ccall((:HYPRE_IJMatrixDestroy, libHYPRE), HYPRE_Int, (HYPRE_IJMatrix,), matrix)
end

function HYPRE_IJMatrixInitialize(matrix)
    ccall((:HYPRE_IJMatrixInitialize, libHYPRE), HYPRE_Int, (HYPRE_IJMatrix,), matrix)
end

function HYPRE_IJMatrixInitialize_v2(matrix, memory_location)
    ccall((:HYPRE_IJMatrixInitialize_v2, libHYPRE), HYPRE_Int, (HYPRE_IJMatrix, HYPRE_MemoryLocation), matrix, memory_location)
end

function HYPRE_IJMatrixSetValues(matrix, nrows, ncols, rows, cols, values)
    ccall((:HYPRE_IJMatrixSetValues, libHYPRE), HYPRE_Int, (HYPRE_IJMatrix, HYPRE_Int, Ptr{HYPRE_Int}, Ptr{HYPRE_BigInt}, Ptr{HYPRE_BigInt}, Ptr{HYPRE_Complex}), matrix, nrows, ncols, rows, cols, values)
end

function HYPRE_IJMatrixSetConstantValues(matrix, value)
    ccall((:HYPRE_IJMatrixSetConstantValues, libHYPRE), HYPRE_Int, (HYPRE_IJMatrix, HYPRE_Complex), matrix, value)
end

function HYPRE_IJMatrixAddToValues(matrix, nrows, ncols, rows, cols, values)
    ccall((:HYPRE_IJMatrixAddToValues, libHYPRE), HYPRE_Int, (HYPRE_IJMatrix, HYPRE_Int, Ptr{HYPRE_Int}, Ptr{HYPRE_BigInt}, Ptr{HYPRE_BigInt}, Ptr{HYPRE_Complex}), matrix, nrows, ncols, rows, cols, values)
end

function HYPRE_IJMatrixSetValues2(matrix, nrows, ncols, rows, row_indexes, cols, values)
    ccall((:HYPRE_IJMatrixSetValues2, libHYPRE), HYPRE_Int, (HYPRE_IJMatrix, HYPRE_Int, Ptr{HYPRE_Int}, Ptr{HYPRE_BigInt}, Ptr{HYPRE_Int}, Ptr{HYPRE_BigInt}, Ptr{HYPRE_Complex}), matrix, nrows, ncols, rows, row_indexes, cols, values)
end

function HYPRE_IJMatrixAddToValues2(matrix, nrows, ncols, rows, row_indexes, cols, values)
    ccall((:HYPRE_IJMatrixAddToValues2, libHYPRE), HYPRE_Int, (HYPRE_IJMatrix, HYPRE_Int, Ptr{HYPRE_Int}, Ptr{HYPRE_BigInt}, Ptr{HYPRE_Int}, Ptr{HYPRE_BigInt}, Ptr{HYPRE_Complex}), matrix, nrows, ncols, rows, row_indexes, cols, values)
end

function HYPRE_IJMatrixAssemble(matrix)
    ccall((:HYPRE_IJMatrixAssemble, libHYPRE), HYPRE_Int, (HYPRE_IJMatrix,), matrix)
end

function HYPRE_IJMatrixGetRowCounts(matrix, nrows, rows, ncols)
    ccall((:HYPRE_IJMatrixGetRowCounts, libHYPRE), HYPRE_Int, (HYPRE_IJMatrix, HYPRE_Int, Ptr{HYPRE_BigInt}, Ptr{HYPRE_Int}), matrix, nrows, rows, ncols)
end

function HYPRE_IJMatrixGetValues(matrix, nrows, ncols, rows, cols, values)
    ccall((:HYPRE_IJMatrixGetValues, libHYPRE), HYPRE_Int, (HYPRE_IJMatrix, HYPRE_Int, Ptr{HYPRE_Int}, Ptr{HYPRE_BigInt}, Ptr{HYPRE_BigInt}, Ptr{HYPRE_Complex}), matrix, nrows, ncols, rows, cols, values)
end

function HYPRE_IJMatrixSetObjectType(matrix, type)
    ccall((:HYPRE_IJMatrixSetObjectType, libHYPRE), HYPRE_Int, (HYPRE_IJMatrix, HYPRE_Int), matrix, type)
end

function HYPRE_IJMatrixGetObjectType(matrix, type)
    ccall((:HYPRE_IJMatrixGetObjectType, libHYPRE), HYPRE_Int, (HYPRE_IJMatrix, Ptr{HYPRE_Int}), matrix, type)
end

function HYPRE_IJMatrixGetLocalRange(matrix, ilower, iupper, jlower, jupper)
    ccall((:HYPRE_IJMatrixGetLocalRange, libHYPRE), HYPRE_Int, (HYPRE_IJMatrix, Ptr{HYPRE_BigInt}, Ptr{HYPRE_BigInt}, Ptr{HYPRE_BigInt}, Ptr{HYPRE_BigInt}), matrix, ilower, iupper, jlower, jupper)
end

function HYPRE_IJMatrixGetObject(matrix, object)
    ccall((:HYPRE_IJMatrixGetObject, libHYPRE), HYPRE_Int, (HYPRE_IJMatrix, Ptr{Ptr{Cvoid}}), matrix, object)
end

function HYPRE_IJMatrixSetRowSizes(matrix, sizes)
    ccall((:HYPRE_IJMatrixSetRowSizes, libHYPRE), HYPRE_Int, (HYPRE_IJMatrix, Ptr{HYPRE_Int}), matrix, sizes)
end

function HYPRE_IJMatrixSetDiagOffdSizes(matrix, diag_sizes, offdiag_sizes)
    ccall((:HYPRE_IJMatrixSetDiagOffdSizes, libHYPRE), HYPRE_Int, (HYPRE_IJMatrix, Ptr{HYPRE_Int}, Ptr{HYPRE_Int}), matrix, diag_sizes, offdiag_sizes)
end

function HYPRE_IJMatrixSetMaxOffProcElmts(matrix, max_off_proc_elmts)
    ccall((:HYPRE_IJMatrixSetMaxOffProcElmts, libHYPRE), HYPRE_Int, (HYPRE_IJMatrix, HYPRE_Int), matrix, max_off_proc_elmts)
end

function HYPRE_IJMatrixSetPrintLevel(matrix, print_level)
    ccall((:HYPRE_IJMatrixSetPrintLevel, libHYPRE), HYPRE_Int, (HYPRE_IJMatrix, HYPRE_Int), matrix, print_level)
end

function HYPRE_IJMatrixSetOMPFlag(matrix, omp_flag)
    ccall((:HYPRE_IJMatrixSetOMPFlag, libHYPRE), HYPRE_Int, (HYPRE_IJMatrix, HYPRE_Int), matrix, omp_flag)
end

function HYPRE_IJMatrixRead(filename, comm, type, matrix)
    ccall((:HYPRE_IJMatrixRead, libHYPRE), HYPRE_Int, (Ptr{Cchar}, MPI_Comm, HYPRE_Int, Ptr{HYPRE_IJMatrix}), filename, comm, type, matrix)
end

function HYPRE_IJMatrixPrint(matrix, filename)
    ccall((:HYPRE_IJMatrixPrint, libHYPRE), HYPRE_Int, (HYPRE_IJMatrix, Ptr{Cchar}), matrix, filename)
end

mutable struct hypre_IJVector_struct end

const HYPRE_IJVector = Ptr{hypre_IJVector_struct}

function HYPRE_IJVectorCreate(comm, jlower, jupper, vector)
    ccall((:HYPRE_IJVectorCreate, libHYPRE), HYPRE_Int, (MPI_Comm, HYPRE_BigInt, HYPRE_BigInt, Ptr{HYPRE_IJVector}), comm, jlower, jupper, vector)
end

function HYPRE_IJVectorDestroy(vector)
    ccall((:HYPRE_IJVectorDestroy, libHYPRE), HYPRE_Int, (HYPRE_IJVector,), vector)
end

function HYPRE_IJVectorInitialize(vector)
    ccall((:HYPRE_IJVectorInitialize, libHYPRE), HYPRE_Int, (HYPRE_IJVector,), vector)
end

function HYPRE_IJVectorInitialize_v2(vector, memory_location)
    ccall((:HYPRE_IJVectorInitialize_v2, libHYPRE), HYPRE_Int, (HYPRE_IJVector, HYPRE_MemoryLocation), vector, memory_location)
end

function HYPRE_IJVectorSetMaxOffProcElmts(vector, max_off_proc_elmts)
    ccall((:HYPRE_IJVectorSetMaxOffProcElmts, libHYPRE), HYPRE_Int, (HYPRE_IJVector, HYPRE_Int), vector, max_off_proc_elmts)
end

function HYPRE_IJVectorSetValues(vector, nvalues, indices, values)
    ccall((:HYPRE_IJVectorSetValues, libHYPRE), HYPRE_Int, (HYPRE_IJVector, HYPRE_Int, Ptr{HYPRE_BigInt}, Ptr{HYPRE_Complex}), vector, nvalues, indices, values)
end

function HYPRE_IJVectorAddToValues(vector, nvalues, indices, values)
    ccall((:HYPRE_IJVectorAddToValues, libHYPRE), HYPRE_Int, (HYPRE_IJVector, HYPRE_Int, Ptr{HYPRE_BigInt}, Ptr{HYPRE_Complex}), vector, nvalues, indices, values)
end

function HYPRE_IJVectorAssemble(vector)
    ccall((:HYPRE_IJVectorAssemble, libHYPRE), HYPRE_Int, (HYPRE_IJVector,), vector)
end

function HYPRE_IJVectorGetValues(vector, nvalues, indices, values)
    ccall((:HYPRE_IJVectorGetValues, libHYPRE), HYPRE_Int, (HYPRE_IJVector, HYPRE_Int, Ptr{HYPRE_BigInt}, Ptr{HYPRE_Complex}), vector, nvalues, indices, values)
end

function HYPRE_IJVectorSetObjectType(vector, type)
    ccall((:HYPRE_IJVectorSetObjectType, libHYPRE), HYPRE_Int, (HYPRE_IJVector, HYPRE_Int), vector, type)
end

function HYPRE_IJVectorGetObjectType(vector, type)
    ccall((:HYPRE_IJVectorGetObjectType, libHYPRE), HYPRE_Int, (HYPRE_IJVector, Ptr{HYPRE_Int}), vector, type)
end

function HYPRE_IJVectorGetLocalRange(vector, jlower, jupper)
    ccall((:HYPRE_IJVectorGetLocalRange, libHYPRE), HYPRE_Int, (HYPRE_IJVector, Ptr{HYPRE_BigInt}, Ptr{HYPRE_BigInt}), vector, jlower, jupper)
end

function HYPRE_IJVectorGetObject(vector, object)
    ccall((:HYPRE_IJVectorGetObject, libHYPRE), HYPRE_Int, (HYPRE_IJVector, Ptr{Ptr{Cvoid}}), vector, object)
end

function HYPRE_IJVectorSetPrintLevel(vector, print_level)
    ccall((:HYPRE_IJVectorSetPrintLevel, libHYPRE), HYPRE_Int, (HYPRE_IJVector, HYPRE_Int), vector, print_level)
end

function HYPRE_IJVectorRead(filename, comm, type, vector)
    ccall((:HYPRE_IJVectorRead, libHYPRE), HYPRE_Int, (Ptr{Cchar}, MPI_Comm, HYPRE_Int, Ptr{HYPRE_IJVector}), filename, comm, type, vector)
end

function HYPRE_IJVectorPrint(vector, filename)
    ccall((:HYPRE_IJVectorPrint, libHYPRE), HYPRE_Int, (HYPRE_IJVector, Ptr{Cchar}), vector, filename)
end

mutable struct hypre_CSRMatrix_struct end

const HYPRE_CSRMatrix = Ptr{hypre_CSRMatrix_struct}

mutable struct hypre_MappedMatrix_struct end

const HYPRE_MappedMatrix = Ptr{hypre_MappedMatrix_struct}

mutable struct hypre_MultiblockMatrix_struct end

const HYPRE_MultiblockMatrix = Ptr{hypre_MultiblockMatrix_struct}

mutable struct hypre_Vector_struct end

const HYPRE_Vector = Ptr{hypre_Vector_struct}

function HYPRE_CSRMatrixCreate(num_rows, num_cols, row_sizes)
    ccall((:HYPRE_CSRMatrixCreate, libHYPRE), HYPRE_CSRMatrix, (HYPRE_Int, HYPRE_Int, Ptr{HYPRE_Int}), num_rows, num_cols, row_sizes)
end

function HYPRE_CSRMatrixDestroy(matrix)
    ccall((:HYPRE_CSRMatrixDestroy, libHYPRE), HYPRE_Int, (HYPRE_CSRMatrix,), matrix)
end

function HYPRE_CSRMatrixInitialize(matrix)
    ccall((:HYPRE_CSRMatrixInitialize, libHYPRE), HYPRE_Int, (HYPRE_CSRMatrix,), matrix)
end

function HYPRE_CSRMatrixRead(file_name)
    ccall((:HYPRE_CSRMatrixRead, libHYPRE), HYPRE_CSRMatrix, (Ptr{Cchar},), file_name)
end

function HYPRE_CSRMatrixPrint(matrix, file_name)
    ccall((:HYPRE_CSRMatrixPrint, libHYPRE), Cvoid, (HYPRE_CSRMatrix, Ptr{Cchar}), matrix, file_name)
end

function HYPRE_CSRMatrixGetNumRows(matrix, num_rows)
    ccall((:HYPRE_CSRMatrixGetNumRows, libHYPRE), HYPRE_Int, (HYPRE_CSRMatrix, Ptr{HYPRE_Int}), matrix, num_rows)
end

function HYPRE_MappedMatrixCreate()
    ccall((:HYPRE_MappedMatrixCreate, libHYPRE), HYPRE_MappedMatrix, ())
end

function HYPRE_MappedMatrixDestroy(matrix)
    ccall((:HYPRE_MappedMatrixDestroy, libHYPRE), HYPRE_Int, (HYPRE_MappedMatrix,), matrix)
end

function HYPRE_MappedMatrixLimitedDestroy(matrix)
    ccall((:HYPRE_MappedMatrixLimitedDestroy, libHYPRE), HYPRE_Int, (HYPRE_MappedMatrix,), matrix)
end

function HYPRE_MappedMatrixInitialize(matrix)
    ccall((:HYPRE_MappedMatrixInitialize, libHYPRE), HYPRE_Int, (HYPRE_MappedMatrix,), matrix)
end

function HYPRE_MappedMatrixAssemble(matrix)
    ccall((:HYPRE_MappedMatrixAssemble, libHYPRE), HYPRE_Int, (HYPRE_MappedMatrix,), matrix)
end

function HYPRE_MappedMatrixPrint(matrix)
    ccall((:HYPRE_MappedMatrixPrint, libHYPRE), Cvoid, (HYPRE_MappedMatrix,), matrix)
end

function HYPRE_MappedMatrixGetColIndex(matrix, j)
    ccall((:HYPRE_MappedMatrixGetColIndex, libHYPRE), HYPRE_Int, (HYPRE_MappedMatrix, HYPRE_Int), matrix, j)
end

function HYPRE_MappedMatrixGetMatrix(matrix)
    ccall((:HYPRE_MappedMatrixGetMatrix, libHYPRE), Ptr{Cvoid}, (HYPRE_MappedMatrix,), matrix)
end

function HYPRE_MappedMatrixSetMatrix(matrix, matrix_data)
    ccall((:HYPRE_MappedMatrixSetMatrix, libHYPRE), HYPRE_Int, (HYPRE_MappedMatrix, Ptr{Cvoid}), matrix, matrix_data)
end

function HYPRE_MappedMatrixSetColMap(matrix, ColMap)
    ccall((:HYPRE_MappedMatrixSetColMap, libHYPRE), HYPRE_Int, (HYPRE_MappedMatrix, Ptr{Cvoid}), matrix, ColMap)
end

function HYPRE_MappedMatrixSetMapData(matrix, MapData)
    ccall((:HYPRE_MappedMatrixSetMapData, libHYPRE), HYPRE_Int, (HYPRE_MappedMatrix, Ptr{Cvoid}), matrix, MapData)
end

function HYPRE_MultiblockMatrixCreate()
    ccall((:HYPRE_MultiblockMatrixCreate, libHYPRE), HYPRE_MultiblockMatrix, ())
end

function HYPRE_MultiblockMatrixDestroy(matrix)
    ccall((:HYPRE_MultiblockMatrixDestroy, libHYPRE), HYPRE_Int, (HYPRE_MultiblockMatrix,), matrix)
end

function HYPRE_MultiblockMatrixLimitedDestroy(matrix)
    ccall((:HYPRE_MultiblockMatrixLimitedDestroy, libHYPRE), HYPRE_Int, (HYPRE_MultiblockMatrix,), matrix)
end

function HYPRE_MultiblockMatrixInitialize(matrix)
    ccall((:HYPRE_MultiblockMatrixInitialize, libHYPRE), HYPRE_Int, (HYPRE_MultiblockMatrix,), matrix)
end

function HYPRE_MultiblockMatrixAssemble(matrix)
    ccall((:HYPRE_MultiblockMatrixAssemble, libHYPRE), HYPRE_Int, (HYPRE_MultiblockMatrix,), matrix)
end

function HYPRE_MultiblockMatrixPrint(matrix)
    ccall((:HYPRE_MultiblockMatrixPrint, libHYPRE), Cvoid, (HYPRE_MultiblockMatrix,), matrix)
end

function HYPRE_MultiblockMatrixSetNumSubmatrices(matrix, n)
    ccall((:HYPRE_MultiblockMatrixSetNumSubmatrices, libHYPRE), HYPRE_Int, (HYPRE_MultiblockMatrix, HYPRE_Int), matrix, n)
end

function HYPRE_MultiblockMatrixSetSubmatrixType(matrix, j, type)
    ccall((:HYPRE_MultiblockMatrixSetSubmatrixType, libHYPRE), HYPRE_Int, (HYPRE_MultiblockMatrix, HYPRE_Int, HYPRE_Int), matrix, j, type)
end

function HYPRE_VectorCreate(size)
    ccall((:HYPRE_VectorCreate, libHYPRE), HYPRE_Vector, (HYPRE_Int,), size)
end

function HYPRE_VectorDestroy(vector)
    ccall((:HYPRE_VectorDestroy, libHYPRE), HYPRE_Int, (HYPRE_Vector,), vector)
end

function HYPRE_VectorInitialize(vector)
    ccall((:HYPRE_VectorInitialize, libHYPRE), HYPRE_Int, (HYPRE_Vector,), vector)
end

function HYPRE_VectorPrint(vector, file_name)
    ccall((:HYPRE_VectorPrint, libHYPRE), HYPRE_Int, (HYPRE_Vector, Ptr{Cchar}), vector, file_name)
end

function HYPRE_VectorRead(file_name)
    ccall((:HYPRE_VectorRead, libHYPRE), HYPRE_Vector, (Ptr{Cchar},), file_name)
end

@cenum HYPRE_TimerID::UInt32 begin
    HYPRE_TIMER_ID_MATVEC = 0
    HYPRE_TIMER_ID_BLAS1 = 1
    HYPRE_TIMER_ID_RELAX = 2
    HYPRE_TIMER_ID_GS_ELIM_SOLVE = 3
    HYPRE_TIMER_ID_PACK_UNPACK = 4
    HYPRE_TIMER_ID_HALO_EXCHANGE = 5
    HYPRE_TIMER_ID_ALL_REDUCE = 6
    HYPRE_TIMER_ID_CREATES = 7
    HYPRE_TIMER_ID_CREATE_2NDS = 8
    HYPRE_TIMER_ID_PMIS = 9
    HYPRE_TIMER_ID_EXTENDED_I_INTERP = 10
    HYPRE_TIMER_ID_PARTIAL_INTERP = 11
    HYPRE_TIMER_ID_MULTIPASS_INTERP = 12
    HYPRE_TIMER_ID_INTERP_TRUNC = 13
    HYPRE_TIMER_ID_MATMUL = 14
    HYPRE_TIMER_ID_COARSE_PARAMS = 15
    HYPRE_TIMER_ID_RAP = 16
    HYPRE_TIMER_ID_RENUMBER_COLIDX = 17
    HYPRE_TIMER_ID_EXCHANGE_INTERP_DATA = 18
    HYPRE_TIMER_ID_GS_ELIM_SETUP = 19
    HYPRE_TIMER_ID_BEXT_A = 20
    HYPRE_TIMER_ID_BEXT_S = 21
    HYPRE_TIMER_ID_RENUMBER_COLIDX_RAP = 22
    HYPRE_TIMER_ID_MERGE = 23
    HYPRE_TIMER_ID_SPMM_ROWNNZ = 24
    HYPRE_TIMER_ID_SPMM_ATTEMPT1 = 25
    HYPRE_TIMER_ID_SPMM_ATTEMPT2 = 26
    HYPRE_TIMER_ID_SPMM_SYMBOLIC = 27
    HYPRE_TIMER_ID_SPMM_NUMERIC = 28
    HYPRE_TIMER_ID_SPMM = 29
    HYPRE_TIMER_ID_SPADD = 30
    HYPRE_TIMER_ID_SPTRANS = 31
    HYPRE_TIMER_ID_COUNT = 32
end

mutable struct hypre_ParCSRMatrix_struct end

const HYPRE_ParCSRMatrix = Ptr{hypre_ParCSRMatrix_struct}

mutable struct hypre_ParVector_struct end

const HYPRE_ParVector = Ptr{hypre_ParVector_struct}

function HYPRE_ParCSRMatrixCreate(comm, global_num_rows, global_num_cols, row_starts, col_starts, num_cols_offd, num_nonzeros_diag, num_nonzeros_offd, matrix)
    ccall((:HYPRE_ParCSRMatrixCreate, libHYPRE), HYPRE_Int, (MPI_Comm, HYPRE_BigInt, HYPRE_BigInt, Ptr{HYPRE_BigInt}, Ptr{HYPRE_BigInt}, HYPRE_Int, HYPRE_Int, HYPRE_Int, Ptr{HYPRE_ParCSRMatrix}), comm, global_num_rows, global_num_cols, row_starts, col_starts, num_cols_offd, num_nonzeros_diag, num_nonzeros_offd, matrix)
end

function HYPRE_ParCSRMatrixDestroy(matrix)
    ccall((:HYPRE_ParCSRMatrixDestroy, libHYPRE), HYPRE_Int, (HYPRE_ParCSRMatrix,), matrix)
end

function HYPRE_ParCSRMatrixInitialize(matrix)
    ccall((:HYPRE_ParCSRMatrixInitialize, libHYPRE), HYPRE_Int, (HYPRE_ParCSRMatrix,), matrix)
end

function HYPRE_ParCSRMatrixRead(comm, file_name, matrix)
    ccall((:HYPRE_ParCSRMatrixRead, libHYPRE), HYPRE_Int, (MPI_Comm, Ptr{Cchar}, Ptr{HYPRE_ParCSRMatrix}), comm, file_name, matrix)
end

function HYPRE_ParCSRMatrixPrint(matrix, file_name)
    ccall((:HYPRE_ParCSRMatrixPrint, libHYPRE), HYPRE_Int, (HYPRE_ParCSRMatrix, Ptr{Cchar}), matrix, file_name)
end

function HYPRE_ParCSRMatrixGetComm(matrix, comm)
    ccall((:HYPRE_ParCSRMatrixGetComm, libHYPRE), HYPRE_Int, (HYPRE_ParCSRMatrix, Ptr{MPI_Comm}), matrix, comm)
end

function HYPRE_ParCSRMatrixGetDims(matrix, M, N)
    ccall((:HYPRE_ParCSRMatrixGetDims, libHYPRE), HYPRE_Int, (HYPRE_ParCSRMatrix, Ptr{HYPRE_BigInt}, Ptr{HYPRE_BigInt}), matrix, M, N)
end

function HYPRE_ParCSRMatrixGetRowPartitioning(matrix, row_partitioning_ptr)
    ccall((:HYPRE_ParCSRMatrixGetRowPartitioning, libHYPRE), HYPRE_Int, (HYPRE_ParCSRMatrix, Ptr{Ptr{HYPRE_BigInt}}), matrix, row_partitioning_ptr)
end

function HYPRE_ParCSRMatrixGetColPartitioning(matrix, col_partitioning_ptr)
    ccall((:HYPRE_ParCSRMatrixGetColPartitioning, libHYPRE), HYPRE_Int, (HYPRE_ParCSRMatrix, Ptr{Ptr{HYPRE_BigInt}}), matrix, col_partitioning_ptr)
end

function HYPRE_ParCSRMatrixGetLocalRange(matrix, row_start, row_end, col_start, col_end)
    ccall((:HYPRE_ParCSRMatrixGetLocalRange, libHYPRE), HYPRE_Int, (HYPRE_ParCSRMatrix, Ptr{HYPRE_BigInt}, Ptr{HYPRE_BigInt}, Ptr{HYPRE_BigInt}, Ptr{HYPRE_BigInt}), matrix, row_start, row_end, col_start, col_end)
end

function HYPRE_ParCSRMatrixGetRow(matrix, row, size, col_ind, values)
    ccall((:HYPRE_ParCSRMatrixGetRow, libHYPRE), HYPRE_Int, (HYPRE_ParCSRMatrix, HYPRE_BigInt, Ptr{HYPRE_Int}, Ptr{Ptr{HYPRE_BigInt}}, Ptr{Ptr{HYPRE_Complex}}), matrix, row, size, col_ind, values)
end

function HYPRE_ParCSRMatrixRestoreRow(matrix, row, size, col_ind, values)
    ccall((:HYPRE_ParCSRMatrixRestoreRow, libHYPRE), HYPRE_Int, (HYPRE_ParCSRMatrix, HYPRE_BigInt, Ptr{HYPRE_Int}, Ptr{Ptr{HYPRE_BigInt}}, Ptr{Ptr{HYPRE_Complex}}), matrix, row, size, col_ind, values)
end

function HYPRE_CSRMatrixToParCSRMatrix(comm, A_CSR, row_partitioning, col_partitioning, matrix)
    ccall((:HYPRE_CSRMatrixToParCSRMatrix, libHYPRE), HYPRE_Int, (MPI_Comm, HYPRE_CSRMatrix, Ptr{HYPRE_BigInt}, Ptr{HYPRE_BigInt}, Ptr{HYPRE_ParCSRMatrix}), comm, A_CSR, row_partitioning, col_partitioning, matrix)
end

function HYPRE_ParCSRMatrixMatvec(alpha, A, x, beta, y)
    ccall((:HYPRE_ParCSRMatrixMatvec, libHYPRE), HYPRE_Int, (HYPRE_Complex, HYPRE_ParCSRMatrix, HYPRE_ParVector, HYPRE_Complex, HYPRE_ParVector), alpha, A, x, beta, y)
end

function HYPRE_ParCSRMatrixMatvecT(alpha, A, x, beta, y)
    ccall((:HYPRE_ParCSRMatrixMatvecT, libHYPRE), HYPRE_Int, (HYPRE_Complex, HYPRE_ParCSRMatrix, HYPRE_ParVector, HYPRE_Complex, HYPRE_ParVector), alpha, A, x, beta, y)
end

function HYPRE_ParVectorCreate(comm, global_size, partitioning, vector)
    ccall((:HYPRE_ParVectorCreate, libHYPRE), HYPRE_Int, (MPI_Comm, HYPRE_BigInt, Ptr{HYPRE_BigInt}, Ptr{HYPRE_ParVector}), comm, global_size, partitioning, vector)
end

function HYPRE_ParVectorDestroy(vector)
    ccall((:HYPRE_ParVectorDestroy, libHYPRE), HYPRE_Int, (HYPRE_ParVector,), vector)
end

function HYPRE_ParVectorInitialize(vector)
    ccall((:HYPRE_ParVectorInitialize, libHYPRE), HYPRE_Int, (HYPRE_ParVector,), vector)
end

function HYPRE_ParVectorRead(comm, file_name, vector)
    ccall((:HYPRE_ParVectorRead, libHYPRE), HYPRE_Int, (MPI_Comm, Ptr{Cchar}, Ptr{HYPRE_ParVector}), comm, file_name, vector)
end

function HYPRE_ParVectorPrint(vector, file_name)
    ccall((:HYPRE_ParVectorPrint, libHYPRE), HYPRE_Int, (HYPRE_ParVector, Ptr{Cchar}), vector, file_name)
end

function HYPRE_ParVectorSetConstantValues(vector, value)
    ccall((:HYPRE_ParVectorSetConstantValues, libHYPRE), HYPRE_Int, (HYPRE_ParVector, HYPRE_Complex), vector, value)
end

function HYPRE_ParVectorSetRandomValues(vector, seed)
    ccall((:HYPRE_ParVectorSetRandomValues, libHYPRE), HYPRE_Int, (HYPRE_ParVector, HYPRE_Int), vector, seed)
end

function HYPRE_ParVectorCopy(x, y)
    ccall((:HYPRE_ParVectorCopy, libHYPRE), HYPRE_Int, (HYPRE_ParVector, HYPRE_ParVector), x, y)
end

function HYPRE_ParVectorScale(value, x)
    ccall((:HYPRE_ParVectorScale, libHYPRE), HYPRE_Int, (HYPRE_Complex, HYPRE_ParVector), value, x)
end

function HYPRE_ParVectorInnerProd(x, y, prod)
    ccall((:HYPRE_ParVectorInnerProd, libHYPRE), HYPRE_Int, (HYPRE_ParVector, HYPRE_ParVector, Ptr{HYPRE_Real}), x, y, prod)
end

function HYPRE_VectorToParVector(comm, b, partitioning, vector)
    ccall((:HYPRE_VectorToParVector, libHYPRE), HYPRE_Int, (MPI_Comm, HYPRE_Vector, Ptr{HYPRE_BigInt}, Ptr{HYPRE_ParVector}), comm, b, partitioning, vector)
end

function HYPRE_ParVectorGetValues(vector, num_values, indices, values)
    ccall((:HYPRE_ParVectorGetValues, libHYPRE), HYPRE_Int, (HYPRE_ParVector, HYPRE_Int, Ptr{HYPRE_BigInt}, Ptr{HYPRE_Complex}), vector, num_values, indices, values)
end

mutable struct hypre_Solver_struct end

const HYPRE_Solver = Ptr{hypre_Solver_struct}

mutable struct hypre_Matrix_struct end

const HYPRE_Matrix = Ptr{hypre_Matrix_struct}

# typedef HYPRE_Int ( * HYPRE_PtrToSolverFcn ) ( HYPRE_Solver , HYPRE_Matrix , HYPRE_Vector , HYPRE_Vector )
const HYPRE_PtrToSolverFcn = Ptr{Cvoid}

# typedef HYPRE_Int ( * HYPRE_PtrToModifyPCFcn ) ( HYPRE_Solver , HYPRE_Int , HYPRE_Real )
const HYPRE_PtrToModifyPCFcn = Ptr{Cvoid}

function HYPRE_PCGSetup(solver, A, b, x)
    ccall((:HYPRE_PCGSetup, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Matrix, HYPRE_Vector, HYPRE_Vector), solver, A, b, x)
end

function HYPRE_PCGSolve(solver, A, b, x)
    ccall((:HYPRE_PCGSolve, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Matrix, HYPRE_Vector, HYPRE_Vector), solver, A, b, x)
end

function HYPRE_PCGSetTol(solver, tol)
    ccall((:HYPRE_PCGSetTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, tol)
end

function HYPRE_PCGSetAbsoluteTol(solver, a_tol)
    ccall((:HYPRE_PCGSetAbsoluteTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, a_tol)
end

function HYPRE_PCGSetResidualTol(solver, rtol)
    ccall((:HYPRE_PCGSetResidualTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, rtol)
end

function HYPRE_PCGSetAbsoluteTolFactor(solver, abstolf)
    ccall((:HYPRE_PCGSetAbsoluteTolFactor, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, abstolf)
end

function HYPRE_PCGSetConvergenceFactorTol(solver, cf_tol)
    ccall((:HYPRE_PCGSetConvergenceFactorTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, cf_tol)
end

function HYPRE_PCGSetStopCrit(solver, stop_crit)
    ccall((:HYPRE_PCGSetStopCrit, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, stop_crit)
end

function HYPRE_PCGSetMaxIter(solver, max_iter)
    ccall((:HYPRE_PCGSetMaxIter, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, max_iter)
end

function HYPRE_PCGSetTwoNorm(solver, two_norm)
    ccall((:HYPRE_PCGSetTwoNorm, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, two_norm)
end

function HYPRE_PCGSetRelChange(solver, rel_change)
    ccall((:HYPRE_PCGSetRelChange, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, rel_change)
end

function HYPRE_PCGSetRecomputeResidual(solver, recompute_residual)
    ccall((:HYPRE_PCGSetRecomputeResidual, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, recompute_residual)
end

function HYPRE_PCGSetRecomputeResidualP(solver, recompute_residual_p)
    ccall((:HYPRE_PCGSetRecomputeResidualP, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, recompute_residual_p)
end

function HYPRE_PCGSetPrecond(solver, precond, precond_setup, precond_solver)
    ccall((:HYPRE_PCGSetPrecond, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_PtrToSolverFcn, HYPRE_PtrToSolverFcn, HYPRE_Solver), solver, precond, precond_setup, precond_solver)
end

function HYPRE_PCGSetLogging(solver, logging)
    ccall((:HYPRE_PCGSetLogging, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, logging)
end

function HYPRE_PCGSetPrintLevel(solver, level)
    ccall((:HYPRE_PCGSetPrintLevel, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, level)
end

function HYPRE_PCGGetNumIterations(solver, num_iterations)
    ccall((:HYPRE_PCGGetNumIterations, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, num_iterations)
end

function HYPRE_PCGGetFinalRelativeResidualNorm(solver, norm)
    ccall((:HYPRE_PCGGetFinalRelativeResidualNorm, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Real}), solver, norm)
end

function HYPRE_PCGGetResidual(solver, residual)
    ccall((:HYPRE_PCGGetResidual, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{Cvoid}), solver, residual)
end

function HYPRE_PCGGetTol(solver, tol)
    ccall((:HYPRE_PCGGetTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Real}), solver, tol)
end

function HYPRE_PCGGetResidualTol(solver, rtol)
    ccall((:HYPRE_PCGGetResidualTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Real}), solver, rtol)
end

function HYPRE_PCGGetAbsoluteTolFactor(solver, abstolf)
    ccall((:HYPRE_PCGGetAbsoluteTolFactor, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Real}), solver, abstolf)
end

function HYPRE_PCGGetConvergenceFactorTol(solver, cf_tol)
    ccall((:HYPRE_PCGGetConvergenceFactorTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Real}), solver, cf_tol)
end

function HYPRE_PCGGetStopCrit(solver, stop_crit)
    ccall((:HYPRE_PCGGetStopCrit, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, stop_crit)
end

function HYPRE_PCGGetMaxIter(solver, max_iter)
    ccall((:HYPRE_PCGGetMaxIter, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, max_iter)
end

function HYPRE_PCGGetTwoNorm(solver, two_norm)
    ccall((:HYPRE_PCGGetTwoNorm, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, two_norm)
end

function HYPRE_PCGGetRelChange(solver, rel_change)
    ccall((:HYPRE_PCGGetRelChange, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, rel_change)
end

function HYPRE_GMRESGetSkipRealResidualCheck(solver, skip_real_r_check)
    ccall((:HYPRE_GMRESGetSkipRealResidualCheck, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, skip_real_r_check)
end

function HYPRE_PCGGetPrecond(solver, precond_data_ptr)
    ccall((:HYPRE_PCGGetPrecond, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Solver}), solver, precond_data_ptr)
end

function HYPRE_PCGGetLogging(solver, level)
    ccall((:HYPRE_PCGGetLogging, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, level)
end

function HYPRE_PCGGetPrintLevel(solver, level)
    ccall((:HYPRE_PCGGetPrintLevel, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, level)
end

function HYPRE_PCGGetConverged(solver, converged)
    ccall((:HYPRE_PCGGetConverged, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, converged)
end

function HYPRE_GMRESSetup(solver, A, b, x)
    ccall((:HYPRE_GMRESSetup, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Matrix, HYPRE_Vector, HYPRE_Vector), solver, A, b, x)
end

function HYPRE_GMRESSolve(solver, A, b, x)
    ccall((:HYPRE_GMRESSolve, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Matrix, HYPRE_Vector, HYPRE_Vector), solver, A, b, x)
end

function HYPRE_GMRESSetTol(solver, tol)
    ccall((:HYPRE_GMRESSetTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, tol)
end

function HYPRE_GMRESSetAbsoluteTol(solver, a_tol)
    ccall((:HYPRE_GMRESSetAbsoluteTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, a_tol)
end

function HYPRE_GMRESSetConvergenceFactorTol(solver, cf_tol)
    ccall((:HYPRE_GMRESSetConvergenceFactorTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, cf_tol)
end

function HYPRE_GMRESSetStopCrit(solver, stop_crit)
    ccall((:HYPRE_GMRESSetStopCrit, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, stop_crit)
end

function HYPRE_GMRESSetMinIter(solver, min_iter)
    ccall((:HYPRE_GMRESSetMinIter, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, min_iter)
end

function HYPRE_GMRESSetMaxIter(solver, max_iter)
    ccall((:HYPRE_GMRESSetMaxIter, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, max_iter)
end

function HYPRE_GMRESSetKDim(solver, k_dim)
    ccall((:HYPRE_GMRESSetKDim, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, k_dim)
end

function HYPRE_GMRESSetRelChange(solver, rel_change)
    ccall((:HYPRE_GMRESSetRelChange, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, rel_change)
end

function HYPRE_GMRESSetSkipRealResidualCheck(solver, skip_real_r_check)
    ccall((:HYPRE_GMRESSetSkipRealResidualCheck, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, skip_real_r_check)
end

function HYPRE_GMRESSetPrecond(solver, precond, precond_setup, precond_solver)
    ccall((:HYPRE_GMRESSetPrecond, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_PtrToSolverFcn, HYPRE_PtrToSolverFcn, HYPRE_Solver), solver, precond, precond_setup, precond_solver)
end

function HYPRE_GMRESSetLogging(solver, logging)
    ccall((:HYPRE_GMRESSetLogging, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, logging)
end

function HYPRE_GMRESSetPrintLevel(solver, level)
    ccall((:HYPRE_GMRESSetPrintLevel, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, level)
end

function HYPRE_GMRESGetNumIterations(solver, num_iterations)
    ccall((:HYPRE_GMRESGetNumIterations, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, num_iterations)
end

function HYPRE_GMRESGetFinalRelativeResidualNorm(solver, norm)
    ccall((:HYPRE_GMRESGetFinalRelativeResidualNorm, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Real}), solver, norm)
end

function HYPRE_GMRESGetResidual(solver, residual)
    ccall((:HYPRE_GMRESGetResidual, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{Cvoid}), solver, residual)
end

function HYPRE_GMRESGetTol(solver, tol)
    ccall((:HYPRE_GMRESGetTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Real}), solver, tol)
end

function HYPRE_GMRESGetAbsoluteTol(solver, tol)
    ccall((:HYPRE_GMRESGetAbsoluteTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Real}), solver, tol)
end

function HYPRE_GMRESGetConvergenceFactorTol(solver, cf_tol)
    ccall((:HYPRE_GMRESGetConvergenceFactorTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Real}), solver, cf_tol)
end

function HYPRE_GMRESGetStopCrit(solver, stop_crit)
    ccall((:HYPRE_GMRESGetStopCrit, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, stop_crit)
end

function HYPRE_GMRESGetMinIter(solver, min_iter)
    ccall((:HYPRE_GMRESGetMinIter, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, min_iter)
end

function HYPRE_GMRESGetMaxIter(solver, max_iter)
    ccall((:HYPRE_GMRESGetMaxIter, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, max_iter)
end

function HYPRE_GMRESGetKDim(solver, k_dim)
    ccall((:HYPRE_GMRESGetKDim, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, k_dim)
end

function HYPRE_GMRESGetRelChange(solver, rel_change)
    ccall((:HYPRE_GMRESGetRelChange, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, rel_change)
end

function HYPRE_GMRESGetPrecond(solver, precond_data_ptr)
    ccall((:HYPRE_GMRESGetPrecond, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Solver}), solver, precond_data_ptr)
end

function HYPRE_GMRESGetLogging(solver, level)
    ccall((:HYPRE_GMRESGetLogging, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, level)
end

function HYPRE_GMRESGetPrintLevel(solver, level)
    ccall((:HYPRE_GMRESGetPrintLevel, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, level)
end

function HYPRE_GMRESGetConverged(solver, converged)
    ccall((:HYPRE_GMRESGetConverged, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, converged)
end

function HYPRE_FlexGMRESSetup(solver, A, b, x)
    ccall((:HYPRE_FlexGMRESSetup, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Matrix, HYPRE_Vector, HYPRE_Vector), solver, A, b, x)
end

function HYPRE_FlexGMRESSolve(solver, A, b, x)
    ccall((:HYPRE_FlexGMRESSolve, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Matrix, HYPRE_Vector, HYPRE_Vector), solver, A, b, x)
end

function HYPRE_FlexGMRESSetTol(solver, tol)
    ccall((:HYPRE_FlexGMRESSetTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, tol)
end

function HYPRE_FlexGMRESSetAbsoluteTol(solver, a_tol)
    ccall((:HYPRE_FlexGMRESSetAbsoluteTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, a_tol)
end

function HYPRE_FlexGMRESSetConvergenceFactorTol(solver, cf_tol)
    ccall((:HYPRE_FlexGMRESSetConvergenceFactorTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, cf_tol)
end

function HYPRE_FlexGMRESSetMinIter(solver, min_iter)
    ccall((:HYPRE_FlexGMRESSetMinIter, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, min_iter)
end

function HYPRE_FlexGMRESSetMaxIter(solver, max_iter)
    ccall((:HYPRE_FlexGMRESSetMaxIter, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, max_iter)
end

function HYPRE_FlexGMRESSetKDim(solver, k_dim)
    ccall((:HYPRE_FlexGMRESSetKDim, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, k_dim)
end

function HYPRE_FlexGMRESSetPrecond(solver, precond, precond_setup, precond_solver)
    ccall((:HYPRE_FlexGMRESSetPrecond, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_PtrToSolverFcn, HYPRE_PtrToSolverFcn, HYPRE_Solver), solver, precond, precond_setup, precond_solver)
end

function HYPRE_FlexGMRESSetLogging(solver, logging)
    ccall((:HYPRE_FlexGMRESSetLogging, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, logging)
end

function HYPRE_FlexGMRESSetPrintLevel(solver, level)
    ccall((:HYPRE_FlexGMRESSetPrintLevel, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, level)
end

function HYPRE_FlexGMRESGetNumIterations(solver, num_iterations)
    ccall((:HYPRE_FlexGMRESGetNumIterations, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, num_iterations)
end

function HYPRE_FlexGMRESGetFinalRelativeResidualNorm(solver, norm)
    ccall((:HYPRE_FlexGMRESGetFinalRelativeResidualNorm, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Real}), solver, norm)
end

function HYPRE_FlexGMRESGetResidual(solver, residual)
    ccall((:HYPRE_FlexGMRESGetResidual, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{Cvoid}), solver, residual)
end

function HYPRE_FlexGMRESGetTol(solver, tol)
    ccall((:HYPRE_FlexGMRESGetTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Real}), solver, tol)
end

function HYPRE_FlexGMRESGetConvergenceFactorTol(solver, cf_tol)
    ccall((:HYPRE_FlexGMRESGetConvergenceFactorTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Real}), solver, cf_tol)
end

function HYPRE_FlexGMRESGetStopCrit(solver, stop_crit)
    ccall((:HYPRE_FlexGMRESGetStopCrit, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, stop_crit)
end

function HYPRE_FlexGMRESGetMinIter(solver, min_iter)
    ccall((:HYPRE_FlexGMRESGetMinIter, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, min_iter)
end

function HYPRE_FlexGMRESGetMaxIter(solver, max_iter)
    ccall((:HYPRE_FlexGMRESGetMaxIter, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, max_iter)
end

function HYPRE_FlexGMRESGetKDim(solver, k_dim)
    ccall((:HYPRE_FlexGMRESGetKDim, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, k_dim)
end

function HYPRE_FlexGMRESGetPrecond(solver, precond_data_ptr)
    ccall((:HYPRE_FlexGMRESGetPrecond, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Solver}), solver, precond_data_ptr)
end

function HYPRE_FlexGMRESGetLogging(solver, level)
    ccall((:HYPRE_FlexGMRESGetLogging, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, level)
end

function HYPRE_FlexGMRESGetPrintLevel(solver, level)
    ccall((:HYPRE_FlexGMRESGetPrintLevel, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, level)
end

function HYPRE_FlexGMRESGetConverged(solver, converged)
    ccall((:HYPRE_FlexGMRESGetConverged, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, converged)
end

function HYPRE_FlexGMRESSetModifyPC(solver, modify_pc)
    ccall((:HYPRE_FlexGMRESSetModifyPC, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_PtrToModifyPCFcn), solver, modify_pc)
end

function HYPRE_LGMRESSetup(solver, A, b, x)
    ccall((:HYPRE_LGMRESSetup, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Matrix, HYPRE_Vector, HYPRE_Vector), solver, A, b, x)
end

function HYPRE_LGMRESSolve(solver, A, b, x)
    ccall((:HYPRE_LGMRESSolve, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Matrix, HYPRE_Vector, HYPRE_Vector), solver, A, b, x)
end

function HYPRE_LGMRESSetTol(solver, tol)
    ccall((:HYPRE_LGMRESSetTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, tol)
end

function HYPRE_LGMRESSetAbsoluteTol(solver, a_tol)
    ccall((:HYPRE_LGMRESSetAbsoluteTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, a_tol)
end

function HYPRE_LGMRESSetConvergenceFactorTol(solver, cf_tol)
    ccall((:HYPRE_LGMRESSetConvergenceFactorTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, cf_tol)
end

function HYPRE_LGMRESSetMinIter(solver, min_iter)
    ccall((:HYPRE_LGMRESSetMinIter, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, min_iter)
end

function HYPRE_LGMRESSetMaxIter(solver, max_iter)
    ccall((:HYPRE_LGMRESSetMaxIter, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, max_iter)
end

function HYPRE_LGMRESSetKDim(solver, k_dim)
    ccall((:HYPRE_LGMRESSetKDim, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, k_dim)
end

function HYPRE_LGMRESSetAugDim(solver, aug_dim)
    ccall((:HYPRE_LGMRESSetAugDim, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, aug_dim)
end

function HYPRE_LGMRESSetPrecond(solver, precond, precond_setup, precond_solver)
    ccall((:HYPRE_LGMRESSetPrecond, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_PtrToSolverFcn, HYPRE_PtrToSolverFcn, HYPRE_Solver), solver, precond, precond_setup, precond_solver)
end

function HYPRE_LGMRESSetLogging(solver, logging)
    ccall((:HYPRE_LGMRESSetLogging, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, logging)
end

function HYPRE_LGMRESSetPrintLevel(solver, level)
    ccall((:HYPRE_LGMRESSetPrintLevel, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, level)
end

function HYPRE_LGMRESGetNumIterations(solver, num_iterations)
    ccall((:HYPRE_LGMRESGetNumIterations, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, num_iterations)
end

function HYPRE_LGMRESGetFinalRelativeResidualNorm(solver, norm)
    ccall((:HYPRE_LGMRESGetFinalRelativeResidualNorm, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Real}), solver, norm)
end

function HYPRE_LGMRESGetResidual(solver, residual)
    ccall((:HYPRE_LGMRESGetResidual, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{Cvoid}), solver, residual)
end

function HYPRE_LGMRESGetTol(solver, tol)
    ccall((:HYPRE_LGMRESGetTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Real}), solver, tol)
end

function HYPRE_LGMRESGetConvergenceFactorTol(solver, cf_tol)
    ccall((:HYPRE_LGMRESGetConvergenceFactorTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Real}), solver, cf_tol)
end

function HYPRE_LGMRESGetStopCrit(solver, stop_crit)
    ccall((:HYPRE_LGMRESGetStopCrit, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, stop_crit)
end

function HYPRE_LGMRESGetMinIter(solver, min_iter)
    ccall((:HYPRE_LGMRESGetMinIter, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, min_iter)
end

function HYPRE_LGMRESGetMaxIter(solver, max_iter)
    ccall((:HYPRE_LGMRESGetMaxIter, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, max_iter)
end

function HYPRE_LGMRESGetKDim(solver, k_dim)
    ccall((:HYPRE_LGMRESGetKDim, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, k_dim)
end

function HYPRE_LGMRESGetAugDim(solver, k_dim)
    ccall((:HYPRE_LGMRESGetAugDim, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, k_dim)
end

function HYPRE_LGMRESGetPrecond(solver, precond_data_ptr)
    ccall((:HYPRE_LGMRESGetPrecond, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Solver}), solver, precond_data_ptr)
end

function HYPRE_LGMRESGetLogging(solver, level)
    ccall((:HYPRE_LGMRESGetLogging, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, level)
end

function HYPRE_LGMRESGetPrintLevel(solver, level)
    ccall((:HYPRE_LGMRESGetPrintLevel, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, level)
end

function HYPRE_LGMRESGetConverged(solver, converged)
    ccall((:HYPRE_LGMRESGetConverged, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, converged)
end

function HYPRE_COGMRESSetup(solver, A, b, x)
    ccall((:HYPRE_COGMRESSetup, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Matrix, HYPRE_Vector, HYPRE_Vector), solver, A, b, x)
end

function HYPRE_COGMRESSolve(solver, A, b, x)
    ccall((:HYPRE_COGMRESSolve, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Matrix, HYPRE_Vector, HYPRE_Vector), solver, A, b, x)
end

function HYPRE_COGMRESSetTol(solver, tol)
    ccall((:HYPRE_COGMRESSetTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, tol)
end

function HYPRE_COGMRESSetAbsoluteTol(solver, a_tol)
    ccall((:HYPRE_COGMRESSetAbsoluteTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, a_tol)
end

function HYPRE_COGMRESSetConvergenceFactorTol(solver, cf_tol)
    ccall((:HYPRE_COGMRESSetConvergenceFactorTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, cf_tol)
end

function HYPRE_COGMRESSetMinIter(solver, min_iter)
    ccall((:HYPRE_COGMRESSetMinIter, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, min_iter)
end

function HYPRE_COGMRESSetMaxIter(solver, max_iter)
    ccall((:HYPRE_COGMRESSetMaxIter, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, max_iter)
end

function HYPRE_COGMRESSetKDim(solver, k_dim)
    ccall((:HYPRE_COGMRESSetKDim, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, k_dim)
end

function HYPRE_COGMRESSetUnroll(solver, unroll)
    ccall((:HYPRE_COGMRESSetUnroll, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, unroll)
end

function HYPRE_COGMRESSetCGS(solver, cgs)
    ccall((:HYPRE_COGMRESSetCGS, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, cgs)
end

function HYPRE_COGMRESSetPrecond(solver, precond, precond_setup, precond_solver)
    ccall((:HYPRE_COGMRESSetPrecond, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_PtrToSolverFcn, HYPRE_PtrToSolverFcn, HYPRE_Solver), solver, precond, precond_setup, precond_solver)
end

function HYPRE_COGMRESSetLogging(solver, logging)
    ccall((:HYPRE_COGMRESSetLogging, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, logging)
end

function HYPRE_COGMRESSetPrintLevel(solver, level)
    ccall((:HYPRE_COGMRESSetPrintLevel, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, level)
end

function HYPRE_COGMRESGetNumIterations(solver, num_iterations)
    ccall((:HYPRE_COGMRESGetNumIterations, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, num_iterations)
end

function HYPRE_COGMRESGetFinalRelativeResidualNorm(solver, norm)
    ccall((:HYPRE_COGMRESGetFinalRelativeResidualNorm, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Real}), solver, norm)
end

function HYPRE_COGMRESGetResidual(solver, residual)
    ccall((:HYPRE_COGMRESGetResidual, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{Cvoid}), solver, residual)
end

function HYPRE_COGMRESGetTol(solver, tol)
    ccall((:HYPRE_COGMRESGetTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Real}), solver, tol)
end

function HYPRE_COGMRESGetConvergenceFactorTol(solver, cf_tol)
    ccall((:HYPRE_COGMRESGetConvergenceFactorTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Real}), solver, cf_tol)
end

function HYPRE_COGMRESGetMinIter(solver, min_iter)
    ccall((:HYPRE_COGMRESGetMinIter, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, min_iter)
end

function HYPRE_COGMRESGetMaxIter(solver, max_iter)
    ccall((:HYPRE_COGMRESGetMaxIter, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, max_iter)
end

function HYPRE_COGMRESGetKDim(solver, k_dim)
    ccall((:HYPRE_COGMRESGetKDim, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, k_dim)
end

function HYPRE_COGMRESGetUnroll(solver, unroll)
    ccall((:HYPRE_COGMRESGetUnroll, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, unroll)
end

function HYPRE_COGMRESGetCGS(solver, cgs)
    ccall((:HYPRE_COGMRESGetCGS, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, cgs)
end

function HYPRE_COGMRESGetPrecond(solver, precond_data_ptr)
    ccall((:HYPRE_COGMRESGetPrecond, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Solver}), solver, precond_data_ptr)
end

function HYPRE_COGMRESGetLogging(solver, level)
    ccall((:HYPRE_COGMRESGetLogging, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, level)
end

function HYPRE_COGMRESGetPrintLevel(solver, level)
    ccall((:HYPRE_COGMRESGetPrintLevel, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, level)
end

function HYPRE_COGMRESGetConverged(solver, converged)
    ccall((:HYPRE_COGMRESGetConverged, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, converged)
end

function HYPRE_COGMRESSetModifyPC(solver, modify_pc)
    ccall((:HYPRE_COGMRESSetModifyPC, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_PtrToModifyPCFcn), solver, modify_pc)
end

function HYPRE_BiCGSTABDestroy(solver)
    ccall((:HYPRE_BiCGSTABDestroy, libHYPRE), HYPRE_Int, (HYPRE_Solver,), solver)
end

function HYPRE_BiCGSTABSetup(solver, A, b, x)
    ccall((:HYPRE_BiCGSTABSetup, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Matrix, HYPRE_Vector, HYPRE_Vector), solver, A, b, x)
end

function HYPRE_BiCGSTABSolve(solver, A, b, x)
    ccall((:HYPRE_BiCGSTABSolve, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Matrix, HYPRE_Vector, HYPRE_Vector), solver, A, b, x)
end

function HYPRE_BiCGSTABSetTol(solver, tol)
    ccall((:HYPRE_BiCGSTABSetTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, tol)
end

function HYPRE_BiCGSTABSetAbsoluteTol(solver, a_tol)
    ccall((:HYPRE_BiCGSTABSetAbsoluteTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, a_tol)
end

function HYPRE_BiCGSTABSetConvergenceFactorTol(solver, cf_tol)
    ccall((:HYPRE_BiCGSTABSetConvergenceFactorTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, cf_tol)
end

function HYPRE_BiCGSTABSetStopCrit(solver, stop_crit)
    ccall((:HYPRE_BiCGSTABSetStopCrit, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, stop_crit)
end

function HYPRE_BiCGSTABSetMinIter(solver, min_iter)
    ccall((:HYPRE_BiCGSTABSetMinIter, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, min_iter)
end

function HYPRE_BiCGSTABSetMaxIter(solver, max_iter)
    ccall((:HYPRE_BiCGSTABSetMaxIter, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, max_iter)
end

function HYPRE_BiCGSTABSetPrecond(solver, precond, precond_setup, precond_solver)
    ccall((:HYPRE_BiCGSTABSetPrecond, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_PtrToSolverFcn, HYPRE_PtrToSolverFcn, HYPRE_Solver), solver, precond, precond_setup, precond_solver)
end

function HYPRE_BiCGSTABSetLogging(solver, logging)
    ccall((:HYPRE_BiCGSTABSetLogging, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, logging)
end

function HYPRE_BiCGSTABSetPrintLevel(solver, level)
    ccall((:HYPRE_BiCGSTABSetPrintLevel, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, level)
end

function HYPRE_BiCGSTABGetNumIterations(solver, num_iterations)
    ccall((:HYPRE_BiCGSTABGetNumIterations, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, num_iterations)
end

function HYPRE_BiCGSTABGetFinalRelativeResidualNorm(solver, norm)
    ccall((:HYPRE_BiCGSTABGetFinalRelativeResidualNorm, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Real}), solver, norm)
end

function HYPRE_BiCGSTABGetResidual(solver, residual)
    ccall((:HYPRE_BiCGSTABGetResidual, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{Cvoid}), solver, residual)
end

function HYPRE_BiCGSTABGetPrecond(solver, precond_data_ptr)
    ccall((:HYPRE_BiCGSTABGetPrecond, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Solver}), solver, precond_data_ptr)
end

function HYPRE_CGNRDestroy(solver)
    ccall((:HYPRE_CGNRDestroy, libHYPRE), HYPRE_Int, (HYPRE_Solver,), solver)
end

function HYPRE_CGNRSetup(solver, A, b, x)
    ccall((:HYPRE_CGNRSetup, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Matrix, HYPRE_Vector, HYPRE_Vector), solver, A, b, x)
end

function HYPRE_CGNRSolve(solver, A, b, x)
    ccall((:HYPRE_CGNRSolve, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Matrix, HYPRE_Vector, HYPRE_Vector), solver, A, b, x)
end

function HYPRE_CGNRSetTol(solver, tol)
    ccall((:HYPRE_CGNRSetTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, tol)
end

function HYPRE_CGNRSetStopCrit(solver, stop_crit)
    ccall((:HYPRE_CGNRSetStopCrit, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, stop_crit)
end

function HYPRE_CGNRSetMinIter(solver, min_iter)
    ccall((:HYPRE_CGNRSetMinIter, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, min_iter)
end

function HYPRE_CGNRSetMaxIter(solver, max_iter)
    ccall((:HYPRE_CGNRSetMaxIter, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, max_iter)
end

function HYPRE_CGNRSetPrecond(solver, precond, precondT, precond_setup, precond_solver)
    ccall((:HYPRE_CGNRSetPrecond, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_PtrToSolverFcn, HYPRE_PtrToSolverFcn, HYPRE_PtrToSolverFcn, HYPRE_Solver), solver, precond, precondT, precond_setup, precond_solver)
end

function HYPRE_CGNRSetLogging(solver, logging)
    ccall((:HYPRE_CGNRSetLogging, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, logging)
end

function HYPRE_CGNRGetNumIterations(solver, num_iterations)
    ccall((:HYPRE_CGNRGetNumIterations, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, num_iterations)
end

function HYPRE_CGNRGetFinalRelativeResidualNorm(solver, norm)
    ccall((:HYPRE_CGNRGetFinalRelativeResidualNorm, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Real}), solver, norm)
end

function HYPRE_CGNRGetPrecond(solver, precond_data_ptr)
    ccall((:HYPRE_CGNRGetPrecond, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Solver}), solver, precond_data_ptr)
end

struct utilities_FortranMatrix
    globalHeight::HYPRE_BigInt
    height::HYPRE_BigInt
    width::HYPRE_BigInt
    value::Ptr{HYPRE_Real}
    ownsValues::HYPRE_Int
end

function utilities_FortranMatrixCreate()
    ccall((:utilities_FortranMatrixCreate, libHYPRE), Ptr{utilities_FortranMatrix}, ())
end

function utilities_FortranMatrixAllocateData(h, w, mtx)
    ccall((:utilities_FortranMatrixAllocateData, libHYPRE), Cvoid, (HYPRE_BigInt, HYPRE_BigInt, Ptr{utilities_FortranMatrix}), h, w, mtx)
end

function utilities_FortranMatrixWrap(arg1, gh, h, w, mtx)
    ccall((:utilities_FortranMatrixWrap, libHYPRE), Cvoid, (Ptr{HYPRE_Real}, HYPRE_BigInt, HYPRE_BigInt, HYPRE_BigInt, Ptr{utilities_FortranMatrix}), arg1, gh, h, w, mtx)
end

function utilities_FortranMatrixDestroy(mtx)
    ccall((:utilities_FortranMatrixDestroy, libHYPRE), Cvoid, (Ptr{utilities_FortranMatrix},), mtx)
end

function utilities_FortranMatrixGlobalHeight(mtx)
    ccall((:utilities_FortranMatrixGlobalHeight, libHYPRE), HYPRE_BigInt, (Ptr{utilities_FortranMatrix},), mtx)
end

function utilities_FortranMatrixHeight(mtx)
    ccall((:utilities_FortranMatrixHeight, libHYPRE), HYPRE_BigInt, (Ptr{utilities_FortranMatrix},), mtx)
end

function utilities_FortranMatrixWidth(mtx)
    ccall((:utilities_FortranMatrixWidth, libHYPRE), HYPRE_BigInt, (Ptr{utilities_FortranMatrix},), mtx)
end

function utilities_FortranMatrixValues(mtx)
    ccall((:utilities_FortranMatrixValues, libHYPRE), Ptr{HYPRE_Real}, (Ptr{utilities_FortranMatrix},), mtx)
end

function utilities_FortranMatrixClear(mtx)
    ccall((:utilities_FortranMatrixClear, libHYPRE), Cvoid, (Ptr{utilities_FortranMatrix},), mtx)
end

function utilities_FortranMatrixClearL(mtx)
    ccall((:utilities_FortranMatrixClearL, libHYPRE), Cvoid, (Ptr{utilities_FortranMatrix},), mtx)
end

function utilities_FortranMatrixSetToIdentity(mtx)
    ccall((:utilities_FortranMatrixSetToIdentity, libHYPRE), Cvoid, (Ptr{utilities_FortranMatrix},), mtx)
end

function utilities_FortranMatrixTransposeSquare(mtx)
    ccall((:utilities_FortranMatrixTransposeSquare, libHYPRE), Cvoid, (Ptr{utilities_FortranMatrix},), mtx)
end

function utilities_FortranMatrixSymmetrize(mtx)
    ccall((:utilities_FortranMatrixSymmetrize, libHYPRE), Cvoid, (Ptr{utilities_FortranMatrix},), mtx)
end

function utilities_FortranMatrixCopy(src, t, dest)
    ccall((:utilities_FortranMatrixCopy, libHYPRE), Cvoid, (Ptr{utilities_FortranMatrix}, HYPRE_Int, Ptr{utilities_FortranMatrix}), src, t, dest)
end

function utilities_FortranMatrixIndexCopy(index, src, t, dest)
    ccall((:utilities_FortranMatrixIndexCopy, libHYPRE), Cvoid, (Ptr{HYPRE_Int}, Ptr{utilities_FortranMatrix}, HYPRE_Int, Ptr{utilities_FortranMatrix}), index, src, t, dest)
end

function utilities_FortranMatrixSetDiagonal(mtx, d)
    ccall((:utilities_FortranMatrixSetDiagonal, libHYPRE), Cvoid, (Ptr{utilities_FortranMatrix}, Ptr{utilities_FortranMatrix}), mtx, d)
end

function utilities_FortranMatrixGetDiagonal(mtx, d)
    ccall((:utilities_FortranMatrixGetDiagonal, libHYPRE), Cvoid, (Ptr{utilities_FortranMatrix}, Ptr{utilities_FortranMatrix}), mtx, d)
end

function utilities_FortranMatrixAdd(a, mtxA, mtxB, mtxC)
    ccall((:utilities_FortranMatrixAdd, libHYPRE), Cvoid, (HYPRE_Real, Ptr{utilities_FortranMatrix}, Ptr{utilities_FortranMatrix}, Ptr{utilities_FortranMatrix}), a, mtxA, mtxB, mtxC)
end

function utilities_FortranMatrixDMultiply(d, mtx)
    ccall((:utilities_FortranMatrixDMultiply, libHYPRE), Cvoid, (Ptr{utilities_FortranMatrix}, Ptr{utilities_FortranMatrix}), d, mtx)
end

function utilities_FortranMatrixMultiplyD(mtx, d)
    ccall((:utilities_FortranMatrixMultiplyD, libHYPRE), Cvoid, (Ptr{utilities_FortranMatrix}, Ptr{utilities_FortranMatrix}), mtx, d)
end

function utilities_FortranMatrixMultiply(mtxA, tA, mtxB, tB, mtxC)
    ccall((:utilities_FortranMatrixMultiply, libHYPRE), Cvoid, (Ptr{utilities_FortranMatrix}, HYPRE_Int, Ptr{utilities_FortranMatrix}, HYPRE_Int, Ptr{utilities_FortranMatrix}), mtxA, tA, mtxB, tB, mtxC)
end

function utilities_FortranMatrixFNorm(mtx)
    ccall((:utilities_FortranMatrixFNorm, libHYPRE), HYPRE_Real, (Ptr{utilities_FortranMatrix},), mtx)
end

function utilities_FortranMatrixValue(mtx, i, j)
    ccall((:utilities_FortranMatrixValue, libHYPRE), HYPRE_Real, (Ptr{utilities_FortranMatrix}, HYPRE_BigInt, HYPRE_BigInt), mtx, i, j)
end

function utilities_FortranMatrixValuePtr(mtx, i, j)
    ccall((:utilities_FortranMatrixValuePtr, libHYPRE), Ptr{HYPRE_Real}, (Ptr{utilities_FortranMatrix}, HYPRE_BigInt, HYPRE_BigInt), mtx, i, j)
end

function utilities_FortranMatrixMaxValue(mtx)
    ccall((:utilities_FortranMatrixMaxValue, libHYPRE), HYPRE_Real, (Ptr{utilities_FortranMatrix},), mtx)
end

function utilities_FortranMatrixSelectBlock(mtx, iFrom, iTo, jFrom, jTo, block)
    ccall((:utilities_FortranMatrixSelectBlock, libHYPRE), Cvoid, (Ptr{utilities_FortranMatrix}, HYPRE_BigInt, HYPRE_BigInt, HYPRE_BigInt, HYPRE_BigInt, Ptr{utilities_FortranMatrix}), mtx, iFrom, iTo, jFrom, jTo, block)
end

function utilities_FortranMatrixUpperInv(u)
    ccall((:utilities_FortranMatrixUpperInv, libHYPRE), Cvoid, (Ptr{utilities_FortranMatrix},), u)
end

function utilities_FortranMatrixPrint(mtx, fileName)
    ccall((:utilities_FortranMatrixPrint, libHYPRE), HYPRE_Int, (Ptr{utilities_FortranMatrix}, Ptr{Cchar}), mtx, fileName)
end

struct mv_InterfaceInterpreter
    CreateVector::Ptr{Cvoid}
    DestroyVector::Ptr{Cvoid}
    InnerProd::Ptr{Cvoid}
    CopyVector::Ptr{Cvoid}
    ClearVector::Ptr{Cvoid}
    SetRandomValues::Ptr{Cvoid}
    ScaleVector::Ptr{Cvoid}
    Axpy::Ptr{Cvoid}
    VectorSize::Ptr{Cvoid}
    CreateMultiVector::Ptr{Cvoid}
    CopyCreateMultiVector::Ptr{Cvoid}
    DestroyMultiVector::Ptr{Cvoid}
    Width::Ptr{Cvoid}
    Height::Ptr{Cvoid}
    SetMask::Ptr{Cvoid}
    CopyMultiVector::Ptr{Cvoid}
    ClearMultiVector::Ptr{Cvoid}
    SetRandomVectors::Ptr{Cvoid}
    MultiInnerProd::Ptr{Cvoid}
    MultiInnerProdDiag::Ptr{Cvoid}
    MultiVecMat::Ptr{Cvoid}
    MultiVecMatDiag::Ptr{Cvoid}
    MultiAxpy::Ptr{Cvoid}
    MultiXapy::Ptr{Cvoid}
    Eval::Ptr{Cvoid}
end

mutable struct mv_MultiVector end

const mv_MultiVectorPtr = Ptr{mv_MultiVector}

function mv_MultiVectorGetData(x)
    ccall((:mv_MultiVectorGetData, libHYPRE), Ptr{Cvoid}, (mv_MultiVectorPtr,), x)
end

function mv_MultiVectorWrap(ii, data, ownsData)
    ccall((:mv_MultiVectorWrap, libHYPRE), mv_MultiVectorPtr, (Ptr{mv_InterfaceInterpreter}, Ptr{Cvoid}, HYPRE_Int), ii, data, ownsData)
end

function mv_MultiVectorCreateFromSampleVector(arg1, n, sample)
    ccall((:mv_MultiVectorCreateFromSampleVector, libHYPRE), mv_MultiVectorPtr, (Ptr{Cvoid}, HYPRE_Int, Ptr{Cvoid}), arg1, n, sample)
end

function mv_MultiVectorCreateCopy(x, copyValues)
    ccall((:mv_MultiVectorCreateCopy, libHYPRE), mv_MultiVectorPtr, (mv_MultiVectorPtr, HYPRE_Int), x, copyValues)
end

function mv_MultiVectorDestroy(arg1)
    ccall((:mv_MultiVectorDestroy, libHYPRE), Cvoid, (mv_MultiVectorPtr,), arg1)
end

function mv_MultiVectorWidth(v)
    ccall((:mv_MultiVectorWidth, libHYPRE), HYPRE_Int, (mv_MultiVectorPtr,), v)
end

function mv_MultiVectorHeight(v)
    ccall((:mv_MultiVectorHeight, libHYPRE), HYPRE_Int, (mv_MultiVectorPtr,), v)
end

function mv_MultiVectorSetMask(v, mask)
    ccall((:mv_MultiVectorSetMask, libHYPRE), Cvoid, (mv_MultiVectorPtr, Ptr{HYPRE_Int}), v, mask)
end

function mv_MultiVectorClear(arg1)
    ccall((:mv_MultiVectorClear, libHYPRE), Cvoid, (mv_MultiVectorPtr,), arg1)
end

function mv_MultiVectorSetRandom(v, seed)
    ccall((:mv_MultiVectorSetRandom, libHYPRE), Cvoid, (mv_MultiVectorPtr, HYPRE_Int), v, seed)
end

function mv_MultiVectorCopy(src, dest)
    ccall((:mv_MultiVectorCopy, libHYPRE), Cvoid, (mv_MultiVectorPtr, mv_MultiVectorPtr), src, dest)
end

function mv_MultiVectorAxpy(a, x, y)
    ccall((:mv_MultiVectorAxpy, libHYPRE), Cvoid, (HYPRE_Complex, mv_MultiVectorPtr, mv_MultiVectorPtr), a, x, y)
end

function mv_MultiVectorByMultiVector(x, y, gh, h, w, v)
    ccall((:mv_MultiVectorByMultiVector, libHYPRE), Cvoid, (mv_MultiVectorPtr, mv_MultiVectorPtr, HYPRE_Int, HYPRE_Int, HYPRE_Int, Ptr{HYPRE_Real}), x, y, gh, h, w, v)
end

function mv_MultiVectorByMultiVectorDiag(arg1, arg2, mask, n, diag)
    ccall((:mv_MultiVectorByMultiVectorDiag, libHYPRE), Cvoid, (mv_MultiVectorPtr, mv_MultiVectorPtr, Ptr{HYPRE_Int}, HYPRE_Int, Ptr{HYPRE_Real}), arg1, arg2, mask, n, diag)
end

function mv_MultiVectorByMatrix(x, gh, h, w, v, y)
    ccall((:mv_MultiVectorByMatrix, libHYPRE), Cvoid, (mv_MultiVectorPtr, HYPRE_Int, HYPRE_Int, HYPRE_Int, Ptr{HYPRE_Complex}, mv_MultiVectorPtr), x, gh, h, w, v, y)
end

function mv_MultiVectorXapy(x, gh, h, w, v, y)
    ccall((:mv_MultiVectorXapy, libHYPRE), Cvoid, (mv_MultiVectorPtr, HYPRE_Int, HYPRE_Int, HYPRE_Int, Ptr{HYPRE_Complex}, mv_MultiVectorPtr), x, gh, h, w, v, y)
end

function mv_MultiVectorByDiagonal(x, mask, n, diag, y)
    ccall((:mv_MultiVectorByDiagonal, libHYPRE), Cvoid, (mv_MultiVectorPtr, Ptr{HYPRE_Int}, HYPRE_Int, Ptr{HYPRE_Complex}, mv_MultiVectorPtr), x, mask, n, diag, y)
end

function mv_MultiVectorEval(f, par, x, y)
    ccall((:mv_MultiVectorEval, libHYPRE), Cvoid, (Ptr{Cvoid}, Ptr{Cvoid}, mv_MultiVectorPtr, mv_MultiVectorPtr), f, par, x, y)
end

struct mv_TempMultiVector
    numVectors::HYPRE_Int
    mask::Ptr{HYPRE_Int}
    vector::Ptr{Ptr{Cvoid}}
    ownsVectors::HYPRE_Int
    ownsMask::HYPRE_Int
    interpreter::Ptr{mv_InterfaceInterpreter}
end

const mv_TempMultiVectorPtr = Ptr{mv_TempMultiVector}

function mv_TempMultiVectorCreateFromSampleVector(arg1, n, sample)
    ccall((:mv_TempMultiVectorCreateFromSampleVector, libHYPRE), Ptr{Cvoid}, (Ptr{Cvoid}, HYPRE_Int, Ptr{Cvoid}), arg1, n, sample)
end

function mv_TempMultiVectorCreateCopy(arg1, copyValues)
    ccall((:mv_TempMultiVectorCreateCopy, libHYPRE), Ptr{Cvoid}, (Ptr{Cvoid}, HYPRE_Int), arg1, copyValues)
end

function mv_TempMultiVectorDestroy(arg1)
    ccall((:mv_TempMultiVectorDestroy, libHYPRE), Cvoid, (Ptr{Cvoid},), arg1)
end

function mv_TempMultiVectorWidth(v)
    ccall((:mv_TempMultiVectorWidth, libHYPRE), HYPRE_Int, (Ptr{Cvoid},), v)
end

function mv_TempMultiVectorHeight(v)
    ccall((:mv_TempMultiVectorHeight, libHYPRE), HYPRE_Int, (Ptr{Cvoid},), v)
end

function mv_TempMultiVectorSetMask(v, mask)
    ccall((:mv_TempMultiVectorSetMask, libHYPRE), Cvoid, (Ptr{Cvoid}, Ptr{HYPRE_Int}), v, mask)
end

function mv_TempMultiVectorClear(arg1)
    ccall((:mv_TempMultiVectorClear, libHYPRE), Cvoid, (Ptr{Cvoid},), arg1)
end

function mv_TempMultiVectorSetRandom(v, seed)
    ccall((:mv_TempMultiVectorSetRandom, libHYPRE), Cvoid, (Ptr{Cvoid}, HYPRE_Int), v, seed)
end

function mv_TempMultiVectorCopy(src, dest)
    ccall((:mv_TempMultiVectorCopy, libHYPRE), Cvoid, (Ptr{Cvoid}, Ptr{Cvoid}), src, dest)
end

function mv_TempMultiVectorAxpy(arg1, arg2, arg3)
    ccall((:mv_TempMultiVectorAxpy, libHYPRE), Cvoid, (HYPRE_Complex, Ptr{Cvoid}, Ptr{Cvoid}), arg1, arg2, arg3)
end

function mv_TempMultiVectorByMultiVector(arg1, arg2, gh, h, w, v)
    ccall((:mv_TempMultiVectorByMultiVector, libHYPRE), Cvoid, (Ptr{Cvoid}, Ptr{Cvoid}, HYPRE_Int, HYPRE_Int, HYPRE_Int, Ptr{HYPRE_Complex}), arg1, arg2, gh, h, w, v)
end

function mv_TempMultiVectorByMultiVectorDiag(x, y, mask, n, diag)
    ccall((:mv_TempMultiVectorByMultiVectorDiag, libHYPRE), Cvoid, (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{HYPRE_Int}, HYPRE_Int, Ptr{HYPRE_Complex}), x, y, mask, n, diag)
end

function mv_TempMultiVectorByMatrix(arg1, gh, h, w, v, arg6)
    ccall((:mv_TempMultiVectorByMatrix, libHYPRE), Cvoid, (Ptr{Cvoid}, HYPRE_Int, HYPRE_Int, HYPRE_Int, Ptr{HYPRE_Complex}, Ptr{Cvoid}), arg1, gh, h, w, v, arg6)
end

function mv_TempMultiVectorXapy(x, gh, h, w, v, y)
    ccall((:mv_TempMultiVectorXapy, libHYPRE), Cvoid, (Ptr{Cvoid}, HYPRE_Int, HYPRE_Int, HYPRE_Int, Ptr{HYPRE_Complex}, Ptr{Cvoid}), x, gh, h, w, v, y)
end

function mv_TempMultiVectorByDiagonal(x, mask, n, diag, y)
    ccall((:mv_TempMultiVectorByDiagonal, libHYPRE), Cvoid, (Ptr{Cvoid}, Ptr{HYPRE_Int}, HYPRE_Int, Ptr{HYPRE_Complex}, Ptr{Cvoid}), x, mask, n, diag, y)
end

function mv_TempMultiVectorEval(f, par, x, y)
    ccall((:mv_TempMultiVectorEval, libHYPRE), Cvoid, (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}), f, par, x, y)
end

struct HYPRE_MatvecFunctions
    MatvecCreate::Ptr{Cvoid}
    Matvec::Ptr{Cvoid}
    MatvecDestroy::Ptr{Cvoid}
    MatMultiVecCreate::Ptr{Cvoid}
    MatMultiVec::Ptr{Cvoid}
    MatMultiVecDestroy::Ptr{Cvoid}
end

function HYPRE_LOBPCGCreate(interpreter, mvfunctions, solver)
    ccall((:HYPRE_LOBPCGCreate, libHYPRE), HYPRE_Int, (Ptr{mv_InterfaceInterpreter}, Ptr{HYPRE_MatvecFunctions}, Ptr{HYPRE_Solver}), interpreter, mvfunctions, solver)
end

function HYPRE_LOBPCGDestroy(solver)
    ccall((:HYPRE_LOBPCGDestroy, libHYPRE), HYPRE_Int, (HYPRE_Solver,), solver)
end

function HYPRE_LOBPCGSetPrecond(solver, precond, precond_setup, precond_solver)
    ccall((:HYPRE_LOBPCGSetPrecond, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_PtrToSolverFcn, HYPRE_PtrToSolverFcn, HYPRE_Solver), solver, precond, precond_setup, precond_solver)
end

function HYPRE_LOBPCGGetPrecond(solver, precond_data_ptr)
    ccall((:HYPRE_LOBPCGGetPrecond, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Solver}), solver, precond_data_ptr)
end

function HYPRE_LOBPCGSetup(solver, A, b, x)
    ccall((:HYPRE_LOBPCGSetup, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Matrix, HYPRE_Vector, HYPRE_Vector), solver, A, b, x)
end

function HYPRE_LOBPCGSetupB(solver, B, x)
    ccall((:HYPRE_LOBPCGSetupB, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Matrix, HYPRE_Vector), solver, B, x)
end

function HYPRE_LOBPCGSetupT(solver, T, x)
    ccall((:HYPRE_LOBPCGSetupT, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Matrix, HYPRE_Vector), solver, T, x)
end

function HYPRE_LOBPCGSolve(solver, y, x, lambda)
    ccall((:HYPRE_LOBPCGSolve, libHYPRE), HYPRE_Int, (HYPRE_Solver, mv_MultiVectorPtr, mv_MultiVectorPtr, Ptr{HYPRE_Real}), solver, y, x, lambda)
end

function HYPRE_LOBPCGSetTol(solver, tol)
    ccall((:HYPRE_LOBPCGSetTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, tol)
end

function HYPRE_LOBPCGSetRTol(solver, tol)
    ccall((:HYPRE_LOBPCGSetRTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, tol)
end

function HYPRE_LOBPCGSetMaxIter(solver, max_iter)
    ccall((:HYPRE_LOBPCGSetMaxIter, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, max_iter)
end

function HYPRE_LOBPCGSetPrecondUsageMode(solver, mode)
    ccall((:HYPRE_LOBPCGSetPrecondUsageMode, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, mode)
end

function HYPRE_LOBPCGSetPrintLevel(solver, level)
    ccall((:HYPRE_LOBPCGSetPrintLevel, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, level)
end

function HYPRE_LOBPCGResidualNorms(solver)
    ccall((:HYPRE_LOBPCGResidualNorms, libHYPRE), Ptr{utilities_FortranMatrix}, (HYPRE_Solver,), solver)
end

function HYPRE_LOBPCGResidualNormsHistory(solver)
    ccall((:HYPRE_LOBPCGResidualNormsHistory, libHYPRE), Ptr{utilities_FortranMatrix}, (HYPRE_Solver,), solver)
end

function HYPRE_LOBPCGEigenvaluesHistory(solver)
    ccall((:HYPRE_LOBPCGEigenvaluesHistory, libHYPRE), Ptr{utilities_FortranMatrix}, (HYPRE_Solver,), solver)
end

function HYPRE_LOBPCGIterations(solver)
    ccall((:HYPRE_LOBPCGIterations, libHYPRE), HYPRE_Int, (HYPRE_Solver,), solver)
end

function hypre_LOBPCGMultiOperatorB(data, x, y)
    ccall((:hypre_LOBPCGMultiOperatorB, libHYPRE), Cvoid, (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}), data, x, y)
end

function lobpcg_MultiVectorByMultiVector(x, y, xy)
    ccall((:lobpcg_MultiVectorByMultiVector, libHYPRE), Cvoid, (mv_MultiVectorPtr, mv_MultiVectorPtr, Ptr{utilities_FortranMatrix}), x, y, xy)
end

# typedef HYPRE_Int ( * HYPRE_PtrToParSolverFcn ) ( HYPRE_Solver , HYPRE_ParCSRMatrix , HYPRE_ParVector , HYPRE_ParVector )
const HYPRE_PtrToParSolverFcn = Ptr{Cvoid}

function HYPRE_BoomerAMGCreate(solver)
    ccall((:HYPRE_BoomerAMGCreate, libHYPRE), HYPRE_Int, (Ptr{HYPRE_Solver},), solver)
end

function HYPRE_BoomerAMGDestroy(solver)
    ccall((:HYPRE_BoomerAMGDestroy, libHYPRE), HYPRE_Int, (HYPRE_Solver,), solver)
end

function HYPRE_BoomerAMGSetup(solver, A, b, x)
    ccall((:HYPRE_BoomerAMGSetup, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParCSRMatrix, HYPRE_ParVector, HYPRE_ParVector), solver, A, b, x)
end

function HYPRE_BoomerAMGSolve(solver, A, b, x)
    ccall((:HYPRE_BoomerAMGSolve, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParCSRMatrix, HYPRE_ParVector, HYPRE_ParVector), solver, A, b, x)
end

function HYPRE_BoomerAMGSolveT(solver, A, b, x)
    ccall((:HYPRE_BoomerAMGSolveT, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParCSRMatrix, HYPRE_ParVector, HYPRE_ParVector), solver, A, b, x)
end

function HYPRE_BoomerAMGSetOldDefault(solver)
    ccall((:HYPRE_BoomerAMGSetOldDefault, libHYPRE), HYPRE_Int, (HYPRE_Solver,), solver)
end

function HYPRE_BoomerAMGGetResidual(solver, residual)
    ccall((:HYPRE_BoomerAMGGetResidual, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_ParVector}), solver, residual)
end

function HYPRE_BoomerAMGGetNumIterations(solver, num_iterations)
    ccall((:HYPRE_BoomerAMGGetNumIterations, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, num_iterations)
end

function HYPRE_BoomerAMGGetFinalRelativeResidualNorm(solver, rel_resid_norm)
    ccall((:HYPRE_BoomerAMGGetFinalRelativeResidualNorm, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Real}), solver, rel_resid_norm)
end

function HYPRE_BoomerAMGSetNumFunctions(solver, num_functions)
    ccall((:HYPRE_BoomerAMGSetNumFunctions, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, num_functions)
end

function HYPRE_BoomerAMGSetDofFunc(solver, dof_func)
    ccall((:HYPRE_BoomerAMGSetDofFunc, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, dof_func)
end

function HYPRE_BoomerAMGSetConvergeType(solver, type)
    ccall((:HYPRE_BoomerAMGSetConvergeType, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, type)
end

function HYPRE_BoomerAMGSetTol(solver, tol)
    ccall((:HYPRE_BoomerAMGSetTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, tol)
end

function HYPRE_BoomerAMGSetMaxIter(solver, max_iter)
    ccall((:HYPRE_BoomerAMGSetMaxIter, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, max_iter)
end

function HYPRE_BoomerAMGSetMinIter(solver, min_iter)
    ccall((:HYPRE_BoomerAMGSetMinIter, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, min_iter)
end

function HYPRE_BoomerAMGSetMaxCoarseSize(solver, max_coarse_size)
    ccall((:HYPRE_BoomerAMGSetMaxCoarseSize, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, max_coarse_size)
end

function HYPRE_BoomerAMGSetMinCoarseSize(solver, min_coarse_size)
    ccall((:HYPRE_BoomerAMGSetMinCoarseSize, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, min_coarse_size)
end

function HYPRE_BoomerAMGSetMaxLevels(solver, max_levels)
    ccall((:HYPRE_BoomerAMGSetMaxLevels, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, max_levels)
end

function HYPRE_BoomerAMGSetCoarsenCutFactor(solver, coarsen_cut_factor)
    ccall((:HYPRE_BoomerAMGSetCoarsenCutFactor, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, coarsen_cut_factor)
end

function HYPRE_BoomerAMGSetStrongThreshold(solver, strong_threshold)
    ccall((:HYPRE_BoomerAMGSetStrongThreshold, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, strong_threshold)
end

function HYPRE_BoomerAMGSetStrongThresholdR(solver, strong_threshold)
    ccall((:HYPRE_BoomerAMGSetStrongThresholdR, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, strong_threshold)
end

function HYPRE_BoomerAMGSetFilterThresholdR(solver, filter_threshold)
    ccall((:HYPRE_BoomerAMGSetFilterThresholdR, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, filter_threshold)
end

function HYPRE_BoomerAMGSetSCommPkgSwitch(solver, S_commpkg_switch)
    ccall((:HYPRE_BoomerAMGSetSCommPkgSwitch, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, S_commpkg_switch)
end

function HYPRE_BoomerAMGSetMaxRowSum(solver, max_row_sum)
    ccall((:HYPRE_BoomerAMGSetMaxRowSum, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, max_row_sum)
end

function HYPRE_BoomerAMGSetCoarsenType(solver, coarsen_type)
    ccall((:HYPRE_BoomerAMGSetCoarsenType, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, coarsen_type)
end

function HYPRE_BoomerAMGSetNonGalerkinTol(solver, nongalerkin_tol)
    ccall((:HYPRE_BoomerAMGSetNonGalerkinTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, nongalerkin_tol)
end

function HYPRE_BoomerAMGSetLevelNonGalerkinTol(solver, nongalerkin_tol, level)
    ccall((:HYPRE_BoomerAMGSetLevelNonGalerkinTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real, HYPRE_Int), solver, nongalerkin_tol, level)
end

function HYPRE_BoomerAMGSetNonGalerkTol(solver, nongalerk_num_tol, nongalerk_tol)
    ccall((:HYPRE_BoomerAMGSetNonGalerkTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int, Ptr{HYPRE_Real}), solver, nongalerk_num_tol, nongalerk_tol)
end

function HYPRE_BoomerAMGSetMeasureType(solver, measure_type)
    ccall((:HYPRE_BoomerAMGSetMeasureType, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, measure_type)
end

function HYPRE_BoomerAMGSetAggNumLevels(solver, agg_num_levels)
    ccall((:HYPRE_BoomerAMGSetAggNumLevels, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, agg_num_levels)
end

function HYPRE_BoomerAMGSetNumPaths(solver, num_paths)
    ccall((:HYPRE_BoomerAMGSetNumPaths, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, num_paths)
end

function HYPRE_BoomerAMGSetCGCIts(solver, its)
    ccall((:HYPRE_BoomerAMGSetCGCIts, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, its)
end

function HYPRE_BoomerAMGSetNodal(solver, nodal)
    ccall((:HYPRE_BoomerAMGSetNodal, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, nodal)
end

function HYPRE_BoomerAMGSetNodalDiag(solver, nodal_diag)
    ccall((:HYPRE_BoomerAMGSetNodalDiag, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, nodal_diag)
end

function HYPRE_BoomerAMGSetKeepSameSign(solver, keep_same_sign)
    ccall((:HYPRE_BoomerAMGSetKeepSameSign, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, keep_same_sign)
end

function HYPRE_BoomerAMGSetInterpType(solver, interp_type)
    ccall((:HYPRE_BoomerAMGSetInterpType, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, interp_type)
end

function HYPRE_BoomerAMGSetTruncFactor(solver, trunc_factor)
    ccall((:HYPRE_BoomerAMGSetTruncFactor, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, trunc_factor)
end

function HYPRE_BoomerAMGSetPMaxElmts(solver, P_max_elmts)
    ccall((:HYPRE_BoomerAMGSetPMaxElmts, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, P_max_elmts)
end

function HYPRE_BoomerAMGSetSepWeight(solver, sep_weight)
    ccall((:HYPRE_BoomerAMGSetSepWeight, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, sep_weight)
end

function HYPRE_BoomerAMGSetAggInterpType(solver, agg_interp_type)
    ccall((:HYPRE_BoomerAMGSetAggInterpType, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, agg_interp_type)
end

function HYPRE_BoomerAMGSetAggTruncFactor(solver, agg_trunc_factor)
    ccall((:HYPRE_BoomerAMGSetAggTruncFactor, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, agg_trunc_factor)
end

function HYPRE_BoomerAMGSetAggP12TruncFactor(solver, agg_P12_trunc_factor)
    ccall((:HYPRE_BoomerAMGSetAggP12TruncFactor, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, agg_P12_trunc_factor)
end

function HYPRE_BoomerAMGSetAggPMaxElmts(solver, agg_P_max_elmts)
    ccall((:HYPRE_BoomerAMGSetAggPMaxElmts, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, agg_P_max_elmts)
end

function HYPRE_BoomerAMGSetAggP12MaxElmts(solver, agg_P12_max_elmts)
    ccall((:HYPRE_BoomerAMGSetAggP12MaxElmts, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, agg_P12_max_elmts)
end

function HYPRE_BoomerAMGSetInterpVectors(solver, num_vectors, interp_vectors)
    ccall((:HYPRE_BoomerAMGSetInterpVectors, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int, Ptr{HYPRE_ParVector}), solver, num_vectors, interp_vectors)
end

function HYPRE_BoomerAMGSetInterpVecVariant(solver, var)
    ccall((:HYPRE_BoomerAMGSetInterpVecVariant, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, var)
end

function HYPRE_BoomerAMGSetInterpVecQMax(solver, q_max)
    ccall((:HYPRE_BoomerAMGSetInterpVecQMax, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, q_max)
end

function HYPRE_BoomerAMGSetInterpVecAbsQTrunc(solver, q_trunc)
    ccall((:HYPRE_BoomerAMGSetInterpVecAbsQTrunc, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, q_trunc)
end

function HYPRE_BoomerAMGSetGSMG(solver, gsmg)
    ccall((:HYPRE_BoomerAMGSetGSMG, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, gsmg)
end

function HYPRE_BoomerAMGSetNumSamples(solver, num_samples)
    ccall((:HYPRE_BoomerAMGSetNumSamples, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, num_samples)
end

function HYPRE_BoomerAMGSetCycleType(solver, cycle_type)
    ccall((:HYPRE_BoomerAMGSetCycleType, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, cycle_type)
end

function HYPRE_BoomerAMGSetFCycle(solver, fcycle)
    ccall((:HYPRE_BoomerAMGSetFCycle, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, fcycle)
end

function HYPRE_BoomerAMGSetAdditive(solver, addlvl)
    ccall((:HYPRE_BoomerAMGSetAdditive, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, addlvl)
end

function HYPRE_BoomerAMGSetMultAdditive(solver, addlvl)
    ccall((:HYPRE_BoomerAMGSetMultAdditive, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, addlvl)
end

function HYPRE_BoomerAMGSetSimple(solver, addlvl)
    ccall((:HYPRE_BoomerAMGSetSimple, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, addlvl)
end

function HYPRE_BoomerAMGSetAddLastLvl(solver, add_last_lvl)
    ccall((:HYPRE_BoomerAMGSetAddLastLvl, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, add_last_lvl)
end

function HYPRE_BoomerAMGSetMultAddTruncFactor(solver, add_trunc_factor)
    ccall((:HYPRE_BoomerAMGSetMultAddTruncFactor, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, add_trunc_factor)
end

function HYPRE_BoomerAMGSetMultAddPMaxElmts(solver, add_P_max_elmts)
    ccall((:HYPRE_BoomerAMGSetMultAddPMaxElmts, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, add_P_max_elmts)
end

function HYPRE_BoomerAMGSetAddRelaxType(solver, add_rlx_type)
    ccall((:HYPRE_BoomerAMGSetAddRelaxType, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, add_rlx_type)
end

function HYPRE_BoomerAMGSetAddRelaxWt(solver, add_rlx_wt)
    ccall((:HYPRE_BoomerAMGSetAddRelaxWt, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, add_rlx_wt)
end

function HYPRE_BoomerAMGSetSeqThreshold(solver, seq_threshold)
    ccall((:HYPRE_BoomerAMGSetSeqThreshold, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, seq_threshold)
end

function HYPRE_BoomerAMGSetRedundant(solver, redundant)
    ccall((:HYPRE_BoomerAMGSetRedundant, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, redundant)
end

function HYPRE_BoomerAMGSetNumGridSweeps(solver, num_grid_sweeps)
    ccall((:HYPRE_BoomerAMGSetNumGridSweeps, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, num_grid_sweeps)
end

function HYPRE_BoomerAMGSetNumSweeps(solver, num_sweeps)
    ccall((:HYPRE_BoomerAMGSetNumSweeps, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, num_sweeps)
end

function HYPRE_BoomerAMGSetCycleNumSweeps(solver, num_sweeps, k)
    ccall((:HYPRE_BoomerAMGSetCycleNumSweeps, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int, HYPRE_Int), solver, num_sweeps, k)
end

function HYPRE_BoomerAMGSetGridRelaxType(solver, grid_relax_type)
    ccall((:HYPRE_BoomerAMGSetGridRelaxType, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, grid_relax_type)
end

function HYPRE_BoomerAMGSetRelaxType(solver, relax_type)
    ccall((:HYPRE_BoomerAMGSetRelaxType, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, relax_type)
end

function HYPRE_BoomerAMGSetCycleRelaxType(solver, relax_type, k)
    ccall((:HYPRE_BoomerAMGSetCycleRelaxType, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int, HYPRE_Int), solver, relax_type, k)
end

function HYPRE_BoomerAMGSetRelaxOrder(solver, relax_order)
    ccall((:HYPRE_BoomerAMGSetRelaxOrder, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, relax_order)
end

function HYPRE_BoomerAMGSetGridRelaxPoints(solver, grid_relax_points)
    ccall((:HYPRE_BoomerAMGSetGridRelaxPoints, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{Ptr{HYPRE_Int}}), solver, grid_relax_points)
end

function HYPRE_BoomerAMGSetRelaxWeight(solver, relax_weight)
    ccall((:HYPRE_BoomerAMGSetRelaxWeight, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Real}), solver, relax_weight)
end

function HYPRE_BoomerAMGSetRelaxWt(solver, relax_weight)
    ccall((:HYPRE_BoomerAMGSetRelaxWt, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, relax_weight)
end

function HYPRE_BoomerAMGSetLevelRelaxWt(solver, relax_weight, level)
    ccall((:HYPRE_BoomerAMGSetLevelRelaxWt, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real, HYPRE_Int), solver, relax_weight, level)
end

function HYPRE_BoomerAMGSetOmega(solver, omega)
    ccall((:HYPRE_BoomerAMGSetOmega, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Real}), solver, omega)
end

function HYPRE_BoomerAMGSetOuterWt(solver, omega)
    ccall((:HYPRE_BoomerAMGSetOuterWt, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, omega)
end

function HYPRE_BoomerAMGSetLevelOuterWt(solver, omega, level)
    ccall((:HYPRE_BoomerAMGSetLevelOuterWt, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real, HYPRE_Int), solver, omega, level)
end

function HYPRE_BoomerAMGSetChebyOrder(solver, order)
    ccall((:HYPRE_BoomerAMGSetChebyOrder, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, order)
end

function HYPRE_BoomerAMGSetChebyFraction(solver, ratio)
    ccall((:HYPRE_BoomerAMGSetChebyFraction, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, ratio)
end

function HYPRE_BoomerAMGSetChebyScale(solver, scale)
    ccall((:HYPRE_BoomerAMGSetChebyScale, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, scale)
end

function HYPRE_BoomerAMGSetChebyVariant(solver, variant)
    ccall((:HYPRE_BoomerAMGSetChebyVariant, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, variant)
end

function HYPRE_BoomerAMGSetChebyEigEst(solver, eig_est)
    ccall((:HYPRE_BoomerAMGSetChebyEigEst, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, eig_est)
end

function HYPRE_BoomerAMGSetSmoothType(solver, smooth_type)
    ccall((:HYPRE_BoomerAMGSetSmoothType, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, smooth_type)
end

function HYPRE_BoomerAMGSetSmoothNumLevels(solver, smooth_num_levels)
    ccall((:HYPRE_BoomerAMGSetSmoothNumLevels, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, smooth_num_levels)
end

function HYPRE_BoomerAMGSetSmoothNumSweeps(solver, smooth_num_sweeps)
    ccall((:HYPRE_BoomerAMGSetSmoothNumSweeps, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, smooth_num_sweeps)
end

function HYPRE_BoomerAMGSetVariant(solver, variant)
    ccall((:HYPRE_BoomerAMGSetVariant, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, variant)
end

function HYPRE_BoomerAMGSetOverlap(solver, overlap)
    ccall((:HYPRE_BoomerAMGSetOverlap, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, overlap)
end

function HYPRE_BoomerAMGSetDomainType(solver, domain_type)
    ccall((:HYPRE_BoomerAMGSetDomainType, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, domain_type)
end

function HYPRE_BoomerAMGSetSchwarzRlxWeight(solver, schwarz_rlx_weight)
    ccall((:HYPRE_BoomerAMGSetSchwarzRlxWeight, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, schwarz_rlx_weight)
end

function HYPRE_BoomerAMGSetSchwarzUseNonSymm(solver, use_nonsymm)
    ccall((:HYPRE_BoomerAMGSetSchwarzUseNonSymm, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, use_nonsymm)
end

function HYPRE_BoomerAMGSetSym(solver, sym)
    ccall((:HYPRE_BoomerAMGSetSym, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, sym)
end

function HYPRE_BoomerAMGSetLevel(solver, level)
    ccall((:HYPRE_BoomerAMGSetLevel, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, level)
end

function HYPRE_BoomerAMGSetThreshold(solver, threshold)
    ccall((:HYPRE_BoomerAMGSetThreshold, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, threshold)
end

function HYPRE_BoomerAMGSetFilter(solver, filter)
    ccall((:HYPRE_BoomerAMGSetFilter, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, filter)
end

function HYPRE_BoomerAMGSetDropTol(solver, drop_tol)
    ccall((:HYPRE_BoomerAMGSetDropTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, drop_tol)
end

function HYPRE_BoomerAMGSetMaxNzPerRow(solver, max_nz_per_row)
    ccall((:HYPRE_BoomerAMGSetMaxNzPerRow, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, max_nz_per_row)
end

function HYPRE_BoomerAMGSetEuclidFile(solver, euclidfile)
    ccall((:HYPRE_BoomerAMGSetEuclidFile, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{Cchar}), solver, euclidfile)
end

function HYPRE_BoomerAMGSetEuLevel(solver, eu_level)
    ccall((:HYPRE_BoomerAMGSetEuLevel, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, eu_level)
end

function HYPRE_BoomerAMGSetEuSparseA(solver, eu_sparse_A)
    ccall((:HYPRE_BoomerAMGSetEuSparseA, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, eu_sparse_A)
end

function HYPRE_BoomerAMGSetEuBJ(solver, eu_bj)
    ccall((:HYPRE_BoomerAMGSetEuBJ, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, eu_bj)
end

function HYPRE_BoomerAMGSetILUType(solver, ilu_type)
    ccall((:HYPRE_BoomerAMGSetILUType, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, ilu_type)
end

function HYPRE_BoomerAMGSetILULevel(solver, ilu_lfil)
    ccall((:HYPRE_BoomerAMGSetILULevel, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, ilu_lfil)
end

function HYPRE_BoomerAMGSetILUMaxRowNnz(solver, ilu_max_row_nnz)
    ccall((:HYPRE_BoomerAMGSetILUMaxRowNnz, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, ilu_max_row_nnz)
end

function HYPRE_BoomerAMGSetILUMaxIter(solver, ilu_max_iter)
    ccall((:HYPRE_BoomerAMGSetILUMaxIter, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, ilu_max_iter)
end

function HYPRE_BoomerAMGSetILUDroptol(solver, ilu_droptol)
    ccall((:HYPRE_BoomerAMGSetILUDroptol, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, ilu_droptol)
end

function HYPRE_BoomerAMGSetRestriction(solver, restr_par)
    ccall((:HYPRE_BoomerAMGSetRestriction, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, restr_par)
end

function HYPRE_BoomerAMGSetIsTriangular(solver, is_triangular)
    ccall((:HYPRE_BoomerAMGSetIsTriangular, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, is_triangular)
end

function HYPRE_BoomerAMGSetGMRESSwitchR(solver, gmres_switch)
    ccall((:HYPRE_BoomerAMGSetGMRESSwitchR, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, gmres_switch)
end

function HYPRE_BoomerAMGSetADropTol(solver, A_drop_tol)
    ccall((:HYPRE_BoomerAMGSetADropTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, A_drop_tol)
end

function HYPRE_BoomerAMGSetADropType(solver, A_drop_type)
    ccall((:HYPRE_BoomerAMGSetADropType, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, A_drop_type)
end

function HYPRE_BoomerAMGSetPrintFileName(solver, print_file_name)
    ccall((:HYPRE_BoomerAMGSetPrintFileName, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{Cchar}), solver, print_file_name)
end

function HYPRE_BoomerAMGSetPrintLevel(solver, print_level)
    ccall((:HYPRE_BoomerAMGSetPrintLevel, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, print_level)
end

function HYPRE_BoomerAMGSetLogging(solver, logging)
    ccall((:HYPRE_BoomerAMGSetLogging, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, logging)
end

function HYPRE_BoomerAMGSetDebugFlag(solver, debug_flag)
    ccall((:HYPRE_BoomerAMGSetDebugFlag, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, debug_flag)
end

function HYPRE_BoomerAMGInitGridRelaxation(num_grid_sweeps_ptr, grid_relax_type_ptr, grid_relax_points_ptr, coarsen_type, relax_weights_ptr, max_levels)
    ccall((:HYPRE_BoomerAMGInitGridRelaxation, libHYPRE), HYPRE_Int, (Ptr{Ptr{HYPRE_Int}}, Ptr{Ptr{HYPRE_Int}}, Ptr{Ptr{Ptr{HYPRE_Int}}}, HYPRE_Int, Ptr{Ptr{HYPRE_Real}}, HYPRE_Int), num_grid_sweeps_ptr, grid_relax_type_ptr, grid_relax_points_ptr, coarsen_type, relax_weights_ptr, max_levels)
end

function HYPRE_BoomerAMGSetRAP2(solver, rap2)
    ccall((:HYPRE_BoomerAMGSetRAP2, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, rap2)
end

function HYPRE_BoomerAMGSetModuleRAP2(solver, mod_rap2)
    ccall((:HYPRE_BoomerAMGSetModuleRAP2, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, mod_rap2)
end

function HYPRE_BoomerAMGSetKeepTranspose(solver, keepTranspose)
    ccall((:HYPRE_BoomerAMGSetKeepTranspose, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, keepTranspose)
end

function HYPRE_BoomerAMGSetPlotGrids(solver, plotgrids)
    ccall((:HYPRE_BoomerAMGSetPlotGrids, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, plotgrids)
end

function HYPRE_BoomerAMGSetPlotFileName(solver, plotfilename)
    ccall((:HYPRE_BoomerAMGSetPlotFileName, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{Cchar}), solver, plotfilename)
end

function HYPRE_BoomerAMGSetCoordDim(solver, coorddim)
    ccall((:HYPRE_BoomerAMGSetCoordDim, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, coorddim)
end

function HYPRE_BoomerAMGSetCoordinates(solver, coordinates)
    ccall((:HYPRE_BoomerAMGSetCoordinates, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{Cfloat}), solver, coordinates)
end

function HYPRE_BoomerAMGGetGridHierarchy(solver, cgrid)
    ccall((:HYPRE_BoomerAMGGetGridHierarchy, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, cgrid)
end

function HYPRE_BoomerAMGSetCPoints(solver, cpt_coarse_level, num_cpt_coarse, cpt_coarse_index)
    ccall((:HYPRE_BoomerAMGSetCPoints, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int, HYPRE_Int, Ptr{HYPRE_BigInt}), solver, cpt_coarse_level, num_cpt_coarse, cpt_coarse_index)
end

function HYPRE_BoomerAMGSetCpointsToKeep(solver, cpt_coarse_level, num_cpt_coarse, cpt_coarse_index)
    ccall((:HYPRE_BoomerAMGSetCpointsToKeep, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int, HYPRE_Int, Ptr{HYPRE_BigInt}), solver, cpt_coarse_level, num_cpt_coarse, cpt_coarse_index)
end

function HYPRE_BoomerAMGSetFPoints(solver, num_fpt, fpt_index)
    ccall((:HYPRE_BoomerAMGSetFPoints, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int, Ptr{HYPRE_BigInt}), solver, num_fpt, fpt_index)
end

function HYPRE_BoomerAMGSetIsolatedFPoints(solver, num_isolated_fpt, isolated_fpt_index)
    ccall((:HYPRE_BoomerAMGSetIsolatedFPoints, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int, Ptr{HYPRE_BigInt}), solver, num_isolated_fpt, isolated_fpt_index)
end

function HYPRE_BoomerAMGSetSabs(solver, Sabs)
    ccall((:HYPRE_BoomerAMGSetSabs, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, Sabs)
end

function HYPRE_BoomerAMGDDCreate(solver)
    ccall((:HYPRE_BoomerAMGDDCreate, libHYPRE), HYPRE_Int, (Ptr{HYPRE_Solver},), solver)
end

function HYPRE_BoomerAMGDDDestroy(solver)
    ccall((:HYPRE_BoomerAMGDDDestroy, libHYPRE), HYPRE_Int, (HYPRE_Solver,), solver)
end

function HYPRE_BoomerAMGDDSetup(solver, A, b, x)
    ccall((:HYPRE_BoomerAMGDDSetup, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParCSRMatrix, HYPRE_ParVector, HYPRE_ParVector), solver, A, b, x)
end

function HYPRE_BoomerAMGDDSolve(solver, A, b, x)
    ccall((:HYPRE_BoomerAMGDDSolve, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParCSRMatrix, HYPRE_ParVector, HYPRE_ParVector), solver, A, b, x)
end

function HYPRE_BoomerAMGDDSetFACNumRelax(solver, amgdd_fac_num_relax)
    ccall((:HYPRE_BoomerAMGDDSetFACNumRelax, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, amgdd_fac_num_relax)
end

function HYPRE_BoomerAMGDDSetFACNumCycles(solver, amgdd_fac_num_cycles)
    ccall((:HYPRE_BoomerAMGDDSetFACNumCycles, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, amgdd_fac_num_cycles)
end

function HYPRE_BoomerAMGDDSetFACCycleType(solver, amgdd_fac_cycle_type)
    ccall((:HYPRE_BoomerAMGDDSetFACCycleType, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, amgdd_fac_cycle_type)
end

function HYPRE_BoomerAMGDDSetFACRelaxType(solver, amgdd_fac_relax_type)
    ccall((:HYPRE_BoomerAMGDDSetFACRelaxType, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, amgdd_fac_relax_type)
end

function HYPRE_BoomerAMGDDSetFACRelaxWeight(solver, amgdd_fac_relax_weight)
    ccall((:HYPRE_BoomerAMGDDSetFACRelaxWeight, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, amgdd_fac_relax_weight)
end

function HYPRE_BoomerAMGDDSetStartLevel(solver, start_level)
    ccall((:HYPRE_BoomerAMGDDSetStartLevel, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, start_level)
end

function HYPRE_BoomerAMGDDSetPadding(solver, padding)
    ccall((:HYPRE_BoomerAMGDDSetPadding, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, padding)
end

function HYPRE_BoomerAMGDDSetNumGhostLayers(solver, num_ghost_layers)
    ccall((:HYPRE_BoomerAMGDDSetNumGhostLayers, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, num_ghost_layers)
end

function HYPRE_BoomerAMGDDSetUserFACRelaxation(solver, userFACRelaxation)
    ccall((:HYPRE_BoomerAMGDDSetUserFACRelaxation, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{Cvoid}), solver, userFACRelaxation)
end

function HYPRE_BoomerAMGDDGetAMG(solver, amg_solver)
    ccall((:HYPRE_BoomerAMGDDGetAMG, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Solver}), solver, amg_solver)
end

function HYPRE_BoomerAMGDDGetFinalRelativeResidualNorm(solver, rel_resid_norm)
    ccall((:HYPRE_BoomerAMGDDGetFinalRelativeResidualNorm, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Real}), solver, rel_resid_norm)
end

function HYPRE_BoomerAMGDDGetNumIterations(solver, num_iterations)
    ccall((:HYPRE_BoomerAMGDDGetNumIterations, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, num_iterations)
end

function HYPRE_ParaSailsCreate(comm, solver)
    ccall((:HYPRE_ParaSailsCreate, libHYPRE), HYPRE_Int, (MPI_Comm, Ptr{HYPRE_Solver}), comm, solver)
end

function HYPRE_ParaSailsDestroy(solver)
    ccall((:HYPRE_ParaSailsDestroy, libHYPRE), HYPRE_Int, (HYPRE_Solver,), solver)
end

function HYPRE_ParaSailsSetup(solver, A, b, x)
    ccall((:HYPRE_ParaSailsSetup, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParCSRMatrix, HYPRE_ParVector, HYPRE_ParVector), solver, A, b, x)
end

function HYPRE_ParaSailsSolve(solver, A, b, x)
    ccall((:HYPRE_ParaSailsSolve, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParCSRMatrix, HYPRE_ParVector, HYPRE_ParVector), solver, A, b, x)
end

function HYPRE_ParaSailsSetParams(solver, thresh, nlevels)
    ccall((:HYPRE_ParaSailsSetParams, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real, HYPRE_Int), solver, thresh, nlevels)
end

function HYPRE_ParaSailsSetFilter(solver, filter)
    ccall((:HYPRE_ParaSailsSetFilter, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, filter)
end

function HYPRE_ParaSailsSetSym(solver, sym)
    ccall((:HYPRE_ParaSailsSetSym, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, sym)
end

function HYPRE_ParaSailsSetLoadbal(solver, loadbal)
    ccall((:HYPRE_ParaSailsSetLoadbal, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, loadbal)
end

function HYPRE_ParaSailsSetReuse(solver, reuse)
    ccall((:HYPRE_ParaSailsSetReuse, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, reuse)
end

function HYPRE_ParaSailsSetLogging(solver, logging)
    ccall((:HYPRE_ParaSailsSetLogging, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, logging)
end

function HYPRE_ParaSailsBuildIJMatrix(solver, pij_A)
    ccall((:HYPRE_ParaSailsBuildIJMatrix, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_IJMatrix}), solver, pij_A)
end

function HYPRE_ParCSRParaSailsCreate(comm, solver)
    ccall((:HYPRE_ParCSRParaSailsCreate, libHYPRE), HYPRE_Int, (MPI_Comm, Ptr{HYPRE_Solver}), comm, solver)
end

function HYPRE_ParCSRParaSailsDestroy(solver)
    ccall((:HYPRE_ParCSRParaSailsDestroy, libHYPRE), HYPRE_Int, (HYPRE_Solver,), solver)
end

function HYPRE_ParCSRParaSailsSetup(solver, A, b, x)
    ccall((:HYPRE_ParCSRParaSailsSetup, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParCSRMatrix, HYPRE_ParVector, HYPRE_ParVector), solver, A, b, x)
end

function HYPRE_ParCSRParaSailsSolve(solver, A, b, x)
    ccall((:HYPRE_ParCSRParaSailsSolve, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParCSRMatrix, HYPRE_ParVector, HYPRE_ParVector), solver, A, b, x)
end

function HYPRE_ParCSRParaSailsSetParams(solver, thresh, nlevels)
    ccall((:HYPRE_ParCSRParaSailsSetParams, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real, HYPRE_Int), solver, thresh, nlevels)
end

function HYPRE_ParCSRParaSailsSetFilter(solver, filter)
    ccall((:HYPRE_ParCSRParaSailsSetFilter, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, filter)
end

function HYPRE_ParCSRParaSailsSetSym(solver, sym)
    ccall((:HYPRE_ParCSRParaSailsSetSym, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, sym)
end

function HYPRE_ParCSRParaSailsSetLoadbal(solver, loadbal)
    ccall((:HYPRE_ParCSRParaSailsSetLoadbal, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, loadbal)
end

function HYPRE_ParCSRParaSailsSetReuse(solver, reuse)
    ccall((:HYPRE_ParCSRParaSailsSetReuse, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, reuse)
end

function HYPRE_ParCSRParaSailsSetLogging(solver, logging)
    ccall((:HYPRE_ParCSRParaSailsSetLogging, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, logging)
end

function HYPRE_EuclidCreate(comm, solver)
    ccall((:HYPRE_EuclidCreate, libHYPRE), HYPRE_Int, (MPI_Comm, Ptr{HYPRE_Solver}), comm, solver)
end

function HYPRE_EuclidDestroy(solver)
    ccall((:HYPRE_EuclidDestroy, libHYPRE), HYPRE_Int, (HYPRE_Solver,), solver)
end

function HYPRE_EuclidSetup(solver, A, b, x)
    ccall((:HYPRE_EuclidSetup, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParCSRMatrix, HYPRE_ParVector, HYPRE_ParVector), solver, A, b, x)
end

function HYPRE_EuclidSolve(solver, A, b, x)
    ccall((:HYPRE_EuclidSolve, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParCSRMatrix, HYPRE_ParVector, HYPRE_ParVector), solver, A, b, x)
end

function HYPRE_EuclidSetParams(solver, argc, argv)
    ccall((:HYPRE_EuclidSetParams, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int, Ptr{Ptr{Cchar}}), solver, argc, argv)
end

function HYPRE_EuclidSetParamsFromFile(solver, filename)
    ccall((:HYPRE_EuclidSetParamsFromFile, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{Cchar}), solver, filename)
end

function HYPRE_EuclidSetLevel(solver, level)
    ccall((:HYPRE_EuclidSetLevel, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, level)
end

function HYPRE_EuclidSetBJ(solver, bj)
    ccall((:HYPRE_EuclidSetBJ, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, bj)
end

function HYPRE_EuclidSetStats(solver, eu_stats)
    ccall((:HYPRE_EuclidSetStats, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, eu_stats)
end

function HYPRE_EuclidSetMem(solver, eu_mem)
    ccall((:HYPRE_EuclidSetMem, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, eu_mem)
end

function HYPRE_EuclidSetSparseA(solver, sparse_A)
    ccall((:HYPRE_EuclidSetSparseA, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, sparse_A)
end

function HYPRE_EuclidSetRowScale(solver, row_scale)
    ccall((:HYPRE_EuclidSetRowScale, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, row_scale)
end

function HYPRE_EuclidSetILUT(solver, drop_tol)
    ccall((:HYPRE_EuclidSetILUT, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, drop_tol)
end

function HYPRE_ParCSRPilutCreate(comm, solver)
    ccall((:HYPRE_ParCSRPilutCreate, libHYPRE), HYPRE_Int, (MPI_Comm, Ptr{HYPRE_Solver}), comm, solver)
end

function HYPRE_ParCSRPilutDestroy(solver)
    ccall((:HYPRE_ParCSRPilutDestroy, libHYPRE), HYPRE_Int, (HYPRE_Solver,), solver)
end

function HYPRE_ParCSRPilutSetup(solver, A, b, x)
    ccall((:HYPRE_ParCSRPilutSetup, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParCSRMatrix, HYPRE_ParVector, HYPRE_ParVector), solver, A, b, x)
end

function HYPRE_ParCSRPilutSolve(solver, A, b, x)
    ccall((:HYPRE_ParCSRPilutSolve, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParCSRMatrix, HYPRE_ParVector, HYPRE_ParVector), solver, A, b, x)
end

function HYPRE_ParCSRPilutSetMaxIter(solver, max_iter)
    ccall((:HYPRE_ParCSRPilutSetMaxIter, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, max_iter)
end

function HYPRE_ParCSRPilutSetDropTolerance(solver, tol)
    ccall((:HYPRE_ParCSRPilutSetDropTolerance, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, tol)
end

function HYPRE_ParCSRPilutSetFactorRowSize(solver, size)
    ccall((:HYPRE_ParCSRPilutSetFactorRowSize, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, size)
end

function HYPRE_ParCSRPilutSetLogging(solver, logging)
    ccall((:HYPRE_ParCSRPilutSetLogging, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, logging)
end

function HYPRE_AMSCreate(solver)
    ccall((:HYPRE_AMSCreate, libHYPRE), HYPRE_Int, (Ptr{HYPRE_Solver},), solver)
end

function HYPRE_AMSDestroy(solver)
    ccall((:HYPRE_AMSDestroy, libHYPRE), HYPRE_Int, (HYPRE_Solver,), solver)
end

function HYPRE_AMSSetup(solver, A, b, x)
    ccall((:HYPRE_AMSSetup, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParCSRMatrix, HYPRE_ParVector, HYPRE_ParVector), solver, A, b, x)
end

function HYPRE_AMSSolve(solver, A, b, x)
    ccall((:HYPRE_AMSSolve, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParCSRMatrix, HYPRE_ParVector, HYPRE_ParVector), solver, A, b, x)
end

function HYPRE_AMSSetDimension(solver, dim)
    ccall((:HYPRE_AMSSetDimension, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, dim)
end

function HYPRE_AMSSetDiscreteGradient(solver, G)
    ccall((:HYPRE_AMSSetDiscreteGradient, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParCSRMatrix), solver, G)
end

function HYPRE_AMSSetCoordinateVectors(solver, x, y, z)
    ccall((:HYPRE_AMSSetCoordinateVectors, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParVector, HYPRE_ParVector, HYPRE_ParVector), solver, x, y, z)
end

function HYPRE_AMSSetEdgeConstantVectors(solver, Gx, Gy, Gz)
    ccall((:HYPRE_AMSSetEdgeConstantVectors, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParVector, HYPRE_ParVector, HYPRE_ParVector), solver, Gx, Gy, Gz)
end

function HYPRE_AMSSetInterpolations(solver, Pi, Pix, Piy, Piz)
    ccall((:HYPRE_AMSSetInterpolations, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParCSRMatrix, HYPRE_ParCSRMatrix, HYPRE_ParCSRMatrix, HYPRE_ParCSRMatrix), solver, Pi, Pix, Piy, Piz)
end

function HYPRE_AMSSetAlphaPoissonMatrix(solver, A_alpha)
    ccall((:HYPRE_AMSSetAlphaPoissonMatrix, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParCSRMatrix), solver, A_alpha)
end

function HYPRE_AMSSetBetaPoissonMatrix(solver, A_beta)
    ccall((:HYPRE_AMSSetBetaPoissonMatrix, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParCSRMatrix), solver, A_beta)
end

function HYPRE_AMSSetInteriorNodes(solver, interior_nodes)
    ccall((:HYPRE_AMSSetInteriorNodes, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParVector), solver, interior_nodes)
end

function HYPRE_AMSSetProjectionFrequency(solver, projection_frequency)
    ccall((:HYPRE_AMSSetProjectionFrequency, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, projection_frequency)
end

function HYPRE_AMSSetMaxIter(solver, maxit)
    ccall((:HYPRE_AMSSetMaxIter, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, maxit)
end

function HYPRE_AMSSetTol(solver, tol)
    ccall((:HYPRE_AMSSetTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, tol)
end

function HYPRE_AMSSetCycleType(solver, cycle_type)
    ccall((:HYPRE_AMSSetCycleType, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, cycle_type)
end

function HYPRE_AMSSetPrintLevel(solver, print_level)
    ccall((:HYPRE_AMSSetPrintLevel, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, print_level)
end

function HYPRE_AMSSetSmoothingOptions(solver, relax_type, relax_times, relax_weight, omega)
    ccall((:HYPRE_AMSSetSmoothingOptions, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int, HYPRE_Int, HYPRE_Real, HYPRE_Real), solver, relax_type, relax_times, relax_weight, omega)
end

function HYPRE_AMSSetAlphaAMGOptions(solver, alpha_coarsen_type, alpha_agg_levels, alpha_relax_type, alpha_strength_threshold, alpha_interp_type, alpha_Pmax)
    ccall((:HYPRE_AMSSetAlphaAMGOptions, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int, HYPRE_Int, HYPRE_Int, HYPRE_Real, HYPRE_Int, HYPRE_Int), solver, alpha_coarsen_type, alpha_agg_levels, alpha_relax_type, alpha_strength_threshold, alpha_interp_type, alpha_Pmax)
end

function HYPRE_AMSSetAlphaAMGCoarseRelaxType(solver, alpha_coarse_relax_type)
    ccall((:HYPRE_AMSSetAlphaAMGCoarseRelaxType, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, alpha_coarse_relax_type)
end

function HYPRE_AMSSetBetaAMGOptions(solver, beta_coarsen_type, beta_agg_levels, beta_relax_type, beta_strength_threshold, beta_interp_type, beta_Pmax)
    ccall((:HYPRE_AMSSetBetaAMGOptions, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int, HYPRE_Int, HYPRE_Int, HYPRE_Real, HYPRE_Int, HYPRE_Int), solver, beta_coarsen_type, beta_agg_levels, beta_relax_type, beta_strength_threshold, beta_interp_type, beta_Pmax)
end

function HYPRE_AMSSetBetaAMGCoarseRelaxType(solver, beta_coarse_relax_type)
    ccall((:HYPRE_AMSSetBetaAMGCoarseRelaxType, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, beta_coarse_relax_type)
end

function HYPRE_AMSGetNumIterations(solver, num_iterations)
    ccall((:HYPRE_AMSGetNumIterations, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, num_iterations)
end

function HYPRE_AMSGetFinalRelativeResidualNorm(solver, rel_resid_norm)
    ccall((:HYPRE_AMSGetFinalRelativeResidualNorm, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Real}), solver, rel_resid_norm)
end

function HYPRE_AMSProjectOutGradients(solver, x)
    ccall((:HYPRE_AMSProjectOutGradients, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParVector), solver, x)
end

function HYPRE_AMSConstructDiscreteGradient(A, x_coord, edge_vertex, edge_orientation, G)
    ccall((:HYPRE_AMSConstructDiscreteGradient, libHYPRE), HYPRE_Int, (HYPRE_ParCSRMatrix, HYPRE_ParVector, Ptr{HYPRE_BigInt}, HYPRE_Int, Ptr{HYPRE_ParCSRMatrix}), A, x_coord, edge_vertex, edge_orientation, G)
end

function HYPRE_ADSCreate(solver)
    ccall((:HYPRE_ADSCreate, libHYPRE), HYPRE_Int, (Ptr{HYPRE_Solver},), solver)
end

function HYPRE_ADSDestroy(solver)
    ccall((:HYPRE_ADSDestroy, libHYPRE), HYPRE_Int, (HYPRE_Solver,), solver)
end

function HYPRE_ADSSetup(solver, A, b, x)
    ccall((:HYPRE_ADSSetup, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParCSRMatrix, HYPRE_ParVector, HYPRE_ParVector), solver, A, b, x)
end

function HYPRE_ADSSolve(solver, A, b, x)
    ccall((:HYPRE_ADSSolve, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParCSRMatrix, HYPRE_ParVector, HYPRE_ParVector), solver, A, b, x)
end

function HYPRE_ADSSetDiscreteCurl(solver, C)
    ccall((:HYPRE_ADSSetDiscreteCurl, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParCSRMatrix), solver, C)
end

function HYPRE_ADSSetDiscreteGradient(solver, G)
    ccall((:HYPRE_ADSSetDiscreteGradient, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParCSRMatrix), solver, G)
end

function HYPRE_ADSSetCoordinateVectors(solver, x, y, z)
    ccall((:HYPRE_ADSSetCoordinateVectors, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParVector, HYPRE_ParVector, HYPRE_ParVector), solver, x, y, z)
end

function HYPRE_ADSSetInterpolations(solver, RT_Pi, RT_Pix, RT_Piy, RT_Piz, ND_Pi, ND_Pix, ND_Piy, ND_Piz)
    ccall((:HYPRE_ADSSetInterpolations, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParCSRMatrix, HYPRE_ParCSRMatrix, HYPRE_ParCSRMatrix, HYPRE_ParCSRMatrix, HYPRE_ParCSRMatrix, HYPRE_ParCSRMatrix, HYPRE_ParCSRMatrix, HYPRE_ParCSRMatrix), solver, RT_Pi, RT_Pix, RT_Piy, RT_Piz, ND_Pi, ND_Pix, ND_Piy, ND_Piz)
end

function HYPRE_ADSSetMaxIter(solver, maxit)
    ccall((:HYPRE_ADSSetMaxIter, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, maxit)
end

function HYPRE_ADSSetTol(solver, tol)
    ccall((:HYPRE_ADSSetTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, tol)
end

function HYPRE_ADSSetCycleType(solver, cycle_type)
    ccall((:HYPRE_ADSSetCycleType, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, cycle_type)
end

function HYPRE_ADSSetPrintLevel(solver, print_level)
    ccall((:HYPRE_ADSSetPrintLevel, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, print_level)
end

function HYPRE_ADSSetSmoothingOptions(solver, relax_type, relax_times, relax_weight, omega)
    ccall((:HYPRE_ADSSetSmoothingOptions, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int, HYPRE_Int, HYPRE_Real, HYPRE_Real), solver, relax_type, relax_times, relax_weight, omega)
end

function HYPRE_ADSSetChebySmoothingOptions(solver, cheby_order, cheby_fraction)
    ccall((:HYPRE_ADSSetChebySmoothingOptions, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int, HYPRE_Int), solver, cheby_order, cheby_fraction)
end

function HYPRE_ADSSetAMSOptions(solver, cycle_type, coarsen_type, agg_levels, relax_type, strength_threshold, interp_type, Pmax)
    ccall((:HYPRE_ADSSetAMSOptions, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int, HYPRE_Int, HYPRE_Int, HYPRE_Int, HYPRE_Real, HYPRE_Int, HYPRE_Int), solver, cycle_type, coarsen_type, agg_levels, relax_type, strength_threshold, interp_type, Pmax)
end

function HYPRE_ADSSetAMGOptions(solver, coarsen_type, agg_levels, relax_type, strength_threshold, interp_type, Pmax)
    ccall((:HYPRE_ADSSetAMGOptions, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int, HYPRE_Int, HYPRE_Int, HYPRE_Real, HYPRE_Int, HYPRE_Int), solver, coarsen_type, agg_levels, relax_type, strength_threshold, interp_type, Pmax)
end

function HYPRE_ADSGetNumIterations(solver, num_iterations)
    ccall((:HYPRE_ADSGetNumIterations, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, num_iterations)
end

function HYPRE_ADSGetFinalRelativeResidualNorm(solver, rel_resid_norm)
    ccall((:HYPRE_ADSGetFinalRelativeResidualNorm, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Real}), solver, rel_resid_norm)
end

function HYPRE_ParCSRPCGCreate(comm, solver)
    ccall((:HYPRE_ParCSRPCGCreate, libHYPRE), HYPRE_Int, (MPI_Comm, Ptr{HYPRE_Solver}), comm, solver)
end

function HYPRE_ParCSRPCGDestroy(solver)
    ccall((:HYPRE_ParCSRPCGDestroy, libHYPRE), HYPRE_Int, (HYPRE_Solver,), solver)
end

function HYPRE_ParCSRPCGSetup(solver, A, b, x)
    ccall((:HYPRE_ParCSRPCGSetup, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParCSRMatrix, HYPRE_ParVector, HYPRE_ParVector), solver, A, b, x)
end

function HYPRE_ParCSRPCGSolve(solver, A, b, x)
    ccall((:HYPRE_ParCSRPCGSolve, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParCSRMatrix, HYPRE_ParVector, HYPRE_ParVector), solver, A, b, x)
end

function HYPRE_ParCSRPCGSetTol(solver, tol)
    ccall((:HYPRE_ParCSRPCGSetTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, tol)
end

function HYPRE_ParCSRPCGSetAbsoluteTol(solver, tol)
    ccall((:HYPRE_ParCSRPCGSetAbsoluteTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, tol)
end

function HYPRE_ParCSRPCGSetMaxIter(solver, max_iter)
    ccall((:HYPRE_ParCSRPCGSetMaxIter, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, max_iter)
end

function HYPRE_ParCSRPCGSetStopCrit(solver, stop_crit)
    ccall((:HYPRE_ParCSRPCGSetStopCrit, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, stop_crit)
end

function HYPRE_ParCSRPCGSetTwoNorm(solver, two_norm)
    ccall((:HYPRE_ParCSRPCGSetTwoNorm, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, two_norm)
end

function HYPRE_ParCSRPCGSetRelChange(solver, rel_change)
    ccall((:HYPRE_ParCSRPCGSetRelChange, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, rel_change)
end

function HYPRE_ParCSRPCGSetPrecond(solver, precond, precond_setup, precond_solver)
    ccall((:HYPRE_ParCSRPCGSetPrecond, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_PtrToParSolverFcn, HYPRE_PtrToParSolverFcn, HYPRE_Solver), solver, precond, precond_setup, precond_solver)
end

function HYPRE_ParCSRPCGGetPrecond(solver, precond_data)
    ccall((:HYPRE_ParCSRPCGGetPrecond, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Solver}), solver, precond_data)
end

function HYPRE_ParCSRPCGSetLogging(solver, logging)
    ccall((:HYPRE_ParCSRPCGSetLogging, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, logging)
end

function HYPRE_ParCSRPCGSetPrintLevel(solver, print_level)
    ccall((:HYPRE_ParCSRPCGSetPrintLevel, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, print_level)
end

function HYPRE_ParCSRPCGGetNumIterations(solver, num_iterations)
    ccall((:HYPRE_ParCSRPCGGetNumIterations, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, num_iterations)
end

function HYPRE_ParCSRPCGGetFinalRelativeResidualNorm(solver, norm)
    ccall((:HYPRE_ParCSRPCGGetFinalRelativeResidualNorm, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Real}), solver, norm)
end

function HYPRE_ParCSRPCGGetResidual(solver, residual)
    ccall((:HYPRE_ParCSRPCGGetResidual, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_ParVector}), solver, residual)
end

function HYPRE_ParCSRDiagScaleSetup(solver, A, y, x)
    ccall((:HYPRE_ParCSRDiagScaleSetup, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParCSRMatrix, HYPRE_ParVector, HYPRE_ParVector), solver, A, y, x)
end

function HYPRE_ParCSRDiagScale(solver, HA, Hy, Hx)
    ccall((:HYPRE_ParCSRDiagScale, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParCSRMatrix, HYPRE_ParVector, HYPRE_ParVector), solver, HA, Hy, Hx)
end

function HYPRE_ParCSROnProcTriSetup(solver, HA, Hy, Hx)
    ccall((:HYPRE_ParCSROnProcTriSetup, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParCSRMatrix, HYPRE_ParVector, HYPRE_ParVector), solver, HA, Hy, Hx)
end

function HYPRE_ParCSROnProcTriSolve(solver, HA, Hy, Hx)
    ccall((:HYPRE_ParCSROnProcTriSolve, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParCSRMatrix, HYPRE_ParVector, HYPRE_ParVector), solver, HA, Hy, Hx)
end

function HYPRE_ParCSRGMRESCreate(comm, solver)
    ccall((:HYPRE_ParCSRGMRESCreate, libHYPRE), HYPRE_Int, (MPI_Comm, Ptr{HYPRE_Solver}), comm, solver)
end

function HYPRE_ParCSRGMRESDestroy(solver)
    ccall((:HYPRE_ParCSRGMRESDestroy, libHYPRE), HYPRE_Int, (HYPRE_Solver,), solver)
end

function HYPRE_ParCSRGMRESSetup(solver, A, b, x)
    ccall((:HYPRE_ParCSRGMRESSetup, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParCSRMatrix, HYPRE_ParVector, HYPRE_ParVector), solver, A, b, x)
end

function HYPRE_ParCSRGMRESSolve(solver, A, b, x)
    ccall((:HYPRE_ParCSRGMRESSolve, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParCSRMatrix, HYPRE_ParVector, HYPRE_ParVector), solver, A, b, x)
end

function HYPRE_ParCSRGMRESSetKDim(solver, k_dim)
    ccall((:HYPRE_ParCSRGMRESSetKDim, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, k_dim)
end

function HYPRE_ParCSRGMRESSetTol(solver, tol)
    ccall((:HYPRE_ParCSRGMRESSetTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, tol)
end

function HYPRE_ParCSRGMRESSetAbsoluteTol(solver, a_tol)
    ccall((:HYPRE_ParCSRGMRESSetAbsoluteTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, a_tol)
end

function HYPRE_ParCSRGMRESSetMinIter(solver, min_iter)
    ccall((:HYPRE_ParCSRGMRESSetMinIter, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, min_iter)
end

function HYPRE_ParCSRGMRESSetMaxIter(solver, max_iter)
    ccall((:HYPRE_ParCSRGMRESSetMaxIter, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, max_iter)
end

function HYPRE_ParCSRGMRESSetStopCrit(solver, stop_crit)
    ccall((:HYPRE_ParCSRGMRESSetStopCrit, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, stop_crit)
end

function HYPRE_ParCSRGMRESSetPrecond(solver, precond, precond_setup, precond_solver)
    ccall((:HYPRE_ParCSRGMRESSetPrecond, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_PtrToParSolverFcn, HYPRE_PtrToParSolverFcn, HYPRE_Solver), solver, precond, precond_setup, precond_solver)
end

function HYPRE_ParCSRGMRESGetPrecond(solver, precond_data)
    ccall((:HYPRE_ParCSRGMRESGetPrecond, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Solver}), solver, precond_data)
end

function HYPRE_ParCSRGMRESSetLogging(solver, logging)
    ccall((:HYPRE_ParCSRGMRESSetLogging, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, logging)
end

function HYPRE_ParCSRGMRESSetPrintLevel(solver, print_level)
    ccall((:HYPRE_ParCSRGMRESSetPrintLevel, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, print_level)
end

function HYPRE_ParCSRGMRESGetNumIterations(solver, num_iterations)
    ccall((:HYPRE_ParCSRGMRESGetNumIterations, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, num_iterations)
end

function HYPRE_ParCSRGMRESGetFinalRelativeResidualNorm(solver, norm)
    ccall((:HYPRE_ParCSRGMRESGetFinalRelativeResidualNorm, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Real}), solver, norm)
end

function HYPRE_ParCSRGMRESGetResidual(solver, residual)
    ccall((:HYPRE_ParCSRGMRESGetResidual, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_ParVector}), solver, residual)
end

function HYPRE_ParCSRCOGMRESCreate(comm, solver)
    ccall((:HYPRE_ParCSRCOGMRESCreate, libHYPRE), HYPRE_Int, (MPI_Comm, Ptr{HYPRE_Solver}), comm, solver)
end

function HYPRE_ParCSRCOGMRESDestroy(solver)
    ccall((:HYPRE_ParCSRCOGMRESDestroy, libHYPRE), HYPRE_Int, (HYPRE_Solver,), solver)
end

function HYPRE_ParCSRCOGMRESSetup(solver, A, b, x)
    ccall((:HYPRE_ParCSRCOGMRESSetup, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParCSRMatrix, HYPRE_ParVector, HYPRE_ParVector), solver, A, b, x)
end

function HYPRE_ParCSRCOGMRESSolve(solver, A, b, x)
    ccall((:HYPRE_ParCSRCOGMRESSolve, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParCSRMatrix, HYPRE_ParVector, HYPRE_ParVector), solver, A, b, x)
end

function HYPRE_ParCSRCOGMRESSetKDim(solver, k_dim)
    ccall((:HYPRE_ParCSRCOGMRESSetKDim, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, k_dim)
end

function HYPRE_ParCSRCOGMRESSetUnroll(solver, unroll)
    ccall((:HYPRE_ParCSRCOGMRESSetUnroll, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, unroll)
end

function HYPRE_ParCSRCOGMRESSetCGS(solver, cgs)
    ccall((:HYPRE_ParCSRCOGMRESSetCGS, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, cgs)
end

function HYPRE_ParCSRCOGMRESSetTol(solver, tol)
    ccall((:HYPRE_ParCSRCOGMRESSetTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, tol)
end

function HYPRE_ParCSRCOGMRESSetAbsoluteTol(solver, a_tol)
    ccall((:HYPRE_ParCSRCOGMRESSetAbsoluteTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, a_tol)
end

function HYPRE_ParCSRCOGMRESSetMinIter(solver, min_iter)
    ccall((:HYPRE_ParCSRCOGMRESSetMinIter, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, min_iter)
end

function HYPRE_ParCSRCOGMRESSetMaxIter(solver, max_iter)
    ccall((:HYPRE_ParCSRCOGMRESSetMaxIter, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, max_iter)
end

function HYPRE_ParCSRCOGMRESSetPrecond(solver, precond, precond_setup, precond_solver)
    ccall((:HYPRE_ParCSRCOGMRESSetPrecond, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_PtrToParSolverFcn, HYPRE_PtrToParSolverFcn, HYPRE_Solver), solver, precond, precond_setup, precond_solver)
end

function HYPRE_ParCSRCOGMRESGetPrecond(solver, precond_data)
    ccall((:HYPRE_ParCSRCOGMRESGetPrecond, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Solver}), solver, precond_data)
end

function HYPRE_ParCSRCOGMRESSetLogging(solver, logging)
    ccall((:HYPRE_ParCSRCOGMRESSetLogging, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, logging)
end

function HYPRE_ParCSRCOGMRESSetPrintLevel(solver, print_level)
    ccall((:HYPRE_ParCSRCOGMRESSetPrintLevel, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, print_level)
end

function HYPRE_ParCSRCOGMRESGetNumIterations(solver, num_iterations)
    ccall((:HYPRE_ParCSRCOGMRESGetNumIterations, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, num_iterations)
end

function HYPRE_ParCSRCOGMRESGetFinalRelativeResidualNorm(solver, norm)
    ccall((:HYPRE_ParCSRCOGMRESGetFinalRelativeResidualNorm, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Real}), solver, norm)
end

function HYPRE_ParCSRCOGMRESGetResidual(solver, residual)
    ccall((:HYPRE_ParCSRCOGMRESGetResidual, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_ParVector}), solver, residual)
end

function HYPRE_ParCSRFlexGMRESCreate(comm, solver)
    ccall((:HYPRE_ParCSRFlexGMRESCreate, libHYPRE), HYPRE_Int, (MPI_Comm, Ptr{HYPRE_Solver}), comm, solver)
end

function HYPRE_ParCSRFlexGMRESDestroy(solver)
    ccall((:HYPRE_ParCSRFlexGMRESDestroy, libHYPRE), HYPRE_Int, (HYPRE_Solver,), solver)
end

function HYPRE_ParCSRFlexGMRESSetup(solver, A, b, x)
    ccall((:HYPRE_ParCSRFlexGMRESSetup, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParCSRMatrix, HYPRE_ParVector, HYPRE_ParVector), solver, A, b, x)
end

function HYPRE_ParCSRFlexGMRESSolve(solver, A, b, x)
    ccall((:HYPRE_ParCSRFlexGMRESSolve, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParCSRMatrix, HYPRE_ParVector, HYPRE_ParVector), solver, A, b, x)
end

function HYPRE_ParCSRFlexGMRESSetKDim(solver, k_dim)
    ccall((:HYPRE_ParCSRFlexGMRESSetKDim, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, k_dim)
end

function HYPRE_ParCSRFlexGMRESSetTol(solver, tol)
    ccall((:HYPRE_ParCSRFlexGMRESSetTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, tol)
end

function HYPRE_ParCSRFlexGMRESSetAbsoluteTol(solver, a_tol)
    ccall((:HYPRE_ParCSRFlexGMRESSetAbsoluteTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, a_tol)
end

function HYPRE_ParCSRFlexGMRESSetMinIter(solver, min_iter)
    ccall((:HYPRE_ParCSRFlexGMRESSetMinIter, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, min_iter)
end

function HYPRE_ParCSRFlexGMRESSetMaxIter(solver, max_iter)
    ccall((:HYPRE_ParCSRFlexGMRESSetMaxIter, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, max_iter)
end

function HYPRE_ParCSRFlexGMRESSetPrecond(solver, precond, precond_setup, precond_solver)
    ccall((:HYPRE_ParCSRFlexGMRESSetPrecond, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_PtrToParSolverFcn, HYPRE_PtrToParSolverFcn, HYPRE_Solver), solver, precond, precond_setup, precond_solver)
end

function HYPRE_ParCSRFlexGMRESGetPrecond(solver, precond_data)
    ccall((:HYPRE_ParCSRFlexGMRESGetPrecond, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Solver}), solver, precond_data)
end

function HYPRE_ParCSRFlexGMRESSetLogging(solver, logging)
    ccall((:HYPRE_ParCSRFlexGMRESSetLogging, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, logging)
end

function HYPRE_ParCSRFlexGMRESSetPrintLevel(solver, print_level)
    ccall((:HYPRE_ParCSRFlexGMRESSetPrintLevel, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, print_level)
end

function HYPRE_ParCSRFlexGMRESGetNumIterations(solver, num_iterations)
    ccall((:HYPRE_ParCSRFlexGMRESGetNumIterations, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, num_iterations)
end

function HYPRE_ParCSRFlexGMRESGetFinalRelativeResidualNorm(solver, norm)
    ccall((:HYPRE_ParCSRFlexGMRESGetFinalRelativeResidualNorm, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Real}), solver, norm)
end

function HYPRE_ParCSRFlexGMRESGetResidual(solver, residual)
    ccall((:HYPRE_ParCSRFlexGMRESGetResidual, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_ParVector}), solver, residual)
end

function HYPRE_ParCSRFlexGMRESSetModifyPC(solver, modify_pc)
    ccall((:HYPRE_ParCSRFlexGMRESSetModifyPC, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_PtrToModifyPCFcn), solver, modify_pc)
end

function HYPRE_ParCSRLGMRESCreate(comm, solver)
    ccall((:HYPRE_ParCSRLGMRESCreate, libHYPRE), HYPRE_Int, (MPI_Comm, Ptr{HYPRE_Solver}), comm, solver)
end

function HYPRE_ParCSRLGMRESDestroy(solver)
    ccall((:HYPRE_ParCSRLGMRESDestroy, libHYPRE), HYPRE_Int, (HYPRE_Solver,), solver)
end

function HYPRE_ParCSRLGMRESSetup(solver, A, b, x)
    ccall((:HYPRE_ParCSRLGMRESSetup, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParCSRMatrix, HYPRE_ParVector, HYPRE_ParVector), solver, A, b, x)
end

function HYPRE_ParCSRLGMRESSolve(solver, A, b, x)
    ccall((:HYPRE_ParCSRLGMRESSolve, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParCSRMatrix, HYPRE_ParVector, HYPRE_ParVector), solver, A, b, x)
end

function HYPRE_ParCSRLGMRESSetKDim(solver, k_dim)
    ccall((:HYPRE_ParCSRLGMRESSetKDim, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, k_dim)
end

function HYPRE_ParCSRLGMRESSetAugDim(solver, aug_dim)
    ccall((:HYPRE_ParCSRLGMRESSetAugDim, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, aug_dim)
end

function HYPRE_ParCSRLGMRESSetTol(solver, tol)
    ccall((:HYPRE_ParCSRLGMRESSetTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, tol)
end

function HYPRE_ParCSRLGMRESSetAbsoluteTol(solver, a_tol)
    ccall((:HYPRE_ParCSRLGMRESSetAbsoluteTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, a_tol)
end

function HYPRE_ParCSRLGMRESSetMinIter(solver, min_iter)
    ccall((:HYPRE_ParCSRLGMRESSetMinIter, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, min_iter)
end

function HYPRE_ParCSRLGMRESSetMaxIter(solver, max_iter)
    ccall((:HYPRE_ParCSRLGMRESSetMaxIter, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, max_iter)
end

function HYPRE_ParCSRLGMRESSetPrecond(solver, precond, precond_setup, precond_solver)
    ccall((:HYPRE_ParCSRLGMRESSetPrecond, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_PtrToParSolverFcn, HYPRE_PtrToParSolverFcn, HYPRE_Solver), solver, precond, precond_setup, precond_solver)
end

function HYPRE_ParCSRLGMRESGetPrecond(solver, precond_data)
    ccall((:HYPRE_ParCSRLGMRESGetPrecond, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Solver}), solver, precond_data)
end

function HYPRE_ParCSRLGMRESSetLogging(solver, logging)
    ccall((:HYPRE_ParCSRLGMRESSetLogging, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, logging)
end

function HYPRE_ParCSRLGMRESSetPrintLevel(solver, print_level)
    ccall((:HYPRE_ParCSRLGMRESSetPrintLevel, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, print_level)
end

function HYPRE_ParCSRLGMRESGetNumIterations(solver, num_iterations)
    ccall((:HYPRE_ParCSRLGMRESGetNumIterations, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, num_iterations)
end

function HYPRE_ParCSRLGMRESGetFinalRelativeResidualNorm(solver, norm)
    ccall((:HYPRE_ParCSRLGMRESGetFinalRelativeResidualNorm, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Real}), solver, norm)
end

function HYPRE_ParCSRLGMRESGetResidual(solver, residual)
    ccall((:HYPRE_ParCSRLGMRESGetResidual, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_ParVector}), solver, residual)
end

function HYPRE_ParCSRBiCGSTABCreate(comm, solver)
    ccall((:HYPRE_ParCSRBiCGSTABCreate, libHYPRE), HYPRE_Int, (MPI_Comm, Ptr{HYPRE_Solver}), comm, solver)
end

function HYPRE_ParCSRBiCGSTABDestroy(solver)
    ccall((:HYPRE_ParCSRBiCGSTABDestroy, libHYPRE), HYPRE_Int, (HYPRE_Solver,), solver)
end

function HYPRE_ParCSRBiCGSTABSetup(solver, A, b, x)
    ccall((:HYPRE_ParCSRBiCGSTABSetup, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParCSRMatrix, HYPRE_ParVector, HYPRE_ParVector), solver, A, b, x)
end

function HYPRE_ParCSRBiCGSTABSolve(solver, A, b, x)
    ccall((:HYPRE_ParCSRBiCGSTABSolve, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParCSRMatrix, HYPRE_ParVector, HYPRE_ParVector), solver, A, b, x)
end

function HYPRE_ParCSRBiCGSTABSetTol(solver, tol)
    ccall((:HYPRE_ParCSRBiCGSTABSetTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, tol)
end

function HYPRE_ParCSRBiCGSTABSetAbsoluteTol(solver, a_tol)
    ccall((:HYPRE_ParCSRBiCGSTABSetAbsoluteTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, a_tol)
end

function HYPRE_ParCSRBiCGSTABSetMinIter(solver, min_iter)
    ccall((:HYPRE_ParCSRBiCGSTABSetMinIter, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, min_iter)
end

function HYPRE_ParCSRBiCGSTABSetMaxIter(solver, max_iter)
    ccall((:HYPRE_ParCSRBiCGSTABSetMaxIter, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, max_iter)
end

function HYPRE_ParCSRBiCGSTABSetStopCrit(solver, stop_crit)
    ccall((:HYPRE_ParCSRBiCGSTABSetStopCrit, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, stop_crit)
end

function HYPRE_ParCSRBiCGSTABSetPrecond(solver, precond, precond_setup, precond_solver)
    ccall((:HYPRE_ParCSRBiCGSTABSetPrecond, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_PtrToParSolverFcn, HYPRE_PtrToParSolverFcn, HYPRE_Solver), solver, precond, precond_setup, precond_solver)
end

function HYPRE_ParCSRBiCGSTABGetPrecond(solver, precond_data)
    ccall((:HYPRE_ParCSRBiCGSTABGetPrecond, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Solver}), solver, precond_data)
end

function HYPRE_ParCSRBiCGSTABSetLogging(solver, logging)
    ccall((:HYPRE_ParCSRBiCGSTABSetLogging, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, logging)
end

function HYPRE_ParCSRBiCGSTABSetPrintLevel(solver, print_level)
    ccall((:HYPRE_ParCSRBiCGSTABSetPrintLevel, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, print_level)
end

function HYPRE_ParCSRBiCGSTABGetNumIterations(solver, num_iterations)
    ccall((:HYPRE_ParCSRBiCGSTABGetNumIterations, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, num_iterations)
end

function HYPRE_ParCSRBiCGSTABGetFinalRelativeResidualNorm(solver, norm)
    ccall((:HYPRE_ParCSRBiCGSTABGetFinalRelativeResidualNorm, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Real}), solver, norm)
end

function HYPRE_ParCSRBiCGSTABGetResidual(solver, residual)
    ccall((:HYPRE_ParCSRBiCGSTABGetResidual, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_ParVector}), solver, residual)
end

function HYPRE_ParCSRHybridCreate(solver)
    ccall((:HYPRE_ParCSRHybridCreate, libHYPRE), HYPRE_Int, (Ptr{HYPRE_Solver},), solver)
end

function HYPRE_ParCSRHybridDestroy(solver)
    ccall((:HYPRE_ParCSRHybridDestroy, libHYPRE), HYPRE_Int, (HYPRE_Solver,), solver)
end

function HYPRE_ParCSRHybridSetup(solver, A, b, x)
    ccall((:HYPRE_ParCSRHybridSetup, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParCSRMatrix, HYPRE_ParVector, HYPRE_ParVector), solver, A, b, x)
end

function HYPRE_ParCSRHybridSolve(solver, A, b, x)
    ccall((:HYPRE_ParCSRHybridSolve, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParCSRMatrix, HYPRE_ParVector, HYPRE_ParVector), solver, A, b, x)
end

function HYPRE_ParCSRHybridSetTol(solver, tol)
    ccall((:HYPRE_ParCSRHybridSetTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, tol)
end

function HYPRE_ParCSRHybridSetAbsoluteTol(solver, tol)
    ccall((:HYPRE_ParCSRHybridSetAbsoluteTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, tol)
end

function HYPRE_ParCSRHybridSetConvergenceTol(solver, cf_tol)
    ccall((:HYPRE_ParCSRHybridSetConvergenceTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, cf_tol)
end

function HYPRE_ParCSRHybridSetDSCGMaxIter(solver, dscg_max_its)
    ccall((:HYPRE_ParCSRHybridSetDSCGMaxIter, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, dscg_max_its)
end

function HYPRE_ParCSRHybridSetPCGMaxIter(solver, pcg_max_its)
    ccall((:HYPRE_ParCSRHybridSetPCGMaxIter, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, pcg_max_its)
end

function HYPRE_ParCSRHybridSetSetupType(solver, setup_type)
    ccall((:HYPRE_ParCSRHybridSetSetupType, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, setup_type)
end

function HYPRE_ParCSRHybridSetSolverType(solver, solver_type)
    ccall((:HYPRE_ParCSRHybridSetSolverType, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, solver_type)
end

function HYPRE_ParCSRHybridSetRecomputeResidual(solver, recompute_residual)
    ccall((:HYPRE_ParCSRHybridSetRecomputeResidual, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, recompute_residual)
end

function HYPRE_ParCSRHybridGetRecomputeResidual(solver, recompute_residual)
    ccall((:HYPRE_ParCSRHybridGetRecomputeResidual, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, recompute_residual)
end

function HYPRE_ParCSRHybridSetRecomputeResidualP(solver, recompute_residual_p)
    ccall((:HYPRE_ParCSRHybridSetRecomputeResidualP, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, recompute_residual_p)
end

function HYPRE_ParCSRHybridGetRecomputeResidualP(solver, recompute_residual_p)
    ccall((:HYPRE_ParCSRHybridGetRecomputeResidualP, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, recompute_residual_p)
end

function HYPRE_ParCSRHybridSetKDim(solver, k_dim)
    ccall((:HYPRE_ParCSRHybridSetKDim, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, k_dim)
end

function HYPRE_ParCSRHybridSetTwoNorm(solver, two_norm)
    ccall((:HYPRE_ParCSRHybridSetTwoNorm, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, two_norm)
end

function HYPRE_ParCSRHybridSetStopCrit(solver, stop_crit)
    ccall((:HYPRE_ParCSRHybridSetStopCrit, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, stop_crit)
end

function HYPRE_ParCSRHybridSetRelChange(solver, rel_change)
    ccall((:HYPRE_ParCSRHybridSetRelChange, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, rel_change)
end

function HYPRE_ParCSRHybridSetPrecond(solver, precond, precond_setup, precond_solver)
    ccall((:HYPRE_ParCSRHybridSetPrecond, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_PtrToParSolverFcn, HYPRE_PtrToParSolverFcn, HYPRE_Solver), solver, precond, precond_setup, precond_solver)
end

function HYPRE_ParCSRHybridSetLogging(solver, logging)
    ccall((:HYPRE_ParCSRHybridSetLogging, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, logging)
end

function HYPRE_ParCSRHybridSetPrintLevel(solver, print_level)
    ccall((:HYPRE_ParCSRHybridSetPrintLevel, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, print_level)
end

function HYPRE_ParCSRHybridSetStrongThreshold(solver, strong_threshold)
    ccall((:HYPRE_ParCSRHybridSetStrongThreshold, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, strong_threshold)
end

function HYPRE_ParCSRHybridSetMaxRowSum(solver, max_row_sum)
    ccall((:HYPRE_ParCSRHybridSetMaxRowSum, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, max_row_sum)
end

function HYPRE_ParCSRHybridSetTruncFactor(solver, trunc_factor)
    ccall((:HYPRE_ParCSRHybridSetTruncFactor, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, trunc_factor)
end

function HYPRE_ParCSRHybridSetPMaxElmts(solver, P_max_elmts)
    ccall((:HYPRE_ParCSRHybridSetPMaxElmts, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, P_max_elmts)
end

function HYPRE_ParCSRHybridSetMaxLevels(solver, max_levels)
    ccall((:HYPRE_ParCSRHybridSetMaxLevels, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, max_levels)
end

function HYPRE_ParCSRHybridSetMeasureType(solver, measure_type)
    ccall((:HYPRE_ParCSRHybridSetMeasureType, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, measure_type)
end

function HYPRE_ParCSRHybridSetCoarsenType(solver, coarsen_type)
    ccall((:HYPRE_ParCSRHybridSetCoarsenType, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, coarsen_type)
end

function HYPRE_ParCSRHybridSetInterpType(solver, interp_type)
    ccall((:HYPRE_ParCSRHybridSetInterpType, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, interp_type)
end

function HYPRE_ParCSRHybridSetCycleType(solver, cycle_type)
    ccall((:HYPRE_ParCSRHybridSetCycleType, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, cycle_type)
end

function HYPRE_ParCSRHybridSetGridRelaxType(solver, grid_relax_type)
    ccall((:HYPRE_ParCSRHybridSetGridRelaxType, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, grid_relax_type)
end

function HYPRE_ParCSRHybridSetGridRelaxPoints(solver, grid_relax_points)
    ccall((:HYPRE_ParCSRHybridSetGridRelaxPoints, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{Ptr{HYPRE_Int}}), solver, grid_relax_points)
end

function HYPRE_ParCSRHybridSetNumSweeps(solver, num_sweeps)
    ccall((:HYPRE_ParCSRHybridSetNumSweeps, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, num_sweeps)
end

function HYPRE_ParCSRHybridSetCycleNumSweeps(solver, num_sweeps, k)
    ccall((:HYPRE_ParCSRHybridSetCycleNumSweeps, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int, HYPRE_Int), solver, num_sweeps, k)
end

function HYPRE_ParCSRHybridSetRelaxType(solver, relax_type)
    ccall((:HYPRE_ParCSRHybridSetRelaxType, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, relax_type)
end

function HYPRE_ParCSRHybridSetCycleRelaxType(solver, relax_type, k)
    ccall((:HYPRE_ParCSRHybridSetCycleRelaxType, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int, HYPRE_Int), solver, relax_type, k)
end

function HYPRE_ParCSRHybridSetRelaxOrder(solver, relax_order)
    ccall((:HYPRE_ParCSRHybridSetRelaxOrder, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, relax_order)
end

function HYPRE_ParCSRHybridSetRelaxWt(solver, relax_wt)
    ccall((:HYPRE_ParCSRHybridSetRelaxWt, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, relax_wt)
end

function HYPRE_ParCSRHybridSetLevelRelaxWt(solver, relax_wt, level)
    ccall((:HYPRE_ParCSRHybridSetLevelRelaxWt, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real, HYPRE_Int), solver, relax_wt, level)
end

function HYPRE_ParCSRHybridSetOuterWt(solver, outer_wt)
    ccall((:HYPRE_ParCSRHybridSetOuterWt, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, outer_wt)
end

function HYPRE_ParCSRHybridSetLevelOuterWt(solver, outer_wt, level)
    ccall((:HYPRE_ParCSRHybridSetLevelOuterWt, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real, HYPRE_Int), solver, outer_wt, level)
end

function HYPRE_ParCSRHybridSetMaxCoarseSize(solver, max_coarse_size)
    ccall((:HYPRE_ParCSRHybridSetMaxCoarseSize, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, max_coarse_size)
end

function HYPRE_ParCSRHybridSetMinCoarseSize(solver, min_coarse_size)
    ccall((:HYPRE_ParCSRHybridSetMinCoarseSize, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, min_coarse_size)
end

function HYPRE_ParCSRHybridSetSeqThreshold(solver, seq_threshold)
    ccall((:HYPRE_ParCSRHybridSetSeqThreshold, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, seq_threshold)
end

function HYPRE_ParCSRHybridSetRelaxWeight(solver, relax_weight)
    ccall((:HYPRE_ParCSRHybridSetRelaxWeight, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Real}), solver, relax_weight)
end

function HYPRE_ParCSRHybridSetOmega(solver, omega)
    ccall((:HYPRE_ParCSRHybridSetOmega, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Real}), solver, omega)
end

function HYPRE_ParCSRHybridSetAggNumLevels(solver, agg_num_levels)
    ccall((:HYPRE_ParCSRHybridSetAggNumLevels, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, agg_num_levels)
end

function HYPRE_ParCSRHybridSetAggInterpType(solver, agg_interp_type)
    ccall((:HYPRE_ParCSRHybridSetAggInterpType, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, agg_interp_type)
end

function HYPRE_ParCSRHybridSetNumPaths(solver, num_paths)
    ccall((:HYPRE_ParCSRHybridSetNumPaths, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, num_paths)
end

function HYPRE_ParCSRHybridSetNumFunctions(solver, num_functions)
    ccall((:HYPRE_ParCSRHybridSetNumFunctions, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, num_functions)
end

function HYPRE_ParCSRHybridSetDofFunc(solver, dof_func)
    ccall((:HYPRE_ParCSRHybridSetDofFunc, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, dof_func)
end

function HYPRE_ParCSRHybridSetNodal(solver, nodal)
    ccall((:HYPRE_ParCSRHybridSetNodal, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, nodal)
end

function HYPRE_ParCSRHybridSetKeepTranspose(solver, keepT)
    ccall((:HYPRE_ParCSRHybridSetKeepTranspose, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, keepT)
end

function HYPRE_ParCSRHybridSetNonGalerkinTol(solver, num_levels, nongalerkin_tol)
    ccall((:HYPRE_ParCSRHybridSetNonGalerkinTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int, Ptr{HYPRE_Real}), solver, num_levels, nongalerkin_tol)
end

function HYPRE_ParCSRHybridGetNumIterations(solver, num_its)
    ccall((:HYPRE_ParCSRHybridGetNumIterations, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, num_its)
end

function HYPRE_ParCSRHybridGetDSCGNumIterations(solver, dscg_num_its)
    ccall((:HYPRE_ParCSRHybridGetDSCGNumIterations, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, dscg_num_its)
end

function HYPRE_ParCSRHybridGetPCGNumIterations(solver, pcg_num_its)
    ccall((:HYPRE_ParCSRHybridGetPCGNumIterations, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, pcg_num_its)
end

function HYPRE_ParCSRHybridGetFinalRelativeResidualNorm(solver, norm)
    ccall((:HYPRE_ParCSRHybridGetFinalRelativeResidualNorm, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Real}), solver, norm)
end

function HYPRE_ParCSRHybridSetNumGridSweeps(solver, num_grid_sweeps)
    ccall((:HYPRE_ParCSRHybridSetNumGridSweeps, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, num_grid_sweeps)
end

function HYPRE_ParCSRHybridGetSetupSolveTime(solver, time)
    ccall((:HYPRE_ParCSRHybridGetSetupSolveTime, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Real}), solver, time)
end

function HYPRE_SchwarzCreate(solver)
    ccall((:HYPRE_SchwarzCreate, libHYPRE), HYPRE_Int, (Ptr{HYPRE_Solver},), solver)
end

function HYPRE_SchwarzDestroy(solver)
    ccall((:HYPRE_SchwarzDestroy, libHYPRE), HYPRE_Int, (HYPRE_Solver,), solver)
end

function HYPRE_SchwarzSetup(solver, A, b, x)
    ccall((:HYPRE_SchwarzSetup, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParCSRMatrix, HYPRE_ParVector, HYPRE_ParVector), solver, A, b, x)
end

function HYPRE_SchwarzSolve(solver, A, b, x)
    ccall((:HYPRE_SchwarzSolve, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParCSRMatrix, HYPRE_ParVector, HYPRE_ParVector), solver, A, b, x)
end

function HYPRE_SchwarzSetVariant(solver, variant)
    ccall((:HYPRE_SchwarzSetVariant, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, variant)
end

function HYPRE_SchwarzSetOverlap(solver, overlap)
    ccall((:HYPRE_SchwarzSetOverlap, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, overlap)
end

function HYPRE_SchwarzSetDomainType(solver, domain_type)
    ccall((:HYPRE_SchwarzSetDomainType, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, domain_type)
end

function HYPRE_SchwarzSetRelaxWeight(solver, relax_weight)
    ccall((:HYPRE_SchwarzSetRelaxWeight, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, relax_weight)
end

function HYPRE_SchwarzSetDomainStructure(solver, domain_structure)
    ccall((:HYPRE_SchwarzSetDomainStructure, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_CSRMatrix), solver, domain_structure)
end

function HYPRE_SchwarzSetNumFunctions(solver, num_functions)
    ccall((:HYPRE_SchwarzSetNumFunctions, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, num_functions)
end

function HYPRE_SchwarzSetDofFunc(solver, dof_func)
    ccall((:HYPRE_SchwarzSetDofFunc, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, dof_func)
end

function HYPRE_SchwarzSetNonSymm(solver, use_nonsymm)
    ccall((:HYPRE_SchwarzSetNonSymm, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, use_nonsymm)
end

function HYPRE_ParCSRCGNRCreate(comm, solver)
    ccall((:HYPRE_ParCSRCGNRCreate, libHYPRE), HYPRE_Int, (MPI_Comm, Ptr{HYPRE_Solver}), comm, solver)
end

function HYPRE_ParCSRCGNRDestroy(solver)
    ccall((:HYPRE_ParCSRCGNRDestroy, libHYPRE), HYPRE_Int, (HYPRE_Solver,), solver)
end

function HYPRE_ParCSRCGNRSetup(solver, A, b, x)
    ccall((:HYPRE_ParCSRCGNRSetup, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParCSRMatrix, HYPRE_ParVector, HYPRE_ParVector), solver, A, b, x)
end

function HYPRE_ParCSRCGNRSolve(solver, A, b, x)
    ccall((:HYPRE_ParCSRCGNRSolve, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParCSRMatrix, HYPRE_ParVector, HYPRE_ParVector), solver, A, b, x)
end

function HYPRE_ParCSRCGNRSetTol(solver, tol)
    ccall((:HYPRE_ParCSRCGNRSetTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, tol)
end

function HYPRE_ParCSRCGNRSetMinIter(solver, min_iter)
    ccall((:HYPRE_ParCSRCGNRSetMinIter, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, min_iter)
end

function HYPRE_ParCSRCGNRSetMaxIter(solver, max_iter)
    ccall((:HYPRE_ParCSRCGNRSetMaxIter, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, max_iter)
end

function HYPRE_ParCSRCGNRSetStopCrit(solver, stop_crit)
    ccall((:HYPRE_ParCSRCGNRSetStopCrit, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, stop_crit)
end

function HYPRE_ParCSRCGNRSetPrecond(solver, precond, precondT, precond_setup, precond_solver)
    ccall((:HYPRE_ParCSRCGNRSetPrecond, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_PtrToParSolverFcn, HYPRE_PtrToParSolverFcn, HYPRE_PtrToParSolverFcn, HYPRE_Solver), solver, precond, precondT, precond_setup, precond_solver)
end

function HYPRE_ParCSRCGNRGetPrecond(solver, precond_data)
    ccall((:HYPRE_ParCSRCGNRGetPrecond, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Solver}), solver, precond_data)
end

function HYPRE_ParCSRCGNRSetLogging(solver, logging)
    ccall((:HYPRE_ParCSRCGNRSetLogging, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, logging)
end

function HYPRE_ParCSRCGNRGetNumIterations(solver, num_iterations)
    ccall((:HYPRE_ParCSRCGNRGetNumIterations, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, num_iterations)
end

function HYPRE_ParCSRCGNRGetFinalRelativeResidualNorm(solver, norm)
    ccall((:HYPRE_ParCSRCGNRGetFinalRelativeResidualNorm, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Real}), solver, norm)
end

function HYPRE_MGRCreate(solver)
    ccall((:HYPRE_MGRCreate, libHYPRE), HYPRE_Int, (Ptr{HYPRE_Solver},), solver)
end

function HYPRE_MGRDestroy(solver)
    ccall((:HYPRE_MGRDestroy, libHYPRE), HYPRE_Int, (HYPRE_Solver,), solver)
end

function HYPRE_MGRSetup(solver, A, b, x)
    ccall((:HYPRE_MGRSetup, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParCSRMatrix, HYPRE_ParVector, HYPRE_ParVector), solver, A, b, x)
end

function HYPRE_MGRSolve(solver, A, b, x)
    ccall((:HYPRE_MGRSolve, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParCSRMatrix, HYPRE_ParVector, HYPRE_ParVector), solver, A, b, x)
end

function HYPRE_MGRSetCpointsByContiguousBlock(solver, block_size, max_num_levels, idx_array, num_block_coarse_points, block_coarse_indexes)
    ccall((:HYPRE_MGRSetCpointsByContiguousBlock, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int, HYPRE_Int, Ptr{HYPRE_BigInt}, Ptr{HYPRE_Int}, Ptr{Ptr{HYPRE_Int}}), solver, block_size, max_num_levels, idx_array, num_block_coarse_points, block_coarse_indexes)
end

function HYPRE_MGRSetCpointsByBlock(solver, block_size, max_num_levels, num_block_coarse_points, block_coarse_indexes)
    ccall((:HYPRE_MGRSetCpointsByBlock, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int, HYPRE_Int, Ptr{HYPRE_Int}, Ptr{Ptr{HYPRE_Int}}), solver, block_size, max_num_levels, num_block_coarse_points, block_coarse_indexes)
end

function HYPRE_MGRSetCpointsByPointMarkerArray(solver, block_size, max_num_levels, num_block_coarse_points, lvl_block_coarse_indexes, point_marker_array)
    ccall((:HYPRE_MGRSetCpointsByPointMarkerArray, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int, HYPRE_Int, Ptr{HYPRE_Int}, Ptr{Ptr{HYPRE_Int}}, Ptr{HYPRE_Int}), solver, block_size, max_num_levels, num_block_coarse_points, lvl_block_coarse_indexes, point_marker_array)
end

function HYPRE_MGRSetNonCpointsToFpoints(solver, nonCptToFptFlag)
    ccall((:HYPRE_MGRSetNonCpointsToFpoints, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, nonCptToFptFlag)
end

function HYPRE_MGRSetMaxCoarseLevels(solver, maxlev)
    ccall((:HYPRE_MGRSetMaxCoarseLevels, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, maxlev)
end

function HYPRE_MGRSetBlockSize(solver, bsize)
    ccall((:HYPRE_MGRSetBlockSize, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, bsize)
end

function HYPRE_MGRSetReservedCoarseNodes(solver, reserved_coarse_size, reserved_coarse_nodes)
    ccall((:HYPRE_MGRSetReservedCoarseNodes, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int, Ptr{HYPRE_BigInt}), solver, reserved_coarse_size, reserved_coarse_nodes)
end

function HYPRE_MGRSetReservedCpointsLevelToKeep(solver, level)
    ccall((:HYPRE_MGRSetReservedCpointsLevelToKeep, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, level)
end

function HYPRE_MGRSetRelaxType(solver, relax_type)
    ccall((:HYPRE_MGRSetRelaxType, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, relax_type)
end

function HYPRE_MGRSetFRelaxMethod(solver, relax_method)
    ccall((:HYPRE_MGRSetFRelaxMethod, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, relax_method)
end

function HYPRE_MGRSetLevelFRelaxMethod(solver, relax_method)
    ccall((:HYPRE_MGRSetLevelFRelaxMethod, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, relax_method)
end

function HYPRE_MGRSetCoarseGridMethod(solver, cg_method)
    ccall((:HYPRE_MGRSetCoarseGridMethod, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, cg_method)
end

function HYPRE_MGRSetLevelFRelaxNumFunctions(solver, num_functions)
    ccall((:HYPRE_MGRSetLevelFRelaxNumFunctions, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, num_functions)
end

function HYPRE_MGRSetRestrictType(solver, restrict_type)
    ccall((:HYPRE_MGRSetRestrictType, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, restrict_type)
end

function HYPRE_MGRSetLevelRestrictType(solver, restrict_type)
    ccall((:HYPRE_MGRSetLevelRestrictType, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, restrict_type)
end

function HYPRE_MGRSetNumRestrictSweeps(solver, nsweeps)
    ccall((:HYPRE_MGRSetNumRestrictSweeps, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, nsweeps)
end

function HYPRE_MGRSetInterpType(solver, interp_type)
    ccall((:HYPRE_MGRSetInterpType, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, interp_type)
end

function HYPRE_MGRSetLevelInterpType(solver, interp_type)
    ccall((:HYPRE_MGRSetLevelInterpType, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, interp_type)
end

function HYPRE_MGRSetNumRelaxSweeps(solver, nsweeps)
    ccall((:HYPRE_MGRSetNumRelaxSweeps, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, nsweeps)
end

function HYPRE_MGRSetNumInterpSweeps(solver, nsweeps)
    ccall((:HYPRE_MGRSetNumInterpSweeps, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, nsweeps)
end

function HYPRE_MGRSetFSolver(solver, fine_grid_solver_solve, fine_grid_solver_setup, fsolver)
    ccall((:HYPRE_MGRSetFSolver, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_PtrToParSolverFcn, HYPRE_PtrToParSolverFcn, HYPRE_Solver), solver, fine_grid_solver_solve, fine_grid_solver_setup, fsolver)
end

function HYPRE_MGRBuildAff(A, CF_marker, debug_flag, A_ff)
    ccall((:HYPRE_MGRBuildAff, libHYPRE), HYPRE_Int, (HYPRE_ParCSRMatrix, Ptr{HYPRE_Int}, HYPRE_Int, Ptr{HYPRE_ParCSRMatrix}), A, CF_marker, debug_flag, A_ff)
end

function HYPRE_MGRSetCoarseSolver(solver, coarse_grid_solver_solve, coarse_grid_solver_setup, coarse_grid_solver)
    ccall((:HYPRE_MGRSetCoarseSolver, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_PtrToParSolverFcn, HYPRE_PtrToParSolverFcn, HYPRE_Solver), solver, coarse_grid_solver_solve, coarse_grid_solver_setup, coarse_grid_solver)
end

function HYPRE_MGRSetPrintLevel(solver, print_level)
    ccall((:HYPRE_MGRSetPrintLevel, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, print_level)
end

function HYPRE_MGRSetFrelaxPrintLevel(solver, print_level)
    ccall((:HYPRE_MGRSetFrelaxPrintLevel, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, print_level)
end

function HYPRE_MGRSetCoarseGridPrintLevel(solver, print_level)
    ccall((:HYPRE_MGRSetCoarseGridPrintLevel, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, print_level)
end

function HYPRE_MGRSetTruncateCoarseGridThreshold(solver, threshold)
    ccall((:HYPRE_MGRSetTruncateCoarseGridThreshold, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, threshold)
end

function HYPRE_MGRSetLogging(solver, logging)
    ccall((:HYPRE_MGRSetLogging, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, logging)
end

function HYPRE_MGRSetMaxIter(solver, max_iter)
    ccall((:HYPRE_MGRSetMaxIter, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, max_iter)
end

function HYPRE_MGRSetTol(solver, tol)
    ccall((:HYPRE_MGRSetTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, tol)
end

function HYPRE_MGRSetMaxGlobalsmoothIters(solver, smooth_iter)
    ccall((:HYPRE_MGRSetMaxGlobalsmoothIters, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, smooth_iter)
end

function HYPRE_MGRSetGlobalsmoothType(solver, smooth_type)
    ccall((:HYPRE_MGRSetGlobalsmoothType, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, smooth_type)
end

function HYPRE_MGRGetNumIterations(solver, num_iterations)
    ccall((:HYPRE_MGRGetNumIterations, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, num_iterations)
end

function HYPRE_MGRGetCoarseGridConvergenceFactor(solver, conv_factor)
    ccall((:HYPRE_MGRGetCoarseGridConvergenceFactor, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Real}), solver, conv_factor)
end

function HYPRE_MGRSetPMaxElmts(solver, P_max_elmts)
    ccall((:HYPRE_MGRSetPMaxElmts, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, P_max_elmts)
end

function HYPRE_MGRGetFinalRelativeResidualNorm(solver, res_norm)
    ccall((:HYPRE_MGRGetFinalRelativeResidualNorm, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Real}), solver, res_norm)
end

function HYPRE_ILUCreate(solver)
    ccall((:HYPRE_ILUCreate, libHYPRE), HYPRE_Int, (Ptr{HYPRE_Solver},), solver)
end

function HYPRE_ILUDestroy(solver)
    ccall((:HYPRE_ILUDestroy, libHYPRE), HYPRE_Int, (HYPRE_Solver,), solver)
end

function HYPRE_ILUSetup(solver, A, b, x)
    ccall((:HYPRE_ILUSetup, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParCSRMatrix, HYPRE_ParVector, HYPRE_ParVector), solver, A, b, x)
end

function HYPRE_ILUSolve(solver, A, b, x)
    ccall((:HYPRE_ILUSolve, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_ParCSRMatrix, HYPRE_ParVector, HYPRE_ParVector), solver, A, b, x)
end

function HYPRE_ILUSetMaxIter(solver, max_iter)
    ccall((:HYPRE_ILUSetMaxIter, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, max_iter)
end

function HYPRE_ILUSetTol(solver, tol)
    ccall((:HYPRE_ILUSetTol, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, tol)
end

function HYPRE_ILUSetLevelOfFill(solver, lfil)
    ccall((:HYPRE_ILUSetLevelOfFill, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, lfil)
end

function HYPRE_ILUSetMaxNnzPerRow(solver, nzmax)
    ccall((:HYPRE_ILUSetMaxNnzPerRow, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, nzmax)
end

function HYPRE_ILUSetDropThreshold(solver, threshold)
    ccall((:HYPRE_ILUSetDropThreshold, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, threshold)
end

function HYPRE_ILUSetDropThresholdArray(solver, threshold)
    ccall((:HYPRE_ILUSetDropThresholdArray, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Real}), solver, threshold)
end

function HYPRE_ILUSetNSHDropThreshold(solver, threshold)
    ccall((:HYPRE_ILUSetNSHDropThreshold, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, threshold)
end

function HYPRE_ILUSetNSHDropThresholdArray(solver, threshold)
    ccall((:HYPRE_ILUSetNSHDropThresholdArray, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Real}), solver, threshold)
end

function HYPRE_ILUSetSchurMaxIter(solver, ss_max_iter)
    ccall((:HYPRE_ILUSetSchurMaxIter, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, ss_max_iter)
end

function HYPRE_ILUSetType(solver, ilu_type)
    ccall((:HYPRE_ILUSetType, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, ilu_type)
end

function HYPRE_ILUSetLocalReordering(solver, reordering_type)
    ccall((:HYPRE_ILUSetLocalReordering, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, reordering_type)
end

function HYPRE_ILUSetPrintLevel(solver, print_level)
    ccall((:HYPRE_ILUSetPrintLevel, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, print_level)
end

function HYPRE_ILUSetLogging(solver, logging)
    ccall((:HYPRE_ILUSetLogging, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, logging)
end

function HYPRE_ILUGetNumIterations(solver, num_iterations)
    ccall((:HYPRE_ILUGetNumIterations, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Int}), solver, num_iterations)
end

function HYPRE_ILUGetFinalRelativeResidualNorm(solver, res_norm)
    ccall((:HYPRE_ILUGetFinalRelativeResidualNorm, libHYPRE), HYPRE_Int, (HYPRE_Solver, Ptr{HYPRE_Real}), solver, res_norm)
end

function GenerateLaplacian(comm, nx, ny, nz, P, Q, R, p, q, r, value)
    ccall((:GenerateLaplacian, libHYPRE), HYPRE_ParCSRMatrix, (MPI_Comm, HYPRE_BigInt, HYPRE_BigInt, HYPRE_BigInt, HYPRE_Int, HYPRE_Int, HYPRE_Int, HYPRE_Int, HYPRE_Int, HYPRE_Int, Ptr{HYPRE_Real}), comm, nx, ny, nz, P, Q, R, p, q, r, value)
end

function GenerateLaplacian27pt(comm, nx, ny, nz, P, Q, R, p, q, r, value)
    ccall((:GenerateLaplacian27pt, libHYPRE), HYPRE_ParCSRMatrix, (MPI_Comm, HYPRE_BigInt, HYPRE_BigInt, HYPRE_BigInt, HYPRE_Int, HYPRE_Int, HYPRE_Int, HYPRE_Int, HYPRE_Int, HYPRE_Int, Ptr{HYPRE_Real}), comm, nx, ny, nz, P, Q, R, p, q, r, value)
end

function GenerateLaplacian9pt(comm, nx, ny, P, Q, p, q, value)
    ccall((:GenerateLaplacian9pt, libHYPRE), HYPRE_ParCSRMatrix, (MPI_Comm, HYPRE_BigInt, HYPRE_BigInt, HYPRE_Int, HYPRE_Int, HYPRE_Int, HYPRE_Int, Ptr{HYPRE_Real}), comm, nx, ny, P, Q, p, q, value)
end

function GenerateDifConv(comm, nx, ny, nz, P, Q, R, p, q, r, value)
    ccall((:GenerateDifConv, libHYPRE), HYPRE_ParCSRMatrix, (MPI_Comm, HYPRE_BigInt, HYPRE_BigInt, HYPRE_BigInt, HYPRE_Int, HYPRE_Int, HYPRE_Int, HYPRE_Int, HYPRE_Int, HYPRE_Int, Ptr{HYPRE_Real}), comm, nx, ny, nz, P, Q, R, p, q, r, value)
end

function GenerateRotate7pt(comm, nx, ny, P, Q, p, q, alpha, eps)
    ccall((:GenerateRotate7pt, libHYPRE), HYPRE_ParCSRMatrix, (MPI_Comm, HYPRE_BigInt, HYPRE_BigInt, HYPRE_Int, HYPRE_Int, HYPRE_Int, HYPRE_Int, HYPRE_Real, HYPRE_Real), comm, nx, ny, P, Q, p, q, alpha, eps)
end

function GenerateVarDifConv(comm, nx, ny, nz, P, Q, R, p, q, r, eps, rhs_ptr)
    ccall((:GenerateVarDifConv, libHYPRE), HYPRE_ParCSRMatrix, (MPI_Comm, HYPRE_BigInt, HYPRE_BigInt, HYPRE_BigInt, HYPRE_Int, HYPRE_Int, HYPRE_Int, HYPRE_Int, HYPRE_Int, HYPRE_Int, HYPRE_Real, Ptr{HYPRE_ParVector}), comm, nx, ny, nz, P, Q, R, p, q, r, eps, rhs_ptr)
end

function GenerateRSVarDifConv(comm, nx, ny, nz, P, Q, R, p, q, r, eps, rhs_ptr, type)
    ccall((:GenerateRSVarDifConv, libHYPRE), HYPRE_ParCSRMatrix, (MPI_Comm, HYPRE_BigInt, HYPRE_BigInt, HYPRE_BigInt, HYPRE_Int, HYPRE_Int, HYPRE_Int, HYPRE_Int, HYPRE_Int, HYPRE_Int, HYPRE_Real, Ptr{HYPRE_ParVector}, HYPRE_Int), comm, nx, ny, nz, P, Q, R, p, q, r, eps, rhs_ptr, type)
end

function GenerateCoordinates(comm, nx, ny, nz, P, Q, R, p, q, r, coorddim)
    ccall((:GenerateCoordinates, libHYPRE), Ptr{Cfloat}, (MPI_Comm, HYPRE_BigInt, HYPRE_BigInt, HYPRE_BigInt, HYPRE_Int, HYPRE_Int, HYPRE_Int, HYPRE_Int, HYPRE_Int, HYPRE_Int, HYPRE_Int), comm, nx, ny, nz, P, Q, R, p, q, r, coorddim)
end

function HYPRE_BoomerAMGSetPostInterpType(solver, post_interp_type)
    ccall((:HYPRE_BoomerAMGSetPostInterpType, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, post_interp_type)
end

function HYPRE_BoomerAMGSetJacobiTruncThreshold(solver, jacobi_trunc_threshold)
    ccall((:HYPRE_BoomerAMGSetJacobiTruncThreshold, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, jacobi_trunc_threshold)
end

function HYPRE_BoomerAMGSetNumCRRelaxSteps(solver, num_CR_relax_steps)
    ccall((:HYPRE_BoomerAMGSetNumCRRelaxSteps, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, num_CR_relax_steps)
end

function HYPRE_BoomerAMGSetCRRate(solver, CR_rate)
    ccall((:HYPRE_BoomerAMGSetCRRate, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, CR_rate)
end

function HYPRE_BoomerAMGSetCRStrongTh(solver, CR_strong_th)
    ccall((:HYPRE_BoomerAMGSetCRStrongTh, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Real), solver, CR_strong_th)
end

function HYPRE_BoomerAMGSetCRUseCG(solver, CR_use_CG)
    ccall((:HYPRE_BoomerAMGSetCRUseCG, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, CR_use_CG)
end

function HYPRE_BoomerAMGSetISType(solver, IS_type)
    ccall((:HYPRE_BoomerAMGSetISType, libHYPRE), HYPRE_Int, (HYPRE_Solver, HYPRE_Int), solver, IS_type)
end

function HYPRE_ParCSRSetupInterpreter(i)
    ccall((:HYPRE_ParCSRSetupInterpreter, libHYPRE), HYPRE_Int, (Ptr{mv_InterfaceInterpreter},), i)
end

function HYPRE_ParCSRSetupMatvec(mv)
    ccall((:HYPRE_ParCSRSetupMatvec, libHYPRE), HYPRE_Int, (Ptr{HYPRE_MatvecFunctions},), mv)
end

function HYPRE_ParCSRMultiVectorPrint(x_, fileName)
    ccall((:HYPRE_ParCSRMultiVectorPrint, libHYPRE), HYPRE_Int, (Ptr{Cvoid}, Ptr{Cchar}), x_, fileName)
end

function HYPRE_ParCSRMultiVectorRead(comm, ii_, fileName)
    ccall((:HYPRE_ParCSRMultiVectorRead, libHYPRE), Ptr{Cvoid}, (MPI_Comm, Ptr{Cvoid}, Ptr{Cchar}), comm, ii_, fileName)
end

const HYPRE_UNITIALIZED = -999

const HYPRE_PETSC_MAT_PARILUT_SOLVER = 222

const HYPRE_PARILUT = 333

const HYPRE_STRUCT = 1111

const HYPRE_SSTRUCT = 3333

const HYPRE_PARCSR = 5555

const HYPRE_ISIS = 9911

const HYPRE_PETSC = 9933

const HYPRE_PFMG = 10

const HYPRE_SMG = 11

const HYPRE_Jacobi = 17

const HYPRE_RELEASE_NAME = "HYPRE"

const HYPRE_RELEASE_VERSION = "2.23.0"

const HYPRE_RELEASE_NUMBER = 22300

const HYPRE_RELEASE_DATE = "2021/10/01"

const HYPRE_RELEASE_TIME = "00:00:00"

const HYPRE_RELEASE_BUGS = "https://github.com/hypre-space/hypre/issues"

const HYPRE_MAXDIM = 3

const HYPRE_USING_HYPRE_BLAS = 1

const HYPRE_USING_HYPRE_LAPACK = 1

const HYPRE_HAVE_MPI = 1

const HYPRE_FMANGLE = 0

const HYPRE_FMANGLE_BLAS = 0

const HYPRE_FMANGLE_LAPACK = 0

const HYPRE_USING_HOST_MEMORY = 1

const NO_TAGS_WITH_MODIFIERS = 1

const ROMIO_VERSION = 126

const HAVE_MPI_GREQUEST = 1

const HYPRE_MPI_BIG_INT = MPI_INT

const HYPRE_MPI_INT = MPI_INT

const HYPRE_MPI_REAL = MPI_DOUBLE

const HYPRE_MPI_COMPLEX = HYPRE_MPI_REAL

const HYPRE_ERROR_GENERIC = 1

const HYPRE_ERROR_MEMORY = 2

const HYPRE_ERROR_ARG = 4

const HYPRE_ERROR_CONV = 256

