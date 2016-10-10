defmodule ExUtils.Map do

  @default_options [recursive: true]

  def atomize_keys(map, opts \\ [])

  def atomize_keys(map, [recursive: false]) do
    Enum.reduce map, %{}, fn {k, v}, m ->
      Map.put(m, String.to_atom(k), v)
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

      Map.put(m, String.to_atom(k), v)
    end
  end

  defdelegate symbolize_keys(map, opts \\ []), to: __MODULE__, as: :atomize_keys
end
