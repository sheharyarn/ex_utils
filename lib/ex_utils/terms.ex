defmodule ExUtils.Terms do
  @moduledoc """
  Generic utilities for all Elixir terms
  """

  @doc """
  Evaluates if a value is blank.

  Returns `true` for `nil`, `false`, `0`, empty strings, whitespace-only strings,
  empty lists, and empty maps.

  ## Examples

  ```elixir
  iex> blank?(0)
  true
  iex> blank?(nil)
  true
  iex> blank?(false)
  true
  iex> blank?("")
  true
  iex> blank?("  ")
  true
  iex> blank?([])
  true
  iex> blank?(%{})
  true
  iex> blank?([1])
  false
  iex> blank?("Hello")
  false
  ```
  """
  @spec blank?(any()) :: boolean()
  def blank?(0), do: true
  def blank?(nil), do: true
  def blank?(false), do: true
  def blank?(str) when is_binary(str), do: String.trim(str) == ""
  def blank?(list) when is_list(list), do: list == []
  def blank?(map) when is_map(map), do: map_size(map) == 0
  def blank?(_), do: false

  @doc """
  Evaluates if a value is present.

  This is the opposite of `blank?/1`.

  ## Examples

  ```elixir
  iex> present?("Hello")
  true
  iex> present?(nil)
  false
  ```
  """
  @spec present?(any()) :: boolean()
  def present?(term) do
    not blank?(term)
  end

  @doc """
  Checks if the term is a struct as well as a map

  ## Example

  ```elixir
  iex> ExUtils.Terms.is_struct?(:atom)
  false
  iex> ExUtils.Terms.is_struct?(%{a: 1})
  false
  iex> ExUtils.Terms.is_struct?(%URI{})
  true
  ```
  """
  @spec is_struct?(any()) :: boolean()
  def is_struct?(term)
  def is_struct?(%{__struct__: _}), do: true
  def is_struct?(_), do: false

  @doc """
  Checks if the term is a pure map (i.e. not a struct)

  ## Example

  ```elixir
  iex> ExUtils.Terms.is_pure_map?(%{a: 1, b: 2})
  true
  iex> ExUtils.Terms.is_pure_map?(%URI{})
  false
  ```
  """
  @spec is_pure_map?(any()) :: boolean()
  def is_pure_map?(term) do
    is_map(term) && !is_struct?(term)
  end
end
