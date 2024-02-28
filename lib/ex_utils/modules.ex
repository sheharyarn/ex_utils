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
  Returns a Keyword List of all functions of a module.

  Calling this will return a `{:atom, arity}` keyword list
  of all the functions of that module.

  ## Example

  ```elixir
  iex> {:flatten, 1} in ExUtils.Modules.functions(List)
  true
  iex> {:unknown, 2} in ExUtils.Modules.functions(List)
  false
  ```
  """
  @spec functions(module()) :: Keyword.t()
  def functions(module) do
    module.__info__(:functions)
  end

  @deprecated "Use ExUtils.Modules.functions/1 instead"
  defdelegate methods(module), to: __MODULE__, as: :functions

  @doc """
  Checks if a Module exports a specific function.

  First argument must be a Module and the second argument can
  either be an `:atom` name of the function or a `{:atom, arity}`
  tuple.

  ## Example

  ```elixir
  iex> ExUtils.Modules.has_function?(Map, :keys)
  true
  iex> ExUtils.Modules.has_function?(Map, {:keys, 1})
  true
  iex> ExUtils.Modules.has_function?(Map, {:keys, 2})
  false
  ```
  """
  @spec has_function?(module(), atom() | {atom(), non_neg_integer()}) :: boolean()
  def has_function?(module, name) when is_atom(name) do
    module
    |> functions()
    |> Keyword.has_key?(name)
  end

  def has_function?(module, {name, arity}) when is_atom(name) and is_integer(arity) do
    :erlang.function_exported(module, name, arity)
  end

  @deprecated "Use ExUtils.Modules.has_function?/2 instead"
  defdelegate has_method?(module, function), to: __MODULE__, as: :has_function?
end
