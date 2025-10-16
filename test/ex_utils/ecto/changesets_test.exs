defmodule ExUtils.Tests.Ecto.Changesets do
  use ExUnit.Case, async: true
  import ExUtils.Ecto.Changesets

  doctest ExUtils.Ecto.Changesets

  defmodule EmbeddedProfile do
    use Ecto.Schema

    embedded_schema do
      field :name, :string
    end
  end

  defmodule SourceProfile do
    use Ecto.Schema

    schema "profiles" do
      field :name, :string
    end
  end

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

  describe "has_source?/1" do
    test "returns true for a source-backed schema" do
      changeset = Ecto.Changeset.change(%SourceProfile{name: "Ada"})

      assert has_source?(changeset)
    end

    test "returns false for an embedded schema" do
      changeset = Ecto.Changeset.change(%EmbeddedProfile{name: "Ada"})

      refute has_source?(changeset)
    end

    test "returns false for a schemaless changeset" do
      refute has_source?(build(%{name: "Ada"}))
    end
  end

  describe "embedded_schema?/1" do
    test "returns false for a source-backed schema" do
      changeset = Ecto.Changeset.change(%SourceProfile{name: "Ada"})

      refute embedded_schema?(changeset)
    end

    test "returns true for an embedded schema" do
      changeset = Ecto.Changeset.change(%EmbeddedProfile{name: "Ada"})

      assert embedded_schema?(changeset)
    end

    test "returns false for a schemaless changeset" do
      refute embedded_schema?(build(%{name: "Ada"}))
    end
  end

  defp build(data, changes \\ %{}) do
    types = Map.new(data, fn {field, _value} -> {field, :string} end)

    Ecto.Changeset.change({data, types}, changes)
  end
end
