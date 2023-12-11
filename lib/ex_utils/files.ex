defmodule ExUtils.Files do
  @moduledoc """
  Utility methods for working with files.
  """

  @filesizes [KB: 1, MB: 2, GB: 3, TB: 4, PB: 5, EB: 6, ZB: 7, YB: 8]
  @byte_size 1024

  @doc """
  Formats an integer byte count as a human-readable file size.

  For example, `1250` is formatted as `"1.22 KB"`.

  ## Options

  - `:precision` - the number of decimal places to use. Defaults to `2`.

  ## Examples

  ```elixir
  iex> ExUtils.Files.format_size(12)
  "12 B"
  iex> ExUtils.Files.format_size(1234)
  "1.21 KB"
  iex> ExUtils.Files.format_size(1_234_567)
  "1.18 MB"
  iex> ExUtils.Files.format_size(1_234_567_890)
  "1.15 GB"
  iex> ExUtils.Files.format_size(1_234_567_890_123)
  "1.12 TB"
  iex> ExUtils.Files.format_size(12_345, precision: 1)
  "12.1 KB"
  iex> ExUtils.Files.format_size(12_345, precision: 2)
  "12.06 KB"
  iex> ExUtils.Files.format_size(12_345, precision: 3)
  "12.056 KB"
  ```
  """
  @spec format_size(integer(), Keyword.t()) :: String.t()
  def format_size(number, opts \\ []) when is_integer(number) and number >= 0 do
    precision = Keyword.get(opts, :precision, 2)

    if number < @byte_size do
      "#{number} B"
    else
      Enum.find_value(@filesizes, fn {name, power} ->
        if number < :math.pow(@byte_size, power + 1) do
          "#{Float.round(number / :math.pow(@byte_size, power), precision)} #{name}"
        end
      end)
    end
  end
end
