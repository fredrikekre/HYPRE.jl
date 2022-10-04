mutable struct ADIOI_FileD end

const HYPRE_BigInt = Cint

const HYPRE_Int = Cint

const HYPRE_Real = Cdouble

const HYPRE_Complex = HYPRE_Real

@cenum _HYPRE_MemoryLocation::Int32 begin
    HYPRE_MEMORY_UNDEFINED = -1
    HYPRE_MEMORY_HOST = 0
    HYPRE_MEMORY_DEVICE = 1
end

const HYPRE_MemoryLocation = _HYPRE_MemoryLocation

@cenum _HYPRE_ExecutionPolicy::Int32 begin
    HYPRE_EXEC_UNDEFINED = -1
    HYPRE_EXEC_HOST = 0
    HYPRE_EXEC_DEVICE = 1
end

const HYPRE_ExecutionPolicy = _HYPRE_ExecutionPolicy

mutable struct hypre_IJMatrix_struct end

const HYPRE_IJMatrix = Ptr{hypre_IJMatrix_struct}

mutable struct hypre_IJVector_struct end

const HYPRE_IJVector = Ptr{hypre_IJVector_struct}

mutable struct hypre_CSRMatrix_struct end

const HYPRE_CSRMatrix = Ptr{hypre_CSRMatrix_struct}

mutable struct hypre_MappedMatrix_struct end

const HYPRE_MappedMatrix = Ptr{hypre_MappedMatrix_struct}

mutable struct hypre_MultiblockMatrix_struct end

const HYPRE_MultiblockMatrix = Ptr{hypre_MultiblockMatrix_struct}

mutable struct hypre_Vector_struct end

const HYPRE_Vector = Ptr{hypre_Vector_struct}

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

mutable struct hypre_Solver_struct end

const HYPRE_Solver = Ptr{hypre_Solver_struct}

mutable struct hypre_Matrix_struct end

const HYPRE_Matrix = Ptr{hypre_Matrix_struct}

# typedef HYPRE_Int ( * HYPRE_PtrToSolverFcn ) ( HYPRE_Solver , HYPRE_Matrix , HYPRE_Vector , HYPRE_Vector )
const HYPRE_PtrToSolverFcn = Ptr{Cvoid}

# typedef HYPRE_Int ( * HYPRE_PtrToModifyPCFcn ) ( HYPRE_Solver , HYPRE_Int , HYPRE_Real )
const HYPRE_PtrToModifyPCFcn = Ptr{Cvoid}

struct utilities_FortranMatrix
    globalHeight::HYPRE_BigInt
    height::HYPRE_BigInt
    width::HYPRE_BigInt
    value::Ptr{HYPRE_Real}
    ownsValues::HYPRE_Int
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

struct mv_TempMultiVector
    numVectors::HYPRE_Int
    mask::Ptr{HYPRE_Int}
    vector::Ptr{Ptr{Cvoid}}
    ownsVectors::HYPRE_Int
    ownsMask::HYPRE_Int
    interpreter::Ptr{mv_InterfaceInterpreter}
end

const mv_TempMultiVectorPtr = Ptr{mv_TempMultiVector}

struct HYPRE_MatvecFunctions
    MatvecCreate::Ptr{Cvoid}
    Matvec::Ptr{Cvoid}
    MatvecDestroy::Ptr{Cvoid}
    MatMultiVecCreate::Ptr{Cvoid}
    MatMultiVec::Ptr{Cvoid}
    MatMultiVecDestroy::Ptr{Cvoid}
end

# typedef HYPRE_Int ( * HYPRE_PtrToParSolverFcn ) ( HYPRE_Solver , HYPRE_ParCSRMatrix , HYPRE_ParVector , HYPRE_ParVector )
const HYPRE_PtrToParSolverFcn = Ptr{Cvoid}

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

