MAKEDIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
LIBHYPRE:=$(shell dirname $(MAKEDIR))/lib/LibHYPRE.jl

generate: $(LIBHYPRE)

clean:
	rm -f $(LIBHYPRE)

.PHONY: generate clean

$(LIBHYPRE): Project.toml Manifest.toml $(MAKEDIR)/generator.toml $(MAKEDIR)/generator.jl
	julia --project generator.jl && \
		sed -i -e '1s/^/local libHYPRE # Silence of the Langs(erver)\n\n/' -e 's/using HYPRE_jll/using HYPRE_jll: HYPRE_jll, libHYPRE/' -e 's/using CEnum/using CEnum: @cenum/' $(LIBHYPRE) && \
		julia-1.11 --project=@runic -e 'using Runic; exit(Runic.main(ARGS))' -- -i $(LIBHYPRE)
