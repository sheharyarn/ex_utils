defmodule ExUtils.Tests.Numbers do
  use ExUnit.Case, async: true

  import Kernel, except: [trunc: 1]
  import ExUtils.Numbers

  doctest ExUtils.Numbers

  describe "is_numeric/1" do
    test "returns true for numeric values" do
      assert is_numeric(12)
      assert is_numeric(12.5)
      assert is_numeric(Decimal.new("12.5"))
    end

    test "returns false for non-numeric values" do
      refute is_numeric("12.5")
      refute is_numeric(nil)
    end
  end

  describe "is_positive/1" do
    test "returns true for positive integers" do
      assert is_positive(1)
      assert is_positive(12)
    end

    test "returns false for other values" do
      refute is_positive(0)
      refute is_positive(-1)
      refute is_positive(1.5)
      refute is_positive(Decimal.new("1"))
    end
  end

  describe "to_decimal/1" do
    test "converts numeric values" do
      decimal = Decimal.new("12.5")

      assert to_decimal(decimal) == decimal
      assert to_decimal(12) == Decimal.new("12")
      assert to_decimal(12.5) == Decimal.new("12.5")
    end

    test "parses strings containing a number" do
      assert to_decimal(" 12.5 ") == Decimal.new("12.5")
      assert to_decimal("-12") == Decimal.new("-12")
    end

    test "returns nil for invalid values" do
      assert to_decimal(nil) == nil
      assert to_decimal(:invalid) == nil
      assert to_decimal("") == nil
      assert to_decimal("12.5px") == nil
    end
  end

  describe "to_float/1" do
    test "converts numeric values" do
      assert to_float(Decimal.new("12.5")) == 12.5
      assert to_float(12) == 12.0
      assert to_float(12.5) == 12.5
    end

    test "parses strings containing a number" do
      assert to_float(" 12.5 ") == 12.5
      assert to_float("-12") == -12.0
    end

    test "returns nil for invalid values" do
      assert to_float(nil) == nil
      assert to_float(:invalid) == nil
      assert to_float("") == nil
      assert to_float("12.5px") == nil
    end
  end

  describe "to_integer/1" do
    test "converts and rounds numeric values" do
      assert to_integer(Decimal.new("12.5")) == 13
      assert to_integer(12) == 12
      assert to_integer(12.4) == 12
      assert to_integer(12.5) == 13
    end

    test "parses strings containing an integer" do
      assert to_integer(" 12 ") == 12
      assert to_integer("-12") == -12
    end

    test "returns nil for invalid values" do
      assert to_integer(nil) == nil
      assert to_integer(:invalid) == nil
      assert to_integer("") == nil
      assert to_integer("12.5") == nil
      assert to_integer("12px") == nil
    end
  end

  describe "trunc/1" do
    test "truncates numeric values toward zero" do
      assert trunc(Decimal.new("5.7")) == 5
      assert trunc(Decimal.new("-5.7")) == -5
      assert trunc(5.7) == 5
      assert trunc(-5.7) == -5
      assert trunc(5) == 5
    end
  end
end
