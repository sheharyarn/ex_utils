ExUtils
=======

[![Build Status][shield-travis]][travis-ci]
[![Coverage Status][shield-inch]][inch-ci]
[![Version][shield-version]][hexpm]
[![License][shield-license]][hexpm]

> :zap: Collection of Awesome Elixir shortcuts and utilities :zap:

ExUtils provides helper methods and utilities for a lot of different data
types in Elixir that haven't made to the Standard Library yet. [Head over
to HexDocs][docs] for the full list of Modules, Functions and Macros.



## Installation

```elixir
def deps do
  [{:ex_utils, "~> 0.1.6"}]
end
```



## Methods

It's not possible to list all functions here, but you should check out the
[Documentation][docs]! `ExUtils` has been divided into sub-modules, each
with their own utility methods:

 - [`ExUtils`][docs] - Core Module with generic methods that fit everything
 - [`ExUtils.Map`][docs-map]
 - [`ExUtils.Module`][docs-module]
 - [`ExUtils.Keyword`][docs-keyword]
 - [`ExUtils.Integer`][docs-integer]



## Roadmap

 - [x] Write missing Tests and Documentation
 - [ ] Provide better integration with core Elixir Modules
 - [ ] Keep adding more awesome shortcuts and utilities



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
  [docs-map]:         https://hexdocs.pm/ex_utils/ExUtils.Map.html
  [docs-module]:      https://hexdocs.pm/ex_utils/ExUtils.Module.html
  [docs-keyword]:     https://hexdocs.pm/ex_utils/ExUtils.Keyword.html
  [docs-integer]:     https://hexdocs.pm/ex_utils/ExUtils.Integer.html

  [travis-ci]:        https://travis-ci.org/sheharyarn/ex_utils
  [inch-ci]:          https://inch-ci.org/github/sheharyarn/ex_utils

  [shield-version]:   https://img.shields.io/hexpm/v/ex_utils.svg
  [shield-license]:   https://img.shields.io/hexpm/l/ex_utils.svg
  [shield-travis]:    https://img.shields.io/travis/sheharyarn/ex_utils/master.svg
  [shield-inch]:      https://inch-ci.org/github/sheharyarn/ex_utils.svg?branch=master

