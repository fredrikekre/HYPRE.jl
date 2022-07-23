SRCDIR:=$(shell dirname $(abspath $(firstword $(MAKEFILE_LIST))))

default: livedocs

instantiate:
	julia --project=${SRCDIR} -e 'using Pkg; Pkg.instantiate()'

livedocs: instantiate
	julia --project=${SRCDIR} -e 'using LiveServer; LiveServer.servedocs(; foldername=pwd())' -- liveserver

.PHONY: default instantiate livedocs
