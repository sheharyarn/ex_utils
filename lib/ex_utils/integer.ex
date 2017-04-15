defmodule ExUtils.Integer do
  @moduledoc """
  Utility methods for the `Integer` types
  """


  @default_opts [precision: 2]
  @filesizes    [KB: 1, MB: 2, GB: 3, TB: 4, PB: 5, EB: 6, ZB: 7, YB: 8]
  @byte_size    1024

  @doc """
  Formats an `Integer` in a human-readable representation of filesize

  This method returns a string representing filesize in Bytes (e.g giving
  it `1250` returns `"1.22 KB"`). It also accepts an optional value of
  `:precision` that formats the number to the given no. of decimal places
  (default is `2`).

  ## Example

  ```
  ExUtils.Integer.to_filesize(12)                   # => "12 Bytes"
  ExUtils.Integer.to_filesize(1234)                 # => "1.21 KB"
  ExUtils.Integer.to_filesize(1234567)              # => "1.18 MB"
  ExUtils.Integer.to_filesize(1234567890)           # => "1.15 GB"
  ExUtils.Integer.to_filesize(1234567890123)        # => "1.12 TB"

  ExUtils.Integer.to_filesize(12345, precision: 1)  # => "12.1 KB"
  ExUtils.Integer.to_filesize(12345, precision: 2)  # => "12.06 KB"
  ExUtils.Integer.to_filesize(12345, precision: 3)  # => "12.056 KB"
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

