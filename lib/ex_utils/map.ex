defmodule ExUtils.Map do

  @default_options [recursive: true]

  def atomize_keys(map, opts \\ [])

  def atomize_keys(map, [recursive: false]) do
    Enum.reduce map, %{}, fn {k, v}, m ->
      map_put(m, k, v)
    end
  end

  def atomize_keys(map, opts) do
    opts = Keyword.merge(@default_options, opts)

    Enum.reduce map, %{}, fn {k, v}, m ->
      v =
        if is_map(v) do
          atomize_keys(v, opts)
        else
          v
        end

      map_put(m, k, v)
    end
  end

  defp map_put(m, k, v) do
    cond do
      is_binary(k) -> Map.put(m, String.to_atom(k), v)
      true         -> Map.put(m, k, v)
    end
  end

  defdelegate symbolize_keys(map, opts \\ []), to: __MODULE__, as: :atomize_keys
end
