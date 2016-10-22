defmodule ExUtils.Tests.Module do
  use ExUnit.Case

  setup do
    [struct: %Person{name: "Ali", age: 23}]
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
