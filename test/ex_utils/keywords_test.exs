defmodule ExUtils.Tests.Keywords do
  use ExUnit.Case
  import ExUtils.Keywords

  doctest ExUtils.Keywords

  setup do
    [kw: [a: 1, b: "abc", c: false, d: [1, 2, 3], e: %{f: 5, g: 7}]]
  end

  describe "to_map/1" do
    test "converts a keyword list into a map", context do
      map = to_map(context.kw)

      assert map |> Map.keys() |> Enum.sort() == [:a, :b, :c, :d, :e]

      assert map[:a] == 1
      assert map[:b] == "abc"
      assert map[:c] == false
      assert map[:d] == [1, 2, 3]
      assert map[:e] == %{f: 5, g: 7}
    end
  end
end
