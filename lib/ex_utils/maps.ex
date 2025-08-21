defmodule ExUtils.Maps do
  @moduledoc """
  Elixir Utility methods for the `Map` module
  """

  @dropped_keys [:__meta__]
  @dropped_structs [Ecto.Association.NotLoaded]
  @ignored_structs [Date, Time, DateTime, NaiveDateTime]

  @doc """
  Converts a struct/map to plain map.

  ## Options

  - `:deep` - recursively converts nested structs when `true`. Defaults to `true`.

  Date, time, and date-time structs are preserved.

  ## Examples

  ```elixir
  iex> ExUtils.Maps.from_struct(1..3)
  %{first: 1, last: 3, step: 1}

  iex> date = ~D[2026-10-04]
  iex> ExUtils.Maps.from_struct(date)
  ~D[2026-10-04]
  ```
  """
  @spec from_struct(map(), Keyword.t()) :: map()
  def from_struct(%{} = map, opts \\ []) do
    do_from_struct(map, opts)
  end

  defp do_from_struct(%module{} = struct, _opts) when module in @ignored_structs do
    struct
  end

  defp do_from_struct(struct, opts) when is_struct(struct) do
    deep? = Keyword.get(opts, :deep, true)

    struct
    |> Map.from_struct()
    |> Map.drop(@dropped_keys)
    |> Enum.map(fn
      {_k, %module{}} when module in @dropped_structs ->
        nil

      {k, v} ->
        value = if deep?, do: do_from_struct(v, opts), else: v
        {k, value}
    end)
    |> Enum.filter(& &1)
    |> Map.new()
  end

  defp do_from_struct([struct | _rest] = list, opts) when is_struct(struct) do
    Enum.map(list, &do_from_struct(&1, opts))
  end

  defp do_from_struct(other, _opts), do: other

  @doc """
  Atomize the given keys of a map.

  Passed keys must be a list of atoms or `:all`. Using a list of atoms is
  the recommended way. If you use `:all`, you must be careful to avoid
  calling it on external or unknown data, which can grow the Erlang Atom table,
  and may even cause it to overload.

  ## Options

  - `:deep` - Perform conversion for keys in nested maps. Defaults to `false`.
  - `:drop` - Drop unconverted keys. Defaults to `false`.

  Original, converted string keys are always dropped.

  ## Examples

  ```elixir
  iex> map = %{"a" => 1, "b" => %{"c" => 3, "d" => 4}}
  iex> ExUtils.Maps.atomize_keys(map, [:a, :b])
  %{a: 1, b: %{"c" => 3, "d" => 4}}
  iex> ExUtils.Maps.atomize_keys(map, [:a, :b], deep: true)
  %{a: 1, b: %{"c" => 3, "d" => 4}}
  iex> ExUtils.Maps.atomize_keys(map, [:a, :b, :d], deep: true)
  %{a: 1, b: %{"c" => 3, d: 4}}
  iex> ExUtils.Maps.atomize_keys(map, [:a], drop: true)
  %{a: 1}
  iex> ExUtils.Maps.atomize_keys(map, :all, deep: true)
  %{a: 1, b: %{c: 3, d: 4}}
  ```
  """
  @spec atomize_keys(map(), :all | [atom()], Keyword.t()) :: map()
  def atomize_keys(%{} = map, keys, opts \\ []) when keys == :all or is_list(keys) do
    all? = keys == :all
    deep? = Keyword.get(opts, :deep, false)
    drop? = Keyword.get(opts, :drop, false)
    string_keys = (all? && []) || Enum.map(keys, &to_string/1)

    map
    |> Enum.map(fn {key, value} ->
      value =
        if deep? and is_map(value) and not is_struct(value) do
          atomize_keys(value, keys, opts)
        else
          value
        end

      cond do
        all? and is_atom(key) -> {key, value}
        all? and is_binary(key) -> {to_unsafe_atom(key), value}
        is_atom(key) and key in keys -> {key, value}
        is_binary(key) and key in string_keys -> {String.to_existing_atom(key), value}
        drop? -> nil
        true -> {key, value}
      end
    end)
    |> Enum.reject(&is_nil/1)
    |> Map.new()
  end

  # sobelow_skip ["DOS.StringToAtom"]
  defp to_unsafe_atom(string), do: String.to_atom(string)

  @deprecated "Use ExUtils.Maps.atomize_keys/3 instead"
  def atomize_keys(%{} = map), do: atomize_keys(map, :all, deep: false)

  @deprecated "Use ExUtils.Maps.atomize_keys/3 instead"
  def symbolize_keys(map, opts \\ []), do: atomize_keys(map, :all, opts)

  @doc """
  Converts the given map keys to strings.

  Passed keys must be a list of atoms or `:all`.

  ## Options

  - `:deep` - Perform conversion for keys in nested maps. Defaults to `false`.
  - `:drop` - Drop unconverted keys. Defaults to `false`.

  Original, converted atom keys are always dropped.

  ## Examples

  ```elixir
  iex> map = %{a: 1, b: %{c: 3, d: 4}}
  iex> ExUtils.Maps.stringify_keys(map, [:a, :b])
  %{"a" => 1, "b" => %{c: 3, d: 4}}
  iex> ExUtils.Maps.stringify_keys(map, [:a, :b], deep: true)
  %{"a" => 1, "b" => %{c: 3, d: 4}}
  iex> ExUtils.Maps.stringify_keys(map, [:a, :b, :d], deep: true)
  %{"a" => 1, "b" => %{:c => 3, "d" => 4}}
  iex> ExUtils.Maps.stringify_keys(map, [:a], drop: true)
  %{"a" => 1}
  iex> ExUtils.Maps.stringify_keys(map, :all, deep: true)
  %{"a" => 1, "b" => %{"c" => 3, "d" => 4}}
  ```
  """
  @spec stringify_keys(map(), :all | [atom()], Keyword.t()) :: map()
  def stringify_keys(%{} = map, keys, opts \\ []) when keys == :all or is_list(keys) do
    all? = keys == :all
    deep? = Keyword.get(opts, :deep, false)
    drop? = Keyword.get(opts, :drop, false)
    string_keys = (all? && []) || Enum.map(keys, &to_string/1)

    map
    |> Enum.map(fn {key, value} ->
      value =
        if deep? and is_map(value) and not is_struct(value) do
          stringify_keys(value, keys, opts)
        else
          value
        end

      cond do
        all? and is_binary(key) -> {key, value}
        all? and is_atom(key) -> {to_string(key), value}
        is_binary(key) and key in string_keys -> {key, value}
        is_atom(key) and key in keys -> {to_string(key), value}
        drop? -> nil
        true -> {key, value}
      end
    end)
    |> Enum.reject(&is_nil/1)
    |> Map.new()
  end
end
