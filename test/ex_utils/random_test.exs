defmodule ExUtils.Tests.Random do
  use ExUnit.Case, async: true
  import ExUtils.Random

  describe "boolean/0" do
    test "returns a boolean" do
      assert boolean() in [true, false]
    end
  end

  describe "integer/2" do
    test "returns a positive integer up to the given maximum" do
      Enum.each(1..100, fn _ ->
        value = integer(10)

        assert is_integer(value)
        assert value in 1..10
      end)
    end

    test "returns an integer within custom bounds" do
      Enum.each(1..100, fn _ ->
        value = integer(-10, 10)

        assert is_integer(value)
        assert value > -10
        assert value <= 10
      end)
    end
  end

  describe "string/1" do
    test "returns ten characters by default" do
      assert byte_size(string()) == 10
    end

    test "returns a URL-safe string of the given length" do
      value = string(25)

      assert byte_size(value) == 25
      assert value =~ ~r/\A[A-Za-z0-9_-]+\z/
    end
  end
end
