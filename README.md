ExUtils
=======

[![Coverage Status][shield-inch]][inch-ci]
[![Version][shield-version]][hexpm]
[![License][shield-license]][hexpm]

> :zap: Elixir utilities, helpers and shortcuts :zap:

ExUtils provides helper methods and utilities for a lot of different data
types in Elixir that are not present in the Kernel yet. [Head over
to HexDocs][docs] for the full list of modules, functions and macros.



## Installation

```elixir
def deps do
  [{:ex_utils, "~> 0.1.7"}]
end
```



## Methods

It's not possible to list all functions here, but you should check out the
[Documentation][docs]. `ExUtils` has been divided into sub-modules, each
with their own utility methods:

 - [`ExUtils.Terms`][docs-terms] - Core Module with generic methods that fit everything
 - [`ExUtils.Maps`][docs-maps]
 - [`ExUtils.Modules`][docs-modules]
 - [`ExUtils.Keywords`][docs-keywords]
 - [`ExUtils.Integers`][docs-integers]



## Contributing

 - [Fork][github-fork], Enhance, Send PR
 - Lock issues with any bugs or feature requests
 - Implement something from Roadmap
 - Spread the word



## License

This package is available as open source under the terms of the [MIT License][license].



  [license]:          https://opensource.org/licenses/MIT
  [github-fork]:      https://github.com/sheharyarn/ex_utils/fork

  [hexpm]:            https://hex.pm/packages/ex_utils
  [docs]:             https://hexdocs.pm/ex_utils/ExUtils.html
  [docs-terms]:       https://hexdocs.pm/ex_utils/ExUtils.Terms.html
  [docs-maps]:        https://hexdocs.pm/ex_utils/ExUtils.Maps.html
  [docs-modules]:     https://hexdocs.pm/ex_utils/ExUtils.Modules.html
  [docs-keywords]:    https://hexdocs.pm/ex_utils/ExUtils.Keywords.html
  [docs-integers]:    https://hexdocs.pm/ex_utils/ExUtils.Integers.html

  [inch-ci]:          https://inch-ci.org/github/sheharyarn/ex_utils

  [shield-version]:   https://img.shields.io/hexpm/v/ex_utils.svg
  [shield-license]:   https://img.shields.io/hexpm/l/ex_utils.svg
  [shield-inch]:      https://inch-ci.org/github/sheharyarn/ex_utils.svg?branch=master
