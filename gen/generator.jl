using Clang.Generators
using HYPRE_jll, MPICH_jll

cd(@__DIR__)

hypre_include_dir = normpath(HYPRE_jll.artifact_dir, "include")
mpi_include_dir = normpath(MPICH_jll.artifact_dir, "include")

options = load_options(joinpath(@__DIR__, "generator.toml"))

args = get_default_args()
push!(args, "-I$(hypre_include_dir)")
push!(args, "-isystem$(mpi_include_dir)")

# Compiler flags from Yggdrasil (??)
# https://github.com/JuliaPackaging/Yggdrasil/blob/9d131ba0e4aa393b00f4d71ef5a3f909419a70a7/H/HYPRE/build_tarballs.jl
push!(args, "-DHYPRE_ENABLE_SHARED=ON")
push!(args, "-DHYPRE_ENABLE_HYPRE_BLAS=ON")
push!(args, "-DHYPRE_ENABLE_HYPRE_LAPACK=ON")
push!(args, "-DHYPRE_ENABLE_CUDA_STREAMS=OFF")
push!(args, "-DHYPRE_ENABLE_CUSPARSE=OFF")
push!(args, "-DHYPRE_ENABLE_CURAND=OFF")

headers = joinpath.(
    hypre_include_dir,
    [
        "HYPRE.h",
        "HYPRE_IJ_mv.h",
        "HYPRE_parcsr_mv.h",
        "HYPRE_parcsr_ls.h",
    ]
)

ctx = create_context(headers, args, options)

build!(ctx)
