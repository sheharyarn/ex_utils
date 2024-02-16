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
  Converts all (string) map keys to atoms

  By default converts all string keys of the map to atoms at the
  first level. You can recursively convert keys in the base map and
  all sub-maps by specifiying `deep: true` in options

  You can also call `:symbolize_keys/2` instead of `:atomize_keys/2`

  ## Options

  Only accepts one option: `deep` with default value `false`

  ## Examples

  ```elixir
  iex> map = %{"a" => 1, "b" => %{"c" => 3, "d" => 4}}
  iex> ExUtils.Maps.atomize_keys(map)
  %{a: 1, b: %{"c" => 3, "d" => 4}}
  iex> ExUtils.Maps.atomize_keys(map, deep: true)
  %{a: 1, b: %{c: 3, d: 4}}
  ```
  """
  @spec atomize_keys(map :: Map.t(), opts :: Keyword.t()) :: Map.t()
  def atomize_keys(map, opts \\ [])

  def atomize_keys(map, opts) do
    opts = Keyword.merge([deep: false], opts)

    Enum.reduce(map, %{}, fn {k, v}, m ->
      v =
        case is_map(v) && opts[:deep] do
          true -> atomize_keys(v, opts)
          false -> v
        end

      map_atom_put(m, k, v)
    end)
  end

  @deprecated "Use ExUtils.Maps.atomize_keys/2 instead"
  defdelegate symbolize_keys(map, opts \\ []), to: __MODULE__, as: :atomize_keys

  ## Private Methods

  defp map_atom_put(m, k, v) do
    cond do
      is_binary(k) -> Map.put(m, String.to_atom(k), v)
      true -> Map.put(m, k, v)
    end
  end
end
