defmodule ExUtils.Module do
  @moduledoc """
  Generic Elixir utility methods for modules themselves
  """


  @doc """
  Checks if a Module exports a specific method

  First argument must be a Module and the second argument can
  either be an `:atom` name of the function or a `{:atom, arity}`
  tuple.

  Can also be directly accessed as `ExUtils.has_method?/2`.

  ## Example

  ```
  ExUtils.has_method?(Map, :keys)         # => true
  ExUtils.has_method?(Map, {:keys, 1})    # => true
  ExUtils.has_method?(Map, {:keys, 2})    # => false
  ```
  """
  @spec has_method?(module :: module, method :: atom | {atom, number}) :: boolean
  def has_method?(module, method) when is_atom(method) do
    Keyword.has_key?(module.__info__(:functions), method)
  end

  def has_method?(module, {method, arity}) when is_atom(method) do
    :erlang.function_exported(module, method, arity)
  end
end
