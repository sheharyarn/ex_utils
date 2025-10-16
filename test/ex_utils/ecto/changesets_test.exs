defmodule ExUtils.Tests.Ecto.Changesets do
  use ExUnit.Case, async: true
  import ExUtils.Ecto.Changesets

  defmodule Profile do
    use Ecto.Schema

    embedded_schema do
      field :platform, :string
      field :username, :string
    end
  end

  defmodule User do
    use Ecto.Schema

    schema "users" do
      field :name, :string
      field :email, :string
      embeds_many :profiles, Profile
    end
  end

  describe "put_new_change/3" do
    test "puts a value when the field is nil" do
      changeset = Ecto.Changeset.change(%User{name: nil})

      assert changeset = put_new_change(changeset, :name, "Ada")
      assert changeset.changes == %{name: "Ada"}
    end

    test "accepts a function for lazy execution" do
      changeset = Ecto.Changeset.change(%User{name: nil})

      assert changeset = put_new_change(changeset, :name, fn -> "Ada" end)
      assert changeset.changes == %{name: "Ada"}
    end

    test "preserves an existing field value" do
      changeset = Ecto.Changeset.change(%User{name: "Ada"})

      assert changeset = put_new_change(changeset, :name, "Grace")
      assert changeset.changes == %{}
    end

    test "preserves an existing change" do
      changeset = Ecto.Changeset.change(%User{name: nil}, %{name: "Ada"})

      assert changeset = put_new_change(changeset, :name, "Grace")
      assert changeset.changes == %{name: "Ada"}
    end
  end

  describe "prevent_change/3" do
    test "adds an error when changing an existing value" do
      changeset = Ecto.Changeset.change(%User{name: "Ada"}, %{name: "Grace"})
      changeset = prevent_change(changeset, :name)

      refute changeset.valid?
      assert changeset.errors == [name: {"cannot modify", []}]
    end

    test "allows changing an ignored initial value" do
      changeset = Ecto.Changeset.change(%User{name: nil}, %{name: "Ada"})
      changeset = prevent_change(changeset, :name)

      assert changeset.valid?
      assert changeset.errors == []
    end

    test "accepts custom ignored initial values" do
      changeset = Ecto.Changeset.change(%User{name: ""}, %{name: "Ada"})
      changeset = prevent_change(changeset, :name, ignore: [nil, ""])

      assert changeset.valid?
      assert changeset.errors == []
    end

    test "uses a custom error message" do
      changeset = Ecto.Changeset.change(%User{name: "Ada"}, %{name: "Grace"})
      changeset = prevent_change(changeset, :name, message: "is permanent")

      assert changeset.errors == [name: {"is permanent", []}]
    end

    test "allows an unchanged value" do
      changeset = Ecto.Changeset.change(%User{name: "Ada"})
      changeset = Ecto.Changeset.force_change(changeset, :name, "Ada")
      changeset = prevent_change(changeset, :name)

      assert changeset.valid?
      assert changeset.errors == []
    end
  end

  describe "has_source?/1" do
    test "returns true for a source-backed schema" do
      changeset = Ecto.Changeset.change(%User{name: "Ada"})

      assert has_source?(changeset)
    end

    test "returns false for an embedded schema" do
      changeset = Ecto.Changeset.change(%Profile{platform: "github"})

      refute has_source?(changeset)
    end

    test "returns false for a schemaless changeset" do
      changeset = Ecto.Changeset.change({%{name: "Ada"}, %{name: :string}})

      refute has_source?(changeset)
    end
  end

  describe "embedded_schema?/1" do
    test "returns false for a source-backed schema" do
      changeset = Ecto.Changeset.change(%User{name: "Ada"})

      refute embedded_schema?(changeset)
    end

    test "returns true for an embedded schema" do
      changeset = Ecto.Changeset.change(%Profile{platform: "github"})

      assert embedded_schema?(changeset)
    end

    test "returns false for a schemaless changeset" do
      changeset = Ecto.Changeset.change({%{name: "Ada"}, %{name: :string}})

      refute embedded_schema?(changeset)
    end
  end
end
