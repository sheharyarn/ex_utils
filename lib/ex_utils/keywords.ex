defmodule ExUtils.Keywords do
  @moduledoc """
  Utility methods for the `Keyword` types
  """

  @doc """
  Converts a keyword into map

  ## Example

  ```elixir
  iex> ExUtils.Keywords.to_map(a: 1, b: 2, c: 3)
  %{a: 1, b: 2, c: 3}
  ```
  """
  @spec to_map(keyword :: Keyword.t()) :: Map.t()
  def to_map(keyword) do
    Enum.into(keyword, %{})
  end
end
