defmodule ExUtils.Lists do
  @moduledoc """
  Elixir Utility methods for Lists.
  """

  @doc """
  Removes nil values from a list.

  Imitates Ruby's .compact:
  https://ruby-doc.org/core-1.9.3/Array.html#method-i-compact

  ## Examples:

  ```elixir
  iex> compact([1, nil, nil, 2, nil, 3, 4])
  [1, 2, 3, 4]
  ```
  """
  @spec compact(list()) :: list()
  def compact(list) when is_list(list) do
    Enum.filter(list, &(!is_nil(&1)))
  end
end
