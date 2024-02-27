defmodule ExUtils.Tests.Modules do
  use ExUnit.Case
  import ExUtils.Modules

  doctest ExUtils.Modules

  defmodule Animal do
  end

  describe "exists?/1" do
    test "returns true for loaded modules" do
      assert exists?(Map)
      assert exists?(Animal)
    end

    test "returns false for modules that do not exist" do
      refute exists?(ExUtils.Tests.Modules.NonExistent)
    end
  end

  describe "methods/1" do
    test "returns a list of all functions in a module" do
      animal_methods = methods(Animal)
      person_methods = methods(Person)

      assert length(animal_methods) == 0
      assert length(person_methods) == 4

      assert Enum.member?(person_methods, {:old?, 1})
      assert Enum.member?(person_methods, {:old?, 2})
    end
  end

  describe "has_method?/2" do
    test "returns whether the function exists in the module" do
      assert has_method?(Person, :old?) == true
      assert has_method?(Person, {:old?, 1}) == true
      assert has_method?(Person, {:old?, 2}) == true

      assert has_method?(Person, :unknown) == false
      assert has_method?(Person, {:old?, 0}) == false
      assert has_method?(Person, {:old?, 3}) == false
    end
  end

  describe "name/1" do
    test "returns the module name without the Elixir namespace" do
      assert name(SomeModule) == "SomeModule"
      assert name(Another.Module) == "Another.Module"
    end
  end
end
