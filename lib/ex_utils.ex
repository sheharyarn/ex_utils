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


  # Delegated Methods

  defdelegate methods(module),              to: ExUtils.Module
  defdelegate functions(module),            to: ExUtils.Module
  defdelegate has_method?(module, method),  to: ExUtils.Module
end

