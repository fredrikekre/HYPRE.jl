# HYPRE.jl changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

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

[1.0.0]: ttps://github.com/fredrikekre/HYPRE.jl/releases/tag/v1.0.0
[1.1.0]: https://github.com/fredrikekre/HYPRE.jl/compare/v1.0.0...v1.1.0
[1.2.0]: https://github.com/fredrikekre/HYPRE.jl/compare/v1.1.0...v1.2.0
[Unreleased]: https://github.com/fredrikekre/HYPRE.jl/compare/v1.2.0...HEAD
