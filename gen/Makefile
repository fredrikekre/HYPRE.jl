LIBHYPRE:=$(shell dirname $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST)))))/lib/LibHYPRE.jl

generate: $(LIBHYPRE) Project.toml Manifest.toml

clean:
	rm -f $(LIBHYPRE)

.PHONY: generate clean

$(LIBHYPRE):
	julia --project generator.jl && \
		sed -i -e 's/using HYPRE_jll/using HYPRE_jll: HYPRE_jll, libHYPRE/' -e 's/using CEnum/using CEnum: @cenum/' $(LIBHYPRE) && \
		julia-1.11 --project=@runic -e 'using Runic; exit(Runic.main(ARGS))' -- -i $(LIBHYPRE)
