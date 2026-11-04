Changelog
=========

All changes to this project are documented in this file.

## [v1.0.0] - 2026-11-03

### Breaking changes

- Increased the minimum supported Elixir version from 1.3 to 1.14.
- Renamed the original singular modules:
  - `ExUtils.Keyword` to `ExUtils.Keywords`.
  - `ExUtils.Map` to `ExUtils.Maps`.
  - `ExUtils.Module` to `ExUtils.Modules`.
- Replaced `ExUtils.Integer.to_filesize/2` with
  `ExUtils.Files.format_size/2`. Byte values now use the shorter `"B"` suffix
  instead of `"Bytes"`.
- Moved the generic `is_struct?/1` and `is_pure_map?/1` helpers from
  `ExUtils` to `ExUtils.Terms`.
- Changed `ExUtils.Maps.atomize_keys` to require an explicit list of allowed
  atom keys or `:all`, helping callers avoid creating arbitrary atoms from
  untrusted input.

### Added

- Added `ExUtils.Configs` for application configuration access and loading
  configuration from `priv` files.
- Added `ExUtils.Ecto.Changesets` with helpers for default changes, immutable
  fields, change diffs, and schema source detection.
- Added `ExUtils.Ecto.Fragments` with helpers for PostgreSQL `CASE`,
  `GREATEST`, `ROUND`, `FLOOR`, and `CEIL` fragments.
- Added `ExUtils.Files.format_size/2` for human-readable byte sizes.
- Added `ExUtils.Lists.compact/1` and `replace/3`.
- Added `ExUtils.Maps` helpers for struct conversion, nested-map flattening,
  key conversion, blank-value removal, and conditional insertion.
- Added `ExUtils.Modules.exists?/1`, function inspection helpers, and the
  `ExUtils.Modules.Extend` macro.
- Added `ExUtils.Numbers` with numeric guards, Decimal conversion, float and
  integer conversion, bang variants, and truncation. This module is available
  when the optional `decimal` dependency is installed.
- Added `ExUtils.Random` helpers for booleans, bounded integers, and strings.
- Added `ExUtils.Runner` for background and parallel task execution.
- Added `ExUtils.Terms.blank?/1` and `present?/1`.
- Added `ExUtils.Typespecs.from_list/1` for generating union types from static
  values.
- Added `ExUtils.URLs` helpers for query merging, encoding normalization, URL
  extraction, and validation.
- Added optional `ecto` and `decimal` dependencies.
- Added OTP application configuration through the `:otp_app` environment key.

### Changed

- Migrated project configuration from `Mix.Config` to `Config`.
- Added `:crypto` and `:logger` to the application's extra applications.
- Expanded documentation with consistent IEx examples and substantially
  increased automated test coverage.
- Added formatter configuration and Sobelow-based quality checks.

### Deprecated

- Deprecated `ExUtils.methods/1`, `ExUtils.functions/1`, and
  `ExUtils.has_method?/2` in favor of the corresponding `ExUtils.Modules`
  functions.
- Deprecated `ExUtils.Modules.methods/1` and `has_method?/2` in favor of
  `functions/1` and `has_function?/2`.
- Deprecated `ExUtils.Maps.atomize_keys/1` and `symbolize_keys/2` in favor of
  `atomize_keys/3` with explicit keys.

### Removed

- Removed the old `ExUtils.Integer`, `ExUtils.Keyword`, `ExUtils.Map`, and
  `ExUtils.Module` modules after their replacements were introduced.
- Removed the Travis CI configuration.

[v1.0.0]: https://github.com/sheharyarn/ex_utils/compare/v0.1.7...v1.0.0
