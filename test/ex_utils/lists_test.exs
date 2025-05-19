defmodule ExUtils.Tests.Lists do
  use ExUnit.Case, async: true
  import ExUtils.Lists

  doctest ExUtils.Lists

  defmodule Item do
    defstruct [:id, :name]
  end

  describe "compact/1" do
    test "removes nil values" do
      assert compact([1, nil, nil, 2, nil, 3, 4]) == [1, 2, 3, 4]
      assert compact([]) == []
    end

    test "preserves non-nil values and their order" do
      assert compact([false, 0, "", [], %{}, nil, :value]) == [false, 0, "", [], %{}, :value]
    end
  end

  describe "replace/3" do
    test "replaces matching items using the id key by default" do
      list = [%{id: 1, name: "Ada"}, %{id: 2, name: "Grace"}]

      assert replace(list, %{id: 1, name: "Ada Lovelace"}) == [
               %{id: 1, name: "Ada Lovelace"},
               %{id: 2, name: "Grace"}
             ]
    end

    test "replaces every matching item" do
      list = [%{id: 1, name: "first"}, %{id: 1, name: "second"}, %{id: 2, name: "other"}]
      replacement = %{id: 1, name: "replacement"}

      assert replace(list, replacement) == [replacement, replacement, %{id: 2, name: "other"}]
    end

    test "matches using a custom key" do
      list = [%{email: "ada@example.com", active: false}]
      replacement = %{email: "ada@example.com", active: true}

      assert replace(list, replacement, key: :email) == [replacement]
    end

    test "supports structs" do
      first = %Item{id: 1, name: "Ada"}
      second = %Item{id: 2, name: "Grace"}
      replacement = %Item{id: 1, name: "Ada Lovelace"}

      assert replace([first, second], replacement) == [replacement, second]
    end

    test "leaves the list unchanged when no item matches" do
      list = [%{id: 1, name: "Ada"}]

      assert replace(list, %{id: 2, name: "Grace"}) == list
    end

    test "raises when the replacement does not contain the matching key" do
      assert_raise KeyError, fn ->
        replace([%{id: 1}], %{name: "Ada"})
      end
    end
  end
end
