defmodule ExUtils.Integer do
  @moduledoc """
  Utility methods for the `Elixir.Integer` types
  """

  @byte_size    1024
  @filesizes    [KB: 1, MB: 2, GB: 3, TB: 4, PB: 5, EB: 6, ZB: 7, YB: 8]
  @default_opts [precision: 2]



  @doc """
  Formats an `Integer` in a human-readable representation
  of filesize (e.g giving it `1250` returns `"1.22 KB"`.

  ## Example

  ```
  ExUtils.Integer.to_filesize(2048)
  # => "2 KB"
  ```
  """
  @spec to_filesize(number :: integer, opts :: Keyword.t) :: String.t
  def to_filesize(number, opts \\ []) when is_integer(number) do
    if number < @byte_size do
      "#{number} Bytes"

    else
      opts = Keyword.merge(@default_opts, opts)

      Enum.find_value(@filesizes, fn {name, power} ->
        if number < :math.pow(@byte_size, power + 1) do
          "#{Float.round(number / :math.pow(@byte_size, power), opts[:precision])} #{name}"
        end
      end)
    end
  end

end

