ExUtils
=======

> :zap: Collection of Awesome Elixir shortcuts and utilities :zap:

(Still a Work in Progress :stuck_out_tongue:)



## Installation

```elixir
def deps do
  [{:ex_utils, "~> 0.1.3"}]
end
```

Or if you want the latest stuff:

```elixir
def deps do
  [{:ex_utils, git: "https://github.com/sheharyarn/ex_utils.git"}]
end
```



## Awesome Methods

It's not possible to list all functions here, but you should check out the
[Documentation][docs]! `ExUtils` has been divided into sub-modules, each
with their own utility methods for different kinds of data:

 - [`ExUtils`][docs] - Core Module with generic methods that fit everything
 - [`ExUtils.Map`][docs-map] - Utility methods for Maps
 - [`ExUtils.Module`][docs-module] - Utility methods for Modules themselves



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



  [license]:          http://opensource.org/licenses/MIT
  [github-fork]:      https://github.com/sheharyarn/ex_utils/fork

  [hexpm]:            https://hex.pm/packages/ex_utils
  [docs]:             https://hexdocs.pm/ex_utils/ExUtils.html
  [docs-map]:         https://hexdocs.pm/ex_utils/ExUtils.Map.html
  [docs-module]:      https://hexdocs.pm/ex_utils/ExUtils.Module.html

