defmodule ExUtils.Tests.Modules.Extend do
  use ExUnit.Case

  defmodule Original do
    def a, do: :a
    def b(value), do: {:b, value}
    def c(left, right), do: {:c, left, right}
  end

  defmodule Extended do
    use ExUtils.Modules.Extend, from: Original

    def d, do: :d

    defoverridable b: 1
    def b(value) do
      {:overridden, value}
    end
  end

  describe "__using__/1" do
    test "delegates the extended module's public functions" do
      assert Extended.a() == :a
      assert Extended.c(:left, :right) == {:c, :left, :right}
    end

    test "allows defining additional functions" do
      assert Extended.d() == :d
    end

    test "allows overriding delegated functions" do
      assert Original.b(:value) == {:b, :value}
      assert Extended.b(:value) == {:overridden, :value}
    end

    test "raises when the extended module does not exist" do
      extend_code =
        quote do
          use ExUtils.Modules.Extend, from: NonExistentModule
        end

      assert_raise ArgumentError, ~r/cannot extend unknown module/, fn ->
        Module.create(__MODULE__.FailingExtended, extend_code, __ENV__)
      end
    end
  end
end
