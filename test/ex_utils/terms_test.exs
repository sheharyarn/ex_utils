defmodule ExUtils.Tests.Terms do
  use ExUnit.Case
  import ExUtils.Terms

  doctest ExUtils.Terms

  setup do
    [map: %{a: 1, b: 2, c: 3}, struct: %Person{name: "Ali", age: 23}]
  end

  describe "blank?/1" do
    test "returns true for blank values" do
      Enum.each([0, nil, false, "", " \t\n", [], %{}], fn value ->
        assert blank?(value)
      end)
    end

    test "returns false for present values" do
      Enum.each([1, true, :atom, "Hello", [1], %{a: 1}, {:ok, 1}], fn value ->
        refute blank?(value)
      end)
    end
  end

  describe "present?/1" do
    test "returns true for present values" do
      Enum.each([1, true, :atom, "Hello", [1], %{a: 1}, {:ok, 1}], fn value ->
        assert present?(value)
      end)
    end

    test "returns false for blank values" do
      Enum.each([0, nil, false, "", " \t\n", [], %{}], fn value ->
        refute present?(value)
      end)
    end
  end

  describe "is_struct?/1" do
    test "returns true only for structs", context do
      assert is_struct?(context[:struct])
      refute is_struct?(context[:map])
    end
  end

  describe "is_pure_map?/1" do
    test "returns true only for maps", context do
      assert is_pure_map?(context[:map])
      refute is_pure_map?(context[:struct])
    end
  end
end
