defmodule ExUtils.Integer do
  @moduledoc """
  Utility methods for the `Elixir.Integer` types
  """

  @byte_size 1024
  @filesizes [Bytes: 0, KB: 1, MB: 2, GB: 3, TB: 4, PB: 5, EB: 6, ZB: 7, YB: 8]



  @doc """
  Formats an `Integer` in a human-readable representation
  of filesize (e.g giving it `1250` returns `"1.22 KB"`.

  ## Example

  ```
  ExUtils.Integer.to_filesize(2048)
  # => "2 KB"
  ```
  """
  @spec to_filesize(number :: integer) :: String.t
  def to_filesize(number) when is_integer(number) do
    Enum.find_value(@filesizes, fn {name, power} ->
      cond do
        number < @byte_size ->
          "#{number} #{name}"

        number < :math.pow(@byte_size, power + 1) ->
          "#{Float.round(number / :math.pow(@byte_size, power), 2)} #{name}"

        true -> nil
      end
    end)
  end

end

