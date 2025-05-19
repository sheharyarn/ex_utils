if ExUtils.Modules.exists?(Ecto) do
  defmodule ExUtils.Ecto.Changesets do
    @moduledoc """
    Utility functions for working with Ecto changesets.

    To use this module, you need to first add `:ecto` as a dependency
    in your mix project.
    """

    alias Ecto.Changeset
    import Ecto.Changeset

    @doc """
    Puts a change only if the field is nil or has not already been changed.

    Value can optionally be a zero-arity function for lazy execution.

    ## Examples

    ```elixir
    iex> changeset = Ecto.Changeset.change({%{name: nil}, %{name: :string}})
    iex> changeset = put_new_change(changeset, :name, "Ali")
    iex> changeset.changes
    %{name: "Ali"}

    iex> changeset = Ecto.Changeset.change({%{name: nil}, %{name: :string}})
    iex> changeset = put_new_change(changeset, :name, fn -> "Shey" end)
    iex> changeset.changes
    %{name: "Shey"}

    iex> changeset = Ecto.Changeset.change({%{name: "Ali"}, %{name: :string}})
    iex> changeset = put_new_change(changeset, :name, "Shey")
    iex> changeset.changes
    %{}
    ```
    """
    @spec put_new_change(Changeset.t(), atom(), any()) :: Changeset.t()
    def put_new_change(%Changeset{} = changeset, field, value) when is_atom(field) do
      value =
        if is_function(value, 0) do
          value.()
        else
          value
        end

      case get_field(changeset, field) do
        nil -> put_change(changeset, field, value)
        _other -> changeset
      end
    end
  end
end
