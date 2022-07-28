const liveserver = "liveserver" in ARGS

if liveserver
    using Revise
    Revise.revise()
end

using Documenter
using HYPRE

makedocs(
    sitename = "HYPRE.jl",
    format = Documenter.HTML(
        canonical = "https://fredrikekre.github.io/HYPRE.jl/stable",
    ),
    modules = [HYPRE],
    pages = Any[
        "Home" => "index.md",
        "matrix-vector.md",
        "libhypre.md",
    ],
    draft = liveserver,
)

if !liveserver
    deploydocs(
        repo = "github.com/fredrikekre/HYPRE.jl.git",
        push_preview = true,
    )
end
