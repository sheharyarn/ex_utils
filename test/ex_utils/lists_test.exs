defmodule ExUtils.Tests.Lists do
  use ExUnit.Case
  import ExUtils.Lists

  doctest ExUtils.Lists

  describe "compact/1" do
    test "removes nil values" do
      assert compact([1, nil, nil, 2, nil, 3, 4]) == [1, 2, 3, 4]
      assert compact([]) == []
    end

    test "preserves non-nil values and their order" do
      assert compact([false, 0, "", [], %{}, nil, :value]) == [false, 0, "", [], %{}, :value]
    end
  end
end
