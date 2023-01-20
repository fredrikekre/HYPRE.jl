# HYPRE.jl changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

<!-- ## [Unreleased] -->

## [1.4.0] - 2023-01-20
### Added
 - New function `HYPRE.GetFinalRelativeResidualNorm(s::HYPRESolver)` for getting the final
   residual norm from a solver. This function dispatches on the solver to the corresponding
   C API wrapper `LibHYPRE.HYPRE_${Solver}GetFinalRelativeResidualNorm`. ([#14][github-14])
 - New function `HYPRE.GetNumIterations(s::HYPRESolver)` for getting the number of
   iterations from a solver. This function dispatches on the solver to the corresponding C
   API wrapper `LibHYPRE.HYPRE_${Solver}GetNumIterations`. ([#14][github-14])

## [1.3.1] - 2023-01-14
### Fixed
 - Solvers now keep an reference to the added preconditioner to make sure the preconditioner
   is not finalized before the solver. This fixes crashes (segfaults) that could happen in
   case no other reference to the preconditioner existed in the program. ([#12][github-12])
 - The proper conversion methods for `ccall` are now defined for `HYPREMatrix`,
   `HYPREVector`, and `HYPRESolver` such that they can be passed direcly to `HYPRE_*`
   functions and let `ccall` guarantee the GC preservation of these objects. Although not
   observed in practice, this fixes a possible race condition where the matrix/vector/solver
   could be finalized too early. ([#13][github-13])

## [1.3.0] - 2022-12-30
### Added
 - Rectangular matrices can now be assembled by the new method
   `HYPRE.assemble!(::HYPREMatrixAssembler, i::Vector, j::Vector, a::Matrix)` where `i` are
   the rows and `j` the columns. ([#7][github-7])
### Fixed
 - All created HYPRE objects (`HYPREMatrix`, `HYPREVector`, and `HYPRESolver`s) are now kept
   track of internally and explicitly `finalize`d (if they haven't been GC'd) before
   finalizing HYPRE. This fixes a "race condition" where MPI and/or HYPRE would finalize
   before these Julia objects are garbage collected and finalized. ([#8][github-8])
### Deprecated
 - The method `HYPRE.assemble!(A::HYPREMatrixAssembler, ij::Vector, a::Matrix)` have been
   deprecated in favor of `HYPRE.assemble!(A::HYPREMatrixAssembler, i::Vector, j::Vector,
   a::Matrix)`, i.e. it is now required to explicitly pass rows and column indices
   individually. The motivation behind this is to support assembling of rectangular
   matrices. Note that `HYPRE.assemble!(A::HYPREAssembler, ij::Vector, a::Matrix,
   b::Vector)` is still supported, where `ij` are used as row and column indices for `a`, as
   well as row indices for `b`. ([#6][github-6])

## [1.2.0] - 2022-10-12
### Added
 - Added assembler interface to assemble `HYPREMatrix` and/or `HYPREVector` directly without
   an intermediate sparse structure in Julia. ([#5][github-5])

## [1.1.0] - 2022-10-05
### Added
 - Added support for MPI.jl version 0.20.x (in addition to the existing version 0.19.x
   support). ([#2][github-2])

## [1.0.0] - 2022-07-28
Initial release of HYPRE.jl.


[github-2]: https://github.com/fredrikekre/HYPRE.jl/pull/2
[github-5]: https://github.com/fredrikekre/HYPRE.jl/pull/5
[github-6]: https://github.com/fredrikekre/HYPRE.jl/pull/6
[github-7]: https://github.com/fredrikekre/HYPRE.jl/pull/7
[github-8]: https://github.com/fredrikekre/HYPRE.jl/pull/8
[github-12]: https://github.com/fredrikekre/HYPRE.jl/pull/12
[github-13]: https://github.com/fredrikekre/HYPRE.jl/pull/13
[github-14]: https://github.com/fredrikekre/HYPRE.jl/pull/14

[1.0.0]: https://github.com/fredrikekre/HYPRE.jl/releases/tag/v1.0.0
[1.1.0]: https://github.com/fredrikekre/HYPRE.jl/compare/v1.0.0...v1.1.0
[1.2.0]: https://github.com/fredrikekre/HYPRE.jl/compare/v1.1.0...v1.2.0
[1.3.0]: https://github.com/fredrikekre/HYPRE.jl/compare/v1.2.0...v1.3.0
[1.3.1]: https://github.com/fredrikekre/HYPRE.jl/compare/v1.3.0...v1.3.1
[1.4.0]: https://github.com/fredrikekre/HYPRE.jl/compare/v1.3.1...v1.4.0
<!-- [Unreleased]: https://github.com/fredrikekre/HYPRE.jl/compare/v1.3.1...HEAD -->
