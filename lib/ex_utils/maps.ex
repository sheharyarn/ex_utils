defmodule ExUtils.Maps do
  @moduledoc """
  Elixir Utility methods for the `Map` module
  """

  @dropped_keys [:__meta__]
  @dropped_structs [Ecto.Association.NotLoaded]
  @ignored_structs [Date, Time, DateTime, NaiveDateTime]

  @blanks [nil, "", []]

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
  Flattens nested map and list keys into dot-separated string keys.

  Structs and empty maps or lists are preserved as values.

  ## Examples

  ```elixir
  iex> ExUtils.Maps.flatten(%{user: %{name: "Ada", settings: %{theme: "dark"}}})
  %{"user.name" => "Ada", "user.settings.theme" => "dark"}

  iex> ExUtils.Maps.flatten(%{profiles: [%{platform: "github", username: "ada"}]})
  %{"profiles.0.platform" => "github", "profiles.0.username" => "ada"}
  ```
  """
  @spec flatten(map()) :: %{String.t() => any()}
  def flatten(%{} = map) do
    []
    |> do_flatten(map)
    |> Enum.map(fn {key_path, value} -> {Enum.reverse(key_path), value} end)
    |> Map.new(fn {key_path, value} ->
      {Enum.map_join(key_path, ".", &to_string/1), value}
    end)
  end

  defp do_flatten(key_path, %module{} = struct) when is_atom(module), do: [{key_path, struct}]
  defp do_flatten(key_path, %{} = map) when map_size(map) == 0, do: [{key_path, map}]
  defp do_flatten(key_path, []), do: [{key_path, []}]

  defp do_flatten(key_path, %{} = map) do
    Enum.flat_map(map, fn {key, value} -> do_flatten([key | key_path], value) end)
  end

  defp do_flatten(key_path, list) when is_list(list) do
    list
    |> Enum.with_index()
    |> Enum.flat_map(fn {value, index} -> do_flatten([index | key_path], value) end)
  end

  defp do_flatten(key_path, value), do: [{key_path, value}]

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

  @doc """
  Removes all keys with blank values.

  ## Options

  - `:blanks` - Values considered blank. Defaults to `#{inspect(@blanks)}`.

  ## Examples

  ```elixir
  iex> ExUtils.Maps.drop_blank_values(%{a: 123, b: nil, c: "", d: [], e: false})
  %{a: 123, e: false}

  iex> ExUtils.Maps.drop_blank_values(%{count: 0, active: false}, blanks: [nil, 0])
  %{active: false}
  ```
  """
  @spec drop_blank_values(map(), Keyword.t()) :: map()
  def drop_blank_values(%{} = map, opts \\ []) do
    blanks = Keyword.get(opts, :blanks, @blanks)

    map
    |> Enum.reject(fn {_key, value} -> value in blanks end)
    |> Map.new()
  end

  @doc """
  Puts a key-value pair into a map when the value is not blank.

  ## Options

  - `:blanks` - Values considered blank. Defaults to `#{inspect(@blanks)}`.

  ## Examples

  ```elixir
  iex> ExUtils.Maps.maybe_put(%{}, :name, "John")
  %{name: "John"}

  iex> ExUtils.Maps.maybe_put(%{name: "Mary"}, :name, "John")
  %{name: "John"}

  iex> ExUtils.Maps.maybe_put(%{name: "John"}, :name, nil)
  %{name: "John"}

  iex> ExUtils.Maps.maybe_put(%{}, :count, 0, blanks: [nil, 0])
  %{}
  ```
  """
  @spec maybe_put(map(), any(), any(), Keyword.t()) :: map()
  def maybe_put(%{} = map, key, value, opts \\ []) do
    blanks = Keyword.get(opts, :blanks, @blanks)

    if value in blanks do
      map
    else
      Map.put(map, key, value)
    end
  end
end
