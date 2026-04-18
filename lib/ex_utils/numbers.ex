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

    @doc "Check if a value is a decimal or internal numeric type"
    defguard is_numeric(num) when is_number(num) or is_decimal(num)

    @doc "Ensure term is a positive integer"
    defguard is_positive(n) when is_integer(n) and n > 0

    @doc """
    Parse a string or another numeric type to decimal.

    If the input is nil or invalid string, returns nil.
    """
    @spec to_decimal(parseable()) :: Decimal.t() | nil
    def to_decimal(%Decimal{} = value), do: value
    def to_decimal(value) when is_integer(value), do: Decimal.new(value)
    def to_decimal(value) when is_float(value), do: Decimal.from_float(value)

    def to_decimal(value) when is_binary(value) do
      value
      |> String.trim()
      |> Decimal.parse()
      |> case do
        {num, ""} -> num
        _ -> nil
      end
    end

    def to_decimal(_), do: nil

    @doc """
    Parse a string or another numeric type to a float.

    If the input is nil or invalid string, returns nil.
    """
    @spec to_float(parseable()) :: float() | nil
    def to_float(%Decimal{} = value), do: Decimal.to_float(value)
    def to_float(value) when is_integer(value), do: value * 1.0
    def to_float(value) when is_float(value), do: value

    def to_float(value) when is_binary(value) do
      value
      |> String.trim()
      |> Float.parse()
      |> case do
        {num, ""} -> num
        _ -> nil
      end
    end

    def to_float(_), do: nil

    @doc """
    Parse a string or another numeric type to an integer.

    If the input is a decimal or float, it rounds it.
    If the input is nil or invalid string, returns nil.
    """
    @spec to_integer(parseable()) :: integer() | nil
    def to_integer(%Decimal{} = value), do: Decimal.round(value)
    def to_integer(value) when is_integer(value), do: value
    def to_integer(value) when is_float(value), do: Kernel.round(value)

    def to_integer(value) when is_binary(value) do
      value
      |> String.trim()
      |> Integer.parse()
      |> case do
        {num, ""} -> num
        _ -> nil
      end
    end

    def to_integer(_), do: nil
  end
end
