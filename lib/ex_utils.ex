defmodule ExUtils do
  @moduledoc """
  Elixir utilities, helpers and shortcuts.
  """

  # Delegated Methods

  defdelegate methods(module), to: ExUtils.Module
  defdelegate functions(module), to: ExUtils.Module
  defdelegate has_method?(module, method), to: ExUtils.Module
end
