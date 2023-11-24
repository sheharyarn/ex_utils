defmodule ExUtils.Integers do
  @moduledoc """
  Utility methods for the `Integer` types
  """

  @default_opts [precision: 2]
  @filesizes [KB: 1, MB: 2, GB: 3, TB: 4, PB: 5, EB: 6, ZB: 7, YB: 8]
  @byte_size 1024

  @doc """
  Formats an `Integer` in a human-readable representation of filesize

  This method returns a string representing filesize in Bytes (e.g giving
  it `1250` returns `"1.22 KB"`). It also accepts an optional value of
  `:precision` that formats the number to the given no. of decimal places
  (default is `2`).

  ## Example

  ```elixir
  iex> ExUtils.Integers.to_filesize(12)
  "12 Bytes"
  iex> ExUtils.Integers.to_filesize(1234)
  "1.21 KB"
  iex> ExUtils.Integers.to_filesize(1_234_567)
  "1.18 MB"
  iex> ExUtils.Integers.to_filesize(1_234_567_890)
  "1.15 GB"
  iex> ExUtils.Integers.to_filesize(1_234_567_890_123)
  "1.12 TB"

  iex> ExUtils.Integers.to_filesize(12_345, precision: 1)
  "12.1 KB"
  iex> ExUtils.Integers.to_filesize(12_345, precision: 2)
  "12.06 KB"
  iex> ExUtils.Integers.to_filesize(12_345, precision: 3)
  "12.056 KB"
  ```
  """
  @spec to_filesize(number :: integer, opts :: Keyword.t()) :: String.t()
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
