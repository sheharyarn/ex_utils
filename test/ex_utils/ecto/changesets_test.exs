defmodule ExUtils.Tests.Ecto.Changesets do
  use ExUnit.Case
  import ExUtils.Ecto.Changesets

  doctest ExUtils.Ecto.Changesets

  describe "put_new_change/3" do
    test "puts a value when the field is nil" do
      changeset = build(%{name: nil})

      assert changeset = put_new_change(changeset, :name, "Ada")
      assert changeset.changes == %{name: "Ada"}
    end

    test "accepts a function for lazy execution" do
      changeset = build(%{name: nil})

      assert changeset = put_new_change(changeset, :name, fn -> "Ada" end)
      assert changeset.changes == %{name: "Ada"}
    end

    test "preserves an existing field value" do
      changeset = build(%{name: "Ada"})

      assert changeset = put_new_change(changeset, :name, "Grace")
      assert changeset.changes == %{}
    end

    test "preserves an existing change" do
      changeset = build(%{name: nil}, %{name: "Ada"})

      assert changeset = put_new_change(changeset, :name, "Grace")
      assert changeset.changes == %{name: "Ada"}
    end
  end

  defp build(data, changes \\ %{}) do
    types = Map.new(data, fn {field, _value} -> {field, :string} end)

    Ecto.Changeset.change({data, types}, changes)
  end
end
