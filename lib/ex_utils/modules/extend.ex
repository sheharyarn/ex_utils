defmodule ExUtils.Modules.Extend do
  @moduledoc """
  Allows extending a module, keeping all functions from the referenced
  module by delegating them.
  """

  alias ExUtils.Modules

  @doc """
  For a given module, defines and duplicates all of that module's
  functions in the caller module. This is equivalent to calling
  `Kernel.defdelegate/2` for every public function of that module.

  ## Example

  Imagine you want to duplicate Elixir's built-in Map module
  but with additional functions or to override behaviors.

  ```elixir
  defmodule MyMap do
    use ExUtils.Modules.Extend, from: Map

    # Add a new function
    def empty, do: %{}

    # Override existing function
    defoverridable equal?: 2
    def equal?(left, right) do
      # add custom equality check here
    end
  end
  ```

  With this, you can call your new functions `MyMap.empty()` and
  `MyMap.equal?(m1, m2)` but also all other `Map` functions, such
  as `MyMap.get/2`, `MyMap.drop/2`, etc.
  `
  """
  defmacro __using__(opts) do
    opts = Macro.expand_literals(opts, __CALLER__)
    module = Keyword.fetch!(opts, :from)

    if !Modules.exists?(module) do
      raise(ArgumentError, "cannot extend unknown module: #{inspect(module)}")
    end

    functions = Modules.functions(module)

    Enum.map(functions, fn {name, arity} ->
      args = Enum.map(1..arity//1, &{:"arg#{&1}", [], __MODULE__})

      quote do
        defdelegate unquote(name)(unquote_splicing(args)), to: unquote(module)
      end
    end)
  end
end
