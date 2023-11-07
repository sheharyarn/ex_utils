defmodule ExUtils.Tests.Modules do
  use ExUnit.Case

  defmodule Animal do
  end

  setup do
    [struct: %Person{name: "Ali", age: 23}]
  end

  test "#methods returns a list of all methods of a module" do
    animal_methods = ExUtils.Modules.methods(Animal)
    person_methods = ExUtils.Modules.methods(Person)

    assert length(animal_methods) == 0
    assert length(person_methods) == 4

    assert Enum.member?(person_methods, {:old?, 1})
    assert Enum.member?(person_methods, {:old?, 2})
  end

  test "#has_method? returns true if method exists for module" do
    assert ExUtils.Modules.has_method?(Person, :old?) == true
    assert ExUtils.Modules.has_method?(Person, {:old?, 1}) == true
    assert ExUtils.Modules.has_method?(Person, {:old?, 2}) == true

    assert ExUtils.Modules.has_method?(Person, :unknown) == false
    assert ExUtils.Modules.has_method?(Person, {:old?, 0}) == false
    assert ExUtils.Modules.has_method?(Person, {:old?, 3}) == false
  end

  test "#name returns Module name without Elixir namespace" do
    assert ExUtils.Modules.name(SomeModule) == "SomeModule"
    assert ExUtils.Modules.name(Another.Module) == "Another.Module"
  end
end
