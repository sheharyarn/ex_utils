defmodule ExUtils.Random do
  @moduledoc """
  Random value generators
  """

  @doc """
  Get a random boolean value.

  ## Example

  ```elixir
  iex> ExUtils.Random.boolean()
  true
  ```
  """
  @spec boolean() :: boolean()
  def boolean do
    Enum.random([true, false])
  end

  @doc """
  Get a random integer value between 1 and `max` (inclusive).

  If you want to get a value within a custom range, see `integer/2`.

  ## Example

  ```elixir
  iex> ExUtils.Random.integer(10)
  7
  ```
  """
  @spec integer(pos_integer()) :: pos_integer()
  def integer(max) when is_integer(max) and max > 0 do
    :rand.uniform(max)
  end

  @doc """
  Get a random integer value within the given range.

  Also see `integer/1`.

  ## Example

  ```elixir
  iex> ExUtils.Random.integer(5, 10)
  8
  ```
  """
  @spec integer(integer(), integer()) :: integer()
  def integer(min, max) when is_integer(min) and is_integer(max) and max > min do
    integer(max - min) + min
  end

  @doc """
  Get a random string of given length.

  The default length is 10 characters.

  ## Examples

  ```elixir
  iex> ExUtils.Random.string()
  "q4mRy_YGXa"
  iex> ExUtils.Random.string(5)
  "Bk9p_"
  ```
  """
  @spec string(pos_integer()) :: binary()
  def string(length \\ 10) when is_integer(length) and length > 0 do
    length
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64()
    |> binary_part(0, length)
  end
end
