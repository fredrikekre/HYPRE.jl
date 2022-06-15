module HYPRE

module LibHYPRE
    include("../lib/LibHYPRE.jl")

    # Export everything with HYPRE_ prefix
    for name in names(@__MODULE__; all=true)
        if startswith(string(name), "HYPRE_")
            @eval export $name
        end
    end
end

end # module HYPRE
