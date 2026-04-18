if ExUtils.Modules.exists?(Decimal) do
  defmodule ExUtils.Numbers do
    @moduledoc """
    Utility functions to work with numeric types.
    """

    import Decimal, only: [is_decimal: 1]
    import Kernel, except: [round: 1, trunc: 1, to_string: 1]

    @typedoc "Any numeric value including Decimal"
    @type t :: number() | Decimal.t()

    @typedoc "A value that can be parsed into a numeric type"
    @type parseable :: t() | String.t() | nil

    @doc """
    Checks whether a value is an integer, float, or decimal.

    You need to `import` or `require` this module to use this guard.

    ## Examples

    ```elixir
    iex> is_numeric(12)
    true

    iex> is_numeric(Decimal.new("12.5"))
    true

    iex> is_numeric("12.5")
    false
    ```
    """
    defguard is_numeric(num) when is_number(num) or is_decimal(num)

    @doc """
    Checks whether a value is a positive integer.

    You need to `import` or `require` this module to use this guard.

    ## Examples

    ```elixir
    iex> is_positive(12)
    true

    iex> is_positive(0)
    false

    iex> is_positive(1.5)
    false
    ```
    """
    defguard is_positive(n) when is_integer(n) and n > 0

    @doc """
    Parse a string or another numeric type to decimal.

    If the input is nil or invalid string, returns nil.

    ## Examples

    ```elixir
    iex> ExUtils.Numbers.to_decimal(" 12.5 ")
    Decimal.new("12.5")

    iex> ExUtils.Numbers.to_decimal(12)
    Decimal.new("12")

    iex> ExUtils.Numbers.to_decimal("invalid")
    nil
    ```
    """
    @spec to_decimal(parseable()) :: Decimal.t() | nil
    def to_decimal(%Decimal{} = value), do: value
    def to_decimal(value) when is_integer(value), do: Decimal.new(value)
    def to_decimal(value) when is_float(value), do: Decimal.from_float(value)
    def to_decimal(value) when is_binary(value), do: from_string(value, &Decimal.parse/1)
    def to_decimal(_), do: nil

    @doc """
    Parse a string or another numeric type to a float.

    If the input is nil or invalid string, returns nil.

    ## Examples

    ```elixir
    iex> ExUtils.Numbers.to_float(" 12.5 ")
    12.5

    iex> ExUtils.Numbers.to_float(12)
    12.0

    iex> ExUtils.Numbers.to_float("invalid")
    nil
    ```
    """
    @spec to_float(parseable()) :: float() | nil
    def to_float(%Decimal{} = value), do: Decimal.to_float(value)
    def to_float(value) when is_integer(value), do: value * 1.0
    def to_float(value) when is_float(value), do: value
    def to_float(value) when is_binary(value), do: from_string(value, &Float.parse/1)
    def to_float(_), do: nil

    @doc """
    Parse a string or another numeric type to an integer.

    If the input is a decimal or float, it rounds it.
    If the input is nil or invalid string, returns nil.

    ## Examples

    ```elixir
    iex> ExUtils.Numbers.to_integer(Decimal.new("12.5"))
    13

    iex> ExUtils.Numbers.to_integer(12.4)
    12

    iex> ExUtils.Numbers.to_integer("12")
    12

    iex> ExUtils.Numbers.to_integer("12.5")
    nil
    ```
    """
    @spec to_integer(parseable()) :: integer() | nil
    def to_integer(%Decimal{} = value), do: value |> Decimal.round() |> Decimal.to_integer()
    def to_integer(value) when is_integer(value), do: value
    def to_integer(value) when is_float(value), do: Kernel.round(value)
    def to_integer(value) when is_binary(value), do: from_string(value, &Integer.parse/1)
    def to_integer(_), do: nil

    @doc """
    Truncates a numeric value and returns an integer.

    ## Examples

    ```elixir
    iex> ExUtils.Numbers.trunc(Decimal.new("5.7"))
    5

    iex> ExUtils.Numbers.trunc(-5.7)
    -5

    iex> ExUtils.Numbers.trunc(5)
    5
    ```
    """
    @spec trunc(t()) :: integer()
    def trunc(%Decimal{} = n), do: n |> Decimal.round(0, :down) |> Decimal.to_integer()
    def trunc(n) when is_integer(n), do: n
    def trunc(n) when is_float(n), do: Kernel.trunc(n)

    # Parse helpers

    defp from_string(string, parser) do
      string
      |> String.trim()
      |> parser.()
      |> case do
        {number, ""} -> number
        _other -> nil
      end
    end
  end
end
