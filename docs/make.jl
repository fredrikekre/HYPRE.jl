const liveserver = "liveserver" in ARGS

if liveserver
    using Revise
    Revise.revise()
end

using Documenter
using HYPRE
using Changelog

# Changelog
Changelog.generate(
    Changelog.Documenter(),
    joinpath(@__DIR__, "..", "CHANGELOG.md"),
    joinpath(@__DIR__, "src", "changelog.md");
    repo = "Ferrite-FEM/Ferrite.jl",
)

makedocs(
    sitename = "HYPRE.jl",
    format = Documenter.HTML(
        canonical = "https://fredrikekre.github.io/HYPRE.jl/stable",
    ),
    modules = [HYPRE],
    pages = Any[
        "Home" => "index.md",
        hide("Changelog" => "changelog.md"),
        "matrix-vector.md",
        "solvers-preconditioners.md",
        "libhypre.md",
        "api.md",
    ],
    draft = liveserver,
)

if !liveserver
    deploydocs(
        repo = "github.com/fredrikekre/HYPRE.jl.git",
        push_preview = true,
    )
end
