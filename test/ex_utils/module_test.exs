defmodule ExUtils.Tests.Module do
  use ExUnit.Case

  defmodule Animal do; end

  setup do
    [struct: %Person{name: "Ali", age: 23}]
  end

  test "methods returns a list of all methods of a module" do
    animal_methods = ExUtils.Module.methods(Animal)
    person_methods = ExUtils.Module.methods(Person)

    assert length(animal_methods) == 0
    assert length(person_methods) == 4

    assert Enum.member?(person_methods, {:old?, 1})
    assert Enum.member?(person_methods, {:old?, 2})
  end

  test "has_method? returns true if method exists for module" do
    assert ExUtils.Module.has_method?(Person, :old?)      == true
    assert ExUtils.Module.has_method?(Person, {:old?, 1}) == true
    assert ExUtils.Module.has_method?(Person, {:old?, 2}) == true

    assert ExUtils.Module.has_method?(Person, :unknown)   == false
    assert ExUtils.Module.has_method?(Person, {:old?, 0}) == false
    assert ExUtils.Module.has_method?(Person, {:old?, 3}) == false
  end
end
