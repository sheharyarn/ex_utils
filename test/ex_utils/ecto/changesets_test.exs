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
