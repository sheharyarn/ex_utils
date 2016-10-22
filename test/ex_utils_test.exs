defmodule ExUtils.Tests.Core do
  use ExUnit.Case

  setup do
    [map: %{a: 1, b: 2, c: 3}, struct: %Person{name: "Ali", age: 23}]
  end

  test "is_struct? returns true only for structs", context do
    assert ExUtils.is_struct?(context[:struct])
    refute ExUtils.is_struct?(context[:map])
  end

  test "is_pure_map? returns true only for maps", context do
    assert ExUtils.is_pure_map?(context[:map])
    refute ExUtils.is_pure_map?(context[:struct])
  end
end
