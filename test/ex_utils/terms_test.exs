defmodule ExUtils.Tests.Terms do
  use ExUnit.Case
  import ExUtils.Terms

  setup do
    [map: %{a: 1, b: 2, c: 3}, struct: %Person{name: "Ali", age: 23}]
  end

  test "is_struct? returns true only for structs", context do
    assert is_struct?(context[:struct])
    refute is_struct?(context[:map])
  end

  test "is_pure_map? returns true only for maps", context do
    assert is_pure_map?(context[:map])
    refute is_pure_map?(context[:struct])
  end
end
