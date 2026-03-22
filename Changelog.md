# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Pattern matching support via `deconstruct` and `deconstruct_keys`
- RBS type signatures
- Gemspec metadata (homepage, source code, bug tracker, changelog URIs)
- MFA required for gem pushes
- Gem attestation via Sigstore

### Changed

- Require Ruby >= 3.3
- Bump equalizer dependency from `~> 0.0.9` to `~> 1.0`
- Disable inspect override from equalizer

### Removed

- Support for Ruby < 3.3

## [0.1.6] - 2020-09-10

### Changed

- Packaging no longer relies on git

## [0.1.5] - 2014-04-10

### Added

- Support calling `super` and `zsuper` from custom initialize

### Changed

- Dependency bumps

## [0.1.4] - 2013-09-22

### Changed

- Dependency bumps

## [0.1.3] - 2013-08-31

### Changed

- Dependency bumps

## [0.1.2] - 2013-08-07

### Changed

- Dependency bumps
- Internal refactorings

## [0.1.1] - 2013-05-15

### Added

- `Concord::Public` mixin defaulting to public attr_readers

## [0.1.0] - 2013-05-15

### Changed

- Default attribute visibility set to protected

## [0.0.3] - 2013-03-08

### Fixed

- Ruby 1.9.2 visibility problem

## [0.0.2] - 2013-03-07

### Removed

- Unneeded backports dependency

## [0.0.1] - 2013-03-06

### Added

- Initial release

[Unreleased]: https://github.com/mbj/concord/compare/v0.1.6...HEAD
[0.1.6]: https://github.com/mbj/concord/compare/v0.1.5...v0.1.6
[0.1.5]: https://github.com/mbj/concord/compare/v0.1.4...v0.1.5
[0.1.4]: https://github.com/mbj/concord/compare/v0.1.3...v0.1.4
[0.1.3]: https://github.com/mbj/concord/compare/v0.1.2...v0.1.3
[0.1.2]: https://github.com/mbj/concord/compare/v0.1.1...v0.1.2
[0.1.1]: https://github.com/mbj/concord/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/mbj/concord/compare/v0.0.3...v0.1.0
[0.0.3]: https://github.com/mbj/concord/compare/v0.0.2...v0.0.3
[0.0.2]: https://github.com/mbj/concord/compare/v0.0.1...v0.0.2
[0.0.1]: https://github.com/mbj/concord/releases/tag/v0.0.1
