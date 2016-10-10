defmodule ExUtils.Tests.Map do
  use ExUnit.Case

  setup do
    [map: %{"a" => 1, "b" => %{ "c" => 3, "d" => 4 } }]
  end

  test "atomize_keys works with recursive option", context do
    map = ExUtils.Map.atomize_keys(context[:map])

    assert map[:a]      == 1
    assert map["a"]     == nil

    assert map[:b][:c]  == 3
    assert map[:b][:d]  == 4
    assert map[:b]["c"] == nil
    assert map[:b]["d"] == nil
  end

  test "atomize_keys works without recursive option", context do
    map = ExUtils.Map.atomize_keys(context[:map], recursive: false)

    assert map[:a]      == 1
    assert map["a"]     == nil

    assert map[:b][:c]  == nil
    assert map[:b][:d]  == nil
    assert map[:b]["c"] == 3
    assert map[:b]["d"] == 4
  end

  test "atomize_keys only symbolizes strings" do
    map = ExUtils.Map.atomize_keys(%{"a" => 0, 3 => 6, :atom => "13", {:a, :b} => 5})

    assert map[:a]       == 0
    assert map[3]        == 6
    assert map[:atom]    == "13"
    assert map[{:a, :b}] == 5
  end
end
