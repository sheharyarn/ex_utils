defmodule ExUtils.Typespecs do
  @moduledoc """
  Elixir utility methods for typespecs.
  """

  @typedoc "Supported literals for dynamic typespec generation"
  @type literal() :: atom() | integer()

  @doc """
  Builds a union type from a list of static values.

  This is useful for generating typespecs for enums when the values are already
  known at compile-time. To use it, you must call this inside a `@type`
  definition inside an `unquote(...)` expression.

  Raises an error for invalid literals.

  ## Examples

  ```elixir
  # Given a list of static values:
  @statuses [:open, :closed]
  @priorities [1, 2, 3]

  # You can use them in a @type definition:
  @type status :: unquote(Typespecs.from_list(@statuses))
  @type priority :: unquote(Typespecs.from_list(@priorities)) | nil
  ```

  The above is equivalent to writing these typespecs by hand:

  ```elixir
  @type status :: :open | :closed
  @type priority :: 1 | 2 | 3 | nil
  ```

  """
  @spec from_list([literal()]) :: Macro.t()
  def from_list([]) do
    raise(ArgumentError, "cannot build a typespec from an empty list")
  end

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
