defmodule ExUtils.Tests.Maps do
  use ExUnit.Case

  setup do
    [map: %{"a" => 1, "b" => %{"c" => 3, "d" => 4}}]
  end

  describe "atomize_keys/1" do
    test "converts keys at the first level", context do
      map = ExUtils.Maps.atomize_keys(context[:map])

      assert map[:a] == 1
      assert map["a"] == nil

      assert map[:b][:c] == nil
      assert map[:b][:d] == nil
      assert map[:b]["c"] == 3
      assert map[:b]["d"] == 4
    end

    test "only converts string keys" do
      map = ExUtils.Maps.atomize_keys(%{"a" => 0, 3 => 6, :atom => "13", {:a, :b} => 5})

      assert map[:a] == 0
      assert map[3] == 6
      assert map[:atom] == "13"
      assert map[{:a, :b}] == 5
    end
  end

  describe "atomize_keys/2" do
    test "recursively converts keys when deep is true", context do
      map = ExUtils.Maps.atomize_keys(context[:map], deep: true)

      assert map[:a] == 1
      assert map["a"] == nil

      assert map[:b][:c] == 3
      assert map[:b][:d] == 4
      assert map[:b]["c"] == nil
      assert map[:b]["d"] == nil
    end
  end
end
