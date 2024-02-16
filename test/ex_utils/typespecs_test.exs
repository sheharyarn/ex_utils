defmodule ExUtils.Tests.Typespecs do
  use ExUnit.Case, async: true
  import ExUtils.Typespecs

  describe "from_list/1" do
    test "returns a union of the given values" do
      assert from_list([:a, :b, :c]) == quote(do: :a | :b | :c)
      assert from_list([1, 2, nil]) == quote(do: 1 | 2 | nil)
    end

    test "returns the value itself for a single-item list" do
      assert from_list([:only]) == :only
      assert from_list([42]) == 42
    end
  end
end
