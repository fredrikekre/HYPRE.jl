local libHYPRE # Silence of the Langs(erver)

using HYPRE_jll: HYPRE_jll, libHYPRE
export HYPRE_jll

using CEnum: @cenum

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


const HYPRE_BigInt = Cint

const HYPRE_Int = Cint

const HYPRE_Real = Cdouble

const HYPRE_Complex = HYPRE_Real

# no prototype is found for this function at HYPRE_utilities.h:116:11, please use with caution
function HYPRE_Init()
    return @ccall libHYPRE.HYPRE_Init()::HYPRE_Int
end

# no prototype is found for this function at HYPRE_utilities.h:117:11, please use with caution
function HYPRE_Finalize()
    return @ccall libHYPRE.HYPRE_Finalize()::HYPRE_Int
end

# no prototype is found for this function at HYPRE_utilities.h:124:11, please use with caution
function HYPRE_GetError()
    return @ccall libHYPRE.HYPRE_GetError()::HYPRE_Int
end

function HYPRE_CheckError(hypre_ierr, hypre_error_code)
    return @ccall libHYPRE.HYPRE_CheckError(hypre_ierr::HYPRE_Int, hypre_error_code::HYPRE_Int)::HYPRE_Int
end

# no prototype is found for this function at HYPRE_utilities.h:131:11, please use with caution
function HYPRE_GetErrorArg()
    return @ccall libHYPRE.HYPRE_GetErrorArg()::HYPRE_Int
end

function HYPRE_DescribeError(hypre_ierr, descr)
    return @ccall libHYPRE.HYPRE_DescribeError(hypre_ierr::HYPRE_Int, descr::Ptr{Cchar})::Cvoid
end

# no prototype is found for this function at HYPRE_utilities.h:137:11, please use with caution
function HYPRE_ClearAllErrors()
    return @ccall libHYPRE.HYPRE_ClearAllErrors()::HYPRE_Int
end

function HYPRE_ClearError(hypre_error_code)
    return @ccall libHYPRE.HYPRE_ClearError(hypre_error_code::HYPRE_Int)::HYPRE_Int
end

# no prototype is found for this function at HYPRE_utilities.h:143:11, please use with caution
function HYPRE_PrintDeviceInfo()
    return @ccall libHYPRE.HYPRE_PrintDeviceInfo()::HYPRE_Int
end

function HYPRE_Version(version_ptr)
    return @ccall libHYPRE.HYPRE_Version(version_ptr::Ptr{Ptr{Cchar}})::HYPRE_Int
end

function HYPRE_VersionNumber(major_ptr, minor_ptr, patch_ptr, single_ptr)
    return @ccall libHYPRE.HYPRE_VersionNumber(major_ptr::Ptr{HYPRE_Int}, minor_ptr::Ptr{HYPRE_Int}, patch_ptr::Ptr{HYPRE_Int}, single_ptr::Ptr{HYPRE_Int})::HYPRE_Int
end

# no prototype is found for this function at HYPRE_utilities.h:174:11, please use with caution
function HYPRE_AssumedPartitionCheck()
    return @ccall libHYPRE.HYPRE_AssumedPartitionCheck()::HYPRE_Int
end

@cenum _HYPRE_MemoryLocation::Int32 begin
    HYPRE_MEMORY_UNDEFINED = -1
    HYPRE_MEMORY_HOST = 0
    HYPRE_MEMORY_DEVICE = 1
end

const HYPRE_MemoryLocation = _HYPRE_MemoryLocation

function HYPRE_SetMemoryLocation(memory_location)
    return @ccall libHYPRE.HYPRE_SetMemoryLocation(memory_location::HYPRE_MemoryLocation)::HYPRE_Int
end

function HYPRE_GetMemoryLocation(memory_location)
    return @ccall libHYPRE.HYPRE_GetMemoryLocation(memory_location::Ptr{HYPRE_MemoryLocation})::HYPRE_Int
end

@cenum _HYPRE_ExecutionPolicy::Int32 begin
    HYPRE_EXEC_UNDEFINED = -1
    HYPRE_EXEC_HOST = 0
    HYPRE_EXEC_DEVICE = 1
end

const HYPRE_ExecutionPolicy = _HYPRE_ExecutionPolicy

function HYPRE_SetExecutionPolicy(exec_policy)
    return @ccall libHYPRE.HYPRE_SetExecutionPolicy(exec_policy::HYPRE_ExecutionPolicy)::HYPRE_Int
end

function HYPRE_GetExecutionPolicy(exec_policy)
    return @ccall libHYPRE.HYPRE_GetExecutionPolicy(exec_policy::Ptr{HYPRE_ExecutionPolicy})::HYPRE_Int
end

function HYPRE_SetStructExecutionPolicy(exec_policy)
    return @ccall libHYPRE.HYPRE_SetStructExecutionPolicy(exec_policy::HYPRE_ExecutionPolicy)::HYPRE_Int
end

function HYPRE_GetStructExecutionPolicy(exec_policy)
    return @ccall libHYPRE.HYPRE_GetStructExecutionPolicy(exec_policy::Ptr{HYPRE_ExecutionPolicy})::HYPRE_Int
end

function HYPRE_SetUmpireDevicePoolSize(nbytes)
    return @ccall libHYPRE.HYPRE_SetUmpireDevicePoolSize(nbytes::Csize_t)::HYPRE_Int
end

function HYPRE_SetUmpireUMPoolSize(nbytes)
    return @ccall libHYPRE.HYPRE_SetUmpireUMPoolSize(nbytes::Csize_t)::HYPRE_Int
end

function HYPRE_SetUmpireHostPoolSize(nbytes)
    return @ccall libHYPRE.HYPRE_SetUmpireHostPoolSize(nbytes::Csize_t)::HYPRE_Int
end

function HYPRE_SetUmpirePinnedPoolSize(nbytes)
    return @ccall libHYPRE.HYPRE_SetUmpirePinnedPoolSize(nbytes::Csize_t)::HYPRE_Int
end

function HYPRE_SetUmpireDevicePoolName(pool_name)
    return @ccall libHYPRE.HYPRE_SetUmpireDevicePoolName(pool_name::Ptr{Cchar})::HYPRE_Int
end

function HYPRE_SetUmpireUMPoolName(pool_name)
    return @ccall libHYPRE.HYPRE_SetUmpireUMPoolName(pool_name::Ptr{Cchar})::HYPRE_Int
end

function HYPRE_SetUmpireHostPoolName(pool_name)
    return @ccall libHYPRE.HYPRE_SetUmpireHostPoolName(pool_name::Ptr{Cchar})::HYPRE_Int
end

function HYPRE_SetUmpirePinnedPoolName(pool_name)
    return @ccall libHYPRE.HYPRE_SetUmpirePinnedPoolName(pool_name::Ptr{Cchar})::HYPRE_Int
end

function HYPRE_SetGPUMemoryPoolSize(bin_growth, min_bin, max_bin, max_cached_bytes)
    return @ccall libHYPRE.HYPRE_SetGPUMemoryPoolSize(bin_growth::HYPRE_Int, min_bin::HYPRE_Int, max_bin::HYPRE_Int, max_cached_bytes::Csize_t)::HYPRE_Int
end

function HYPRE_SetSpGemmUseCusparse(use_cusparse)
    return @ccall libHYPRE.HYPRE_SetSpGemmUseCusparse(use_cusparse::HYPRE_Int)::HYPRE_Int
end

function HYPRE_SetUseGpuRand(use_curand)
    return @ccall libHYPRE.HYPRE_SetUseGpuRand(use_curand::HYPRE_Int)::HYPRE_Int
end

mutable struct hypre_IJMatrix_struct end

const HYPRE_IJMatrix = Ptr{hypre_IJMatrix_struct}

function HYPRE_IJMatrixCreate(comm, ilower, iupper, jlower, jupper, matrix)
    return @ccall libHYPRE.HYPRE_IJMatrixCreate(comm::MPI_Comm, ilower::HYPRE_BigInt, iupper::HYPRE_BigInt, jlower::HYPRE_BigInt, jupper::HYPRE_BigInt, matrix::Ptr{HYPRE_IJMatrix})::HYPRE_Int
end

function HYPRE_IJMatrixDestroy(matrix)
    return @ccall libHYPRE.HYPRE_IJMatrixDestroy(matrix::HYPRE_IJMatrix)::HYPRE_Int
end

function HYPRE_IJMatrixInitialize(matrix)
    return @ccall libHYPRE.HYPRE_IJMatrixInitialize(matrix::HYPRE_IJMatrix)::HYPRE_Int
end

function HYPRE_IJMatrixInitialize_v2(matrix, memory_location)
    return @ccall libHYPRE.HYPRE_IJMatrixInitialize_v2(matrix::HYPRE_IJMatrix, memory_location::HYPRE_MemoryLocation)::HYPRE_Int
end

function HYPRE_IJMatrixSetValues(matrix, nrows, ncols, rows, cols, values)
    return @ccall libHYPRE.HYPRE_IJMatrixSetValues(matrix::HYPRE_IJMatrix, nrows::HYPRE_Int, ncols::Ptr{HYPRE_Int}, rows::Ptr{HYPRE_BigInt}, cols::Ptr{HYPRE_BigInt}, values::Ptr{HYPRE_Complex})::HYPRE_Int
end

function HYPRE_IJMatrixSetConstantValues(matrix, value)
    return @ccall libHYPRE.HYPRE_IJMatrixSetConstantValues(matrix::HYPRE_IJMatrix, value::HYPRE_Complex)::HYPRE_Int
end

function HYPRE_IJMatrixAddToValues(matrix, nrows, ncols, rows, cols, values)
    return @ccall libHYPRE.HYPRE_IJMatrixAddToValues(matrix::HYPRE_IJMatrix, nrows::HYPRE_Int, ncols::Ptr{HYPRE_Int}, rows::Ptr{HYPRE_BigInt}, cols::Ptr{HYPRE_BigInt}, values::Ptr{HYPRE_Complex})::HYPRE_Int
end

function HYPRE_IJMatrixSetValues2(matrix, nrows, ncols, rows, row_indexes, cols, values)
    return @ccall libHYPRE.HYPRE_IJMatrixSetValues2(matrix::HYPRE_IJMatrix, nrows::HYPRE_Int, ncols::Ptr{HYPRE_Int}, rows::Ptr{HYPRE_BigInt}, row_indexes::Ptr{HYPRE_Int}, cols::Ptr{HYPRE_BigInt}, values::Ptr{HYPRE_Complex})::HYPRE_Int
end

function HYPRE_IJMatrixAddToValues2(matrix, nrows, ncols, rows, row_indexes, cols, values)
    return @ccall libHYPRE.HYPRE_IJMatrixAddToValues2(matrix::HYPRE_IJMatrix, nrows::HYPRE_Int, ncols::Ptr{HYPRE_Int}, rows::Ptr{HYPRE_BigInt}, row_indexes::Ptr{HYPRE_Int}, cols::Ptr{HYPRE_BigInt}, values::Ptr{HYPRE_Complex})::HYPRE_Int
end

function HYPRE_IJMatrixAssemble(matrix)
    return @ccall libHYPRE.HYPRE_IJMatrixAssemble(matrix::HYPRE_IJMatrix)::HYPRE_Int
end

function HYPRE_IJMatrixGetRowCounts(matrix, nrows, rows, ncols)
    return @ccall libHYPRE.HYPRE_IJMatrixGetRowCounts(matrix::HYPRE_IJMatrix, nrows::HYPRE_Int, rows::Ptr{HYPRE_BigInt}, ncols::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_IJMatrixGetValues(matrix, nrows, ncols, rows, cols, values)
    return @ccall libHYPRE.HYPRE_IJMatrixGetValues(matrix::HYPRE_IJMatrix, nrows::HYPRE_Int, ncols::Ptr{HYPRE_Int}, rows::Ptr{HYPRE_BigInt}, cols::Ptr{HYPRE_BigInt}, values::Ptr{HYPRE_Complex})::HYPRE_Int
end

function HYPRE_IJMatrixSetObjectType(matrix, type)
    return @ccall libHYPRE.HYPRE_IJMatrixSetObjectType(matrix::HYPRE_IJMatrix, type::HYPRE_Int)::HYPRE_Int
end

function HYPRE_IJMatrixGetObjectType(matrix, type)
    return @ccall libHYPRE.HYPRE_IJMatrixGetObjectType(matrix::HYPRE_IJMatrix, type::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_IJMatrixGetLocalRange(matrix, ilower, iupper, jlower, jupper)
    return @ccall libHYPRE.HYPRE_IJMatrixGetLocalRange(matrix::HYPRE_IJMatrix, ilower::Ptr{HYPRE_BigInt}, iupper::Ptr{HYPRE_BigInt}, jlower::Ptr{HYPRE_BigInt}, jupper::Ptr{HYPRE_BigInt})::HYPRE_Int
end

function HYPRE_IJMatrixGetObject(matrix, object)
    return @ccall libHYPRE.HYPRE_IJMatrixGetObject(matrix::HYPRE_IJMatrix, object::Ptr{Ptr{Cvoid}})::HYPRE_Int
end

function HYPRE_IJMatrixSetRowSizes(matrix, sizes)
    return @ccall libHYPRE.HYPRE_IJMatrixSetRowSizes(matrix::HYPRE_IJMatrix, sizes::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_IJMatrixSetDiagOffdSizes(matrix, diag_sizes, offdiag_sizes)
    return @ccall libHYPRE.HYPRE_IJMatrixSetDiagOffdSizes(matrix::HYPRE_IJMatrix, diag_sizes::Ptr{HYPRE_Int}, offdiag_sizes::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_IJMatrixSetMaxOffProcElmts(matrix, max_off_proc_elmts)
    return @ccall libHYPRE.HYPRE_IJMatrixSetMaxOffProcElmts(matrix::HYPRE_IJMatrix, max_off_proc_elmts::HYPRE_Int)::HYPRE_Int
end

function HYPRE_IJMatrixSetPrintLevel(matrix, print_level)
    return @ccall libHYPRE.HYPRE_IJMatrixSetPrintLevel(matrix::HYPRE_IJMatrix, print_level::HYPRE_Int)::HYPRE_Int
end

function HYPRE_IJMatrixSetOMPFlag(matrix, omp_flag)
    return @ccall libHYPRE.HYPRE_IJMatrixSetOMPFlag(matrix::HYPRE_IJMatrix, omp_flag::HYPRE_Int)::HYPRE_Int
end

function HYPRE_IJMatrixRead(filename, comm, type, matrix)
    return @ccall libHYPRE.HYPRE_IJMatrixRead(filename::Ptr{Cchar}, comm::MPI_Comm, type::HYPRE_Int, matrix::Ptr{HYPRE_IJMatrix})::HYPRE_Int
end

function HYPRE_IJMatrixPrint(matrix, filename)
    return @ccall libHYPRE.HYPRE_IJMatrixPrint(matrix::HYPRE_IJMatrix, filename::Ptr{Cchar})::HYPRE_Int
end

mutable struct hypre_IJVector_struct end

const HYPRE_IJVector = Ptr{hypre_IJVector_struct}

function HYPRE_IJVectorCreate(comm, jlower, jupper, vector)
    return @ccall libHYPRE.HYPRE_IJVectorCreate(comm::MPI_Comm, jlower::HYPRE_BigInt, jupper::HYPRE_BigInt, vector::Ptr{HYPRE_IJVector})::HYPRE_Int
end

function HYPRE_IJVectorDestroy(vector)
    return @ccall libHYPRE.HYPRE_IJVectorDestroy(vector::HYPRE_IJVector)::HYPRE_Int
end

function HYPRE_IJVectorInitialize(vector)
    return @ccall libHYPRE.HYPRE_IJVectorInitialize(vector::HYPRE_IJVector)::HYPRE_Int
end

function HYPRE_IJVectorInitialize_v2(vector, memory_location)
    return @ccall libHYPRE.HYPRE_IJVectorInitialize_v2(vector::HYPRE_IJVector, memory_location::HYPRE_MemoryLocation)::HYPRE_Int
end

function HYPRE_IJVectorSetMaxOffProcElmts(vector, max_off_proc_elmts)
    return @ccall libHYPRE.HYPRE_IJVectorSetMaxOffProcElmts(vector::HYPRE_IJVector, max_off_proc_elmts::HYPRE_Int)::HYPRE_Int
end

function HYPRE_IJVectorSetValues(vector, nvalues, indices, values)
    return @ccall libHYPRE.HYPRE_IJVectorSetValues(vector::HYPRE_IJVector, nvalues::HYPRE_Int, indices::Ptr{HYPRE_BigInt}, values::Ptr{HYPRE_Complex})::HYPRE_Int
end

function HYPRE_IJVectorAddToValues(vector, nvalues, indices, values)
    return @ccall libHYPRE.HYPRE_IJVectorAddToValues(vector::HYPRE_IJVector, nvalues::HYPRE_Int, indices::Ptr{HYPRE_BigInt}, values::Ptr{HYPRE_Complex})::HYPRE_Int
end

function HYPRE_IJVectorAssemble(vector)
    return @ccall libHYPRE.HYPRE_IJVectorAssemble(vector::HYPRE_IJVector)::HYPRE_Int
end

function HYPRE_IJVectorGetValues(vector, nvalues, indices, values)
    return @ccall libHYPRE.HYPRE_IJVectorGetValues(vector::HYPRE_IJVector, nvalues::HYPRE_Int, indices::Ptr{HYPRE_BigInt}, values::Ptr{HYPRE_Complex})::HYPRE_Int
end

function HYPRE_IJVectorSetObjectType(vector, type)
    return @ccall libHYPRE.HYPRE_IJVectorSetObjectType(vector::HYPRE_IJVector, type::HYPRE_Int)::HYPRE_Int
end

function HYPRE_IJVectorGetObjectType(vector, type)
    return @ccall libHYPRE.HYPRE_IJVectorGetObjectType(vector::HYPRE_IJVector, type::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_IJVectorGetLocalRange(vector, jlower, jupper)
    return @ccall libHYPRE.HYPRE_IJVectorGetLocalRange(vector::HYPRE_IJVector, jlower::Ptr{HYPRE_BigInt}, jupper::Ptr{HYPRE_BigInt})::HYPRE_Int
end

function HYPRE_IJVectorGetObject(vector, object)
    return @ccall libHYPRE.HYPRE_IJVectorGetObject(vector::HYPRE_IJVector, object::Ptr{Ptr{Cvoid}})::HYPRE_Int
end

function HYPRE_IJVectorSetPrintLevel(vector, print_level)
    return @ccall libHYPRE.HYPRE_IJVectorSetPrintLevel(vector::HYPRE_IJVector, print_level::HYPRE_Int)::HYPRE_Int
end

function HYPRE_IJVectorRead(filename, comm, type, vector)
    return @ccall libHYPRE.HYPRE_IJVectorRead(filename::Ptr{Cchar}, comm::MPI_Comm, type::HYPRE_Int, vector::Ptr{HYPRE_IJVector})::HYPRE_Int
end

function HYPRE_IJVectorPrint(vector, filename)
    return @ccall libHYPRE.HYPRE_IJVectorPrint(vector::HYPRE_IJVector, filename::Ptr{Cchar})::HYPRE_Int
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
    return @ccall libHYPRE.HYPRE_CSRMatrixCreate(num_rows::HYPRE_Int, num_cols::HYPRE_Int, row_sizes::Ptr{HYPRE_Int})::HYPRE_CSRMatrix
end

function HYPRE_CSRMatrixDestroy(matrix)
    return @ccall libHYPRE.HYPRE_CSRMatrixDestroy(matrix::HYPRE_CSRMatrix)::HYPRE_Int
end

function HYPRE_CSRMatrixInitialize(matrix)
    return @ccall libHYPRE.HYPRE_CSRMatrixInitialize(matrix::HYPRE_CSRMatrix)::HYPRE_Int
end

function HYPRE_CSRMatrixRead(file_name)
    return @ccall libHYPRE.HYPRE_CSRMatrixRead(file_name::Ptr{Cchar})::HYPRE_CSRMatrix
end

function HYPRE_CSRMatrixPrint(matrix, file_name)
    return @ccall libHYPRE.HYPRE_CSRMatrixPrint(matrix::HYPRE_CSRMatrix, file_name::Ptr{Cchar})::Cvoid
end

function HYPRE_CSRMatrixGetNumRows(matrix, num_rows)
    return @ccall libHYPRE.HYPRE_CSRMatrixGetNumRows(matrix::HYPRE_CSRMatrix, num_rows::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_MappedMatrixCreate()
    return @ccall libHYPRE.HYPRE_MappedMatrixCreate()::HYPRE_MappedMatrix
end

function HYPRE_MappedMatrixDestroy(matrix)
    return @ccall libHYPRE.HYPRE_MappedMatrixDestroy(matrix::HYPRE_MappedMatrix)::HYPRE_Int
end

function HYPRE_MappedMatrixLimitedDestroy(matrix)
    return @ccall libHYPRE.HYPRE_MappedMatrixLimitedDestroy(matrix::HYPRE_MappedMatrix)::HYPRE_Int
end

function HYPRE_MappedMatrixInitialize(matrix)
    return @ccall libHYPRE.HYPRE_MappedMatrixInitialize(matrix::HYPRE_MappedMatrix)::HYPRE_Int
end

function HYPRE_MappedMatrixAssemble(matrix)
    return @ccall libHYPRE.HYPRE_MappedMatrixAssemble(matrix::HYPRE_MappedMatrix)::HYPRE_Int
end

function HYPRE_MappedMatrixPrint(matrix)
    return @ccall libHYPRE.HYPRE_MappedMatrixPrint(matrix::HYPRE_MappedMatrix)::Cvoid
end

function HYPRE_MappedMatrixGetColIndex(matrix, j)
    return @ccall libHYPRE.HYPRE_MappedMatrixGetColIndex(matrix::HYPRE_MappedMatrix, j::HYPRE_Int)::HYPRE_Int
end

function HYPRE_MappedMatrixGetMatrix(matrix)
    return @ccall libHYPRE.HYPRE_MappedMatrixGetMatrix(matrix::HYPRE_MappedMatrix)::Ptr{Cvoid}
end

function HYPRE_MappedMatrixSetMatrix(matrix, matrix_data)
    return @ccall libHYPRE.HYPRE_MappedMatrixSetMatrix(matrix::HYPRE_MappedMatrix, matrix_data::Ptr{Cvoid})::HYPRE_Int
end

function HYPRE_MappedMatrixSetColMap(matrix, ColMap)
    return @ccall libHYPRE.HYPRE_MappedMatrixSetColMap(matrix::HYPRE_MappedMatrix, ColMap::Ptr{Cvoid})::HYPRE_Int
end

function HYPRE_MappedMatrixSetMapData(matrix, MapData)
    return @ccall libHYPRE.HYPRE_MappedMatrixSetMapData(matrix::HYPRE_MappedMatrix, MapData::Ptr{Cvoid})::HYPRE_Int
end

function HYPRE_MultiblockMatrixCreate()
    return @ccall libHYPRE.HYPRE_MultiblockMatrixCreate()::HYPRE_MultiblockMatrix
end

function HYPRE_MultiblockMatrixDestroy(matrix)
    return @ccall libHYPRE.HYPRE_MultiblockMatrixDestroy(matrix::HYPRE_MultiblockMatrix)::HYPRE_Int
end

function HYPRE_MultiblockMatrixLimitedDestroy(matrix)
    return @ccall libHYPRE.HYPRE_MultiblockMatrixLimitedDestroy(matrix::HYPRE_MultiblockMatrix)::HYPRE_Int
end

function HYPRE_MultiblockMatrixInitialize(matrix)
    return @ccall libHYPRE.HYPRE_MultiblockMatrixInitialize(matrix::HYPRE_MultiblockMatrix)::HYPRE_Int
end

function HYPRE_MultiblockMatrixAssemble(matrix)
    return @ccall libHYPRE.HYPRE_MultiblockMatrixAssemble(matrix::HYPRE_MultiblockMatrix)::HYPRE_Int
end

function HYPRE_MultiblockMatrixPrint(matrix)
    return @ccall libHYPRE.HYPRE_MultiblockMatrixPrint(matrix::HYPRE_MultiblockMatrix)::Cvoid
end

function HYPRE_MultiblockMatrixSetNumSubmatrices(matrix, n)
    return @ccall libHYPRE.HYPRE_MultiblockMatrixSetNumSubmatrices(matrix::HYPRE_MultiblockMatrix, n::HYPRE_Int)::HYPRE_Int
end

function HYPRE_MultiblockMatrixSetSubmatrixType(matrix, j, type)
    return @ccall libHYPRE.HYPRE_MultiblockMatrixSetSubmatrixType(matrix::HYPRE_MultiblockMatrix, j::HYPRE_Int, type::HYPRE_Int)::HYPRE_Int
end

function HYPRE_VectorCreate(size)
    return @ccall libHYPRE.HYPRE_VectorCreate(size::HYPRE_Int)::HYPRE_Vector
end

function HYPRE_VectorDestroy(vector)
    return @ccall libHYPRE.HYPRE_VectorDestroy(vector::HYPRE_Vector)::HYPRE_Int
end

function HYPRE_VectorInitialize(vector)
    return @ccall libHYPRE.HYPRE_VectorInitialize(vector::HYPRE_Vector)::HYPRE_Int
end

function HYPRE_VectorPrint(vector, file_name)
    return @ccall libHYPRE.HYPRE_VectorPrint(vector::HYPRE_Vector, file_name::Ptr{Cchar})::HYPRE_Int
end

function HYPRE_VectorRead(file_name)
    return @ccall libHYPRE.HYPRE_VectorRead(file_name::Ptr{Cchar})::HYPRE_Vector
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
    return @ccall libHYPRE.HYPRE_ParCSRMatrixCreate(comm::MPI_Comm, global_num_rows::HYPRE_BigInt, global_num_cols::HYPRE_BigInt, row_starts::Ptr{HYPRE_BigInt}, col_starts::Ptr{HYPRE_BigInt}, num_cols_offd::HYPRE_Int, num_nonzeros_diag::HYPRE_Int, num_nonzeros_offd::HYPRE_Int, matrix::Ptr{HYPRE_ParCSRMatrix})::HYPRE_Int
end

function HYPRE_ParCSRMatrixDestroy(matrix)
    return @ccall libHYPRE.HYPRE_ParCSRMatrixDestroy(matrix::HYPRE_ParCSRMatrix)::HYPRE_Int
end

function HYPRE_ParCSRMatrixInitialize(matrix)
    return @ccall libHYPRE.HYPRE_ParCSRMatrixInitialize(matrix::HYPRE_ParCSRMatrix)::HYPRE_Int
end

function HYPRE_ParCSRMatrixRead(comm, file_name, matrix)
    return @ccall libHYPRE.HYPRE_ParCSRMatrixRead(comm::MPI_Comm, file_name::Ptr{Cchar}, matrix::Ptr{HYPRE_ParCSRMatrix})::HYPRE_Int
end

function HYPRE_ParCSRMatrixPrint(matrix, file_name)
    return @ccall libHYPRE.HYPRE_ParCSRMatrixPrint(matrix::HYPRE_ParCSRMatrix, file_name::Ptr{Cchar})::HYPRE_Int
end

function HYPRE_ParCSRMatrixGetComm(matrix, comm)
    return @ccall libHYPRE.HYPRE_ParCSRMatrixGetComm(matrix::HYPRE_ParCSRMatrix, comm::Ptr{MPI_Comm})::HYPRE_Int
end

function HYPRE_ParCSRMatrixGetDims(matrix, M, N)
    return @ccall libHYPRE.HYPRE_ParCSRMatrixGetDims(matrix::HYPRE_ParCSRMatrix, M::Ptr{HYPRE_BigInt}, N::Ptr{HYPRE_BigInt})::HYPRE_Int
end

function HYPRE_ParCSRMatrixGetRowPartitioning(matrix, row_partitioning_ptr)
    return @ccall libHYPRE.HYPRE_ParCSRMatrixGetRowPartitioning(matrix::HYPRE_ParCSRMatrix, row_partitioning_ptr::Ptr{Ptr{HYPRE_BigInt}})::HYPRE_Int
end

function HYPRE_ParCSRMatrixGetColPartitioning(matrix, col_partitioning_ptr)
    return @ccall libHYPRE.HYPRE_ParCSRMatrixGetColPartitioning(matrix::HYPRE_ParCSRMatrix, col_partitioning_ptr::Ptr{Ptr{HYPRE_BigInt}})::HYPRE_Int
end

function HYPRE_ParCSRMatrixGetLocalRange(matrix, row_start, row_end, col_start, col_end)
    return @ccall libHYPRE.HYPRE_ParCSRMatrixGetLocalRange(matrix::HYPRE_ParCSRMatrix, row_start::Ptr{HYPRE_BigInt}, row_end::Ptr{HYPRE_BigInt}, col_start::Ptr{HYPRE_BigInt}, col_end::Ptr{HYPRE_BigInt})::HYPRE_Int
end

function HYPRE_ParCSRMatrixGetRow(matrix, row, size, col_ind, values)
    return @ccall libHYPRE.HYPRE_ParCSRMatrixGetRow(matrix::HYPRE_ParCSRMatrix, row::HYPRE_BigInt, size::Ptr{HYPRE_Int}, col_ind::Ptr{Ptr{HYPRE_BigInt}}, values::Ptr{Ptr{HYPRE_Complex}})::HYPRE_Int
end

function HYPRE_ParCSRMatrixRestoreRow(matrix, row, size, col_ind, values)
    return @ccall libHYPRE.HYPRE_ParCSRMatrixRestoreRow(matrix::HYPRE_ParCSRMatrix, row::HYPRE_BigInt, size::Ptr{HYPRE_Int}, col_ind::Ptr{Ptr{HYPRE_BigInt}}, values::Ptr{Ptr{HYPRE_Complex}})::HYPRE_Int
end

function HYPRE_CSRMatrixToParCSRMatrix(comm, A_CSR, row_partitioning, col_partitioning, matrix)
    return @ccall libHYPRE.HYPRE_CSRMatrixToParCSRMatrix(comm::MPI_Comm, A_CSR::HYPRE_CSRMatrix, row_partitioning::Ptr{HYPRE_BigInt}, col_partitioning::Ptr{HYPRE_BigInt}, matrix::Ptr{HYPRE_ParCSRMatrix})::HYPRE_Int
end

function HYPRE_ParCSRMatrixMatvec(alpha, A, x, beta, y)
    return @ccall libHYPRE.HYPRE_ParCSRMatrixMatvec(alpha::HYPRE_Complex, A::HYPRE_ParCSRMatrix, x::HYPRE_ParVector, beta::HYPRE_Complex, y::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_ParCSRMatrixMatvecT(alpha, A, x, beta, y)
    return @ccall libHYPRE.HYPRE_ParCSRMatrixMatvecT(alpha::HYPRE_Complex, A::HYPRE_ParCSRMatrix, x::HYPRE_ParVector, beta::HYPRE_Complex, y::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_ParVectorCreate(comm, global_size, partitioning, vector)
    return @ccall libHYPRE.HYPRE_ParVectorCreate(comm::MPI_Comm, global_size::HYPRE_BigInt, partitioning::Ptr{HYPRE_BigInt}, vector::Ptr{HYPRE_ParVector})::HYPRE_Int
end

function HYPRE_ParVectorDestroy(vector)
    return @ccall libHYPRE.HYPRE_ParVectorDestroy(vector::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_ParVectorInitialize(vector)
    return @ccall libHYPRE.HYPRE_ParVectorInitialize(vector::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_ParVectorRead(comm, file_name, vector)
    return @ccall libHYPRE.HYPRE_ParVectorRead(comm::MPI_Comm, file_name::Ptr{Cchar}, vector::Ptr{HYPRE_ParVector})::HYPRE_Int
end

function HYPRE_ParVectorPrint(vector, file_name)
    return @ccall libHYPRE.HYPRE_ParVectorPrint(vector::HYPRE_ParVector, file_name::Ptr{Cchar})::HYPRE_Int
end

function HYPRE_ParVectorSetConstantValues(vector, value)
    return @ccall libHYPRE.HYPRE_ParVectorSetConstantValues(vector::HYPRE_ParVector, value::HYPRE_Complex)::HYPRE_Int
end

function HYPRE_ParVectorSetRandomValues(vector, seed)
    return @ccall libHYPRE.HYPRE_ParVectorSetRandomValues(vector::HYPRE_ParVector, seed::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParVectorCopy(x, y)
    return @ccall libHYPRE.HYPRE_ParVectorCopy(x::HYPRE_ParVector, y::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_ParVectorScale(value, x)
    return @ccall libHYPRE.HYPRE_ParVectorScale(value::HYPRE_Complex, x::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_ParVectorInnerProd(x, y, prod)
    return @ccall libHYPRE.HYPRE_ParVectorInnerProd(x::HYPRE_ParVector, y::HYPRE_ParVector, prod::Ptr{HYPRE_Real})::HYPRE_Int
end

function HYPRE_VectorToParVector(comm, b, partitioning, vector)
    return @ccall libHYPRE.HYPRE_VectorToParVector(comm::MPI_Comm, b::HYPRE_Vector, partitioning::Ptr{HYPRE_BigInt}, vector::Ptr{HYPRE_ParVector})::HYPRE_Int
end

function HYPRE_ParVectorGetValues(vector, num_values, indices, values)
    return @ccall libHYPRE.HYPRE_ParVectorGetValues(vector::HYPRE_ParVector, num_values::HYPRE_Int, indices::Ptr{HYPRE_BigInt}, values::Ptr{HYPRE_Complex})::HYPRE_Int
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
    return @ccall libHYPRE.HYPRE_PCGSetup(solver::HYPRE_Solver, A::HYPRE_Matrix, b::HYPRE_Vector, x::HYPRE_Vector)::HYPRE_Int
end

function HYPRE_PCGSolve(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_PCGSolve(solver::HYPRE_Solver, A::HYPRE_Matrix, b::HYPRE_Vector, x::HYPRE_Vector)::HYPRE_Int
end

function HYPRE_PCGSetTol(solver, tol)
    return @ccall libHYPRE.HYPRE_PCGSetTol(solver::HYPRE_Solver, tol::HYPRE_Real)::HYPRE_Int
end

function HYPRE_PCGSetAbsoluteTol(solver, a_tol)
    return @ccall libHYPRE.HYPRE_PCGSetAbsoluteTol(solver::HYPRE_Solver, a_tol::HYPRE_Real)::HYPRE_Int
end

function HYPRE_PCGSetResidualTol(solver, rtol)
    return @ccall libHYPRE.HYPRE_PCGSetResidualTol(solver::HYPRE_Solver, rtol::HYPRE_Real)::HYPRE_Int
end

function HYPRE_PCGSetAbsoluteTolFactor(solver, abstolf)
    return @ccall libHYPRE.HYPRE_PCGSetAbsoluteTolFactor(solver::HYPRE_Solver, abstolf::HYPRE_Real)::HYPRE_Int
end

function HYPRE_PCGSetConvergenceFactorTol(solver, cf_tol)
    return @ccall libHYPRE.HYPRE_PCGSetConvergenceFactorTol(solver::HYPRE_Solver, cf_tol::HYPRE_Real)::HYPRE_Int
end

function HYPRE_PCGSetStopCrit(solver, stop_crit)
    return @ccall libHYPRE.HYPRE_PCGSetStopCrit(solver::HYPRE_Solver, stop_crit::HYPRE_Int)::HYPRE_Int
end

function HYPRE_PCGSetMaxIter(solver, max_iter)
    return @ccall libHYPRE.HYPRE_PCGSetMaxIter(solver::HYPRE_Solver, max_iter::HYPRE_Int)::HYPRE_Int
end

function HYPRE_PCGSetTwoNorm(solver, two_norm)
    return @ccall libHYPRE.HYPRE_PCGSetTwoNorm(solver::HYPRE_Solver, two_norm::HYPRE_Int)::HYPRE_Int
end

function HYPRE_PCGSetRelChange(solver, rel_change)
    return @ccall libHYPRE.HYPRE_PCGSetRelChange(solver::HYPRE_Solver, rel_change::HYPRE_Int)::HYPRE_Int
end

function HYPRE_PCGSetRecomputeResidual(solver, recompute_residual)
    return @ccall libHYPRE.HYPRE_PCGSetRecomputeResidual(solver::HYPRE_Solver, recompute_residual::HYPRE_Int)::HYPRE_Int
end

function HYPRE_PCGSetRecomputeResidualP(solver, recompute_residual_p)
    return @ccall libHYPRE.HYPRE_PCGSetRecomputeResidualP(solver::HYPRE_Solver, recompute_residual_p::HYPRE_Int)::HYPRE_Int
end

function HYPRE_PCGSetPrecond(solver, precond, precond_setup, precond_solver)
    return @ccall libHYPRE.HYPRE_PCGSetPrecond(solver::HYPRE_Solver, precond::HYPRE_PtrToSolverFcn, precond_setup::HYPRE_PtrToSolverFcn, precond_solver::HYPRE_Solver)::HYPRE_Int
end

function HYPRE_PCGSetLogging(solver, logging)
    return @ccall libHYPRE.HYPRE_PCGSetLogging(solver::HYPRE_Solver, logging::HYPRE_Int)::HYPRE_Int
end

function HYPRE_PCGSetPrintLevel(solver, level)
    return @ccall libHYPRE.HYPRE_PCGSetPrintLevel(solver::HYPRE_Solver, level::HYPRE_Int)::HYPRE_Int
end

function HYPRE_PCGGetNumIterations(solver, num_iterations)
    return @ccall libHYPRE.HYPRE_PCGGetNumIterations(solver::HYPRE_Solver, num_iterations::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_PCGGetFinalRelativeResidualNorm(solver, norm)
    return @ccall libHYPRE.HYPRE_PCGGetFinalRelativeResidualNorm(solver::HYPRE_Solver, norm::Ptr{HYPRE_Real})::HYPRE_Int
end

function HYPRE_PCGGetResidual(solver, residual)
    return @ccall libHYPRE.HYPRE_PCGGetResidual(solver::HYPRE_Solver, residual::Ptr{Cvoid})::HYPRE_Int
end

function HYPRE_PCGGetTol(solver, tol)
    return @ccall libHYPRE.HYPRE_PCGGetTol(solver::HYPRE_Solver, tol::Ptr{HYPRE_Real})::HYPRE_Int
end

function HYPRE_PCGGetResidualTol(solver, rtol)
    return @ccall libHYPRE.HYPRE_PCGGetResidualTol(solver::HYPRE_Solver, rtol::Ptr{HYPRE_Real})::HYPRE_Int
end

function HYPRE_PCGGetAbsoluteTolFactor(solver, abstolf)
    return @ccall libHYPRE.HYPRE_PCGGetAbsoluteTolFactor(solver::HYPRE_Solver, abstolf::Ptr{HYPRE_Real})::HYPRE_Int
end

function HYPRE_PCGGetConvergenceFactorTol(solver, cf_tol)
    return @ccall libHYPRE.HYPRE_PCGGetConvergenceFactorTol(solver::HYPRE_Solver, cf_tol::Ptr{HYPRE_Real})::HYPRE_Int
end

function HYPRE_PCGGetStopCrit(solver, stop_crit)
    return @ccall libHYPRE.HYPRE_PCGGetStopCrit(solver::HYPRE_Solver, stop_crit::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_PCGGetMaxIter(solver, max_iter)
    return @ccall libHYPRE.HYPRE_PCGGetMaxIter(solver::HYPRE_Solver, max_iter::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_PCGGetTwoNorm(solver, two_norm)
    return @ccall libHYPRE.HYPRE_PCGGetTwoNorm(solver::HYPRE_Solver, two_norm::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_PCGGetRelChange(solver, rel_change)
    return @ccall libHYPRE.HYPRE_PCGGetRelChange(solver::HYPRE_Solver, rel_change::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_GMRESGetSkipRealResidualCheck(solver, skip_real_r_check)
    return @ccall libHYPRE.HYPRE_GMRESGetSkipRealResidualCheck(solver::HYPRE_Solver, skip_real_r_check::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_PCGGetPrecond(solver, precond_data_ptr)
    return @ccall libHYPRE.HYPRE_PCGGetPrecond(solver::HYPRE_Solver, precond_data_ptr::Ptr{HYPRE_Solver})::HYPRE_Int
end

function HYPRE_PCGGetLogging(solver, level)
    return @ccall libHYPRE.HYPRE_PCGGetLogging(solver::HYPRE_Solver, level::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_PCGGetPrintLevel(solver, level)
    return @ccall libHYPRE.HYPRE_PCGGetPrintLevel(solver::HYPRE_Solver, level::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_PCGGetConverged(solver, converged)
    return @ccall libHYPRE.HYPRE_PCGGetConverged(solver::HYPRE_Solver, converged::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_GMRESSetup(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_GMRESSetup(solver::HYPRE_Solver, A::HYPRE_Matrix, b::HYPRE_Vector, x::HYPRE_Vector)::HYPRE_Int
end

function HYPRE_GMRESSolve(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_GMRESSolve(solver::HYPRE_Solver, A::HYPRE_Matrix, b::HYPRE_Vector, x::HYPRE_Vector)::HYPRE_Int
end

function HYPRE_GMRESSetTol(solver, tol)
    return @ccall libHYPRE.HYPRE_GMRESSetTol(solver::HYPRE_Solver, tol::HYPRE_Real)::HYPRE_Int
end

function HYPRE_GMRESSetAbsoluteTol(solver, a_tol)
    return @ccall libHYPRE.HYPRE_GMRESSetAbsoluteTol(solver::HYPRE_Solver, a_tol::HYPRE_Real)::HYPRE_Int
end

function HYPRE_GMRESSetConvergenceFactorTol(solver, cf_tol)
    return @ccall libHYPRE.HYPRE_GMRESSetConvergenceFactorTol(solver::HYPRE_Solver, cf_tol::HYPRE_Real)::HYPRE_Int
end

function HYPRE_GMRESSetStopCrit(solver, stop_crit)
    return @ccall libHYPRE.HYPRE_GMRESSetStopCrit(solver::HYPRE_Solver, stop_crit::HYPRE_Int)::HYPRE_Int
end

function HYPRE_GMRESSetMinIter(solver, min_iter)
    return @ccall libHYPRE.HYPRE_GMRESSetMinIter(solver::HYPRE_Solver, min_iter::HYPRE_Int)::HYPRE_Int
end

function HYPRE_GMRESSetMaxIter(solver, max_iter)
    return @ccall libHYPRE.HYPRE_GMRESSetMaxIter(solver::HYPRE_Solver, max_iter::HYPRE_Int)::HYPRE_Int
end

function HYPRE_GMRESSetKDim(solver, k_dim)
    return @ccall libHYPRE.HYPRE_GMRESSetKDim(solver::HYPRE_Solver, k_dim::HYPRE_Int)::HYPRE_Int
end

function HYPRE_GMRESSetRelChange(solver, rel_change)
    return @ccall libHYPRE.HYPRE_GMRESSetRelChange(solver::HYPRE_Solver, rel_change::HYPRE_Int)::HYPRE_Int
end

function HYPRE_GMRESSetSkipRealResidualCheck(solver, skip_real_r_check)
    return @ccall libHYPRE.HYPRE_GMRESSetSkipRealResidualCheck(solver::HYPRE_Solver, skip_real_r_check::HYPRE_Int)::HYPRE_Int
end

function HYPRE_GMRESSetPrecond(solver, precond, precond_setup, precond_solver)
    return @ccall libHYPRE.HYPRE_GMRESSetPrecond(solver::HYPRE_Solver, precond::HYPRE_PtrToSolverFcn, precond_setup::HYPRE_PtrToSolverFcn, precond_solver::HYPRE_Solver)::HYPRE_Int
end

function HYPRE_GMRESSetLogging(solver, logging)
    return @ccall libHYPRE.HYPRE_GMRESSetLogging(solver::HYPRE_Solver, logging::HYPRE_Int)::HYPRE_Int
end

function HYPRE_GMRESSetPrintLevel(solver, level)
    return @ccall libHYPRE.HYPRE_GMRESSetPrintLevel(solver::HYPRE_Solver, level::HYPRE_Int)::HYPRE_Int
end

function HYPRE_GMRESGetNumIterations(solver, num_iterations)
    return @ccall libHYPRE.HYPRE_GMRESGetNumIterations(solver::HYPRE_Solver, num_iterations::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_GMRESGetFinalRelativeResidualNorm(solver, norm)
    return @ccall libHYPRE.HYPRE_GMRESGetFinalRelativeResidualNorm(solver::HYPRE_Solver, norm::Ptr{HYPRE_Real})::HYPRE_Int
end

function HYPRE_GMRESGetResidual(solver, residual)
    return @ccall libHYPRE.HYPRE_GMRESGetResidual(solver::HYPRE_Solver, residual::Ptr{Cvoid})::HYPRE_Int
end

function HYPRE_GMRESGetTol(solver, tol)
    return @ccall libHYPRE.HYPRE_GMRESGetTol(solver::HYPRE_Solver, tol::Ptr{HYPRE_Real})::HYPRE_Int
end

function HYPRE_GMRESGetAbsoluteTol(solver, tol)
    return @ccall libHYPRE.HYPRE_GMRESGetAbsoluteTol(solver::HYPRE_Solver, tol::Ptr{HYPRE_Real})::HYPRE_Int
end

function HYPRE_GMRESGetConvergenceFactorTol(solver, cf_tol)
    return @ccall libHYPRE.HYPRE_GMRESGetConvergenceFactorTol(solver::HYPRE_Solver, cf_tol::Ptr{HYPRE_Real})::HYPRE_Int
end

function HYPRE_GMRESGetStopCrit(solver, stop_crit)
    return @ccall libHYPRE.HYPRE_GMRESGetStopCrit(solver::HYPRE_Solver, stop_crit::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_GMRESGetMinIter(solver, min_iter)
    return @ccall libHYPRE.HYPRE_GMRESGetMinIter(solver::HYPRE_Solver, min_iter::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_GMRESGetMaxIter(solver, max_iter)
    return @ccall libHYPRE.HYPRE_GMRESGetMaxIter(solver::HYPRE_Solver, max_iter::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_GMRESGetKDim(solver, k_dim)
    return @ccall libHYPRE.HYPRE_GMRESGetKDim(solver::HYPRE_Solver, k_dim::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_GMRESGetRelChange(solver, rel_change)
    return @ccall libHYPRE.HYPRE_GMRESGetRelChange(solver::HYPRE_Solver, rel_change::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_GMRESGetPrecond(solver, precond_data_ptr)
    return @ccall libHYPRE.HYPRE_GMRESGetPrecond(solver::HYPRE_Solver, precond_data_ptr::Ptr{HYPRE_Solver})::HYPRE_Int
end

function HYPRE_GMRESGetLogging(solver, level)
    return @ccall libHYPRE.HYPRE_GMRESGetLogging(solver::HYPRE_Solver, level::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_GMRESGetPrintLevel(solver, level)
    return @ccall libHYPRE.HYPRE_GMRESGetPrintLevel(solver::HYPRE_Solver, level::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_GMRESGetConverged(solver, converged)
    return @ccall libHYPRE.HYPRE_GMRESGetConverged(solver::HYPRE_Solver, converged::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_FlexGMRESSetup(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_FlexGMRESSetup(solver::HYPRE_Solver, A::HYPRE_Matrix, b::HYPRE_Vector, x::HYPRE_Vector)::HYPRE_Int
end

function HYPRE_FlexGMRESSolve(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_FlexGMRESSolve(solver::HYPRE_Solver, A::HYPRE_Matrix, b::HYPRE_Vector, x::HYPRE_Vector)::HYPRE_Int
end

function HYPRE_FlexGMRESSetTol(solver, tol)
    return @ccall libHYPRE.HYPRE_FlexGMRESSetTol(solver::HYPRE_Solver, tol::HYPRE_Real)::HYPRE_Int
end

function HYPRE_FlexGMRESSetAbsoluteTol(solver, a_tol)
    return @ccall libHYPRE.HYPRE_FlexGMRESSetAbsoluteTol(solver::HYPRE_Solver, a_tol::HYPRE_Real)::HYPRE_Int
end

function HYPRE_FlexGMRESSetConvergenceFactorTol(solver, cf_tol)
    return @ccall libHYPRE.HYPRE_FlexGMRESSetConvergenceFactorTol(solver::HYPRE_Solver, cf_tol::HYPRE_Real)::HYPRE_Int
end

function HYPRE_FlexGMRESSetMinIter(solver, min_iter)
    return @ccall libHYPRE.HYPRE_FlexGMRESSetMinIter(solver::HYPRE_Solver, min_iter::HYPRE_Int)::HYPRE_Int
end

function HYPRE_FlexGMRESSetMaxIter(solver, max_iter)
    return @ccall libHYPRE.HYPRE_FlexGMRESSetMaxIter(solver::HYPRE_Solver, max_iter::HYPRE_Int)::HYPRE_Int
end

function HYPRE_FlexGMRESSetKDim(solver, k_dim)
    return @ccall libHYPRE.HYPRE_FlexGMRESSetKDim(solver::HYPRE_Solver, k_dim::HYPRE_Int)::HYPRE_Int
end

function HYPRE_FlexGMRESSetPrecond(solver, precond, precond_setup, precond_solver)
    return @ccall libHYPRE.HYPRE_FlexGMRESSetPrecond(solver::HYPRE_Solver, precond::HYPRE_PtrToSolverFcn, precond_setup::HYPRE_PtrToSolverFcn, precond_solver::HYPRE_Solver)::HYPRE_Int
end

function HYPRE_FlexGMRESSetLogging(solver, logging)
    return @ccall libHYPRE.HYPRE_FlexGMRESSetLogging(solver::HYPRE_Solver, logging::HYPRE_Int)::HYPRE_Int
end

function HYPRE_FlexGMRESSetPrintLevel(solver, level)
    return @ccall libHYPRE.HYPRE_FlexGMRESSetPrintLevel(solver::HYPRE_Solver, level::HYPRE_Int)::HYPRE_Int
end

function HYPRE_FlexGMRESGetNumIterations(solver, num_iterations)
    return @ccall libHYPRE.HYPRE_FlexGMRESGetNumIterations(solver::HYPRE_Solver, num_iterations::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_FlexGMRESGetFinalRelativeResidualNorm(solver, norm)
    return @ccall libHYPRE.HYPRE_FlexGMRESGetFinalRelativeResidualNorm(solver::HYPRE_Solver, norm::Ptr{HYPRE_Real})::HYPRE_Int
end

function HYPRE_FlexGMRESGetResidual(solver, residual)
    return @ccall libHYPRE.HYPRE_FlexGMRESGetResidual(solver::HYPRE_Solver, residual::Ptr{Cvoid})::HYPRE_Int
end

function HYPRE_FlexGMRESGetTol(solver, tol)
    return @ccall libHYPRE.HYPRE_FlexGMRESGetTol(solver::HYPRE_Solver, tol::Ptr{HYPRE_Real})::HYPRE_Int
end

function HYPRE_FlexGMRESGetConvergenceFactorTol(solver, cf_tol)
    return @ccall libHYPRE.HYPRE_FlexGMRESGetConvergenceFactorTol(solver::HYPRE_Solver, cf_tol::Ptr{HYPRE_Real})::HYPRE_Int
end

function HYPRE_FlexGMRESGetStopCrit(solver, stop_crit)
    return @ccall libHYPRE.HYPRE_FlexGMRESGetStopCrit(solver::HYPRE_Solver, stop_crit::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_FlexGMRESGetMinIter(solver, min_iter)
    return @ccall libHYPRE.HYPRE_FlexGMRESGetMinIter(solver::HYPRE_Solver, min_iter::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_FlexGMRESGetMaxIter(solver, max_iter)
    return @ccall libHYPRE.HYPRE_FlexGMRESGetMaxIter(solver::HYPRE_Solver, max_iter::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_FlexGMRESGetKDim(solver, k_dim)
    return @ccall libHYPRE.HYPRE_FlexGMRESGetKDim(solver::HYPRE_Solver, k_dim::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_FlexGMRESGetPrecond(solver, precond_data_ptr)
    return @ccall libHYPRE.HYPRE_FlexGMRESGetPrecond(solver::HYPRE_Solver, precond_data_ptr::Ptr{HYPRE_Solver})::HYPRE_Int
end

function HYPRE_FlexGMRESGetLogging(solver, level)
    return @ccall libHYPRE.HYPRE_FlexGMRESGetLogging(solver::HYPRE_Solver, level::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_FlexGMRESGetPrintLevel(solver, level)
    return @ccall libHYPRE.HYPRE_FlexGMRESGetPrintLevel(solver::HYPRE_Solver, level::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_FlexGMRESGetConverged(solver, converged)
    return @ccall libHYPRE.HYPRE_FlexGMRESGetConverged(solver::HYPRE_Solver, converged::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_FlexGMRESSetModifyPC(solver, modify_pc)
    return @ccall libHYPRE.HYPRE_FlexGMRESSetModifyPC(solver::HYPRE_Solver, modify_pc::HYPRE_PtrToModifyPCFcn)::HYPRE_Int
end

function HYPRE_LGMRESSetup(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_LGMRESSetup(solver::HYPRE_Solver, A::HYPRE_Matrix, b::HYPRE_Vector, x::HYPRE_Vector)::HYPRE_Int
end

function HYPRE_LGMRESSolve(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_LGMRESSolve(solver::HYPRE_Solver, A::HYPRE_Matrix, b::HYPRE_Vector, x::HYPRE_Vector)::HYPRE_Int
end

function HYPRE_LGMRESSetTol(solver, tol)
    return @ccall libHYPRE.HYPRE_LGMRESSetTol(solver::HYPRE_Solver, tol::HYPRE_Real)::HYPRE_Int
end

function HYPRE_LGMRESSetAbsoluteTol(solver, a_tol)
    return @ccall libHYPRE.HYPRE_LGMRESSetAbsoluteTol(solver::HYPRE_Solver, a_tol::HYPRE_Real)::HYPRE_Int
end

function HYPRE_LGMRESSetConvergenceFactorTol(solver, cf_tol)
    return @ccall libHYPRE.HYPRE_LGMRESSetConvergenceFactorTol(solver::HYPRE_Solver, cf_tol::HYPRE_Real)::HYPRE_Int
end

function HYPRE_LGMRESSetMinIter(solver, min_iter)
    return @ccall libHYPRE.HYPRE_LGMRESSetMinIter(solver::HYPRE_Solver, min_iter::HYPRE_Int)::HYPRE_Int
end

function HYPRE_LGMRESSetMaxIter(solver, max_iter)
    return @ccall libHYPRE.HYPRE_LGMRESSetMaxIter(solver::HYPRE_Solver, max_iter::HYPRE_Int)::HYPRE_Int
end

function HYPRE_LGMRESSetKDim(solver, k_dim)
    return @ccall libHYPRE.HYPRE_LGMRESSetKDim(solver::HYPRE_Solver, k_dim::HYPRE_Int)::HYPRE_Int
end

function HYPRE_LGMRESSetAugDim(solver, aug_dim)
    return @ccall libHYPRE.HYPRE_LGMRESSetAugDim(solver::HYPRE_Solver, aug_dim::HYPRE_Int)::HYPRE_Int
end

function HYPRE_LGMRESSetPrecond(solver, precond, precond_setup, precond_solver)
    return @ccall libHYPRE.HYPRE_LGMRESSetPrecond(solver::HYPRE_Solver, precond::HYPRE_PtrToSolverFcn, precond_setup::HYPRE_PtrToSolverFcn, precond_solver::HYPRE_Solver)::HYPRE_Int
end

function HYPRE_LGMRESSetLogging(solver, logging)
    return @ccall libHYPRE.HYPRE_LGMRESSetLogging(solver::HYPRE_Solver, logging::HYPRE_Int)::HYPRE_Int
end

function HYPRE_LGMRESSetPrintLevel(solver, level)
    return @ccall libHYPRE.HYPRE_LGMRESSetPrintLevel(solver::HYPRE_Solver, level::HYPRE_Int)::HYPRE_Int
end

function HYPRE_LGMRESGetNumIterations(solver, num_iterations)
    return @ccall libHYPRE.HYPRE_LGMRESGetNumIterations(solver::HYPRE_Solver, num_iterations::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_LGMRESGetFinalRelativeResidualNorm(solver, norm)
    return @ccall libHYPRE.HYPRE_LGMRESGetFinalRelativeResidualNorm(solver::HYPRE_Solver, norm::Ptr{HYPRE_Real})::HYPRE_Int
end

function HYPRE_LGMRESGetResidual(solver, residual)
    return @ccall libHYPRE.HYPRE_LGMRESGetResidual(solver::HYPRE_Solver, residual::Ptr{Cvoid})::HYPRE_Int
end

function HYPRE_LGMRESGetTol(solver, tol)
    return @ccall libHYPRE.HYPRE_LGMRESGetTol(solver::HYPRE_Solver, tol::Ptr{HYPRE_Real})::HYPRE_Int
end

function HYPRE_LGMRESGetConvergenceFactorTol(solver, cf_tol)
    return @ccall libHYPRE.HYPRE_LGMRESGetConvergenceFactorTol(solver::HYPRE_Solver, cf_tol::Ptr{HYPRE_Real})::HYPRE_Int
end

function HYPRE_LGMRESGetStopCrit(solver, stop_crit)
    return @ccall libHYPRE.HYPRE_LGMRESGetStopCrit(solver::HYPRE_Solver, stop_crit::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_LGMRESGetMinIter(solver, min_iter)
    return @ccall libHYPRE.HYPRE_LGMRESGetMinIter(solver::HYPRE_Solver, min_iter::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_LGMRESGetMaxIter(solver, max_iter)
    return @ccall libHYPRE.HYPRE_LGMRESGetMaxIter(solver::HYPRE_Solver, max_iter::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_LGMRESGetKDim(solver, k_dim)
    return @ccall libHYPRE.HYPRE_LGMRESGetKDim(solver::HYPRE_Solver, k_dim::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_LGMRESGetAugDim(solver, k_dim)
    return @ccall libHYPRE.HYPRE_LGMRESGetAugDim(solver::HYPRE_Solver, k_dim::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_LGMRESGetPrecond(solver, precond_data_ptr)
    return @ccall libHYPRE.HYPRE_LGMRESGetPrecond(solver::HYPRE_Solver, precond_data_ptr::Ptr{HYPRE_Solver})::HYPRE_Int
end

function HYPRE_LGMRESGetLogging(solver, level)
    return @ccall libHYPRE.HYPRE_LGMRESGetLogging(solver::HYPRE_Solver, level::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_LGMRESGetPrintLevel(solver, level)
    return @ccall libHYPRE.HYPRE_LGMRESGetPrintLevel(solver::HYPRE_Solver, level::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_LGMRESGetConverged(solver, converged)
    return @ccall libHYPRE.HYPRE_LGMRESGetConverged(solver::HYPRE_Solver, converged::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_COGMRESSetup(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_COGMRESSetup(solver::HYPRE_Solver, A::HYPRE_Matrix, b::HYPRE_Vector, x::HYPRE_Vector)::HYPRE_Int
end

function HYPRE_COGMRESSolve(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_COGMRESSolve(solver::HYPRE_Solver, A::HYPRE_Matrix, b::HYPRE_Vector, x::HYPRE_Vector)::HYPRE_Int
end

function HYPRE_COGMRESSetTol(solver, tol)
    return @ccall libHYPRE.HYPRE_COGMRESSetTol(solver::HYPRE_Solver, tol::HYPRE_Real)::HYPRE_Int
end

function HYPRE_COGMRESSetAbsoluteTol(solver, a_tol)
    return @ccall libHYPRE.HYPRE_COGMRESSetAbsoluteTol(solver::HYPRE_Solver, a_tol::HYPRE_Real)::HYPRE_Int
end

function HYPRE_COGMRESSetConvergenceFactorTol(solver, cf_tol)
    return @ccall libHYPRE.HYPRE_COGMRESSetConvergenceFactorTol(solver::HYPRE_Solver, cf_tol::HYPRE_Real)::HYPRE_Int
end

function HYPRE_COGMRESSetMinIter(solver, min_iter)
    return @ccall libHYPRE.HYPRE_COGMRESSetMinIter(solver::HYPRE_Solver, min_iter::HYPRE_Int)::HYPRE_Int
end

function HYPRE_COGMRESSetMaxIter(solver, max_iter)
    return @ccall libHYPRE.HYPRE_COGMRESSetMaxIter(solver::HYPRE_Solver, max_iter::HYPRE_Int)::HYPRE_Int
end

function HYPRE_COGMRESSetKDim(solver, k_dim)
    return @ccall libHYPRE.HYPRE_COGMRESSetKDim(solver::HYPRE_Solver, k_dim::HYPRE_Int)::HYPRE_Int
end

function HYPRE_COGMRESSetUnroll(solver, unroll)
    return @ccall libHYPRE.HYPRE_COGMRESSetUnroll(solver::HYPRE_Solver, unroll::HYPRE_Int)::HYPRE_Int
end

function HYPRE_COGMRESSetCGS(solver, cgs)
    return @ccall libHYPRE.HYPRE_COGMRESSetCGS(solver::HYPRE_Solver, cgs::HYPRE_Int)::HYPRE_Int
end

function HYPRE_COGMRESSetPrecond(solver, precond, precond_setup, precond_solver)
    return @ccall libHYPRE.HYPRE_COGMRESSetPrecond(solver::HYPRE_Solver, precond::HYPRE_PtrToSolverFcn, precond_setup::HYPRE_PtrToSolverFcn, precond_solver::HYPRE_Solver)::HYPRE_Int
end

function HYPRE_COGMRESSetLogging(solver, logging)
    return @ccall libHYPRE.HYPRE_COGMRESSetLogging(solver::HYPRE_Solver, logging::HYPRE_Int)::HYPRE_Int
end

function HYPRE_COGMRESSetPrintLevel(solver, level)
    return @ccall libHYPRE.HYPRE_COGMRESSetPrintLevel(solver::HYPRE_Solver, level::HYPRE_Int)::HYPRE_Int
end

function HYPRE_COGMRESGetNumIterations(solver, num_iterations)
    return @ccall libHYPRE.HYPRE_COGMRESGetNumIterations(solver::HYPRE_Solver, num_iterations::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_COGMRESGetFinalRelativeResidualNorm(solver, norm)
    return @ccall libHYPRE.HYPRE_COGMRESGetFinalRelativeResidualNorm(solver::HYPRE_Solver, norm::Ptr{HYPRE_Real})::HYPRE_Int
end

function HYPRE_COGMRESGetResidual(solver, residual)
    return @ccall libHYPRE.HYPRE_COGMRESGetResidual(solver::HYPRE_Solver, residual::Ptr{Cvoid})::HYPRE_Int
end

function HYPRE_COGMRESGetTol(solver, tol)
    return @ccall libHYPRE.HYPRE_COGMRESGetTol(solver::HYPRE_Solver, tol::Ptr{HYPRE_Real})::HYPRE_Int
end

function HYPRE_COGMRESGetConvergenceFactorTol(solver, cf_tol)
    return @ccall libHYPRE.HYPRE_COGMRESGetConvergenceFactorTol(solver::HYPRE_Solver, cf_tol::Ptr{HYPRE_Real})::HYPRE_Int
end

function HYPRE_COGMRESGetMinIter(solver, min_iter)
    return @ccall libHYPRE.HYPRE_COGMRESGetMinIter(solver::HYPRE_Solver, min_iter::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_COGMRESGetMaxIter(solver, max_iter)
    return @ccall libHYPRE.HYPRE_COGMRESGetMaxIter(solver::HYPRE_Solver, max_iter::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_COGMRESGetKDim(solver, k_dim)
    return @ccall libHYPRE.HYPRE_COGMRESGetKDim(solver::HYPRE_Solver, k_dim::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_COGMRESGetUnroll(solver, unroll)
    return @ccall libHYPRE.HYPRE_COGMRESGetUnroll(solver::HYPRE_Solver, unroll::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_COGMRESGetCGS(solver, cgs)
    return @ccall libHYPRE.HYPRE_COGMRESGetCGS(solver::HYPRE_Solver, cgs::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_COGMRESGetPrecond(solver, precond_data_ptr)
    return @ccall libHYPRE.HYPRE_COGMRESGetPrecond(solver::HYPRE_Solver, precond_data_ptr::Ptr{HYPRE_Solver})::HYPRE_Int
end

function HYPRE_COGMRESGetLogging(solver, level)
    return @ccall libHYPRE.HYPRE_COGMRESGetLogging(solver::HYPRE_Solver, level::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_COGMRESGetPrintLevel(solver, level)
    return @ccall libHYPRE.HYPRE_COGMRESGetPrintLevel(solver::HYPRE_Solver, level::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_COGMRESGetConverged(solver, converged)
    return @ccall libHYPRE.HYPRE_COGMRESGetConverged(solver::HYPRE_Solver, converged::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_COGMRESSetModifyPC(solver, modify_pc)
    return @ccall libHYPRE.HYPRE_COGMRESSetModifyPC(solver::HYPRE_Solver, modify_pc::HYPRE_PtrToModifyPCFcn)::HYPRE_Int
end

function HYPRE_BiCGSTABDestroy(solver)
    return @ccall libHYPRE.HYPRE_BiCGSTABDestroy(solver::HYPRE_Solver)::HYPRE_Int
end

function HYPRE_BiCGSTABSetup(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_BiCGSTABSetup(solver::HYPRE_Solver, A::HYPRE_Matrix, b::HYPRE_Vector, x::HYPRE_Vector)::HYPRE_Int
end

function HYPRE_BiCGSTABSolve(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_BiCGSTABSolve(solver::HYPRE_Solver, A::HYPRE_Matrix, b::HYPRE_Vector, x::HYPRE_Vector)::HYPRE_Int
end

function HYPRE_BiCGSTABSetTol(solver, tol)
    return @ccall libHYPRE.HYPRE_BiCGSTABSetTol(solver::HYPRE_Solver, tol::HYPRE_Real)::HYPRE_Int
end

function HYPRE_BiCGSTABSetAbsoluteTol(solver, a_tol)
    return @ccall libHYPRE.HYPRE_BiCGSTABSetAbsoluteTol(solver::HYPRE_Solver, a_tol::HYPRE_Real)::HYPRE_Int
end

function HYPRE_BiCGSTABSetConvergenceFactorTol(solver, cf_tol)
    return @ccall libHYPRE.HYPRE_BiCGSTABSetConvergenceFactorTol(solver::HYPRE_Solver, cf_tol::HYPRE_Real)::HYPRE_Int
end

function HYPRE_BiCGSTABSetStopCrit(solver, stop_crit)
    return @ccall libHYPRE.HYPRE_BiCGSTABSetStopCrit(solver::HYPRE_Solver, stop_crit::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BiCGSTABSetMinIter(solver, min_iter)
    return @ccall libHYPRE.HYPRE_BiCGSTABSetMinIter(solver::HYPRE_Solver, min_iter::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BiCGSTABSetMaxIter(solver, max_iter)
    return @ccall libHYPRE.HYPRE_BiCGSTABSetMaxIter(solver::HYPRE_Solver, max_iter::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BiCGSTABSetPrecond(solver, precond, precond_setup, precond_solver)
    return @ccall libHYPRE.HYPRE_BiCGSTABSetPrecond(solver::HYPRE_Solver, precond::HYPRE_PtrToSolverFcn, precond_setup::HYPRE_PtrToSolverFcn, precond_solver::HYPRE_Solver)::HYPRE_Int
end

function HYPRE_BiCGSTABSetLogging(solver, logging)
    return @ccall libHYPRE.HYPRE_BiCGSTABSetLogging(solver::HYPRE_Solver, logging::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BiCGSTABSetPrintLevel(solver, level)
    return @ccall libHYPRE.HYPRE_BiCGSTABSetPrintLevel(solver::HYPRE_Solver, level::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BiCGSTABGetNumIterations(solver, num_iterations)
    return @ccall libHYPRE.HYPRE_BiCGSTABGetNumIterations(solver::HYPRE_Solver, num_iterations::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_BiCGSTABGetFinalRelativeResidualNorm(solver, norm)
    return @ccall libHYPRE.HYPRE_BiCGSTABGetFinalRelativeResidualNorm(solver::HYPRE_Solver, norm::Ptr{HYPRE_Real})::HYPRE_Int
end

function HYPRE_BiCGSTABGetResidual(solver, residual)
    return @ccall libHYPRE.HYPRE_BiCGSTABGetResidual(solver::HYPRE_Solver, residual::Ptr{Cvoid})::HYPRE_Int
end

function HYPRE_BiCGSTABGetPrecond(solver, precond_data_ptr)
    return @ccall libHYPRE.HYPRE_BiCGSTABGetPrecond(solver::HYPRE_Solver, precond_data_ptr::Ptr{HYPRE_Solver})::HYPRE_Int
end

function HYPRE_CGNRDestroy(solver)
    return @ccall libHYPRE.HYPRE_CGNRDestroy(solver::HYPRE_Solver)::HYPRE_Int
end

function HYPRE_CGNRSetup(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_CGNRSetup(solver::HYPRE_Solver, A::HYPRE_Matrix, b::HYPRE_Vector, x::HYPRE_Vector)::HYPRE_Int
end

function HYPRE_CGNRSolve(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_CGNRSolve(solver::HYPRE_Solver, A::HYPRE_Matrix, b::HYPRE_Vector, x::HYPRE_Vector)::HYPRE_Int
end

function HYPRE_CGNRSetTol(solver, tol)
    return @ccall libHYPRE.HYPRE_CGNRSetTol(solver::HYPRE_Solver, tol::HYPRE_Real)::HYPRE_Int
end

function HYPRE_CGNRSetStopCrit(solver, stop_crit)
    return @ccall libHYPRE.HYPRE_CGNRSetStopCrit(solver::HYPRE_Solver, stop_crit::HYPRE_Int)::HYPRE_Int
end

function HYPRE_CGNRSetMinIter(solver, min_iter)
    return @ccall libHYPRE.HYPRE_CGNRSetMinIter(solver::HYPRE_Solver, min_iter::HYPRE_Int)::HYPRE_Int
end

function HYPRE_CGNRSetMaxIter(solver, max_iter)
    return @ccall libHYPRE.HYPRE_CGNRSetMaxIter(solver::HYPRE_Solver, max_iter::HYPRE_Int)::HYPRE_Int
end

function HYPRE_CGNRSetPrecond(solver, precond, precondT, precond_setup, precond_solver)
    return @ccall libHYPRE.HYPRE_CGNRSetPrecond(solver::HYPRE_Solver, precond::HYPRE_PtrToSolverFcn, precondT::HYPRE_PtrToSolverFcn, precond_setup::HYPRE_PtrToSolverFcn, precond_solver::HYPRE_Solver)::HYPRE_Int
end

function HYPRE_CGNRSetLogging(solver, logging)
    return @ccall libHYPRE.HYPRE_CGNRSetLogging(solver::HYPRE_Solver, logging::HYPRE_Int)::HYPRE_Int
end

function HYPRE_CGNRGetNumIterations(solver, num_iterations)
    return @ccall libHYPRE.HYPRE_CGNRGetNumIterations(solver::HYPRE_Solver, num_iterations::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_CGNRGetFinalRelativeResidualNorm(solver, norm)
    return @ccall libHYPRE.HYPRE_CGNRGetFinalRelativeResidualNorm(solver::HYPRE_Solver, norm::Ptr{HYPRE_Real})::HYPRE_Int
end

function HYPRE_CGNRGetPrecond(solver, precond_data_ptr)
    return @ccall libHYPRE.HYPRE_CGNRGetPrecond(solver::HYPRE_Solver, precond_data_ptr::Ptr{HYPRE_Solver})::HYPRE_Int
end

struct utilities_FortranMatrix
    globalHeight::HYPRE_BigInt
    height::HYPRE_BigInt
    width::HYPRE_BigInt
    value::Ptr{HYPRE_Real}
    ownsValues::HYPRE_Int
end

function utilities_FortranMatrixCreate()
    return @ccall libHYPRE.utilities_FortranMatrixCreate()::Ptr{utilities_FortranMatrix}
end

function utilities_FortranMatrixAllocateData(h, w, mtx)
    return @ccall libHYPRE.utilities_FortranMatrixAllocateData(h::HYPRE_BigInt, w::HYPRE_BigInt, mtx::Ptr{utilities_FortranMatrix})::Cvoid
end

function utilities_FortranMatrixWrap(arg1, gh, h, w, mtx)
    return @ccall libHYPRE.utilities_FortranMatrixWrap(arg1::Ptr{HYPRE_Real}, gh::HYPRE_BigInt, h::HYPRE_BigInt, w::HYPRE_BigInt, mtx::Ptr{utilities_FortranMatrix})::Cvoid
end

function utilities_FortranMatrixDestroy(mtx)
    return @ccall libHYPRE.utilities_FortranMatrixDestroy(mtx::Ptr{utilities_FortranMatrix})::Cvoid
end

function utilities_FortranMatrixGlobalHeight(mtx)
    return @ccall libHYPRE.utilities_FortranMatrixGlobalHeight(mtx::Ptr{utilities_FortranMatrix})::HYPRE_BigInt
end

function utilities_FortranMatrixHeight(mtx)
    return @ccall libHYPRE.utilities_FortranMatrixHeight(mtx::Ptr{utilities_FortranMatrix})::HYPRE_BigInt
end

function utilities_FortranMatrixWidth(mtx)
    return @ccall libHYPRE.utilities_FortranMatrixWidth(mtx::Ptr{utilities_FortranMatrix})::HYPRE_BigInt
end

function utilities_FortranMatrixValues(mtx)
    return @ccall libHYPRE.utilities_FortranMatrixValues(mtx::Ptr{utilities_FortranMatrix})::Ptr{HYPRE_Real}
end

function utilities_FortranMatrixClear(mtx)
    return @ccall libHYPRE.utilities_FortranMatrixClear(mtx::Ptr{utilities_FortranMatrix})::Cvoid
end

function utilities_FortranMatrixClearL(mtx)
    return @ccall libHYPRE.utilities_FortranMatrixClearL(mtx::Ptr{utilities_FortranMatrix})::Cvoid
end

function utilities_FortranMatrixSetToIdentity(mtx)
    return @ccall libHYPRE.utilities_FortranMatrixSetToIdentity(mtx::Ptr{utilities_FortranMatrix})::Cvoid
end

function utilities_FortranMatrixTransposeSquare(mtx)
    return @ccall libHYPRE.utilities_FortranMatrixTransposeSquare(mtx::Ptr{utilities_FortranMatrix})::Cvoid
end

function utilities_FortranMatrixSymmetrize(mtx)
    return @ccall libHYPRE.utilities_FortranMatrixSymmetrize(mtx::Ptr{utilities_FortranMatrix})::Cvoid
end

function utilities_FortranMatrixCopy(src, t, dest)
    return @ccall libHYPRE.utilities_FortranMatrixCopy(src::Ptr{utilities_FortranMatrix}, t::HYPRE_Int, dest::Ptr{utilities_FortranMatrix})::Cvoid
end

function utilities_FortranMatrixIndexCopy(index, src, t, dest)
    return @ccall libHYPRE.utilities_FortranMatrixIndexCopy(index::Ptr{HYPRE_Int}, src::Ptr{utilities_FortranMatrix}, t::HYPRE_Int, dest::Ptr{utilities_FortranMatrix})::Cvoid
end

function utilities_FortranMatrixSetDiagonal(mtx, d)
    return @ccall libHYPRE.utilities_FortranMatrixSetDiagonal(mtx::Ptr{utilities_FortranMatrix}, d::Ptr{utilities_FortranMatrix})::Cvoid
end

function utilities_FortranMatrixGetDiagonal(mtx, d)
    return @ccall libHYPRE.utilities_FortranMatrixGetDiagonal(mtx::Ptr{utilities_FortranMatrix}, d::Ptr{utilities_FortranMatrix})::Cvoid
end

function utilities_FortranMatrixAdd(a, mtxA, mtxB, mtxC)
    return @ccall libHYPRE.utilities_FortranMatrixAdd(a::HYPRE_Real, mtxA::Ptr{utilities_FortranMatrix}, mtxB::Ptr{utilities_FortranMatrix}, mtxC::Ptr{utilities_FortranMatrix})::Cvoid
end

function utilities_FortranMatrixDMultiply(d, mtx)
    return @ccall libHYPRE.utilities_FortranMatrixDMultiply(d::Ptr{utilities_FortranMatrix}, mtx::Ptr{utilities_FortranMatrix})::Cvoid
end

function utilities_FortranMatrixMultiplyD(mtx, d)
    return @ccall libHYPRE.utilities_FortranMatrixMultiplyD(mtx::Ptr{utilities_FortranMatrix}, d::Ptr{utilities_FortranMatrix})::Cvoid
end

function utilities_FortranMatrixMultiply(mtxA, tA, mtxB, tB, mtxC)
    return @ccall libHYPRE.utilities_FortranMatrixMultiply(mtxA::Ptr{utilities_FortranMatrix}, tA::HYPRE_Int, mtxB::Ptr{utilities_FortranMatrix}, tB::HYPRE_Int, mtxC::Ptr{utilities_FortranMatrix})::Cvoid
end

function utilities_FortranMatrixFNorm(mtx)
    return @ccall libHYPRE.utilities_FortranMatrixFNorm(mtx::Ptr{utilities_FortranMatrix})::HYPRE_Real
end

function utilities_FortranMatrixValue(mtx, i, j)
    return @ccall libHYPRE.utilities_FortranMatrixValue(mtx::Ptr{utilities_FortranMatrix}, i::HYPRE_BigInt, j::HYPRE_BigInt)::HYPRE_Real
end

function utilities_FortranMatrixValuePtr(mtx, i, j)
    return @ccall libHYPRE.utilities_FortranMatrixValuePtr(mtx::Ptr{utilities_FortranMatrix}, i::HYPRE_BigInt, j::HYPRE_BigInt)::Ptr{HYPRE_Real}
end

function utilities_FortranMatrixMaxValue(mtx)
    return @ccall libHYPRE.utilities_FortranMatrixMaxValue(mtx::Ptr{utilities_FortranMatrix})::HYPRE_Real
end

function utilities_FortranMatrixSelectBlock(mtx, iFrom, iTo, jFrom, jTo, block)
    return @ccall libHYPRE.utilities_FortranMatrixSelectBlock(mtx::Ptr{utilities_FortranMatrix}, iFrom::HYPRE_BigInt, iTo::HYPRE_BigInt, jFrom::HYPRE_BigInt, jTo::HYPRE_BigInt, block::Ptr{utilities_FortranMatrix})::Cvoid
end

function utilities_FortranMatrixUpperInv(u)
    return @ccall libHYPRE.utilities_FortranMatrixUpperInv(u::Ptr{utilities_FortranMatrix})::Cvoid
end

function utilities_FortranMatrixPrint(mtx, fileName)
    return @ccall libHYPRE.utilities_FortranMatrixPrint(mtx::Ptr{utilities_FortranMatrix}, fileName::Ptr{Cchar})::HYPRE_Int
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
    return @ccall libHYPRE.mv_MultiVectorGetData(x::mv_MultiVectorPtr)::Ptr{Cvoid}
end

function mv_MultiVectorWrap(ii, data, ownsData)
    return @ccall libHYPRE.mv_MultiVectorWrap(ii::Ptr{mv_InterfaceInterpreter}, data::Ptr{Cvoid}, ownsData::HYPRE_Int)::mv_MultiVectorPtr
end

function mv_MultiVectorCreateFromSampleVector(arg1, n, sample)
    return @ccall libHYPRE.mv_MultiVectorCreateFromSampleVector(arg1::Ptr{Cvoid}, n::HYPRE_Int, sample::Ptr{Cvoid})::mv_MultiVectorPtr
end

function mv_MultiVectorCreateCopy(x, copyValues)
    return @ccall libHYPRE.mv_MultiVectorCreateCopy(x::mv_MultiVectorPtr, copyValues::HYPRE_Int)::mv_MultiVectorPtr
end

function mv_MultiVectorDestroy(arg1)
    return @ccall libHYPRE.mv_MultiVectorDestroy(arg1::mv_MultiVectorPtr)::Cvoid
end

function mv_MultiVectorWidth(v)
    return @ccall libHYPRE.mv_MultiVectorWidth(v::mv_MultiVectorPtr)::HYPRE_Int
end

function mv_MultiVectorHeight(v)
    return @ccall libHYPRE.mv_MultiVectorHeight(v::mv_MultiVectorPtr)::HYPRE_Int
end

function mv_MultiVectorSetMask(v, mask)
    return @ccall libHYPRE.mv_MultiVectorSetMask(v::mv_MultiVectorPtr, mask::Ptr{HYPRE_Int})::Cvoid
end

function mv_MultiVectorClear(arg1)
    return @ccall libHYPRE.mv_MultiVectorClear(arg1::mv_MultiVectorPtr)::Cvoid
end

function mv_MultiVectorSetRandom(v, seed)
    return @ccall libHYPRE.mv_MultiVectorSetRandom(v::mv_MultiVectorPtr, seed::HYPRE_Int)::Cvoid
end

function mv_MultiVectorCopy(src, dest)
    return @ccall libHYPRE.mv_MultiVectorCopy(src::mv_MultiVectorPtr, dest::mv_MultiVectorPtr)::Cvoid
end

function mv_MultiVectorAxpy(a, x, y)
    return @ccall libHYPRE.mv_MultiVectorAxpy(a::HYPRE_Complex, x::mv_MultiVectorPtr, y::mv_MultiVectorPtr)::Cvoid
end

function mv_MultiVectorByMultiVector(x, y, gh, h, w, v)
    return @ccall libHYPRE.mv_MultiVectorByMultiVector(x::mv_MultiVectorPtr, y::mv_MultiVectorPtr, gh::HYPRE_Int, h::HYPRE_Int, w::HYPRE_Int, v::Ptr{HYPRE_Real})::Cvoid
end

function mv_MultiVectorByMultiVectorDiag(arg1, arg2, mask, n, diag)
    return @ccall libHYPRE.mv_MultiVectorByMultiVectorDiag(arg1::mv_MultiVectorPtr, arg2::mv_MultiVectorPtr, mask::Ptr{HYPRE_Int}, n::HYPRE_Int, diag::Ptr{HYPRE_Real})::Cvoid
end

function mv_MultiVectorByMatrix(x, gh, h, w, v, y)
    return @ccall libHYPRE.mv_MultiVectorByMatrix(x::mv_MultiVectorPtr, gh::HYPRE_Int, h::HYPRE_Int, w::HYPRE_Int, v::Ptr{HYPRE_Complex}, y::mv_MultiVectorPtr)::Cvoid
end

function mv_MultiVectorXapy(x, gh, h, w, v, y)
    return @ccall libHYPRE.mv_MultiVectorXapy(x::mv_MultiVectorPtr, gh::HYPRE_Int, h::HYPRE_Int, w::HYPRE_Int, v::Ptr{HYPRE_Complex}, y::mv_MultiVectorPtr)::Cvoid
end

function mv_MultiVectorByDiagonal(x, mask, n, diag, y)
    return @ccall libHYPRE.mv_MultiVectorByDiagonal(x::mv_MultiVectorPtr, mask::Ptr{HYPRE_Int}, n::HYPRE_Int, diag::Ptr{HYPRE_Complex}, y::mv_MultiVectorPtr)::Cvoid
end

function mv_MultiVectorEval(f, par, x, y)
    return @ccall libHYPRE.mv_MultiVectorEval(f::Ptr{Cvoid}, par::Ptr{Cvoid}, x::mv_MultiVectorPtr, y::mv_MultiVectorPtr)::Cvoid
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
    return @ccall libHYPRE.mv_TempMultiVectorCreateFromSampleVector(arg1::Ptr{Cvoid}, n::HYPRE_Int, sample::Ptr{Cvoid})::Ptr{Cvoid}
end

function mv_TempMultiVectorCreateCopy(arg1, copyValues)
    return @ccall libHYPRE.mv_TempMultiVectorCreateCopy(arg1::Ptr{Cvoid}, copyValues::HYPRE_Int)::Ptr{Cvoid}
end

function mv_TempMultiVectorDestroy(arg1)
    return @ccall libHYPRE.mv_TempMultiVectorDestroy(arg1::Ptr{Cvoid})::Cvoid
end

function mv_TempMultiVectorWidth(v)
    return @ccall libHYPRE.mv_TempMultiVectorWidth(v::Ptr{Cvoid})::HYPRE_Int
end

function mv_TempMultiVectorHeight(v)
    return @ccall libHYPRE.mv_TempMultiVectorHeight(v::Ptr{Cvoid})::HYPRE_Int
end

function mv_TempMultiVectorSetMask(v, mask)
    return @ccall libHYPRE.mv_TempMultiVectorSetMask(v::Ptr{Cvoid}, mask::Ptr{HYPRE_Int})::Cvoid
end

function mv_TempMultiVectorClear(arg1)
    return @ccall libHYPRE.mv_TempMultiVectorClear(arg1::Ptr{Cvoid})::Cvoid
end

function mv_TempMultiVectorSetRandom(v, seed)
    return @ccall libHYPRE.mv_TempMultiVectorSetRandom(v::Ptr{Cvoid}, seed::HYPRE_Int)::Cvoid
end

function mv_TempMultiVectorCopy(src, dest)
    return @ccall libHYPRE.mv_TempMultiVectorCopy(src::Ptr{Cvoid}, dest::Ptr{Cvoid})::Cvoid
end

function mv_TempMultiVectorAxpy(arg1, arg2, arg3)
    return @ccall libHYPRE.mv_TempMultiVectorAxpy(arg1::HYPRE_Complex, arg2::Ptr{Cvoid}, arg3::Ptr{Cvoid})::Cvoid
end

function mv_TempMultiVectorByMultiVector(arg1, arg2, gh, h, w, v)
    return @ccall libHYPRE.mv_TempMultiVectorByMultiVector(arg1::Ptr{Cvoid}, arg2::Ptr{Cvoid}, gh::HYPRE_Int, h::HYPRE_Int, w::HYPRE_Int, v::Ptr{HYPRE_Complex})::Cvoid
end

function mv_TempMultiVectorByMultiVectorDiag(x, y, mask, n, diag)
    return @ccall libHYPRE.mv_TempMultiVectorByMultiVectorDiag(x::Ptr{Cvoid}, y::Ptr{Cvoid}, mask::Ptr{HYPRE_Int}, n::HYPRE_Int, diag::Ptr{HYPRE_Complex})::Cvoid
end

function mv_TempMultiVectorByMatrix(arg1, gh, h, w, v, arg6)
    return @ccall libHYPRE.mv_TempMultiVectorByMatrix(arg1::Ptr{Cvoid}, gh::HYPRE_Int, h::HYPRE_Int, w::HYPRE_Int, v::Ptr{HYPRE_Complex}, arg6::Ptr{Cvoid})::Cvoid
end

function mv_TempMultiVectorXapy(x, gh, h, w, v, y)
    return @ccall libHYPRE.mv_TempMultiVectorXapy(x::Ptr{Cvoid}, gh::HYPRE_Int, h::HYPRE_Int, w::HYPRE_Int, v::Ptr{HYPRE_Complex}, y::Ptr{Cvoid})::Cvoid
end

function mv_TempMultiVectorByDiagonal(x, mask, n, diag, y)
    return @ccall libHYPRE.mv_TempMultiVectorByDiagonal(x::Ptr{Cvoid}, mask::Ptr{HYPRE_Int}, n::HYPRE_Int, diag::Ptr{HYPRE_Complex}, y::Ptr{Cvoid})::Cvoid
end

function mv_TempMultiVectorEval(f, par, x, y)
    return @ccall libHYPRE.mv_TempMultiVectorEval(f::Ptr{Cvoid}, par::Ptr{Cvoid}, x::Ptr{Cvoid}, y::Ptr{Cvoid})::Cvoid
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
    return @ccall libHYPRE.HYPRE_LOBPCGCreate(interpreter::Ptr{mv_InterfaceInterpreter}, mvfunctions::Ptr{HYPRE_MatvecFunctions}, solver::Ptr{HYPRE_Solver})::HYPRE_Int
end

function HYPRE_LOBPCGDestroy(solver)
    return @ccall libHYPRE.HYPRE_LOBPCGDestroy(solver::HYPRE_Solver)::HYPRE_Int
end

function HYPRE_LOBPCGSetPrecond(solver, precond, precond_setup, precond_solver)
    return @ccall libHYPRE.HYPRE_LOBPCGSetPrecond(solver::HYPRE_Solver, precond::HYPRE_PtrToSolverFcn, precond_setup::HYPRE_PtrToSolverFcn, precond_solver::HYPRE_Solver)::HYPRE_Int
end

function HYPRE_LOBPCGGetPrecond(solver, precond_data_ptr)
    return @ccall libHYPRE.HYPRE_LOBPCGGetPrecond(solver::HYPRE_Solver, precond_data_ptr::Ptr{HYPRE_Solver})::HYPRE_Int
end

function HYPRE_LOBPCGSetup(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_LOBPCGSetup(solver::HYPRE_Solver, A::HYPRE_Matrix, b::HYPRE_Vector, x::HYPRE_Vector)::HYPRE_Int
end

function HYPRE_LOBPCGSetupB(solver, B, x)
    return @ccall libHYPRE.HYPRE_LOBPCGSetupB(solver::HYPRE_Solver, B::HYPRE_Matrix, x::HYPRE_Vector)::HYPRE_Int
end

function HYPRE_LOBPCGSetupT(solver, T, x)
    return @ccall libHYPRE.HYPRE_LOBPCGSetupT(solver::HYPRE_Solver, T::HYPRE_Matrix, x::HYPRE_Vector)::HYPRE_Int
end

function HYPRE_LOBPCGSolve(solver, y, x, lambda)
    return @ccall libHYPRE.HYPRE_LOBPCGSolve(solver::HYPRE_Solver, y::mv_MultiVectorPtr, x::mv_MultiVectorPtr, lambda::Ptr{HYPRE_Real})::HYPRE_Int
end

function HYPRE_LOBPCGSetTol(solver, tol)
    return @ccall libHYPRE.HYPRE_LOBPCGSetTol(solver::HYPRE_Solver, tol::HYPRE_Real)::HYPRE_Int
end

function HYPRE_LOBPCGSetRTol(solver, tol)
    return @ccall libHYPRE.HYPRE_LOBPCGSetRTol(solver::HYPRE_Solver, tol::HYPRE_Real)::HYPRE_Int
end

function HYPRE_LOBPCGSetMaxIter(solver, max_iter)
    return @ccall libHYPRE.HYPRE_LOBPCGSetMaxIter(solver::HYPRE_Solver, max_iter::HYPRE_Int)::HYPRE_Int
end

function HYPRE_LOBPCGSetPrecondUsageMode(solver, mode)
    return @ccall libHYPRE.HYPRE_LOBPCGSetPrecondUsageMode(solver::HYPRE_Solver, mode::HYPRE_Int)::HYPRE_Int
end

function HYPRE_LOBPCGSetPrintLevel(solver, level)
    return @ccall libHYPRE.HYPRE_LOBPCGSetPrintLevel(solver::HYPRE_Solver, level::HYPRE_Int)::HYPRE_Int
end

function HYPRE_LOBPCGResidualNorms(solver)
    return @ccall libHYPRE.HYPRE_LOBPCGResidualNorms(solver::HYPRE_Solver)::Ptr{utilities_FortranMatrix}
end

function HYPRE_LOBPCGResidualNormsHistory(solver)
    return @ccall libHYPRE.HYPRE_LOBPCGResidualNormsHistory(solver::HYPRE_Solver)::Ptr{utilities_FortranMatrix}
end

function HYPRE_LOBPCGEigenvaluesHistory(solver)
    return @ccall libHYPRE.HYPRE_LOBPCGEigenvaluesHistory(solver::HYPRE_Solver)::Ptr{utilities_FortranMatrix}
end

function HYPRE_LOBPCGIterations(solver)
    return @ccall libHYPRE.HYPRE_LOBPCGIterations(solver::HYPRE_Solver)::HYPRE_Int
end

function hypre_LOBPCGMultiOperatorB(data, x, y)
    return @ccall libHYPRE.hypre_LOBPCGMultiOperatorB(data::Ptr{Cvoid}, x::Ptr{Cvoid}, y::Ptr{Cvoid})::Cvoid
end

function lobpcg_MultiVectorByMultiVector(x, y, xy)
    return @ccall libHYPRE.lobpcg_MultiVectorByMultiVector(x::mv_MultiVectorPtr, y::mv_MultiVectorPtr, xy::Ptr{utilities_FortranMatrix})::Cvoid
end

# typedef HYPRE_Int ( * HYPRE_PtrToParSolverFcn ) ( HYPRE_Solver , HYPRE_ParCSRMatrix , HYPRE_ParVector , HYPRE_ParVector )
const HYPRE_PtrToParSolverFcn = Ptr{Cvoid}

function HYPRE_BoomerAMGCreate(solver)
    return @ccall libHYPRE.HYPRE_BoomerAMGCreate(solver::Ptr{HYPRE_Solver})::HYPRE_Int
end

function HYPRE_BoomerAMGDestroy(solver)
    return @ccall libHYPRE.HYPRE_BoomerAMGDestroy(solver::HYPRE_Solver)::HYPRE_Int
end

function HYPRE_BoomerAMGSetup(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetup(solver::HYPRE_Solver, A::HYPRE_ParCSRMatrix, b::HYPRE_ParVector, x::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_BoomerAMGSolve(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_BoomerAMGSolve(solver::HYPRE_Solver, A::HYPRE_ParCSRMatrix, b::HYPRE_ParVector, x::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_BoomerAMGSolveT(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_BoomerAMGSolveT(solver::HYPRE_Solver, A::HYPRE_ParCSRMatrix, b::HYPRE_ParVector, x::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_BoomerAMGSetOldDefault(solver)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetOldDefault(solver::HYPRE_Solver)::HYPRE_Int
end

function HYPRE_BoomerAMGGetResidual(solver, residual)
    return @ccall libHYPRE.HYPRE_BoomerAMGGetResidual(solver::HYPRE_Solver, residual::Ptr{HYPRE_ParVector})::HYPRE_Int
end

function HYPRE_BoomerAMGGetNumIterations(solver, num_iterations)
    return @ccall libHYPRE.HYPRE_BoomerAMGGetNumIterations(solver::HYPRE_Solver, num_iterations::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_BoomerAMGGetFinalRelativeResidualNorm(solver, rel_resid_norm)
    return @ccall libHYPRE.HYPRE_BoomerAMGGetFinalRelativeResidualNorm(solver::HYPRE_Solver, rel_resid_norm::Ptr{HYPRE_Real})::HYPRE_Int
end

function HYPRE_BoomerAMGSetNumFunctions(solver, num_functions)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetNumFunctions(solver::HYPRE_Solver, num_functions::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetDofFunc(solver, dof_func)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetDofFunc(solver::HYPRE_Solver, dof_func::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_BoomerAMGSetConvergeType(solver, type)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetConvergeType(solver::HYPRE_Solver, type::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetTol(solver, tol)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetTol(solver::HYPRE_Solver, tol::HYPRE_Real)::HYPRE_Int
end

function HYPRE_BoomerAMGSetMaxIter(solver, max_iter)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetMaxIter(solver::HYPRE_Solver, max_iter::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetMinIter(solver, min_iter)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetMinIter(solver::HYPRE_Solver, min_iter::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetMaxCoarseSize(solver, max_coarse_size)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetMaxCoarseSize(solver::HYPRE_Solver, max_coarse_size::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetMinCoarseSize(solver, min_coarse_size)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetMinCoarseSize(solver::HYPRE_Solver, min_coarse_size::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetMaxLevels(solver, max_levels)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetMaxLevels(solver::HYPRE_Solver, max_levels::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetCoarsenCutFactor(solver, coarsen_cut_factor)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetCoarsenCutFactor(solver::HYPRE_Solver, coarsen_cut_factor::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetStrongThreshold(solver, strong_threshold)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetStrongThreshold(solver::HYPRE_Solver, strong_threshold::HYPRE_Real)::HYPRE_Int
end

function HYPRE_BoomerAMGSetStrongThresholdR(solver, strong_threshold)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetStrongThresholdR(solver::HYPRE_Solver, strong_threshold::HYPRE_Real)::HYPRE_Int
end

function HYPRE_BoomerAMGSetFilterThresholdR(solver, filter_threshold)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetFilterThresholdR(solver::HYPRE_Solver, filter_threshold::HYPRE_Real)::HYPRE_Int
end

function HYPRE_BoomerAMGSetSCommPkgSwitch(solver, S_commpkg_switch)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetSCommPkgSwitch(solver::HYPRE_Solver, S_commpkg_switch::HYPRE_Real)::HYPRE_Int
end

function HYPRE_BoomerAMGSetMaxRowSum(solver, max_row_sum)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetMaxRowSum(solver::HYPRE_Solver, max_row_sum::HYPRE_Real)::HYPRE_Int
end

function HYPRE_BoomerAMGSetCoarsenType(solver, coarsen_type)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetCoarsenType(solver::HYPRE_Solver, coarsen_type::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetNonGalerkinTol(solver, nongalerkin_tol)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetNonGalerkinTol(solver::HYPRE_Solver, nongalerkin_tol::HYPRE_Real)::HYPRE_Int
end

function HYPRE_BoomerAMGSetLevelNonGalerkinTol(solver, nongalerkin_tol, level)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetLevelNonGalerkinTol(solver::HYPRE_Solver, nongalerkin_tol::HYPRE_Real, level::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetNonGalerkTol(solver, nongalerk_num_tol, nongalerk_tol)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetNonGalerkTol(solver::HYPRE_Solver, nongalerk_num_tol::HYPRE_Int, nongalerk_tol::Ptr{HYPRE_Real})::HYPRE_Int
end

function HYPRE_BoomerAMGSetMeasureType(solver, measure_type)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetMeasureType(solver::HYPRE_Solver, measure_type::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetAggNumLevels(solver, agg_num_levels)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetAggNumLevels(solver::HYPRE_Solver, agg_num_levels::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetNumPaths(solver, num_paths)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetNumPaths(solver::HYPRE_Solver, num_paths::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetCGCIts(solver, its)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetCGCIts(solver::HYPRE_Solver, its::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetNodal(solver, nodal)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetNodal(solver::HYPRE_Solver, nodal::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetNodalDiag(solver, nodal_diag)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetNodalDiag(solver::HYPRE_Solver, nodal_diag::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetKeepSameSign(solver, keep_same_sign)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetKeepSameSign(solver::HYPRE_Solver, keep_same_sign::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetInterpType(solver, interp_type)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetInterpType(solver::HYPRE_Solver, interp_type::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetTruncFactor(solver, trunc_factor)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetTruncFactor(solver::HYPRE_Solver, trunc_factor::HYPRE_Real)::HYPRE_Int
end

function HYPRE_BoomerAMGSetPMaxElmts(solver, P_max_elmts)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetPMaxElmts(solver::HYPRE_Solver, P_max_elmts::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetSepWeight(solver, sep_weight)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetSepWeight(solver::HYPRE_Solver, sep_weight::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetAggInterpType(solver, agg_interp_type)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetAggInterpType(solver::HYPRE_Solver, agg_interp_type::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetAggTruncFactor(solver, agg_trunc_factor)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetAggTruncFactor(solver::HYPRE_Solver, agg_trunc_factor::HYPRE_Real)::HYPRE_Int
end

function HYPRE_BoomerAMGSetAggP12TruncFactor(solver, agg_P12_trunc_factor)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetAggP12TruncFactor(solver::HYPRE_Solver, agg_P12_trunc_factor::HYPRE_Real)::HYPRE_Int
end

function HYPRE_BoomerAMGSetAggPMaxElmts(solver, agg_P_max_elmts)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetAggPMaxElmts(solver::HYPRE_Solver, agg_P_max_elmts::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetAggP12MaxElmts(solver, agg_P12_max_elmts)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetAggP12MaxElmts(solver::HYPRE_Solver, agg_P12_max_elmts::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetInterpVectors(solver, num_vectors, interp_vectors)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetInterpVectors(solver::HYPRE_Solver, num_vectors::HYPRE_Int, interp_vectors::Ptr{HYPRE_ParVector})::HYPRE_Int
end

function HYPRE_BoomerAMGSetInterpVecVariant(solver, var)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetInterpVecVariant(solver::HYPRE_Solver, var::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetInterpVecQMax(solver, q_max)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetInterpVecQMax(solver::HYPRE_Solver, q_max::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetInterpVecAbsQTrunc(solver, q_trunc)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetInterpVecAbsQTrunc(solver::HYPRE_Solver, q_trunc::HYPRE_Real)::HYPRE_Int
end

function HYPRE_BoomerAMGSetGSMG(solver, gsmg)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetGSMG(solver::HYPRE_Solver, gsmg::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetNumSamples(solver, num_samples)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetNumSamples(solver::HYPRE_Solver, num_samples::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetCycleType(solver, cycle_type)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetCycleType(solver::HYPRE_Solver, cycle_type::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetFCycle(solver, fcycle)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetFCycle(solver::HYPRE_Solver, fcycle::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetAdditive(solver, addlvl)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetAdditive(solver::HYPRE_Solver, addlvl::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetMultAdditive(solver, addlvl)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetMultAdditive(solver::HYPRE_Solver, addlvl::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetSimple(solver, addlvl)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetSimple(solver::HYPRE_Solver, addlvl::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetAddLastLvl(solver, add_last_lvl)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetAddLastLvl(solver::HYPRE_Solver, add_last_lvl::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetMultAddTruncFactor(solver, add_trunc_factor)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetMultAddTruncFactor(solver::HYPRE_Solver, add_trunc_factor::HYPRE_Real)::HYPRE_Int
end

function HYPRE_BoomerAMGSetMultAddPMaxElmts(solver, add_P_max_elmts)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetMultAddPMaxElmts(solver::HYPRE_Solver, add_P_max_elmts::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetAddRelaxType(solver, add_rlx_type)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetAddRelaxType(solver::HYPRE_Solver, add_rlx_type::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetAddRelaxWt(solver, add_rlx_wt)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetAddRelaxWt(solver::HYPRE_Solver, add_rlx_wt::HYPRE_Real)::HYPRE_Int
end

function HYPRE_BoomerAMGSetSeqThreshold(solver, seq_threshold)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetSeqThreshold(solver::HYPRE_Solver, seq_threshold::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetRedundant(solver, redundant)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetRedundant(solver::HYPRE_Solver, redundant::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetNumGridSweeps(solver, num_grid_sweeps)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetNumGridSweeps(solver::HYPRE_Solver, num_grid_sweeps::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_BoomerAMGSetNumSweeps(solver, num_sweeps)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetNumSweeps(solver::HYPRE_Solver, num_sweeps::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetCycleNumSweeps(solver, num_sweeps, k)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetCycleNumSweeps(solver::HYPRE_Solver, num_sweeps::HYPRE_Int, k::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetGridRelaxType(solver, grid_relax_type)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetGridRelaxType(solver::HYPRE_Solver, grid_relax_type::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_BoomerAMGSetRelaxType(solver, relax_type)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetRelaxType(solver::HYPRE_Solver, relax_type::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetCycleRelaxType(solver, relax_type, k)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetCycleRelaxType(solver::HYPRE_Solver, relax_type::HYPRE_Int, k::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetRelaxOrder(solver, relax_order)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetRelaxOrder(solver::HYPRE_Solver, relax_order::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetGridRelaxPoints(solver, grid_relax_points)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetGridRelaxPoints(solver::HYPRE_Solver, grid_relax_points::Ptr{Ptr{HYPRE_Int}})::HYPRE_Int
end

function HYPRE_BoomerAMGSetRelaxWeight(solver, relax_weight)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetRelaxWeight(solver::HYPRE_Solver, relax_weight::Ptr{HYPRE_Real})::HYPRE_Int
end

function HYPRE_BoomerAMGSetRelaxWt(solver, relax_weight)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetRelaxWt(solver::HYPRE_Solver, relax_weight::HYPRE_Real)::HYPRE_Int
end

function HYPRE_BoomerAMGSetLevelRelaxWt(solver, relax_weight, level)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetLevelRelaxWt(solver::HYPRE_Solver, relax_weight::HYPRE_Real, level::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetOmega(solver, omega)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetOmega(solver::HYPRE_Solver, omega::Ptr{HYPRE_Real})::HYPRE_Int
end

function HYPRE_BoomerAMGSetOuterWt(solver, omega)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetOuterWt(solver::HYPRE_Solver, omega::HYPRE_Real)::HYPRE_Int
end

function HYPRE_BoomerAMGSetLevelOuterWt(solver, omega, level)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetLevelOuterWt(solver::HYPRE_Solver, omega::HYPRE_Real, level::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetChebyOrder(solver, order)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetChebyOrder(solver::HYPRE_Solver, order::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetChebyFraction(solver, ratio)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetChebyFraction(solver::HYPRE_Solver, ratio::HYPRE_Real)::HYPRE_Int
end

function HYPRE_BoomerAMGSetChebyScale(solver, scale)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetChebyScale(solver::HYPRE_Solver, scale::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetChebyVariant(solver, variant)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetChebyVariant(solver::HYPRE_Solver, variant::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetChebyEigEst(solver, eig_est)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetChebyEigEst(solver::HYPRE_Solver, eig_est::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetSmoothType(solver, smooth_type)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetSmoothType(solver::HYPRE_Solver, smooth_type::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetSmoothNumLevels(solver, smooth_num_levels)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetSmoothNumLevels(solver::HYPRE_Solver, smooth_num_levels::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetSmoothNumSweeps(solver, smooth_num_sweeps)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetSmoothNumSweeps(solver::HYPRE_Solver, smooth_num_sweeps::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetVariant(solver, variant)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetVariant(solver::HYPRE_Solver, variant::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetOverlap(solver, overlap)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetOverlap(solver::HYPRE_Solver, overlap::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetDomainType(solver, domain_type)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetDomainType(solver::HYPRE_Solver, domain_type::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetSchwarzRlxWeight(solver, schwarz_rlx_weight)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetSchwarzRlxWeight(solver::HYPRE_Solver, schwarz_rlx_weight::HYPRE_Real)::HYPRE_Int
end

function HYPRE_BoomerAMGSetSchwarzUseNonSymm(solver, use_nonsymm)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetSchwarzUseNonSymm(solver::HYPRE_Solver, use_nonsymm::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetSym(solver, sym)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetSym(solver::HYPRE_Solver, sym::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetLevel(solver, level)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetLevel(solver::HYPRE_Solver, level::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetThreshold(solver, threshold)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetThreshold(solver::HYPRE_Solver, threshold::HYPRE_Real)::HYPRE_Int
end

function HYPRE_BoomerAMGSetFilter(solver, filter)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetFilter(solver::HYPRE_Solver, filter::HYPRE_Real)::HYPRE_Int
end

function HYPRE_BoomerAMGSetDropTol(solver, drop_tol)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetDropTol(solver::HYPRE_Solver, drop_tol::HYPRE_Real)::HYPRE_Int
end

function HYPRE_BoomerAMGSetMaxNzPerRow(solver, max_nz_per_row)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetMaxNzPerRow(solver::HYPRE_Solver, max_nz_per_row::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetEuclidFile(solver, euclidfile)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetEuclidFile(solver::HYPRE_Solver, euclidfile::Ptr{Cchar})::HYPRE_Int
end

function HYPRE_BoomerAMGSetEuLevel(solver, eu_level)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetEuLevel(solver::HYPRE_Solver, eu_level::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetEuSparseA(solver, eu_sparse_A)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetEuSparseA(solver::HYPRE_Solver, eu_sparse_A::HYPRE_Real)::HYPRE_Int
end

function HYPRE_BoomerAMGSetEuBJ(solver, eu_bj)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetEuBJ(solver::HYPRE_Solver, eu_bj::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetILUType(solver, ilu_type)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetILUType(solver::HYPRE_Solver, ilu_type::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetILULevel(solver, ilu_lfil)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetILULevel(solver::HYPRE_Solver, ilu_lfil::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetILUMaxRowNnz(solver, ilu_max_row_nnz)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetILUMaxRowNnz(solver::HYPRE_Solver, ilu_max_row_nnz::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetILUMaxIter(solver, ilu_max_iter)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetILUMaxIter(solver::HYPRE_Solver, ilu_max_iter::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetILUDroptol(solver, ilu_droptol)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetILUDroptol(solver::HYPRE_Solver, ilu_droptol::HYPRE_Real)::HYPRE_Int
end

function HYPRE_BoomerAMGSetRestriction(solver, restr_par)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetRestriction(solver::HYPRE_Solver, restr_par::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetIsTriangular(solver, is_triangular)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetIsTriangular(solver::HYPRE_Solver, is_triangular::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetGMRESSwitchR(solver, gmres_switch)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetGMRESSwitchR(solver::HYPRE_Solver, gmres_switch::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetADropTol(solver, A_drop_tol)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetADropTol(solver::HYPRE_Solver, A_drop_tol::HYPRE_Real)::HYPRE_Int
end

function HYPRE_BoomerAMGSetADropType(solver, A_drop_type)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetADropType(solver::HYPRE_Solver, A_drop_type::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetPrintFileName(solver, print_file_name)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetPrintFileName(solver::HYPRE_Solver, print_file_name::Ptr{Cchar})::HYPRE_Int
end

function HYPRE_BoomerAMGSetPrintLevel(solver, print_level)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetPrintLevel(solver::HYPRE_Solver, print_level::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetLogging(solver, logging)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetLogging(solver::HYPRE_Solver, logging::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetDebugFlag(solver, debug_flag)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetDebugFlag(solver::HYPRE_Solver, debug_flag::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGInitGridRelaxation(num_grid_sweeps_ptr, grid_relax_type_ptr, grid_relax_points_ptr, coarsen_type, relax_weights_ptr, max_levels)
    return @ccall libHYPRE.HYPRE_BoomerAMGInitGridRelaxation(num_grid_sweeps_ptr::Ptr{Ptr{HYPRE_Int}}, grid_relax_type_ptr::Ptr{Ptr{HYPRE_Int}}, grid_relax_points_ptr::Ptr{Ptr{Ptr{HYPRE_Int}}}, coarsen_type::HYPRE_Int, relax_weights_ptr::Ptr{Ptr{HYPRE_Real}}, max_levels::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetRAP2(solver, rap2)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetRAP2(solver::HYPRE_Solver, rap2::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetModuleRAP2(solver, mod_rap2)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetModuleRAP2(solver::HYPRE_Solver, mod_rap2::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetKeepTranspose(solver, keepTranspose)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetKeepTranspose(solver::HYPRE_Solver, keepTranspose::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetPlotGrids(solver, plotgrids)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetPlotGrids(solver::HYPRE_Solver, plotgrids::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetPlotFileName(solver, plotfilename)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetPlotFileName(solver::HYPRE_Solver, plotfilename::Ptr{Cchar})::HYPRE_Int
end

function HYPRE_BoomerAMGSetCoordDim(solver, coorddim)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetCoordDim(solver::HYPRE_Solver, coorddim::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetCoordinates(solver, coordinates)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetCoordinates(solver::HYPRE_Solver, coordinates::Ptr{Cfloat})::HYPRE_Int
end

function HYPRE_BoomerAMGGetGridHierarchy(solver, cgrid)
    return @ccall libHYPRE.HYPRE_BoomerAMGGetGridHierarchy(solver::HYPRE_Solver, cgrid::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_BoomerAMGSetCPoints(solver, cpt_coarse_level, num_cpt_coarse, cpt_coarse_index)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetCPoints(solver::HYPRE_Solver, cpt_coarse_level::HYPRE_Int, num_cpt_coarse::HYPRE_Int, cpt_coarse_index::Ptr{HYPRE_BigInt})::HYPRE_Int
end

function HYPRE_BoomerAMGSetCpointsToKeep(solver, cpt_coarse_level, num_cpt_coarse, cpt_coarse_index)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetCpointsToKeep(solver::HYPRE_Solver, cpt_coarse_level::HYPRE_Int, num_cpt_coarse::HYPRE_Int, cpt_coarse_index::Ptr{HYPRE_BigInt})::HYPRE_Int
end

function HYPRE_BoomerAMGSetFPoints(solver, num_fpt, fpt_index)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetFPoints(solver::HYPRE_Solver, num_fpt::HYPRE_Int, fpt_index::Ptr{HYPRE_BigInt})::HYPRE_Int
end

function HYPRE_BoomerAMGSetIsolatedFPoints(solver, num_isolated_fpt, isolated_fpt_index)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetIsolatedFPoints(solver::HYPRE_Solver, num_isolated_fpt::HYPRE_Int, isolated_fpt_index::Ptr{HYPRE_BigInt})::HYPRE_Int
end

function HYPRE_BoomerAMGSetSabs(solver, Sabs)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetSabs(solver::HYPRE_Solver, Sabs::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGDDCreate(solver)
    return @ccall libHYPRE.HYPRE_BoomerAMGDDCreate(solver::Ptr{HYPRE_Solver})::HYPRE_Int
end

function HYPRE_BoomerAMGDDDestroy(solver)
    return @ccall libHYPRE.HYPRE_BoomerAMGDDDestroy(solver::HYPRE_Solver)::HYPRE_Int
end

function HYPRE_BoomerAMGDDSetup(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_BoomerAMGDDSetup(solver::HYPRE_Solver, A::HYPRE_ParCSRMatrix, b::HYPRE_ParVector, x::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_BoomerAMGDDSolve(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_BoomerAMGDDSolve(solver::HYPRE_Solver, A::HYPRE_ParCSRMatrix, b::HYPRE_ParVector, x::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_BoomerAMGDDSetFACNumRelax(solver, amgdd_fac_num_relax)
    return @ccall libHYPRE.HYPRE_BoomerAMGDDSetFACNumRelax(solver::HYPRE_Solver, amgdd_fac_num_relax::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGDDSetFACNumCycles(solver, amgdd_fac_num_cycles)
    return @ccall libHYPRE.HYPRE_BoomerAMGDDSetFACNumCycles(solver::HYPRE_Solver, amgdd_fac_num_cycles::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGDDSetFACCycleType(solver, amgdd_fac_cycle_type)
    return @ccall libHYPRE.HYPRE_BoomerAMGDDSetFACCycleType(solver::HYPRE_Solver, amgdd_fac_cycle_type::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGDDSetFACRelaxType(solver, amgdd_fac_relax_type)
    return @ccall libHYPRE.HYPRE_BoomerAMGDDSetFACRelaxType(solver::HYPRE_Solver, amgdd_fac_relax_type::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGDDSetFACRelaxWeight(solver, amgdd_fac_relax_weight)
    return @ccall libHYPRE.HYPRE_BoomerAMGDDSetFACRelaxWeight(solver::HYPRE_Solver, amgdd_fac_relax_weight::HYPRE_Real)::HYPRE_Int
end

function HYPRE_BoomerAMGDDSetStartLevel(solver, start_level)
    return @ccall libHYPRE.HYPRE_BoomerAMGDDSetStartLevel(solver::HYPRE_Solver, start_level::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGDDSetPadding(solver, padding)
    return @ccall libHYPRE.HYPRE_BoomerAMGDDSetPadding(solver::HYPRE_Solver, padding::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGDDSetNumGhostLayers(solver, num_ghost_layers)
    return @ccall libHYPRE.HYPRE_BoomerAMGDDSetNumGhostLayers(solver::HYPRE_Solver, num_ghost_layers::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGDDSetUserFACRelaxation(solver, userFACRelaxation)
    return @ccall libHYPRE.HYPRE_BoomerAMGDDSetUserFACRelaxation(solver::HYPRE_Solver, userFACRelaxation::Ptr{Cvoid})::HYPRE_Int
end

function HYPRE_BoomerAMGDDGetAMG(solver, amg_solver)
    return @ccall libHYPRE.HYPRE_BoomerAMGDDGetAMG(solver::HYPRE_Solver, amg_solver::Ptr{HYPRE_Solver})::HYPRE_Int
end

function HYPRE_BoomerAMGDDGetFinalRelativeResidualNorm(solver, rel_resid_norm)
    return @ccall libHYPRE.HYPRE_BoomerAMGDDGetFinalRelativeResidualNorm(solver::HYPRE_Solver, rel_resid_norm::Ptr{HYPRE_Real})::HYPRE_Int
end

function HYPRE_BoomerAMGDDGetNumIterations(solver, num_iterations)
    return @ccall libHYPRE.HYPRE_BoomerAMGDDGetNumIterations(solver::HYPRE_Solver, num_iterations::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_ParaSailsCreate(comm, solver)
    return @ccall libHYPRE.HYPRE_ParaSailsCreate(comm::MPI_Comm, solver::Ptr{HYPRE_Solver})::HYPRE_Int
end

function HYPRE_ParaSailsDestroy(solver)
    return @ccall libHYPRE.HYPRE_ParaSailsDestroy(solver::HYPRE_Solver)::HYPRE_Int
end

function HYPRE_ParaSailsSetup(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_ParaSailsSetup(solver::HYPRE_Solver, A::HYPRE_ParCSRMatrix, b::HYPRE_ParVector, x::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_ParaSailsSolve(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_ParaSailsSolve(solver::HYPRE_Solver, A::HYPRE_ParCSRMatrix, b::HYPRE_ParVector, x::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_ParaSailsSetParams(solver, thresh, nlevels)
    return @ccall libHYPRE.HYPRE_ParaSailsSetParams(solver::HYPRE_Solver, thresh::HYPRE_Real, nlevels::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParaSailsSetFilter(solver, filter)
    return @ccall libHYPRE.HYPRE_ParaSailsSetFilter(solver::HYPRE_Solver, filter::HYPRE_Real)::HYPRE_Int
end

function HYPRE_ParaSailsSetSym(solver, sym)
    return @ccall libHYPRE.HYPRE_ParaSailsSetSym(solver::HYPRE_Solver, sym::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParaSailsSetLoadbal(solver, loadbal)
    return @ccall libHYPRE.HYPRE_ParaSailsSetLoadbal(solver::HYPRE_Solver, loadbal::HYPRE_Real)::HYPRE_Int
end

function HYPRE_ParaSailsSetReuse(solver, reuse)
    return @ccall libHYPRE.HYPRE_ParaSailsSetReuse(solver::HYPRE_Solver, reuse::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParaSailsSetLogging(solver, logging)
    return @ccall libHYPRE.HYPRE_ParaSailsSetLogging(solver::HYPRE_Solver, logging::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParaSailsBuildIJMatrix(solver, pij_A)
    return @ccall libHYPRE.HYPRE_ParaSailsBuildIJMatrix(solver::HYPRE_Solver, pij_A::Ptr{HYPRE_IJMatrix})::HYPRE_Int
end

function HYPRE_ParCSRParaSailsCreate(comm, solver)
    return @ccall libHYPRE.HYPRE_ParCSRParaSailsCreate(comm::MPI_Comm, solver::Ptr{HYPRE_Solver})::HYPRE_Int
end

function HYPRE_ParCSRParaSailsDestroy(solver)
    return @ccall libHYPRE.HYPRE_ParCSRParaSailsDestroy(solver::HYPRE_Solver)::HYPRE_Int
end

function HYPRE_ParCSRParaSailsSetup(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_ParCSRParaSailsSetup(solver::HYPRE_Solver, A::HYPRE_ParCSRMatrix, b::HYPRE_ParVector, x::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_ParCSRParaSailsSolve(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_ParCSRParaSailsSolve(solver::HYPRE_Solver, A::HYPRE_ParCSRMatrix, b::HYPRE_ParVector, x::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_ParCSRParaSailsSetParams(solver, thresh, nlevels)
    return @ccall libHYPRE.HYPRE_ParCSRParaSailsSetParams(solver::HYPRE_Solver, thresh::HYPRE_Real, nlevels::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRParaSailsSetFilter(solver, filter)
    return @ccall libHYPRE.HYPRE_ParCSRParaSailsSetFilter(solver::HYPRE_Solver, filter::HYPRE_Real)::HYPRE_Int
end

function HYPRE_ParCSRParaSailsSetSym(solver, sym)
    return @ccall libHYPRE.HYPRE_ParCSRParaSailsSetSym(solver::HYPRE_Solver, sym::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRParaSailsSetLoadbal(solver, loadbal)
    return @ccall libHYPRE.HYPRE_ParCSRParaSailsSetLoadbal(solver::HYPRE_Solver, loadbal::HYPRE_Real)::HYPRE_Int
end

function HYPRE_ParCSRParaSailsSetReuse(solver, reuse)
    return @ccall libHYPRE.HYPRE_ParCSRParaSailsSetReuse(solver::HYPRE_Solver, reuse::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRParaSailsSetLogging(solver, logging)
    return @ccall libHYPRE.HYPRE_ParCSRParaSailsSetLogging(solver::HYPRE_Solver, logging::HYPRE_Int)::HYPRE_Int
end

function HYPRE_EuclidCreate(comm, solver)
    return @ccall libHYPRE.HYPRE_EuclidCreate(comm::MPI_Comm, solver::Ptr{HYPRE_Solver})::HYPRE_Int
end

function HYPRE_EuclidDestroy(solver)
    return @ccall libHYPRE.HYPRE_EuclidDestroy(solver::HYPRE_Solver)::HYPRE_Int
end

function HYPRE_EuclidSetup(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_EuclidSetup(solver::HYPRE_Solver, A::HYPRE_ParCSRMatrix, b::HYPRE_ParVector, x::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_EuclidSolve(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_EuclidSolve(solver::HYPRE_Solver, A::HYPRE_ParCSRMatrix, b::HYPRE_ParVector, x::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_EuclidSetParams(solver, argc, argv)
    return @ccall libHYPRE.HYPRE_EuclidSetParams(solver::HYPRE_Solver, argc::HYPRE_Int, argv::Ptr{Ptr{Cchar}})::HYPRE_Int
end

function HYPRE_EuclidSetParamsFromFile(solver, filename)
    return @ccall libHYPRE.HYPRE_EuclidSetParamsFromFile(solver::HYPRE_Solver, filename::Ptr{Cchar})::HYPRE_Int
end

function HYPRE_EuclidSetLevel(solver, level)
    return @ccall libHYPRE.HYPRE_EuclidSetLevel(solver::HYPRE_Solver, level::HYPRE_Int)::HYPRE_Int
end

function HYPRE_EuclidSetBJ(solver, bj)
    return @ccall libHYPRE.HYPRE_EuclidSetBJ(solver::HYPRE_Solver, bj::HYPRE_Int)::HYPRE_Int
end

function HYPRE_EuclidSetStats(solver, eu_stats)
    return @ccall libHYPRE.HYPRE_EuclidSetStats(solver::HYPRE_Solver, eu_stats::HYPRE_Int)::HYPRE_Int
end

function HYPRE_EuclidSetMem(solver, eu_mem)
    return @ccall libHYPRE.HYPRE_EuclidSetMem(solver::HYPRE_Solver, eu_mem::HYPRE_Int)::HYPRE_Int
end

function HYPRE_EuclidSetSparseA(solver, sparse_A)
    return @ccall libHYPRE.HYPRE_EuclidSetSparseA(solver::HYPRE_Solver, sparse_A::HYPRE_Real)::HYPRE_Int
end

function HYPRE_EuclidSetRowScale(solver, row_scale)
    return @ccall libHYPRE.HYPRE_EuclidSetRowScale(solver::HYPRE_Solver, row_scale::HYPRE_Int)::HYPRE_Int
end

function HYPRE_EuclidSetILUT(solver, drop_tol)
    return @ccall libHYPRE.HYPRE_EuclidSetILUT(solver::HYPRE_Solver, drop_tol::HYPRE_Real)::HYPRE_Int
end

function HYPRE_ParCSRPilutCreate(comm, solver)
    return @ccall libHYPRE.HYPRE_ParCSRPilutCreate(comm::MPI_Comm, solver::Ptr{HYPRE_Solver})::HYPRE_Int
end

function HYPRE_ParCSRPilutDestroy(solver)
    return @ccall libHYPRE.HYPRE_ParCSRPilutDestroy(solver::HYPRE_Solver)::HYPRE_Int
end

function HYPRE_ParCSRPilutSetup(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_ParCSRPilutSetup(solver::HYPRE_Solver, A::HYPRE_ParCSRMatrix, b::HYPRE_ParVector, x::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_ParCSRPilutSolve(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_ParCSRPilutSolve(solver::HYPRE_Solver, A::HYPRE_ParCSRMatrix, b::HYPRE_ParVector, x::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_ParCSRPilutSetMaxIter(solver, max_iter)
    return @ccall libHYPRE.HYPRE_ParCSRPilutSetMaxIter(solver::HYPRE_Solver, max_iter::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRPilutSetDropTolerance(solver, tol)
    return @ccall libHYPRE.HYPRE_ParCSRPilutSetDropTolerance(solver::HYPRE_Solver, tol::HYPRE_Real)::HYPRE_Int
end

function HYPRE_ParCSRPilutSetFactorRowSize(solver, size)
    return @ccall libHYPRE.HYPRE_ParCSRPilutSetFactorRowSize(solver::HYPRE_Solver, size::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRPilutSetLogging(solver, logging)
    return @ccall libHYPRE.HYPRE_ParCSRPilutSetLogging(solver::HYPRE_Solver, logging::HYPRE_Int)::HYPRE_Int
end

function HYPRE_AMSCreate(solver)
    return @ccall libHYPRE.HYPRE_AMSCreate(solver::Ptr{HYPRE_Solver})::HYPRE_Int
end

function HYPRE_AMSDestroy(solver)
    return @ccall libHYPRE.HYPRE_AMSDestroy(solver::HYPRE_Solver)::HYPRE_Int
end

function HYPRE_AMSSetup(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_AMSSetup(solver::HYPRE_Solver, A::HYPRE_ParCSRMatrix, b::HYPRE_ParVector, x::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_AMSSolve(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_AMSSolve(solver::HYPRE_Solver, A::HYPRE_ParCSRMatrix, b::HYPRE_ParVector, x::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_AMSSetDimension(solver, dim)
    return @ccall libHYPRE.HYPRE_AMSSetDimension(solver::HYPRE_Solver, dim::HYPRE_Int)::HYPRE_Int
end

function HYPRE_AMSSetDiscreteGradient(solver, G)
    return @ccall libHYPRE.HYPRE_AMSSetDiscreteGradient(solver::HYPRE_Solver, G::HYPRE_ParCSRMatrix)::HYPRE_Int
end

function HYPRE_AMSSetCoordinateVectors(solver, x, y, z)
    return @ccall libHYPRE.HYPRE_AMSSetCoordinateVectors(solver::HYPRE_Solver, x::HYPRE_ParVector, y::HYPRE_ParVector, z::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_AMSSetEdgeConstantVectors(solver, Gx, Gy, Gz)
    return @ccall libHYPRE.HYPRE_AMSSetEdgeConstantVectors(solver::HYPRE_Solver, Gx::HYPRE_ParVector, Gy::HYPRE_ParVector, Gz::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_AMSSetInterpolations(solver, Pi, Pix, Piy, Piz)
    return @ccall libHYPRE.HYPRE_AMSSetInterpolations(solver::HYPRE_Solver, Pi::HYPRE_ParCSRMatrix, Pix::HYPRE_ParCSRMatrix, Piy::HYPRE_ParCSRMatrix, Piz::HYPRE_ParCSRMatrix)::HYPRE_Int
end

function HYPRE_AMSSetAlphaPoissonMatrix(solver, A_alpha)
    return @ccall libHYPRE.HYPRE_AMSSetAlphaPoissonMatrix(solver::HYPRE_Solver, A_alpha::HYPRE_ParCSRMatrix)::HYPRE_Int
end

function HYPRE_AMSSetBetaPoissonMatrix(solver, A_beta)
    return @ccall libHYPRE.HYPRE_AMSSetBetaPoissonMatrix(solver::HYPRE_Solver, A_beta::HYPRE_ParCSRMatrix)::HYPRE_Int
end

function HYPRE_AMSSetInteriorNodes(solver, interior_nodes)
    return @ccall libHYPRE.HYPRE_AMSSetInteriorNodes(solver::HYPRE_Solver, interior_nodes::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_AMSSetProjectionFrequency(solver, projection_frequency)
    return @ccall libHYPRE.HYPRE_AMSSetProjectionFrequency(solver::HYPRE_Solver, projection_frequency::HYPRE_Int)::HYPRE_Int
end

function HYPRE_AMSSetMaxIter(solver, maxit)
    return @ccall libHYPRE.HYPRE_AMSSetMaxIter(solver::HYPRE_Solver, maxit::HYPRE_Int)::HYPRE_Int
end

function HYPRE_AMSSetTol(solver, tol)
    return @ccall libHYPRE.HYPRE_AMSSetTol(solver::HYPRE_Solver, tol::HYPRE_Real)::HYPRE_Int
end

function HYPRE_AMSSetCycleType(solver, cycle_type)
    return @ccall libHYPRE.HYPRE_AMSSetCycleType(solver::HYPRE_Solver, cycle_type::HYPRE_Int)::HYPRE_Int
end

function HYPRE_AMSSetPrintLevel(solver, print_level)
    return @ccall libHYPRE.HYPRE_AMSSetPrintLevel(solver::HYPRE_Solver, print_level::HYPRE_Int)::HYPRE_Int
end

function HYPRE_AMSSetSmoothingOptions(solver, relax_type, relax_times, relax_weight, omega)
    return @ccall libHYPRE.HYPRE_AMSSetSmoothingOptions(solver::HYPRE_Solver, relax_type::HYPRE_Int, relax_times::HYPRE_Int, relax_weight::HYPRE_Real, omega::HYPRE_Real)::HYPRE_Int
end

function HYPRE_AMSSetAlphaAMGOptions(solver, alpha_coarsen_type, alpha_agg_levels, alpha_relax_type, alpha_strength_threshold, alpha_interp_type, alpha_Pmax)
    return @ccall libHYPRE.HYPRE_AMSSetAlphaAMGOptions(solver::HYPRE_Solver, alpha_coarsen_type::HYPRE_Int, alpha_agg_levels::HYPRE_Int, alpha_relax_type::HYPRE_Int, alpha_strength_threshold::HYPRE_Real, alpha_interp_type::HYPRE_Int, alpha_Pmax::HYPRE_Int)::HYPRE_Int
end

function HYPRE_AMSSetAlphaAMGCoarseRelaxType(solver, alpha_coarse_relax_type)
    return @ccall libHYPRE.HYPRE_AMSSetAlphaAMGCoarseRelaxType(solver::HYPRE_Solver, alpha_coarse_relax_type::HYPRE_Int)::HYPRE_Int
end

function HYPRE_AMSSetBetaAMGOptions(solver, beta_coarsen_type, beta_agg_levels, beta_relax_type, beta_strength_threshold, beta_interp_type, beta_Pmax)
    return @ccall libHYPRE.HYPRE_AMSSetBetaAMGOptions(solver::HYPRE_Solver, beta_coarsen_type::HYPRE_Int, beta_agg_levels::HYPRE_Int, beta_relax_type::HYPRE_Int, beta_strength_threshold::HYPRE_Real, beta_interp_type::HYPRE_Int, beta_Pmax::HYPRE_Int)::HYPRE_Int
end

function HYPRE_AMSSetBetaAMGCoarseRelaxType(solver, beta_coarse_relax_type)
    return @ccall libHYPRE.HYPRE_AMSSetBetaAMGCoarseRelaxType(solver::HYPRE_Solver, beta_coarse_relax_type::HYPRE_Int)::HYPRE_Int
end

function HYPRE_AMSGetNumIterations(solver, num_iterations)
    return @ccall libHYPRE.HYPRE_AMSGetNumIterations(solver::HYPRE_Solver, num_iterations::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_AMSGetFinalRelativeResidualNorm(solver, rel_resid_norm)
    return @ccall libHYPRE.HYPRE_AMSGetFinalRelativeResidualNorm(solver::HYPRE_Solver, rel_resid_norm::Ptr{HYPRE_Real})::HYPRE_Int
end

function HYPRE_AMSProjectOutGradients(solver, x)
    return @ccall libHYPRE.HYPRE_AMSProjectOutGradients(solver::HYPRE_Solver, x::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_AMSConstructDiscreteGradient(A, x_coord, edge_vertex, edge_orientation, G)
    return @ccall libHYPRE.HYPRE_AMSConstructDiscreteGradient(A::HYPRE_ParCSRMatrix, x_coord::HYPRE_ParVector, edge_vertex::Ptr{HYPRE_BigInt}, edge_orientation::HYPRE_Int, G::Ptr{HYPRE_ParCSRMatrix})::HYPRE_Int
end

function HYPRE_ADSCreate(solver)
    return @ccall libHYPRE.HYPRE_ADSCreate(solver::Ptr{HYPRE_Solver})::HYPRE_Int
end

function HYPRE_ADSDestroy(solver)
    return @ccall libHYPRE.HYPRE_ADSDestroy(solver::HYPRE_Solver)::HYPRE_Int
end

function HYPRE_ADSSetup(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_ADSSetup(solver::HYPRE_Solver, A::HYPRE_ParCSRMatrix, b::HYPRE_ParVector, x::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_ADSSolve(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_ADSSolve(solver::HYPRE_Solver, A::HYPRE_ParCSRMatrix, b::HYPRE_ParVector, x::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_ADSSetDiscreteCurl(solver, C)
    return @ccall libHYPRE.HYPRE_ADSSetDiscreteCurl(solver::HYPRE_Solver, C::HYPRE_ParCSRMatrix)::HYPRE_Int
end

function HYPRE_ADSSetDiscreteGradient(solver, G)
    return @ccall libHYPRE.HYPRE_ADSSetDiscreteGradient(solver::HYPRE_Solver, G::HYPRE_ParCSRMatrix)::HYPRE_Int
end

function HYPRE_ADSSetCoordinateVectors(solver, x, y, z)
    return @ccall libHYPRE.HYPRE_ADSSetCoordinateVectors(solver::HYPRE_Solver, x::HYPRE_ParVector, y::HYPRE_ParVector, z::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_ADSSetInterpolations(solver, RT_Pi, RT_Pix, RT_Piy, RT_Piz, ND_Pi, ND_Pix, ND_Piy, ND_Piz)
    return @ccall libHYPRE.HYPRE_ADSSetInterpolations(solver::HYPRE_Solver, RT_Pi::HYPRE_ParCSRMatrix, RT_Pix::HYPRE_ParCSRMatrix, RT_Piy::HYPRE_ParCSRMatrix, RT_Piz::HYPRE_ParCSRMatrix, ND_Pi::HYPRE_ParCSRMatrix, ND_Pix::HYPRE_ParCSRMatrix, ND_Piy::HYPRE_ParCSRMatrix, ND_Piz::HYPRE_ParCSRMatrix)::HYPRE_Int
end

function HYPRE_ADSSetMaxIter(solver, maxit)
    return @ccall libHYPRE.HYPRE_ADSSetMaxIter(solver::HYPRE_Solver, maxit::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ADSSetTol(solver, tol)
    return @ccall libHYPRE.HYPRE_ADSSetTol(solver::HYPRE_Solver, tol::HYPRE_Real)::HYPRE_Int
end

function HYPRE_ADSSetCycleType(solver, cycle_type)
    return @ccall libHYPRE.HYPRE_ADSSetCycleType(solver::HYPRE_Solver, cycle_type::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ADSSetPrintLevel(solver, print_level)
    return @ccall libHYPRE.HYPRE_ADSSetPrintLevel(solver::HYPRE_Solver, print_level::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ADSSetSmoothingOptions(solver, relax_type, relax_times, relax_weight, omega)
    return @ccall libHYPRE.HYPRE_ADSSetSmoothingOptions(solver::HYPRE_Solver, relax_type::HYPRE_Int, relax_times::HYPRE_Int, relax_weight::HYPRE_Real, omega::HYPRE_Real)::HYPRE_Int
end

function HYPRE_ADSSetChebySmoothingOptions(solver, cheby_order, cheby_fraction)
    return @ccall libHYPRE.HYPRE_ADSSetChebySmoothingOptions(solver::HYPRE_Solver, cheby_order::HYPRE_Int, cheby_fraction::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ADSSetAMSOptions(solver, cycle_type, coarsen_type, agg_levels, relax_type, strength_threshold, interp_type, Pmax)
    return @ccall libHYPRE.HYPRE_ADSSetAMSOptions(solver::HYPRE_Solver, cycle_type::HYPRE_Int, coarsen_type::HYPRE_Int, agg_levels::HYPRE_Int, relax_type::HYPRE_Int, strength_threshold::HYPRE_Real, interp_type::HYPRE_Int, Pmax::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ADSSetAMGOptions(solver, coarsen_type, agg_levels, relax_type, strength_threshold, interp_type, Pmax)
    return @ccall libHYPRE.HYPRE_ADSSetAMGOptions(solver::HYPRE_Solver, coarsen_type::HYPRE_Int, agg_levels::HYPRE_Int, relax_type::HYPRE_Int, strength_threshold::HYPRE_Real, interp_type::HYPRE_Int, Pmax::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ADSGetNumIterations(solver, num_iterations)
    return @ccall libHYPRE.HYPRE_ADSGetNumIterations(solver::HYPRE_Solver, num_iterations::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_ADSGetFinalRelativeResidualNorm(solver, rel_resid_norm)
    return @ccall libHYPRE.HYPRE_ADSGetFinalRelativeResidualNorm(solver::HYPRE_Solver, rel_resid_norm::Ptr{HYPRE_Real})::HYPRE_Int
end

function HYPRE_ParCSRPCGCreate(comm, solver)
    return @ccall libHYPRE.HYPRE_ParCSRPCGCreate(comm::MPI_Comm, solver::Ptr{HYPRE_Solver})::HYPRE_Int
end

function HYPRE_ParCSRPCGDestroy(solver)
    return @ccall libHYPRE.HYPRE_ParCSRPCGDestroy(solver::HYPRE_Solver)::HYPRE_Int
end

function HYPRE_ParCSRPCGSetup(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_ParCSRPCGSetup(solver::HYPRE_Solver, A::HYPRE_ParCSRMatrix, b::HYPRE_ParVector, x::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_ParCSRPCGSolve(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_ParCSRPCGSolve(solver::HYPRE_Solver, A::HYPRE_ParCSRMatrix, b::HYPRE_ParVector, x::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_ParCSRPCGSetTol(solver, tol)
    return @ccall libHYPRE.HYPRE_ParCSRPCGSetTol(solver::HYPRE_Solver, tol::HYPRE_Real)::HYPRE_Int
end

function HYPRE_ParCSRPCGSetAbsoluteTol(solver, tol)
    return @ccall libHYPRE.HYPRE_ParCSRPCGSetAbsoluteTol(solver::HYPRE_Solver, tol::HYPRE_Real)::HYPRE_Int
end

function HYPRE_ParCSRPCGSetMaxIter(solver, max_iter)
    return @ccall libHYPRE.HYPRE_ParCSRPCGSetMaxIter(solver::HYPRE_Solver, max_iter::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRPCGSetStopCrit(solver, stop_crit)
    return @ccall libHYPRE.HYPRE_ParCSRPCGSetStopCrit(solver::HYPRE_Solver, stop_crit::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRPCGSetTwoNorm(solver, two_norm)
    return @ccall libHYPRE.HYPRE_ParCSRPCGSetTwoNorm(solver::HYPRE_Solver, two_norm::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRPCGSetRelChange(solver, rel_change)
    return @ccall libHYPRE.HYPRE_ParCSRPCGSetRelChange(solver::HYPRE_Solver, rel_change::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRPCGSetPrecond(solver, precond, precond_setup, precond_solver)
    return @ccall libHYPRE.HYPRE_ParCSRPCGSetPrecond(solver::HYPRE_Solver, precond::HYPRE_PtrToParSolverFcn, precond_setup::HYPRE_PtrToParSolverFcn, precond_solver::HYPRE_Solver)::HYPRE_Int
end

function HYPRE_ParCSRPCGGetPrecond(solver, precond_data)
    return @ccall libHYPRE.HYPRE_ParCSRPCGGetPrecond(solver::HYPRE_Solver, precond_data::Ptr{HYPRE_Solver})::HYPRE_Int
end

function HYPRE_ParCSRPCGSetLogging(solver, logging)
    return @ccall libHYPRE.HYPRE_ParCSRPCGSetLogging(solver::HYPRE_Solver, logging::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRPCGSetPrintLevel(solver, print_level)
    return @ccall libHYPRE.HYPRE_ParCSRPCGSetPrintLevel(solver::HYPRE_Solver, print_level::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRPCGGetNumIterations(solver, num_iterations)
    return @ccall libHYPRE.HYPRE_ParCSRPCGGetNumIterations(solver::HYPRE_Solver, num_iterations::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_ParCSRPCGGetFinalRelativeResidualNorm(solver, norm)
    return @ccall libHYPRE.HYPRE_ParCSRPCGGetFinalRelativeResidualNorm(solver::HYPRE_Solver, norm::Ptr{HYPRE_Real})::HYPRE_Int
end

function HYPRE_ParCSRPCGGetResidual(solver, residual)
    return @ccall libHYPRE.HYPRE_ParCSRPCGGetResidual(solver::HYPRE_Solver, residual::Ptr{HYPRE_ParVector})::HYPRE_Int
end

function HYPRE_ParCSRDiagScaleSetup(solver, A, y, x)
    return @ccall libHYPRE.HYPRE_ParCSRDiagScaleSetup(solver::HYPRE_Solver, A::HYPRE_ParCSRMatrix, y::HYPRE_ParVector, x::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_ParCSRDiagScale(solver, HA, Hy, Hx)
    return @ccall libHYPRE.HYPRE_ParCSRDiagScale(solver::HYPRE_Solver, HA::HYPRE_ParCSRMatrix, Hy::HYPRE_ParVector, Hx::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_ParCSROnProcTriSetup(solver, HA, Hy, Hx)
    return @ccall libHYPRE.HYPRE_ParCSROnProcTriSetup(solver::HYPRE_Solver, HA::HYPRE_ParCSRMatrix, Hy::HYPRE_ParVector, Hx::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_ParCSROnProcTriSolve(solver, HA, Hy, Hx)
    return @ccall libHYPRE.HYPRE_ParCSROnProcTriSolve(solver::HYPRE_Solver, HA::HYPRE_ParCSRMatrix, Hy::HYPRE_ParVector, Hx::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_ParCSRGMRESCreate(comm, solver)
    return @ccall libHYPRE.HYPRE_ParCSRGMRESCreate(comm::MPI_Comm, solver::Ptr{HYPRE_Solver})::HYPRE_Int
end

function HYPRE_ParCSRGMRESDestroy(solver)
    return @ccall libHYPRE.HYPRE_ParCSRGMRESDestroy(solver::HYPRE_Solver)::HYPRE_Int
end

function HYPRE_ParCSRGMRESSetup(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_ParCSRGMRESSetup(solver::HYPRE_Solver, A::HYPRE_ParCSRMatrix, b::HYPRE_ParVector, x::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_ParCSRGMRESSolve(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_ParCSRGMRESSolve(solver::HYPRE_Solver, A::HYPRE_ParCSRMatrix, b::HYPRE_ParVector, x::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_ParCSRGMRESSetKDim(solver, k_dim)
    return @ccall libHYPRE.HYPRE_ParCSRGMRESSetKDim(solver::HYPRE_Solver, k_dim::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRGMRESSetTol(solver, tol)
    return @ccall libHYPRE.HYPRE_ParCSRGMRESSetTol(solver::HYPRE_Solver, tol::HYPRE_Real)::HYPRE_Int
end

function HYPRE_ParCSRGMRESSetAbsoluteTol(solver, a_tol)
    return @ccall libHYPRE.HYPRE_ParCSRGMRESSetAbsoluteTol(solver::HYPRE_Solver, a_tol::HYPRE_Real)::HYPRE_Int
end

function HYPRE_ParCSRGMRESSetMinIter(solver, min_iter)
    return @ccall libHYPRE.HYPRE_ParCSRGMRESSetMinIter(solver::HYPRE_Solver, min_iter::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRGMRESSetMaxIter(solver, max_iter)
    return @ccall libHYPRE.HYPRE_ParCSRGMRESSetMaxIter(solver::HYPRE_Solver, max_iter::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRGMRESSetStopCrit(solver, stop_crit)
    return @ccall libHYPRE.HYPRE_ParCSRGMRESSetStopCrit(solver::HYPRE_Solver, stop_crit::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRGMRESSetPrecond(solver, precond, precond_setup, precond_solver)
    return @ccall libHYPRE.HYPRE_ParCSRGMRESSetPrecond(solver::HYPRE_Solver, precond::HYPRE_PtrToParSolverFcn, precond_setup::HYPRE_PtrToParSolverFcn, precond_solver::HYPRE_Solver)::HYPRE_Int
end

function HYPRE_ParCSRGMRESGetPrecond(solver, precond_data)
    return @ccall libHYPRE.HYPRE_ParCSRGMRESGetPrecond(solver::HYPRE_Solver, precond_data::Ptr{HYPRE_Solver})::HYPRE_Int
end

function HYPRE_ParCSRGMRESSetLogging(solver, logging)
    return @ccall libHYPRE.HYPRE_ParCSRGMRESSetLogging(solver::HYPRE_Solver, logging::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRGMRESSetPrintLevel(solver, print_level)
    return @ccall libHYPRE.HYPRE_ParCSRGMRESSetPrintLevel(solver::HYPRE_Solver, print_level::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRGMRESGetNumIterations(solver, num_iterations)
    return @ccall libHYPRE.HYPRE_ParCSRGMRESGetNumIterations(solver::HYPRE_Solver, num_iterations::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_ParCSRGMRESGetFinalRelativeResidualNorm(solver, norm)
    return @ccall libHYPRE.HYPRE_ParCSRGMRESGetFinalRelativeResidualNorm(solver::HYPRE_Solver, norm::Ptr{HYPRE_Real})::HYPRE_Int
end

function HYPRE_ParCSRGMRESGetResidual(solver, residual)
    return @ccall libHYPRE.HYPRE_ParCSRGMRESGetResidual(solver::HYPRE_Solver, residual::Ptr{HYPRE_ParVector})::HYPRE_Int
end

function HYPRE_ParCSRCOGMRESCreate(comm, solver)
    return @ccall libHYPRE.HYPRE_ParCSRCOGMRESCreate(comm::MPI_Comm, solver::Ptr{HYPRE_Solver})::HYPRE_Int
end

function HYPRE_ParCSRCOGMRESDestroy(solver)
    return @ccall libHYPRE.HYPRE_ParCSRCOGMRESDestroy(solver::HYPRE_Solver)::HYPRE_Int
end

function HYPRE_ParCSRCOGMRESSetup(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_ParCSRCOGMRESSetup(solver::HYPRE_Solver, A::HYPRE_ParCSRMatrix, b::HYPRE_ParVector, x::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_ParCSRCOGMRESSolve(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_ParCSRCOGMRESSolve(solver::HYPRE_Solver, A::HYPRE_ParCSRMatrix, b::HYPRE_ParVector, x::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_ParCSRCOGMRESSetKDim(solver, k_dim)
    return @ccall libHYPRE.HYPRE_ParCSRCOGMRESSetKDim(solver::HYPRE_Solver, k_dim::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRCOGMRESSetUnroll(solver, unroll)
    return @ccall libHYPRE.HYPRE_ParCSRCOGMRESSetUnroll(solver::HYPRE_Solver, unroll::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRCOGMRESSetCGS(solver, cgs)
    return @ccall libHYPRE.HYPRE_ParCSRCOGMRESSetCGS(solver::HYPRE_Solver, cgs::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRCOGMRESSetTol(solver, tol)
    return @ccall libHYPRE.HYPRE_ParCSRCOGMRESSetTol(solver::HYPRE_Solver, tol::HYPRE_Real)::HYPRE_Int
end

function HYPRE_ParCSRCOGMRESSetAbsoluteTol(solver, a_tol)
    return @ccall libHYPRE.HYPRE_ParCSRCOGMRESSetAbsoluteTol(solver::HYPRE_Solver, a_tol::HYPRE_Real)::HYPRE_Int
end

function HYPRE_ParCSRCOGMRESSetMinIter(solver, min_iter)
    return @ccall libHYPRE.HYPRE_ParCSRCOGMRESSetMinIter(solver::HYPRE_Solver, min_iter::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRCOGMRESSetMaxIter(solver, max_iter)
    return @ccall libHYPRE.HYPRE_ParCSRCOGMRESSetMaxIter(solver::HYPRE_Solver, max_iter::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRCOGMRESSetPrecond(solver, precond, precond_setup, precond_solver)
    return @ccall libHYPRE.HYPRE_ParCSRCOGMRESSetPrecond(solver::HYPRE_Solver, precond::HYPRE_PtrToParSolverFcn, precond_setup::HYPRE_PtrToParSolverFcn, precond_solver::HYPRE_Solver)::HYPRE_Int
end

function HYPRE_ParCSRCOGMRESGetPrecond(solver, precond_data)
    return @ccall libHYPRE.HYPRE_ParCSRCOGMRESGetPrecond(solver::HYPRE_Solver, precond_data::Ptr{HYPRE_Solver})::HYPRE_Int
end

function HYPRE_ParCSRCOGMRESSetLogging(solver, logging)
    return @ccall libHYPRE.HYPRE_ParCSRCOGMRESSetLogging(solver::HYPRE_Solver, logging::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRCOGMRESSetPrintLevel(solver, print_level)
    return @ccall libHYPRE.HYPRE_ParCSRCOGMRESSetPrintLevel(solver::HYPRE_Solver, print_level::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRCOGMRESGetNumIterations(solver, num_iterations)
    return @ccall libHYPRE.HYPRE_ParCSRCOGMRESGetNumIterations(solver::HYPRE_Solver, num_iterations::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_ParCSRCOGMRESGetFinalRelativeResidualNorm(solver, norm)
    return @ccall libHYPRE.HYPRE_ParCSRCOGMRESGetFinalRelativeResidualNorm(solver::HYPRE_Solver, norm::Ptr{HYPRE_Real})::HYPRE_Int
end

function HYPRE_ParCSRCOGMRESGetResidual(solver, residual)
    return @ccall libHYPRE.HYPRE_ParCSRCOGMRESGetResidual(solver::HYPRE_Solver, residual::Ptr{HYPRE_ParVector})::HYPRE_Int
end

function HYPRE_ParCSRFlexGMRESCreate(comm, solver)
    return @ccall libHYPRE.HYPRE_ParCSRFlexGMRESCreate(comm::MPI_Comm, solver::Ptr{HYPRE_Solver})::HYPRE_Int
end

function HYPRE_ParCSRFlexGMRESDestroy(solver)
    return @ccall libHYPRE.HYPRE_ParCSRFlexGMRESDestroy(solver::HYPRE_Solver)::HYPRE_Int
end

function HYPRE_ParCSRFlexGMRESSetup(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_ParCSRFlexGMRESSetup(solver::HYPRE_Solver, A::HYPRE_ParCSRMatrix, b::HYPRE_ParVector, x::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_ParCSRFlexGMRESSolve(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_ParCSRFlexGMRESSolve(solver::HYPRE_Solver, A::HYPRE_ParCSRMatrix, b::HYPRE_ParVector, x::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_ParCSRFlexGMRESSetKDim(solver, k_dim)
    return @ccall libHYPRE.HYPRE_ParCSRFlexGMRESSetKDim(solver::HYPRE_Solver, k_dim::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRFlexGMRESSetTol(solver, tol)
    return @ccall libHYPRE.HYPRE_ParCSRFlexGMRESSetTol(solver::HYPRE_Solver, tol::HYPRE_Real)::HYPRE_Int
end

function HYPRE_ParCSRFlexGMRESSetAbsoluteTol(solver, a_tol)
    return @ccall libHYPRE.HYPRE_ParCSRFlexGMRESSetAbsoluteTol(solver::HYPRE_Solver, a_tol::HYPRE_Real)::HYPRE_Int
end

function HYPRE_ParCSRFlexGMRESSetMinIter(solver, min_iter)
    return @ccall libHYPRE.HYPRE_ParCSRFlexGMRESSetMinIter(solver::HYPRE_Solver, min_iter::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRFlexGMRESSetMaxIter(solver, max_iter)
    return @ccall libHYPRE.HYPRE_ParCSRFlexGMRESSetMaxIter(solver::HYPRE_Solver, max_iter::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRFlexGMRESSetPrecond(solver, precond, precond_setup, precond_solver)
    return @ccall libHYPRE.HYPRE_ParCSRFlexGMRESSetPrecond(solver::HYPRE_Solver, precond::HYPRE_PtrToParSolverFcn, precond_setup::HYPRE_PtrToParSolverFcn, precond_solver::HYPRE_Solver)::HYPRE_Int
end

function HYPRE_ParCSRFlexGMRESGetPrecond(solver, precond_data)
    return @ccall libHYPRE.HYPRE_ParCSRFlexGMRESGetPrecond(solver::HYPRE_Solver, precond_data::Ptr{HYPRE_Solver})::HYPRE_Int
end

function HYPRE_ParCSRFlexGMRESSetLogging(solver, logging)
    return @ccall libHYPRE.HYPRE_ParCSRFlexGMRESSetLogging(solver::HYPRE_Solver, logging::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRFlexGMRESSetPrintLevel(solver, print_level)
    return @ccall libHYPRE.HYPRE_ParCSRFlexGMRESSetPrintLevel(solver::HYPRE_Solver, print_level::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRFlexGMRESGetNumIterations(solver, num_iterations)
    return @ccall libHYPRE.HYPRE_ParCSRFlexGMRESGetNumIterations(solver::HYPRE_Solver, num_iterations::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_ParCSRFlexGMRESGetFinalRelativeResidualNorm(solver, norm)
    return @ccall libHYPRE.HYPRE_ParCSRFlexGMRESGetFinalRelativeResidualNorm(solver::HYPRE_Solver, norm::Ptr{HYPRE_Real})::HYPRE_Int
end

function HYPRE_ParCSRFlexGMRESGetResidual(solver, residual)
    return @ccall libHYPRE.HYPRE_ParCSRFlexGMRESGetResidual(solver::HYPRE_Solver, residual::Ptr{HYPRE_ParVector})::HYPRE_Int
end

function HYPRE_ParCSRFlexGMRESSetModifyPC(solver, modify_pc)
    return @ccall libHYPRE.HYPRE_ParCSRFlexGMRESSetModifyPC(solver::HYPRE_Solver, modify_pc::HYPRE_PtrToModifyPCFcn)::HYPRE_Int
end

function HYPRE_ParCSRLGMRESCreate(comm, solver)
    return @ccall libHYPRE.HYPRE_ParCSRLGMRESCreate(comm::MPI_Comm, solver::Ptr{HYPRE_Solver})::HYPRE_Int
end

function HYPRE_ParCSRLGMRESDestroy(solver)
    return @ccall libHYPRE.HYPRE_ParCSRLGMRESDestroy(solver::HYPRE_Solver)::HYPRE_Int
end

function HYPRE_ParCSRLGMRESSetup(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_ParCSRLGMRESSetup(solver::HYPRE_Solver, A::HYPRE_ParCSRMatrix, b::HYPRE_ParVector, x::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_ParCSRLGMRESSolve(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_ParCSRLGMRESSolve(solver::HYPRE_Solver, A::HYPRE_ParCSRMatrix, b::HYPRE_ParVector, x::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_ParCSRLGMRESSetKDim(solver, k_dim)
    return @ccall libHYPRE.HYPRE_ParCSRLGMRESSetKDim(solver::HYPRE_Solver, k_dim::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRLGMRESSetAugDim(solver, aug_dim)
    return @ccall libHYPRE.HYPRE_ParCSRLGMRESSetAugDim(solver::HYPRE_Solver, aug_dim::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRLGMRESSetTol(solver, tol)
    return @ccall libHYPRE.HYPRE_ParCSRLGMRESSetTol(solver::HYPRE_Solver, tol::HYPRE_Real)::HYPRE_Int
end

function HYPRE_ParCSRLGMRESSetAbsoluteTol(solver, a_tol)
    return @ccall libHYPRE.HYPRE_ParCSRLGMRESSetAbsoluteTol(solver::HYPRE_Solver, a_tol::HYPRE_Real)::HYPRE_Int
end

function HYPRE_ParCSRLGMRESSetMinIter(solver, min_iter)
    return @ccall libHYPRE.HYPRE_ParCSRLGMRESSetMinIter(solver::HYPRE_Solver, min_iter::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRLGMRESSetMaxIter(solver, max_iter)
    return @ccall libHYPRE.HYPRE_ParCSRLGMRESSetMaxIter(solver::HYPRE_Solver, max_iter::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRLGMRESSetPrecond(solver, precond, precond_setup, precond_solver)
    return @ccall libHYPRE.HYPRE_ParCSRLGMRESSetPrecond(solver::HYPRE_Solver, precond::HYPRE_PtrToParSolverFcn, precond_setup::HYPRE_PtrToParSolverFcn, precond_solver::HYPRE_Solver)::HYPRE_Int
end

function HYPRE_ParCSRLGMRESGetPrecond(solver, precond_data)
    return @ccall libHYPRE.HYPRE_ParCSRLGMRESGetPrecond(solver::HYPRE_Solver, precond_data::Ptr{HYPRE_Solver})::HYPRE_Int
end

function HYPRE_ParCSRLGMRESSetLogging(solver, logging)
    return @ccall libHYPRE.HYPRE_ParCSRLGMRESSetLogging(solver::HYPRE_Solver, logging::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRLGMRESSetPrintLevel(solver, print_level)
    return @ccall libHYPRE.HYPRE_ParCSRLGMRESSetPrintLevel(solver::HYPRE_Solver, print_level::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRLGMRESGetNumIterations(solver, num_iterations)
    return @ccall libHYPRE.HYPRE_ParCSRLGMRESGetNumIterations(solver::HYPRE_Solver, num_iterations::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_ParCSRLGMRESGetFinalRelativeResidualNorm(solver, norm)
    return @ccall libHYPRE.HYPRE_ParCSRLGMRESGetFinalRelativeResidualNorm(solver::HYPRE_Solver, norm::Ptr{HYPRE_Real})::HYPRE_Int
end

function HYPRE_ParCSRLGMRESGetResidual(solver, residual)
    return @ccall libHYPRE.HYPRE_ParCSRLGMRESGetResidual(solver::HYPRE_Solver, residual::Ptr{HYPRE_ParVector})::HYPRE_Int
end

function HYPRE_ParCSRBiCGSTABCreate(comm, solver)
    return @ccall libHYPRE.HYPRE_ParCSRBiCGSTABCreate(comm::MPI_Comm, solver::Ptr{HYPRE_Solver})::HYPRE_Int
end

function HYPRE_ParCSRBiCGSTABDestroy(solver)
    return @ccall libHYPRE.HYPRE_ParCSRBiCGSTABDestroy(solver::HYPRE_Solver)::HYPRE_Int
end

function HYPRE_ParCSRBiCGSTABSetup(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_ParCSRBiCGSTABSetup(solver::HYPRE_Solver, A::HYPRE_ParCSRMatrix, b::HYPRE_ParVector, x::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_ParCSRBiCGSTABSolve(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_ParCSRBiCGSTABSolve(solver::HYPRE_Solver, A::HYPRE_ParCSRMatrix, b::HYPRE_ParVector, x::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_ParCSRBiCGSTABSetTol(solver, tol)
    return @ccall libHYPRE.HYPRE_ParCSRBiCGSTABSetTol(solver::HYPRE_Solver, tol::HYPRE_Real)::HYPRE_Int
end

function HYPRE_ParCSRBiCGSTABSetAbsoluteTol(solver, a_tol)
    return @ccall libHYPRE.HYPRE_ParCSRBiCGSTABSetAbsoluteTol(solver::HYPRE_Solver, a_tol::HYPRE_Real)::HYPRE_Int
end

function HYPRE_ParCSRBiCGSTABSetMinIter(solver, min_iter)
    return @ccall libHYPRE.HYPRE_ParCSRBiCGSTABSetMinIter(solver::HYPRE_Solver, min_iter::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRBiCGSTABSetMaxIter(solver, max_iter)
    return @ccall libHYPRE.HYPRE_ParCSRBiCGSTABSetMaxIter(solver::HYPRE_Solver, max_iter::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRBiCGSTABSetStopCrit(solver, stop_crit)
    return @ccall libHYPRE.HYPRE_ParCSRBiCGSTABSetStopCrit(solver::HYPRE_Solver, stop_crit::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRBiCGSTABSetPrecond(solver, precond, precond_setup, precond_solver)
    return @ccall libHYPRE.HYPRE_ParCSRBiCGSTABSetPrecond(solver::HYPRE_Solver, precond::HYPRE_PtrToParSolverFcn, precond_setup::HYPRE_PtrToParSolverFcn, precond_solver::HYPRE_Solver)::HYPRE_Int
end

function HYPRE_ParCSRBiCGSTABGetPrecond(solver, precond_data)
    return @ccall libHYPRE.HYPRE_ParCSRBiCGSTABGetPrecond(solver::HYPRE_Solver, precond_data::Ptr{HYPRE_Solver})::HYPRE_Int
end

function HYPRE_ParCSRBiCGSTABSetLogging(solver, logging)
    return @ccall libHYPRE.HYPRE_ParCSRBiCGSTABSetLogging(solver::HYPRE_Solver, logging::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRBiCGSTABSetPrintLevel(solver, print_level)
    return @ccall libHYPRE.HYPRE_ParCSRBiCGSTABSetPrintLevel(solver::HYPRE_Solver, print_level::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRBiCGSTABGetNumIterations(solver, num_iterations)
    return @ccall libHYPRE.HYPRE_ParCSRBiCGSTABGetNumIterations(solver::HYPRE_Solver, num_iterations::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_ParCSRBiCGSTABGetFinalRelativeResidualNorm(solver, norm)
    return @ccall libHYPRE.HYPRE_ParCSRBiCGSTABGetFinalRelativeResidualNorm(solver::HYPRE_Solver, norm::Ptr{HYPRE_Real})::HYPRE_Int
end

function HYPRE_ParCSRBiCGSTABGetResidual(solver, residual)
    return @ccall libHYPRE.HYPRE_ParCSRBiCGSTABGetResidual(solver::HYPRE_Solver, residual::Ptr{HYPRE_ParVector})::HYPRE_Int
end

function HYPRE_ParCSRHybridCreate(solver)
    return @ccall libHYPRE.HYPRE_ParCSRHybridCreate(solver::Ptr{HYPRE_Solver})::HYPRE_Int
end

function HYPRE_ParCSRHybridDestroy(solver)
    return @ccall libHYPRE.HYPRE_ParCSRHybridDestroy(solver::HYPRE_Solver)::HYPRE_Int
end

function HYPRE_ParCSRHybridSetup(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSetup(solver::HYPRE_Solver, A::HYPRE_ParCSRMatrix, b::HYPRE_ParVector, x::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_ParCSRHybridSolve(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSolve(solver::HYPRE_Solver, A::HYPRE_ParCSRMatrix, b::HYPRE_ParVector, x::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_ParCSRHybridSetTol(solver, tol)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSetTol(solver::HYPRE_Solver, tol::HYPRE_Real)::HYPRE_Int
end

function HYPRE_ParCSRHybridSetAbsoluteTol(solver, tol)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSetAbsoluteTol(solver::HYPRE_Solver, tol::HYPRE_Real)::HYPRE_Int
end

function HYPRE_ParCSRHybridSetConvergenceTol(solver, cf_tol)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSetConvergenceTol(solver::HYPRE_Solver, cf_tol::HYPRE_Real)::HYPRE_Int
end

function HYPRE_ParCSRHybridSetDSCGMaxIter(solver, dscg_max_its)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSetDSCGMaxIter(solver::HYPRE_Solver, dscg_max_its::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRHybridSetPCGMaxIter(solver, pcg_max_its)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSetPCGMaxIter(solver::HYPRE_Solver, pcg_max_its::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRHybridSetSetupType(solver, setup_type)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSetSetupType(solver::HYPRE_Solver, setup_type::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRHybridSetSolverType(solver, solver_type)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSetSolverType(solver::HYPRE_Solver, solver_type::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRHybridSetRecomputeResidual(solver, recompute_residual)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSetRecomputeResidual(solver::HYPRE_Solver, recompute_residual::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRHybridGetRecomputeResidual(solver, recompute_residual)
    return @ccall libHYPRE.HYPRE_ParCSRHybridGetRecomputeResidual(solver::HYPRE_Solver, recompute_residual::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_ParCSRHybridSetRecomputeResidualP(solver, recompute_residual_p)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSetRecomputeResidualP(solver::HYPRE_Solver, recompute_residual_p::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRHybridGetRecomputeResidualP(solver, recompute_residual_p)
    return @ccall libHYPRE.HYPRE_ParCSRHybridGetRecomputeResidualP(solver::HYPRE_Solver, recompute_residual_p::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_ParCSRHybridSetKDim(solver, k_dim)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSetKDim(solver::HYPRE_Solver, k_dim::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRHybridSetTwoNorm(solver, two_norm)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSetTwoNorm(solver::HYPRE_Solver, two_norm::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRHybridSetStopCrit(solver, stop_crit)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSetStopCrit(solver::HYPRE_Solver, stop_crit::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRHybridSetRelChange(solver, rel_change)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSetRelChange(solver::HYPRE_Solver, rel_change::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRHybridSetPrecond(solver, precond, precond_setup, precond_solver)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSetPrecond(solver::HYPRE_Solver, precond::HYPRE_PtrToParSolverFcn, precond_setup::HYPRE_PtrToParSolverFcn, precond_solver::HYPRE_Solver)::HYPRE_Int
end

function HYPRE_ParCSRHybridSetLogging(solver, logging)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSetLogging(solver::HYPRE_Solver, logging::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRHybridSetPrintLevel(solver, print_level)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSetPrintLevel(solver::HYPRE_Solver, print_level::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRHybridSetStrongThreshold(solver, strong_threshold)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSetStrongThreshold(solver::HYPRE_Solver, strong_threshold::HYPRE_Real)::HYPRE_Int
end

function HYPRE_ParCSRHybridSetMaxRowSum(solver, max_row_sum)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSetMaxRowSum(solver::HYPRE_Solver, max_row_sum::HYPRE_Real)::HYPRE_Int
end

function HYPRE_ParCSRHybridSetTruncFactor(solver, trunc_factor)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSetTruncFactor(solver::HYPRE_Solver, trunc_factor::HYPRE_Real)::HYPRE_Int
end

function HYPRE_ParCSRHybridSetPMaxElmts(solver, P_max_elmts)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSetPMaxElmts(solver::HYPRE_Solver, P_max_elmts::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRHybridSetMaxLevels(solver, max_levels)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSetMaxLevels(solver::HYPRE_Solver, max_levels::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRHybridSetMeasureType(solver, measure_type)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSetMeasureType(solver::HYPRE_Solver, measure_type::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRHybridSetCoarsenType(solver, coarsen_type)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSetCoarsenType(solver::HYPRE_Solver, coarsen_type::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRHybridSetInterpType(solver, interp_type)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSetInterpType(solver::HYPRE_Solver, interp_type::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRHybridSetCycleType(solver, cycle_type)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSetCycleType(solver::HYPRE_Solver, cycle_type::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRHybridSetGridRelaxType(solver, grid_relax_type)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSetGridRelaxType(solver::HYPRE_Solver, grid_relax_type::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_ParCSRHybridSetGridRelaxPoints(solver, grid_relax_points)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSetGridRelaxPoints(solver::HYPRE_Solver, grid_relax_points::Ptr{Ptr{HYPRE_Int}})::HYPRE_Int
end

function HYPRE_ParCSRHybridSetNumSweeps(solver, num_sweeps)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSetNumSweeps(solver::HYPRE_Solver, num_sweeps::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRHybridSetCycleNumSweeps(solver, num_sweeps, k)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSetCycleNumSweeps(solver::HYPRE_Solver, num_sweeps::HYPRE_Int, k::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRHybridSetRelaxType(solver, relax_type)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSetRelaxType(solver::HYPRE_Solver, relax_type::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRHybridSetCycleRelaxType(solver, relax_type, k)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSetCycleRelaxType(solver::HYPRE_Solver, relax_type::HYPRE_Int, k::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRHybridSetRelaxOrder(solver, relax_order)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSetRelaxOrder(solver::HYPRE_Solver, relax_order::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRHybridSetRelaxWt(solver, relax_wt)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSetRelaxWt(solver::HYPRE_Solver, relax_wt::HYPRE_Real)::HYPRE_Int
end

function HYPRE_ParCSRHybridSetLevelRelaxWt(solver, relax_wt, level)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSetLevelRelaxWt(solver::HYPRE_Solver, relax_wt::HYPRE_Real, level::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRHybridSetOuterWt(solver, outer_wt)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSetOuterWt(solver::HYPRE_Solver, outer_wt::HYPRE_Real)::HYPRE_Int
end

function HYPRE_ParCSRHybridSetLevelOuterWt(solver, outer_wt, level)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSetLevelOuterWt(solver::HYPRE_Solver, outer_wt::HYPRE_Real, level::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRHybridSetMaxCoarseSize(solver, max_coarse_size)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSetMaxCoarseSize(solver::HYPRE_Solver, max_coarse_size::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRHybridSetMinCoarseSize(solver, min_coarse_size)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSetMinCoarseSize(solver::HYPRE_Solver, min_coarse_size::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRHybridSetSeqThreshold(solver, seq_threshold)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSetSeqThreshold(solver::HYPRE_Solver, seq_threshold::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRHybridSetRelaxWeight(solver, relax_weight)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSetRelaxWeight(solver::HYPRE_Solver, relax_weight::Ptr{HYPRE_Real})::HYPRE_Int
end

function HYPRE_ParCSRHybridSetOmega(solver, omega)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSetOmega(solver::HYPRE_Solver, omega::Ptr{HYPRE_Real})::HYPRE_Int
end

function HYPRE_ParCSRHybridSetAggNumLevels(solver, agg_num_levels)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSetAggNumLevels(solver::HYPRE_Solver, agg_num_levels::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRHybridSetAggInterpType(solver, agg_interp_type)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSetAggInterpType(solver::HYPRE_Solver, agg_interp_type::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRHybridSetNumPaths(solver, num_paths)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSetNumPaths(solver::HYPRE_Solver, num_paths::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRHybridSetNumFunctions(solver, num_functions)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSetNumFunctions(solver::HYPRE_Solver, num_functions::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRHybridSetDofFunc(solver, dof_func)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSetDofFunc(solver::HYPRE_Solver, dof_func::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_ParCSRHybridSetNodal(solver, nodal)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSetNodal(solver::HYPRE_Solver, nodal::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRHybridSetKeepTranspose(solver, keepT)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSetKeepTranspose(solver::HYPRE_Solver, keepT::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRHybridSetNonGalerkinTol(solver, num_levels, nongalerkin_tol)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSetNonGalerkinTol(solver::HYPRE_Solver, num_levels::HYPRE_Int, nongalerkin_tol::Ptr{HYPRE_Real})::HYPRE_Int
end

function HYPRE_ParCSRHybridGetNumIterations(solver, num_its)
    return @ccall libHYPRE.HYPRE_ParCSRHybridGetNumIterations(solver::HYPRE_Solver, num_its::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_ParCSRHybridGetDSCGNumIterations(solver, dscg_num_its)
    return @ccall libHYPRE.HYPRE_ParCSRHybridGetDSCGNumIterations(solver::HYPRE_Solver, dscg_num_its::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_ParCSRHybridGetPCGNumIterations(solver, pcg_num_its)
    return @ccall libHYPRE.HYPRE_ParCSRHybridGetPCGNumIterations(solver::HYPRE_Solver, pcg_num_its::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_ParCSRHybridGetFinalRelativeResidualNorm(solver, norm)
    return @ccall libHYPRE.HYPRE_ParCSRHybridGetFinalRelativeResidualNorm(solver::HYPRE_Solver, norm::Ptr{HYPRE_Real})::HYPRE_Int
end

function HYPRE_ParCSRHybridSetNumGridSweeps(solver, num_grid_sweeps)
    return @ccall libHYPRE.HYPRE_ParCSRHybridSetNumGridSweeps(solver::HYPRE_Solver, num_grid_sweeps::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_ParCSRHybridGetSetupSolveTime(solver, time)
    return @ccall libHYPRE.HYPRE_ParCSRHybridGetSetupSolveTime(solver::HYPRE_Solver, time::Ptr{HYPRE_Real})::HYPRE_Int
end

function HYPRE_SchwarzCreate(solver)
    return @ccall libHYPRE.HYPRE_SchwarzCreate(solver::Ptr{HYPRE_Solver})::HYPRE_Int
end

function HYPRE_SchwarzDestroy(solver)
    return @ccall libHYPRE.HYPRE_SchwarzDestroy(solver::HYPRE_Solver)::HYPRE_Int
end

function HYPRE_SchwarzSetup(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_SchwarzSetup(solver::HYPRE_Solver, A::HYPRE_ParCSRMatrix, b::HYPRE_ParVector, x::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_SchwarzSolve(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_SchwarzSolve(solver::HYPRE_Solver, A::HYPRE_ParCSRMatrix, b::HYPRE_ParVector, x::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_SchwarzSetVariant(solver, variant)
    return @ccall libHYPRE.HYPRE_SchwarzSetVariant(solver::HYPRE_Solver, variant::HYPRE_Int)::HYPRE_Int
end

function HYPRE_SchwarzSetOverlap(solver, overlap)
    return @ccall libHYPRE.HYPRE_SchwarzSetOverlap(solver::HYPRE_Solver, overlap::HYPRE_Int)::HYPRE_Int
end

function HYPRE_SchwarzSetDomainType(solver, domain_type)
    return @ccall libHYPRE.HYPRE_SchwarzSetDomainType(solver::HYPRE_Solver, domain_type::HYPRE_Int)::HYPRE_Int
end

function HYPRE_SchwarzSetRelaxWeight(solver, relax_weight)
    return @ccall libHYPRE.HYPRE_SchwarzSetRelaxWeight(solver::HYPRE_Solver, relax_weight::HYPRE_Real)::HYPRE_Int
end

function HYPRE_SchwarzSetDomainStructure(solver, domain_structure)
    return @ccall libHYPRE.HYPRE_SchwarzSetDomainStructure(solver::HYPRE_Solver, domain_structure::HYPRE_CSRMatrix)::HYPRE_Int
end

function HYPRE_SchwarzSetNumFunctions(solver, num_functions)
    return @ccall libHYPRE.HYPRE_SchwarzSetNumFunctions(solver::HYPRE_Solver, num_functions::HYPRE_Int)::HYPRE_Int
end

function HYPRE_SchwarzSetDofFunc(solver, dof_func)
    return @ccall libHYPRE.HYPRE_SchwarzSetDofFunc(solver::HYPRE_Solver, dof_func::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_SchwarzSetNonSymm(solver, use_nonsymm)
    return @ccall libHYPRE.HYPRE_SchwarzSetNonSymm(solver::HYPRE_Solver, use_nonsymm::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRCGNRCreate(comm, solver)
    return @ccall libHYPRE.HYPRE_ParCSRCGNRCreate(comm::MPI_Comm, solver::Ptr{HYPRE_Solver})::HYPRE_Int
end

function HYPRE_ParCSRCGNRDestroy(solver)
    return @ccall libHYPRE.HYPRE_ParCSRCGNRDestroy(solver::HYPRE_Solver)::HYPRE_Int
end

function HYPRE_ParCSRCGNRSetup(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_ParCSRCGNRSetup(solver::HYPRE_Solver, A::HYPRE_ParCSRMatrix, b::HYPRE_ParVector, x::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_ParCSRCGNRSolve(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_ParCSRCGNRSolve(solver::HYPRE_Solver, A::HYPRE_ParCSRMatrix, b::HYPRE_ParVector, x::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_ParCSRCGNRSetTol(solver, tol)
    return @ccall libHYPRE.HYPRE_ParCSRCGNRSetTol(solver::HYPRE_Solver, tol::HYPRE_Real)::HYPRE_Int
end

function HYPRE_ParCSRCGNRSetMinIter(solver, min_iter)
    return @ccall libHYPRE.HYPRE_ParCSRCGNRSetMinIter(solver::HYPRE_Solver, min_iter::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRCGNRSetMaxIter(solver, max_iter)
    return @ccall libHYPRE.HYPRE_ParCSRCGNRSetMaxIter(solver::HYPRE_Solver, max_iter::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRCGNRSetStopCrit(solver, stop_crit)
    return @ccall libHYPRE.HYPRE_ParCSRCGNRSetStopCrit(solver::HYPRE_Solver, stop_crit::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRCGNRSetPrecond(solver, precond, precondT, precond_setup, precond_solver)
    return @ccall libHYPRE.HYPRE_ParCSRCGNRSetPrecond(solver::HYPRE_Solver, precond::HYPRE_PtrToParSolverFcn, precondT::HYPRE_PtrToParSolverFcn, precond_setup::HYPRE_PtrToParSolverFcn, precond_solver::HYPRE_Solver)::HYPRE_Int
end

function HYPRE_ParCSRCGNRGetPrecond(solver, precond_data)
    return @ccall libHYPRE.HYPRE_ParCSRCGNRGetPrecond(solver::HYPRE_Solver, precond_data::Ptr{HYPRE_Solver})::HYPRE_Int
end

function HYPRE_ParCSRCGNRSetLogging(solver, logging)
    return @ccall libHYPRE.HYPRE_ParCSRCGNRSetLogging(solver::HYPRE_Solver, logging::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRCGNRGetNumIterations(solver, num_iterations)
    return @ccall libHYPRE.HYPRE_ParCSRCGNRGetNumIterations(solver::HYPRE_Solver, num_iterations::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_ParCSRCGNRGetFinalRelativeResidualNorm(solver, norm)
    return @ccall libHYPRE.HYPRE_ParCSRCGNRGetFinalRelativeResidualNorm(solver::HYPRE_Solver, norm::Ptr{HYPRE_Real})::HYPRE_Int
end

function HYPRE_MGRCreate(solver)
    return @ccall libHYPRE.HYPRE_MGRCreate(solver::Ptr{HYPRE_Solver})::HYPRE_Int
end

function HYPRE_MGRDestroy(solver)
    return @ccall libHYPRE.HYPRE_MGRDestroy(solver::HYPRE_Solver)::HYPRE_Int
end

function HYPRE_MGRSetup(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_MGRSetup(solver::HYPRE_Solver, A::HYPRE_ParCSRMatrix, b::HYPRE_ParVector, x::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_MGRSolve(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_MGRSolve(solver::HYPRE_Solver, A::HYPRE_ParCSRMatrix, b::HYPRE_ParVector, x::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_MGRSetCpointsByContiguousBlock(solver, block_size, max_num_levels, idx_array, num_block_coarse_points, block_coarse_indexes)
    return @ccall libHYPRE.HYPRE_MGRSetCpointsByContiguousBlock(solver::HYPRE_Solver, block_size::HYPRE_Int, max_num_levels::HYPRE_Int, idx_array::Ptr{HYPRE_BigInt}, num_block_coarse_points::Ptr{HYPRE_Int}, block_coarse_indexes::Ptr{Ptr{HYPRE_Int}})::HYPRE_Int
end

function HYPRE_MGRSetCpointsByBlock(solver, block_size, max_num_levels, num_block_coarse_points, block_coarse_indexes)
    return @ccall libHYPRE.HYPRE_MGRSetCpointsByBlock(solver::HYPRE_Solver, block_size::HYPRE_Int, max_num_levels::HYPRE_Int, num_block_coarse_points::Ptr{HYPRE_Int}, block_coarse_indexes::Ptr{Ptr{HYPRE_Int}})::HYPRE_Int
end

function HYPRE_MGRSetCpointsByPointMarkerArray(solver, block_size, max_num_levels, num_block_coarse_points, lvl_block_coarse_indexes, point_marker_array)
    return @ccall libHYPRE.HYPRE_MGRSetCpointsByPointMarkerArray(solver::HYPRE_Solver, block_size::HYPRE_Int, max_num_levels::HYPRE_Int, num_block_coarse_points::Ptr{HYPRE_Int}, lvl_block_coarse_indexes::Ptr{Ptr{HYPRE_Int}}, point_marker_array::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_MGRSetNonCpointsToFpoints(solver, nonCptToFptFlag)
    return @ccall libHYPRE.HYPRE_MGRSetNonCpointsToFpoints(solver::HYPRE_Solver, nonCptToFptFlag::HYPRE_Int)::HYPRE_Int
end

function HYPRE_MGRSetMaxCoarseLevels(solver, maxlev)
    return @ccall libHYPRE.HYPRE_MGRSetMaxCoarseLevels(solver::HYPRE_Solver, maxlev::HYPRE_Int)::HYPRE_Int
end

function HYPRE_MGRSetBlockSize(solver, bsize)
    return @ccall libHYPRE.HYPRE_MGRSetBlockSize(solver::HYPRE_Solver, bsize::HYPRE_Int)::HYPRE_Int
end

function HYPRE_MGRSetReservedCoarseNodes(solver, reserved_coarse_size, reserved_coarse_nodes)
    return @ccall libHYPRE.HYPRE_MGRSetReservedCoarseNodes(solver::HYPRE_Solver, reserved_coarse_size::HYPRE_Int, reserved_coarse_nodes::Ptr{HYPRE_BigInt})::HYPRE_Int
end

function HYPRE_MGRSetReservedCpointsLevelToKeep(solver, level)
    return @ccall libHYPRE.HYPRE_MGRSetReservedCpointsLevelToKeep(solver::HYPRE_Solver, level::HYPRE_Int)::HYPRE_Int
end

function HYPRE_MGRSetRelaxType(solver, relax_type)
    return @ccall libHYPRE.HYPRE_MGRSetRelaxType(solver::HYPRE_Solver, relax_type::HYPRE_Int)::HYPRE_Int
end

function HYPRE_MGRSetFRelaxMethod(solver, relax_method)
    return @ccall libHYPRE.HYPRE_MGRSetFRelaxMethod(solver::HYPRE_Solver, relax_method::HYPRE_Int)::HYPRE_Int
end

function HYPRE_MGRSetLevelFRelaxMethod(solver, relax_method)
    return @ccall libHYPRE.HYPRE_MGRSetLevelFRelaxMethod(solver::HYPRE_Solver, relax_method::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_MGRSetCoarseGridMethod(solver, cg_method)
    return @ccall libHYPRE.HYPRE_MGRSetCoarseGridMethod(solver::HYPRE_Solver, cg_method::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_MGRSetLevelFRelaxNumFunctions(solver, num_functions)
    return @ccall libHYPRE.HYPRE_MGRSetLevelFRelaxNumFunctions(solver::HYPRE_Solver, num_functions::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_MGRSetRestrictType(solver, restrict_type)
    return @ccall libHYPRE.HYPRE_MGRSetRestrictType(solver::HYPRE_Solver, restrict_type::HYPRE_Int)::HYPRE_Int
end

function HYPRE_MGRSetLevelRestrictType(solver, restrict_type)
    return @ccall libHYPRE.HYPRE_MGRSetLevelRestrictType(solver::HYPRE_Solver, restrict_type::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_MGRSetNumRestrictSweeps(solver, nsweeps)
    return @ccall libHYPRE.HYPRE_MGRSetNumRestrictSweeps(solver::HYPRE_Solver, nsweeps::HYPRE_Int)::HYPRE_Int
end

function HYPRE_MGRSetInterpType(solver, interp_type)
    return @ccall libHYPRE.HYPRE_MGRSetInterpType(solver::HYPRE_Solver, interp_type::HYPRE_Int)::HYPRE_Int
end

function HYPRE_MGRSetLevelInterpType(solver, interp_type)
    return @ccall libHYPRE.HYPRE_MGRSetLevelInterpType(solver::HYPRE_Solver, interp_type::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_MGRSetNumRelaxSweeps(solver, nsweeps)
    return @ccall libHYPRE.HYPRE_MGRSetNumRelaxSweeps(solver::HYPRE_Solver, nsweeps::HYPRE_Int)::HYPRE_Int
end

function HYPRE_MGRSetNumInterpSweeps(solver, nsweeps)
    return @ccall libHYPRE.HYPRE_MGRSetNumInterpSweeps(solver::HYPRE_Solver, nsweeps::HYPRE_Int)::HYPRE_Int
end

function HYPRE_MGRSetFSolver(solver, fine_grid_solver_solve, fine_grid_solver_setup, fsolver)
    return @ccall libHYPRE.HYPRE_MGRSetFSolver(solver::HYPRE_Solver, fine_grid_solver_solve::HYPRE_PtrToParSolverFcn, fine_grid_solver_setup::HYPRE_PtrToParSolverFcn, fsolver::HYPRE_Solver)::HYPRE_Int
end

function HYPRE_MGRBuildAff(A, CF_marker, debug_flag, A_ff)
    return @ccall libHYPRE.HYPRE_MGRBuildAff(A::HYPRE_ParCSRMatrix, CF_marker::Ptr{HYPRE_Int}, debug_flag::HYPRE_Int, A_ff::Ptr{HYPRE_ParCSRMatrix})::HYPRE_Int
end

function HYPRE_MGRSetCoarseSolver(solver, coarse_grid_solver_solve, coarse_grid_solver_setup, coarse_grid_solver)
    return @ccall libHYPRE.HYPRE_MGRSetCoarseSolver(solver::HYPRE_Solver, coarse_grid_solver_solve::HYPRE_PtrToParSolverFcn, coarse_grid_solver_setup::HYPRE_PtrToParSolverFcn, coarse_grid_solver::HYPRE_Solver)::HYPRE_Int
end

function HYPRE_MGRSetPrintLevel(solver, print_level)
    return @ccall libHYPRE.HYPRE_MGRSetPrintLevel(solver::HYPRE_Solver, print_level::HYPRE_Int)::HYPRE_Int
end

function HYPRE_MGRSetFrelaxPrintLevel(solver, print_level)
    return @ccall libHYPRE.HYPRE_MGRSetFrelaxPrintLevel(solver::HYPRE_Solver, print_level::HYPRE_Int)::HYPRE_Int
end

function HYPRE_MGRSetCoarseGridPrintLevel(solver, print_level)
    return @ccall libHYPRE.HYPRE_MGRSetCoarseGridPrintLevel(solver::HYPRE_Solver, print_level::HYPRE_Int)::HYPRE_Int
end

function HYPRE_MGRSetTruncateCoarseGridThreshold(solver, threshold)
    return @ccall libHYPRE.HYPRE_MGRSetTruncateCoarseGridThreshold(solver::HYPRE_Solver, threshold::HYPRE_Real)::HYPRE_Int
end

function HYPRE_MGRSetLogging(solver, logging)
    return @ccall libHYPRE.HYPRE_MGRSetLogging(solver::HYPRE_Solver, logging::HYPRE_Int)::HYPRE_Int
end

function HYPRE_MGRSetMaxIter(solver, max_iter)
    return @ccall libHYPRE.HYPRE_MGRSetMaxIter(solver::HYPRE_Solver, max_iter::HYPRE_Int)::HYPRE_Int
end

function HYPRE_MGRSetTol(solver, tol)
    return @ccall libHYPRE.HYPRE_MGRSetTol(solver::HYPRE_Solver, tol::HYPRE_Real)::HYPRE_Int
end

function HYPRE_MGRSetMaxGlobalsmoothIters(solver, smooth_iter)
    return @ccall libHYPRE.HYPRE_MGRSetMaxGlobalsmoothIters(solver::HYPRE_Solver, smooth_iter::HYPRE_Int)::HYPRE_Int
end

function HYPRE_MGRSetGlobalsmoothType(solver, smooth_type)
    return @ccall libHYPRE.HYPRE_MGRSetGlobalsmoothType(solver::HYPRE_Solver, smooth_type::HYPRE_Int)::HYPRE_Int
end

function HYPRE_MGRGetNumIterations(solver, num_iterations)
    return @ccall libHYPRE.HYPRE_MGRGetNumIterations(solver::HYPRE_Solver, num_iterations::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_MGRGetCoarseGridConvergenceFactor(solver, conv_factor)
    return @ccall libHYPRE.HYPRE_MGRGetCoarseGridConvergenceFactor(solver::HYPRE_Solver, conv_factor::Ptr{HYPRE_Real})::HYPRE_Int
end

function HYPRE_MGRSetPMaxElmts(solver, P_max_elmts)
    return @ccall libHYPRE.HYPRE_MGRSetPMaxElmts(solver::HYPRE_Solver, P_max_elmts::HYPRE_Int)::HYPRE_Int
end

function HYPRE_MGRGetFinalRelativeResidualNorm(solver, res_norm)
    return @ccall libHYPRE.HYPRE_MGRGetFinalRelativeResidualNorm(solver::HYPRE_Solver, res_norm::Ptr{HYPRE_Real})::HYPRE_Int
end

function HYPRE_ILUCreate(solver)
    return @ccall libHYPRE.HYPRE_ILUCreate(solver::Ptr{HYPRE_Solver})::HYPRE_Int
end

function HYPRE_ILUDestroy(solver)
    return @ccall libHYPRE.HYPRE_ILUDestroy(solver::HYPRE_Solver)::HYPRE_Int
end

function HYPRE_ILUSetup(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_ILUSetup(solver::HYPRE_Solver, A::HYPRE_ParCSRMatrix, b::HYPRE_ParVector, x::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_ILUSolve(solver, A, b, x)
    return @ccall libHYPRE.HYPRE_ILUSolve(solver::HYPRE_Solver, A::HYPRE_ParCSRMatrix, b::HYPRE_ParVector, x::HYPRE_ParVector)::HYPRE_Int
end

function HYPRE_ILUSetMaxIter(solver, max_iter)
    return @ccall libHYPRE.HYPRE_ILUSetMaxIter(solver::HYPRE_Solver, max_iter::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ILUSetTol(solver, tol)
    return @ccall libHYPRE.HYPRE_ILUSetTol(solver::HYPRE_Solver, tol::HYPRE_Real)::HYPRE_Int
end

function HYPRE_ILUSetLevelOfFill(solver, lfil)
    return @ccall libHYPRE.HYPRE_ILUSetLevelOfFill(solver::HYPRE_Solver, lfil::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ILUSetMaxNnzPerRow(solver, nzmax)
    return @ccall libHYPRE.HYPRE_ILUSetMaxNnzPerRow(solver::HYPRE_Solver, nzmax::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ILUSetDropThreshold(solver, threshold)
    return @ccall libHYPRE.HYPRE_ILUSetDropThreshold(solver::HYPRE_Solver, threshold::HYPRE_Real)::HYPRE_Int
end

function HYPRE_ILUSetDropThresholdArray(solver, threshold)
    return @ccall libHYPRE.HYPRE_ILUSetDropThresholdArray(solver::HYPRE_Solver, threshold::Ptr{HYPRE_Real})::HYPRE_Int
end

function HYPRE_ILUSetNSHDropThreshold(solver, threshold)
    return @ccall libHYPRE.HYPRE_ILUSetNSHDropThreshold(solver::HYPRE_Solver, threshold::HYPRE_Real)::HYPRE_Int
end

function HYPRE_ILUSetNSHDropThresholdArray(solver, threshold)
    return @ccall libHYPRE.HYPRE_ILUSetNSHDropThresholdArray(solver::HYPRE_Solver, threshold::Ptr{HYPRE_Real})::HYPRE_Int
end

function HYPRE_ILUSetSchurMaxIter(solver, ss_max_iter)
    return @ccall libHYPRE.HYPRE_ILUSetSchurMaxIter(solver::HYPRE_Solver, ss_max_iter::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ILUSetType(solver, ilu_type)
    return @ccall libHYPRE.HYPRE_ILUSetType(solver::HYPRE_Solver, ilu_type::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ILUSetLocalReordering(solver, reordering_type)
    return @ccall libHYPRE.HYPRE_ILUSetLocalReordering(solver::HYPRE_Solver, reordering_type::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ILUSetPrintLevel(solver, print_level)
    return @ccall libHYPRE.HYPRE_ILUSetPrintLevel(solver::HYPRE_Solver, print_level::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ILUSetLogging(solver, logging)
    return @ccall libHYPRE.HYPRE_ILUSetLogging(solver::HYPRE_Solver, logging::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ILUGetNumIterations(solver, num_iterations)
    return @ccall libHYPRE.HYPRE_ILUGetNumIterations(solver::HYPRE_Solver, num_iterations::Ptr{HYPRE_Int})::HYPRE_Int
end

function HYPRE_ILUGetFinalRelativeResidualNorm(solver, res_norm)
    return @ccall libHYPRE.HYPRE_ILUGetFinalRelativeResidualNorm(solver::HYPRE_Solver, res_norm::Ptr{HYPRE_Real})::HYPRE_Int
end

function GenerateLaplacian(comm, nx, ny, nz, P, Q, R, p, q, r, value)
    return @ccall libHYPRE.GenerateLaplacian(comm::MPI_Comm, nx::HYPRE_BigInt, ny::HYPRE_BigInt, nz::HYPRE_BigInt, P::HYPRE_Int, Q::HYPRE_Int, R::HYPRE_Int, p::HYPRE_Int, q::HYPRE_Int, r::HYPRE_Int, value::Ptr{HYPRE_Real})::HYPRE_ParCSRMatrix
end

function GenerateLaplacian27pt(comm, nx, ny, nz, P, Q, R, p, q, r, value)
    return @ccall libHYPRE.GenerateLaplacian27pt(comm::MPI_Comm, nx::HYPRE_BigInt, ny::HYPRE_BigInt, nz::HYPRE_BigInt, P::HYPRE_Int, Q::HYPRE_Int, R::HYPRE_Int, p::HYPRE_Int, q::HYPRE_Int, r::HYPRE_Int, value::Ptr{HYPRE_Real})::HYPRE_ParCSRMatrix
end

function GenerateLaplacian9pt(comm, nx, ny, P, Q, p, q, value)
    return @ccall libHYPRE.GenerateLaplacian9pt(comm::MPI_Comm, nx::HYPRE_BigInt, ny::HYPRE_BigInt, P::HYPRE_Int, Q::HYPRE_Int, p::HYPRE_Int, q::HYPRE_Int, value::Ptr{HYPRE_Real})::HYPRE_ParCSRMatrix
end

function GenerateDifConv(comm, nx, ny, nz, P, Q, R, p, q, r, value)
    return @ccall libHYPRE.GenerateDifConv(comm::MPI_Comm, nx::HYPRE_BigInt, ny::HYPRE_BigInt, nz::HYPRE_BigInt, P::HYPRE_Int, Q::HYPRE_Int, R::HYPRE_Int, p::HYPRE_Int, q::HYPRE_Int, r::HYPRE_Int, value::Ptr{HYPRE_Real})::HYPRE_ParCSRMatrix
end

function GenerateRotate7pt(comm, nx, ny, P, Q, p, q, alpha, eps)
    return @ccall libHYPRE.GenerateRotate7pt(comm::MPI_Comm, nx::HYPRE_BigInt, ny::HYPRE_BigInt, P::HYPRE_Int, Q::HYPRE_Int, p::HYPRE_Int, q::HYPRE_Int, alpha::HYPRE_Real, eps::HYPRE_Real)::HYPRE_ParCSRMatrix
end

function GenerateVarDifConv(comm, nx, ny, nz, P, Q, R, p, q, r, eps, rhs_ptr)
    return @ccall libHYPRE.GenerateVarDifConv(comm::MPI_Comm, nx::HYPRE_BigInt, ny::HYPRE_BigInt, nz::HYPRE_BigInt, P::HYPRE_Int, Q::HYPRE_Int, R::HYPRE_Int, p::HYPRE_Int, q::HYPRE_Int, r::HYPRE_Int, eps::HYPRE_Real, rhs_ptr::Ptr{HYPRE_ParVector})::HYPRE_ParCSRMatrix
end

function GenerateRSVarDifConv(comm, nx, ny, nz, P, Q, R, p, q, r, eps, rhs_ptr, type)
    return @ccall libHYPRE.GenerateRSVarDifConv(comm::MPI_Comm, nx::HYPRE_BigInt, ny::HYPRE_BigInt, nz::HYPRE_BigInt, P::HYPRE_Int, Q::HYPRE_Int, R::HYPRE_Int, p::HYPRE_Int, q::HYPRE_Int, r::HYPRE_Int, eps::HYPRE_Real, rhs_ptr::Ptr{HYPRE_ParVector}, type::HYPRE_Int)::HYPRE_ParCSRMatrix
end

function GenerateCoordinates(comm, nx, ny, nz, P, Q, R, p, q, r, coorddim)
    return @ccall libHYPRE.GenerateCoordinates(comm::MPI_Comm, nx::HYPRE_BigInt, ny::HYPRE_BigInt, nz::HYPRE_BigInt, P::HYPRE_Int, Q::HYPRE_Int, R::HYPRE_Int, p::HYPRE_Int, q::HYPRE_Int, r::HYPRE_Int, coorddim::HYPRE_Int)::Ptr{Cfloat}
end

function HYPRE_BoomerAMGSetPostInterpType(solver, post_interp_type)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetPostInterpType(solver::HYPRE_Solver, post_interp_type::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetJacobiTruncThreshold(solver, jacobi_trunc_threshold)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetJacobiTruncThreshold(solver::HYPRE_Solver, jacobi_trunc_threshold::HYPRE_Real)::HYPRE_Int
end

function HYPRE_BoomerAMGSetNumCRRelaxSteps(solver, num_CR_relax_steps)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetNumCRRelaxSteps(solver::HYPRE_Solver, num_CR_relax_steps::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetCRRate(solver, CR_rate)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetCRRate(solver::HYPRE_Solver, CR_rate::HYPRE_Real)::HYPRE_Int
end

function HYPRE_BoomerAMGSetCRStrongTh(solver, CR_strong_th)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetCRStrongTh(solver::HYPRE_Solver, CR_strong_th::HYPRE_Real)::HYPRE_Int
end

function HYPRE_BoomerAMGSetCRUseCG(solver, CR_use_CG)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetCRUseCG(solver::HYPRE_Solver, CR_use_CG::HYPRE_Int)::HYPRE_Int
end

function HYPRE_BoomerAMGSetISType(solver, IS_type)
    return @ccall libHYPRE.HYPRE_BoomerAMGSetISType(solver::HYPRE_Solver, IS_type::HYPRE_Int)::HYPRE_Int
end

function HYPRE_ParCSRSetupInterpreter(i)
    return @ccall libHYPRE.HYPRE_ParCSRSetupInterpreter(i::Ptr{mv_InterfaceInterpreter})::HYPRE_Int
end

function HYPRE_ParCSRSetupMatvec(mv)
    return @ccall libHYPRE.HYPRE_ParCSRSetupMatvec(mv::Ptr{HYPRE_MatvecFunctions})::HYPRE_Int
end

function HYPRE_ParCSRMultiVectorPrint(x_, fileName)
    return @ccall libHYPRE.HYPRE_ParCSRMultiVectorPrint(x_::Ptr{Cvoid}, fileName::Ptr{Cchar})::HYPRE_Int
end

function HYPRE_ParCSRMultiVectorRead(comm, ii_, fileName)
    return @ccall libHYPRE.HYPRE_ParCSRMultiVectorRead(comm::MPI_Comm, ii_::Ptr{Cvoid}, fileName::Ptr{Cchar})::Ptr{Cvoid}
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

const HYPRE_MPI_BIG_INT = MPI_INT

const HYPRE_MPI_INT = MPI_INT

const HYPRE_MPI_REAL = MPI_DOUBLE

const HYPRE_MPI_COMPLEX = HYPRE_MPI_REAL

const HYPRE_ERROR_GENERIC = 1

const HYPRE_ERROR_MEMORY = 2

const HYPRE_ERROR_ARG = 4

const HYPRE_ERROR_CONV = 256
