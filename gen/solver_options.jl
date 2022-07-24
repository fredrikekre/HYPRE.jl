using HYPRE.LibHYPRE

function generate_options(io, structname, prefixes...)
    println(io, "")
    println(io, "function Internals.set_options(s::$(structname), kwargs)")
    println(io, "    solver = s.solver")
    println(io, "    for (k, v) in kwargs")

    ns = Tuple{Symbol,String}[]
    for prefix in prefixes, n in names(LibHYPRE)
        r = Regex("^" * prefix * "([A-Z].*)\$")
        if (m = match(r, string(n)); m !== nothing)
            m1 = String(m[1])
            if (idx = findfirst(x -> x[2] == m1, ns); idx === nothing)
                push!(ns, (n, m1))
            else
                @info "Ignoring $(n) since $(ns[idx][1]) already used."
            end
        end
    end
    sort!(ns; by = Base.first)

    first = true
    for (n, k) in ns
        m = get(methods(getfield(LibHYPRE, n)), 1, nothing)
        m === nothing && continue
        nargs = m.nargs - 1
        print(io, "        $(first ? "" : "else")if k === :$(k)")
        println(io)
        if k == "Precond"
            println(io, "            Internals.set_precond(s, v)")
        elseif nargs == 1
            println(io, "            @check ", n, "(solver)")
        elseif nargs == 2
            println(io, "            @check ", n, "(solver, v)")
        else # nargs >= 3
            println(io, "            @check ", n, "(solver, v...)")
        end
        first = false
    end
    println(io, "        end")
    println(io, "    end")
    println(io, "end")
end

open(joinpath(@__DIR__, "..", "src", "solver_options.jl"), "w") do io
    println(io, "# SPDX-License-Identifier: MIT")
    println(io, "")
    println(io, "# This file is automatically generated by gen/solver_options.jl")
    println(io, "")
    println(io, "Internals.set_options(::HYPRESolver, kwargs) = nothing")

    generate_options(io, "BoomerAMG", "HYPRE_BoomerAMGSet")
    generate_options(io, "GMRES", "HYPRE_ParCSRGMRESSet", "HYPRE_GMRESSet")
    generate_options(io, "PCG", "HYPRE_ParCSRPCGSet", "HYPRE_PCGSet")
end
