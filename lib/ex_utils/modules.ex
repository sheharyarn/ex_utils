defmodule ExUtils.Modules do
  @moduledoc """
  Generic Elixir utility methods for modules themselves
  """

  @doc """
  Returns a String of the Module's name (without the Elixir namespace)

  ## Example

  ```elixir
  iex> ExUtils.Modules.name(SomeModule)
  "SomeModule"
  iex> ExUtils.Modules.name(Another.Module)
  "Another.Module"
  ```
  """
  @spec name(module()) :: String.t()
  def name(module) do
    module
    |> Module.split()
    |> Enum.join(".")
  end

  @doc """
  Check if a module exists and is compiled

  ## Example

  ```elixir
  iex> ExUtils.Modules.exists?(Map)
  true
  iex> ExUtils.Modules.exists?(NonExistentModule)
  false
  ```
  """
  @spec exists?(module()) :: boolean()
  def exists?(module) do
    Code.ensure_loaded?(module)
  end

  @doc """
  Returns a Keyword List of all methods of a module

  Calling `methods` on Module will return a `{:atom, arity}` Keyword
  List of all the functions of that module.

  You can also use these other aliases of this method:

   - `ExUtils.methods/1`
   - `ExUtils.functions/1`
   - `ExUtils.Modules.functions/1`

  ## Example

  ```elixir
  iex> {:flatten, 1} in ExUtils.functions(List)
  true
  iex> {:flatten, 2} in ExUtils.Modules.methods(List)
  true
  ```
  """
  @spec methods(module :: module) :: Keyword.t()
  def methods(module) do
    module.__info__(:functions)
  end

  @doc """
  Checks if a Module exports a specific method

  First argument must be a Module and the second argument can
  either be an `:atom` name of the function or a `{:atom, arity}`
  tuple.

  Can also be directly accessed as `ExUtils.has_method?/2`.

  ## Example

  ```elixir
  iex> ExUtils.has_method?(Map, :keys)
  true
  iex> ExUtils.has_method?(Map, {:keys, 1})
  true
  iex> ExUtils.has_method?(Map, {:keys, 2})
  false
  ```
  """
  @spec has_method?(module :: module, method :: atom | {atom, number}) :: boolean
  def has_method?(module, method) when is_atom(method) do
    Keyword.has_key?(methods(module), method)
  end

  def has_method?(module, {method, arity}) when is_atom(method) do
    :erlang.function_exported(module, method, arity)
  end

  ## Delegated Methods

  defdelegate functions(module), to: __MODULE__, as: :methods
end
