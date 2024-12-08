# Changelog

All notable changes to this gem will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this gem adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.3.0] - 2026-04-03

### Added
- `#delete(key)` method to remove a key entirely, returning its count or nil
- `#max_count` method returning `[key, count]` pair with highest count
- `#min_count` method returning `[key, count]` pair with lowest count
- `#to_json` method for JSON string serialization
- `.from_json(str)` class method to deserialize from JSON string
- `#sample(n)` method for weighted random sampling based on counts
- `#keys` method to return all tracked keys
- `#values` method to return all count values

## [0.2.0] - 2026-04-01

### Added
- `#decrement(key, n)` method to decrease counts, floored at zero
- `#reset(key)` method to clear a specific key or all counts
- `#update(data)` method for batch updates from Hash or Enumerable
- `#filter_by_count(min:, max:)` method to filter entries by count range

## [0.1.5] - 2026-03-31

### Added
- Add GitHub issue templates, dependabot config, and PR template

## [0.1.4] - 2026-03-31

### Changed
- Standardize README badges, support section, and license format

## [0.1.3] - 2026-03-24

### Fixed
- Standardize README code examples to use double-quote require statements
- Remove inline comments from Development section to match template

## [0.1.2] - 2026-03-24

### Fixed

- Fix Installation section quote style to double quotes

## [0.1.1] - 2026-03-22

### Changed

- Expand test coverage to 30+ examples with edge cases for decrement, negative values, empty counters, defensive copies, Enumerable methods, and mixed types

## [0.1.0] - 2026-03-22

### Added

- Initial release
- Frequency counting from any enumerable
- Most-common and least-common queries
- Merge and subtract operations
- Percentage calculations
- Enumerable support
