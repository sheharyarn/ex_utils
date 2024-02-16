defmodule ExUtils.Typespecs do
  @moduledoc """
  Elixir utility methods for typespecs.
  """

  @doc """
  Builds a union type from a list of static values.

  This is useful for generating typespecs for enums when the values are already
  known at compile-time. To use it, you must call this inside a `@type`
  definition inside an `unquote(...)` expression.

  ## Examples

  ```elixir
  # Given a list of static values:
  @statuses [:open, :closed]
  @priorities [1, 2, 3]

  # You can use them in a @type definition:
  @type status :: unquote(Typespecs.from_list(@statuses))
  @type priority :: unquote(Typespecs.from_list(@priorities)) | nil
  ```
  """
  @spec from_list([atom() | integer()]) :: Macro.t()
  def from_list(values) when is_list(values) do
    values
    |> Enum.map(&to_literal/1)
    |> Enum.reverse()
    |> Enum.reduce(fn value, union -> {:|, [], [value, union]} end)
  end

  defp to_literal(num) when is_integer(num), do: num
  defp to_literal(atom) when is_atom(atom), do: atom

  defp to_literal(value) do
    raise(ArgumentError, "invalid typespec literal: #{inspect(value)} (expected an atom or integer)")
  end
end
