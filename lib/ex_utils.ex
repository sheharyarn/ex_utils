defmodule ExUtils do
  @moduledoc """
  Elixir utilities, helpers and shortcuts.
  """

  # Delegated Methods

  @deprecated "Use ExUtils.Modules.functions/1 instead"
  defdelegate methods(module), to: ExUtils.Modules, as: :functions

  @deprecated "Use ExUtils.Modules.functions/1 instead"
  defdelegate functions(module), to: ExUtils.Modules, as: :functions

  @deprecated "Use ExUtils.Modules.has_function?/2 instead"
  defdelegate has_method?(module, function), to: ExUtils.Modules, as: :has_function?
end
