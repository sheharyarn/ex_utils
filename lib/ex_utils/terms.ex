defmodule ExUtils.Terms do
  @moduledoc """
  Generic utilities for all Elixir terms
  """

  @doc """
  Checks if the term is a struct as well as a map

  ## Example

  ```
  ExUtils.Terms.is_struct?(:atom)                  # => false
  ExUtils.Terms.is_struct?(%{a: 1})                # => false
  ExUtils.Terms.is_struct?(%Person{name: "Ali"})   # => true
  ```
  """
  @spec is_struct?(term :: term) :: boolean
  def is_struct?(term)
  def is_struct?(%{__struct__: _}), do: true
  def is_struct?(_), do: false

  @doc """
  Checks if the term is a pure map (i.e. not a struct)

  ## Example

  ```
  ExUtils.Terms.is_pure_map?(%{a: 1, b: 2})          # => true
  ExUtils.Terms.is_pure_map?(%Person{name: "Ali"})   # => false
  ```
  """
  @spec is_pure_map?(term :: term) :: boolean
  def is_pure_map?(term) do
    is_map(term) && !is_struct?(term)
  end
end
