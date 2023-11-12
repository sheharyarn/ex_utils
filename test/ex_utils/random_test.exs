defmodule ExUtils.Tests.Random do
  use ExUnit.Case
  import ExUtils.Random

  test "#boolean returns a boolean" do
    assert boolean() in [true, false]
  end

  test "#integer returns a positive integer up to the given maximum" do
    Enum.each(1..100, fn _ ->
      value = integer(10)

      assert is_integer(value)
      assert value in 1..10
    end)
  end

  test "#integer returns an integer within custom bounds" do
    Enum.each(1..100, fn _ ->
      value = integer(-10, 10)

      assert is_integer(value)
      assert value > -10
      assert value <= 10
    end)
  end

  test "#string returns a URL-safe string of the given length" do
    value = string(25)

    assert byte_size(value) == 25
    assert value =~ ~r/\A[A-Za-z0-9_-]+\z/
  end

  test "#string defaults to ten characters" do
    assert byte_size(string()) == 10
  end
end
