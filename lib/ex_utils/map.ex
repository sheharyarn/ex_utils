defmodule ExUtils.Map do
  @moduledoc """
  Elixir Utility methods for the `Map` module
  """


  @default_options [recursive: true]
  @doc """
  Converts all (string) map keys to atoms

  By default converts all string keys of the map and all sub-maps
  to atoms. Conversion to atoms can be limited to the base map
  by specifiying `recursive: false` in options

  You can also call `:symbolize_keys/2` instead of `:atomize_keys/2`

  ## Options

  Only accepts one option: `recursive` with default value `true`

  ## Examples

  ```
  map = %{"a" => 1, "b" => %{"c" => 3, "d" => 4} }

  ExUtils.Map.symbolize_keys(map)
  #=> %{a: 1, b: %{c: 3, d: 4}}

  ExUtils.Map.atomize_keys(map, recursive: false)
  #=> %{a: 1, b: %{"c" => 3, "d" => 4}}
  ```
  """
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


  defdelegate symbolize_keys(map, opts \\ []), to: __MODULE__, as: :atomize_keys



  ## Private Methods

  defp map_put(m, k, v) do
    cond do
      is_binary(k) -> Map.put(m, String.to_atom(k), v)
      true         -> Map.put(m, k, v)
    end
  end

end
