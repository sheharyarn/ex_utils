defmodule ExUtils do
  @moduledoc """
  Collection of core Elixir utility methods that don't fit
  in any specific Module
  """


  @doc """
  Checks if the term is a struct as well as a map

  ## Example

  ```
  ExUnit.is_struct?(:atom)                  # => false
  ExUnit.is_struct?(%{a: 1})                # => false
  ExUnit.is_struct?(%Person{name: "Ali"})   # => true
  ```
  """
  @spec is_struct?(term :: term) :: boolean
  def is_struct?(term)
  def is_struct?(%{__struct__: _}), do: true
  def is_struct?(_),                do: false


  @doc """
  Checks if the term is a pure map (i.e. not a struct)

  ## Example

  ```
  ExUtils.is_pure_map?(%{a: 1, b: 2})          # => true
  ExUtils.is_pure_map?(%Person{name: "Ali"})   # => false
  ```
  """
  @spec is_pure_map?(term :: term) :: boolean
  def is_pure_map?(term) do
    is_map(term) && !is_struct?(term)
  end


  @doc """
  Checks if a Module exports a specific method

  First argument must be a Module and the second argument can
  either be an `:atom` name of the function or a `{:atom, arity}`
  tuple

  ## Example

  ```
  ExUtils.has_method?(Map, :keys)         # => true
  ExUtils.has_method?(Map, {:keys, 1})    # => true
  ExUtils.has_method?(Map, {:keys, 2})    # => false
  ```
  """
  @spec has_method?(module :: module, method :: atom | tuple :: {atom, number}) :: boolean
  def has_method?(module, method) when is_atom(method) do
    module.__info__(:functions)[method] != nil
  end

  def has_method?(module, {method, arity}) when is_atom(method) do
    module.__info__(:functions)[method] == arity
  end
end

