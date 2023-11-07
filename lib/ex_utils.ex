defmodule ExUtils do
  @moduledoc """
  Elixir utilities, helpers and shortcuts.
  """

  # Delegated Methods

  defdelegate methods(module), to: ExUtils.Modules
  defdelegate functions(module), to: ExUtils.Modules
  defdelegate has_method?(module, method), to: ExUtils.Modules
end
