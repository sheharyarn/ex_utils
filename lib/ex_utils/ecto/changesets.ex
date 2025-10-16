if ExUtils.Modules.exists?(Ecto) do
  defmodule ExUtils.Ecto.Changesets do
    @moduledoc """
    Utility functions for working with Ecto changesets.

    To use this module, you need to first add `:ecto` as a dependency
    in your mix project.
    """

    alias Ecto.Changeset
    alias ExUtils.Modules
    import Ecto.Changeset

    @doc """
    Puts a change only if the field is nil or has not already been changed.

    Value can optionally be a zero-arity function for lazy execution.

    ## Examples

    ```elixir
    iex> changeset = Ecto.Changeset.change(%User{name: nil})
    iex> changeset = put_new_change(changeset, :name, "Ali")
    iex> changeset.changes
    %{name: "Ali"}

    iex> changeset = Ecto.Changeset.change(%User{name: nil})
    iex> changeset = put_new_change(changeset, :name, fn -> "Shey" end)
    iex> changeset.changes
    %{name: "Shey"}

    iex> changeset = Ecto.Changeset.change(%User{name: "Ali"})
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

    @doc """
    Prevents changing a field once set.

    Adds an error when the changeset changes a field whose original value is
    not ignored.

    ## Options

    - `:ignore` - Initial values that may be changed. Defaults to `[nil]`.
    - `:message` - Error message used when a change is prevented. Defaults to
      `"cannot modify"`.

    ## Examples

    ```elixir
    # Specify which fields cannot be changed
    def changeset(user, attrs) do
      user
      |> cast(attrs, [:name, :email])
      |> prevent_change(:email)
    end

    iex> changeset = User.changeset(%User{email: "old@example.com"}, %{email: "new@example.com"})
    iex> changeset.errors
    [email: {"cannot modify", []}]

    iex> changeset = User.changeset(%User{}, %{email: "new@example.com"})
    iex> changeset.errors
    []
    ```
    """
    @spec prevent_change(Changeset.t(), atom(), Keyword.t()) :: Changeset.t()
    def prevent_change(%Changeset{} = changeset, field, opts \\ []) when is_atom(field) do
      error_message = Keyword.get(opts, :message, "cannot modify")
      ignored_values = Keyword.get(opts, :ignore, [nil])
      old_value = Map.get(changeset.data, field)

      validate_change(changeset, field, fn ^field, new_value ->
        cond do
          new_value == old_value -> []
          old_value in ignored_values -> []
          true -> [{field, error_message}]
        end
      end)
    end

    @doc """
    Checks if the changeset data has an Ecto source.

    This returns `true` for changesets of source-backed schemas (that map
    to a real data source such as a database table), and returns `false`
    for [Embedded Schemas](https://hexdocs.pm/ecto/embedded-schemas.html)
    and [schemaless changesets](https://hexdocs.pm/ecto/Ecto.Changeset.html#module-schemaless-changesets).

    Also see `embedded_schema?/1`.

    ## Examples

    ```elixir
    # When `User` schema maps to the "users" table
    iex> changeset = Ecto.Changeset.change(%User{})
    iex> has_source?(changeset)
    true

    # When `Profile` is defined using `embedded_schema`
    iex> changeset = Ecto.Changeset.change(%Profile{})
    iex> has_source?(changeset)
    false
    ```
    """
    @spec has_source?(Changeset.t()) :: boolean()
    def has_source?(%Changeset{data: %{__meta__: %{source: source}}}) when not is_nil(source), do: true
    def has_source?(%Changeset{}), do: false

    @doc """
    Checks if the given changeset is for an Ecto
    [embedded schema](https://hexdocs.pm/ecto/embedded-schemas.html).

    Returns `false` for source-backed schemas and [schemaless changesets](https://hexdocs.pm/ecto/Ecto.Changeset.html#module-schemaless-changesets).
    Also see `has_source?/1`.

    ## Examples

    ```elixir
    # When `Profile` is defined using `embedded_schema`
    iex> changeset = Ecto.Changeset.change(%Profile{})
    iex> embedded_schema?(changeset)
    true

    # When `User` schema maps to the "users" table
    iex> changeset = Ecto.Changeset.change(%User{})
    iex> embedded_schema?(changeset)
    false
    ```
    """
    @spec embedded_schema?(Changeset.t()) :: boolean()
    def embedded_schema?(%Changeset{data: %module{}} = changeset) do
      !has_source?(changeset) and Modules.has_function?(module, {:__schema__, 1})
    end

    def embedded_schema?(%Changeset{}), do: false
  end
end
