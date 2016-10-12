defmodule ExUtils.Tests.Core do
  use ExUnit.Case

  defmodule Person do
    defstruct [:name, :age]

    def old?(person), do: person.age > 60
  end

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

  test "has_method? returns true if method exists for module" do
    assert ExUtils.has_method?(Person, :old?)      == true
    assert ExUtils.has_method?(Person, {:old?, 1}) == true

    assert ExUtils.has_method?(Person, :unknown)   == false
    assert ExUtils.has_method?(Person, {:old?, 2}) == false
  end
end
