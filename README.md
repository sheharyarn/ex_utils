ExUtils ⚡
=========

[![Coverage Status][shield-inch]][inch-ci]
[![Downloads][shield-downloads]][hexpm]
[![Version][shield-version]][hexpm]
[![License][shield-license]][hexpm]

> Elixir utilities, helpers and shortcuts

ExUtils provides helper methods and utilities for a lot of different data
types in Elixir that are not present in the Kernel yet. [Head over
to HexDocs][docs] for the full list of modules, functions and macros.



## Installation

```elixir
def deps do
  [{:ex_utils, "~> 1.0"}]
end
```



## Configuration

Some utilities require specifying your OTP application in your config.
Add the following to your `config/config.exs`:

```elixir
config :ex_utils,
  otp_app: :your_app
```

Replace `:your_app` with your application's OTP app name.



## Modules

ExUtils is organized in independent modules, each providing helpers for
a single domain or subject type, following a pluralized naming strategy
wherever possible. This is done so to avoid potential aliasing conflicts
with Elixir standard library modules, which use singular names. E.g. It
exports a `ExUtils.Maps` module with helpers that extend Elixir's built-in
`Map` module.

A high level overview of each module is provided below. You can also view
all docs at on [HexDocs][docs] for the complete API.

### Core Utils

| Module |
| --- |
| [`ExUtils.Configs`][docs-configs] |
| [`ExUtils.Files`][docs-files] |
| [`ExUtils.Keywords`][docs-keywords] |
| [`ExUtils.Lists`][docs-lists] |
| [`ExUtils.Maps`][docs-maps] |
| [`ExUtils.Numbers`][docs-numbers] |
| [`ExUtils.Random`][docs-random] |
| [`ExUtils.Runner`][docs-runner] |
| [`ExUtils.Terms`][docs-terms] |
| [`ExUtils.Typespecs`][docs-typespecs] |
| [`ExUtils.URLs`][docs-urls] |

### Module Utils

| Module |
| --- |
| [`ExUtils.Modules`][docs-modules] |
| [`ExUtils.Modules.Extend`][docs-modules-extend] |

### Ecto Utils

These modules are available when the optional `ecto` dependency is installed.

| Module |
| --- |
| [`ExUtils.Ecto.Changesets`][docs-ecto-changesets] |
| [`ExUtils.Ecto.Fragments`][docs-ecto-fragments] |



## Contributing

 - [Fork][github-fork], Enhance, Send PR
 - Lock issues with any bugs or feature requests
 - Implement something from Roadmap
 - Spread the word ❤️



## License

This package is available as open source under the terms of the [MIT License][license].



  [license]:          https://opensource.org/licenses/MIT
  [github-fork]:      https://github.com/sheharyarn/ex_utils/fork

  [hexpm]:            https://hex.pm/packages/ex_utils
  [docs]:             https://hexdocs.pm/ex_utils/ExUtils.html
  [docs-configs]:     https://hexdocs.pm/ex_utils/ExUtils.Configs.html
  [docs-ecto-changesets]: https://hexdocs.pm/ex_utils/ExUtils.Ecto.Changesets.html
  [docs-ecto-fragments]: https://hexdocs.pm/ex_utils/ExUtils.Ecto.Fragments.html
  [docs-files]:       https://hexdocs.pm/ex_utils/ExUtils.Files.html
  [docs-keywords]:    https://hexdocs.pm/ex_utils/ExUtils.Keywords.html
  [docs-lists]:       https://hexdocs.pm/ex_utils/ExUtils.Lists.html
  [docs-maps]:        https://hexdocs.pm/ex_utils/ExUtils.Maps.html
  [docs-modules]:     https://hexdocs.pm/ex_utils/ExUtils.Modules.html
  [docs-modules-extend]: https://hexdocs.pm/ex_utils/ExUtils.Modules.Extend.html
  [docs-numbers]:     https://hexdocs.pm/ex_utils/ExUtils.Numbers.html
  [docs-random]:      https://hexdocs.pm/ex_utils/ExUtils.Random.html
  [docs-runner]:      https://hexdocs.pm/ex_utils/ExUtils.Runner.html
  [docs-terms]:       https://hexdocs.pm/ex_utils/ExUtils.Terms.html
  [docs-typespecs]:   https://hexdocs.pm/ex_utils/ExUtils.Typespecs.html
  [docs-urls]:        https://hexdocs.pm/ex_utils/ExUtils.URLs.html

  [inch-ci]:          https://inch-ci.org/github/sheharyarn/ex_utils

  [shield-downloads]: https://img.shields.io/hexpm/dt/ex_utils.svg
  [shield-version]:   https://img.shields.io/hexpm/v/ex_utils.svg
  [shield-license]:   https://img.shields.io/hexpm/l/ex_utils.svg
  [shield-inch]:      https://inch-ci.org/github/sheharyarn/ex_utils.svg?branch=master
