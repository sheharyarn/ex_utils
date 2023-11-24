defmodule ExUtils.Tests.Modules do
  use ExUnit.Case

  defmodule Animal do
  end

  describe "methods/1" do
    test "returns a list of all functions in a module" do
      animal_methods = ExUtils.Modules.methods(Animal)
      person_methods = ExUtils.Modules.methods(Person)

      assert length(animal_methods) == 0
      assert length(person_methods) == 4

      assert Enum.member?(person_methods, {:old?, 1})
      assert Enum.member?(person_methods, {:old?, 2})
    end
  end

  describe "has_method?/2" do
    test "returns whether the function exists in the module" do
      assert ExUtils.Modules.has_method?(Person, :old?) == true
      assert ExUtils.Modules.has_method?(Person, {:old?, 1}) == true
      assert ExUtils.Modules.has_method?(Person, {:old?, 2}) == true

      assert ExUtils.Modules.has_method?(Person, :unknown) == false
      assert ExUtils.Modules.has_method?(Person, {:old?, 0}) == false
      assert ExUtils.Modules.has_method?(Person, {:old?, 3}) == false
    end
  end

  describe "name/1" do
    test "returns the module name without the Elixir namespace" do
      assert ExUtils.Modules.name(SomeModule) == "SomeModule"
      assert ExUtils.Modules.name(Another.Module) == "Another.Module"
    end
  end
end
