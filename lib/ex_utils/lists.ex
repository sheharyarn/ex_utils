defmodule ExUtils.Lists do
  @moduledoc """
  Elixir Utility methods for Lists.
  """

  @doc """
  Removes nil values from a list.

  Imitates Ruby's .compact:
  https://ruby-doc.org/core-1.9.3/Array.html#method-i-compact

  ## Examples

  ```elixir
  iex> compact([1, nil, nil, 2, nil, 3, 4])
  [1, 2, 3, 4]
  ```
  """
  @spec compact(list()) :: list()
  def compact(list) when is_list(list) do
    Enum.filter(list, &(!is_nil(&1)))
  end

  @doc """
  Replaces a value in a list of maps/structs, given a `:key`
  (default `:id`).

  The `key` should ideally be unique, because this function
  will replace all matches on key with the new `item`.

  ## Options

  - `:key` - The key with which to match value in the list. Defaults to `:id`.

  ## Examples

  ```elixir
  iex> list = [%{id: 1, name: "Ada"}, %{id: 2, name: "Grace"}, %{id: 3, name: "Linus"}]
  iex> replace(list, %{id: 2, name: "Grace Hopper"})
  [%{id: 1, name: "Ada"}, %{id: 2, name: "Grace Hopper"}, %{id: 3, name: "Linus"}]

  iex> list = [%{email: "ada@example.com", active: false}]
  iex> replace(list, %{email: "ada@example.com", active: true}, key: :email)
  [%{email: "ada@example.com", active: true}]
  ```
  """
  @spec replace([map()], map(), Keyword.t()) :: [map()]
  def replace(list, item, opts \\ []) do
    key = Keyword.get(opts, :key, :id)
    value = Map.fetch!(item, key)
    predicate = &(Map.fetch(&1, key) == {:ok, value})

    put_in(list, [Access.filter(predicate)], item)
  end
end
