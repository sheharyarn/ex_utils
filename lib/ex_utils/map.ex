defmodule ExUtils.Map do
  @moduledoc """
  Elixir Utility methods for the `Map` module
  """


  @default_options [deep: false]
  @doc """
  Converts all (string) map keys to atoms

  By default converts all string keys of the map and all sub-maps
  to atoms. Conversion to atoms can be limited to the base map
  by specifiying `recursive: false` in options

  You can also call `:symbolize_keys/2` instead of `:atomize_keys/2`

  ## Options

  Only accepts one option: `deep` with default value `false`

  ## Examples

  ```
  map = %{"a" => 1, "b" => %{"c" => 3, "d" => 4} }

  ExUtils.Map.symbolize_keys(map)
  #=> %{a: 1, b: %{"c" => 3, "d" => 4}}

  ExUtils.Map.atomize_keys(map, deep: true)
  #=> %{a: 1, b: %{c: 3, d: 4}}
  ```
  """
  @spec atomize_keys(map :: Map.t, opts :: Keyword.t) :: Map.t
  def atomize_keys(map, opts \\ [])
  def atomize_keys(map, opts) do
    opts = Keyword.merge(@default_options, opts)

    Enum.reduce map, %{}, fn {k, v}, m ->
      v = case is_map(v) && opts[:deep] do
        true  -> atomize_keys(v, opts)
        false -> v
      end

      map_atom_put(m, k, v)
    end
  end


  defdelegate symbolize_keys(map, opts \\ []), to: __MODULE__, as: :atomize_keys



  ## Private Methods

  defp map_atom_put(m, k, v) do
    cond do
      is_binary(k) -> Map.put(m, String.to_atom(k), v)
      true         -> Map.put(m, k, v)
    end
  end

end
