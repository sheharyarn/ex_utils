defmodule ExUtils.Tests.Modules do
  use ExUnit.Case, async: true
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

  describe "functions/1" do
    test "returns a list of all functions in a module" do
      animal_functions = functions(Animal)
      person_functions = functions(Person)

      assert length(animal_functions) == 0
      assert length(person_functions) == 4

      assert Enum.member?(person_functions, {:old?, 1})
      assert Enum.member?(person_functions, {:old?, 2})
    end
  end

  describe "has_function?/2" do
    test "returns whether the function exists in the module" do
      assert has_function?(Person, :old?) == true
      assert has_function?(Person, {:old?, 1}) == true
      assert has_function?(Person, {:old?, 2}) == true

      assert has_function?(Person, :unknown) == false
      assert has_function?(Person, {:old?, 0}) == false
      assert has_function?(Person, {:old?, 3}) == false
    end
  end

  describe "name/1" do
    test "returns the module name without the Elixir namespace" do
      assert name(SomeModule) == "SomeModule"
      assert name(Another.Module) == "Another.Module"
    end
  end
end
