defmodule ExUtils.Tests.Maps do
  use ExUnit.Case, async: true
  import ExUtils.Maps

  doctest ExUtils.Maps

  defmodule Profile do
    defstruct [:name]
  end

  defmodule Account do
    defstruct [:profile, :profiles, :joined_on, :association, :__meta__]
  end

  setup do
    [
      map: %{"a" => 1, "b" => %{"c" => 3, "d" => 4}},
      atom_map: %{a: 1, b: %{c: 3, d: 4}}
    ]
  end

  describe "from_struct/2" do
    test "converts structs to plain maps recursively" do
      account = %Account{
        profile: %Profile{name: "primary"},
        profiles: [%Profile{name: "secondary"}]
      }

      assert from_struct(account) == %{
               profile: %{name: "primary"},
               profiles: [%{name: "secondary"}],
               joined_on: nil,
               association: nil
             }
    end

    test "preserves date and time structs" do
      values = [
        ~D[2026-10-04],
        ~T[12:30:00],
        ~N[2026-10-04 12:30:00],
        ~U[2026-10-04 12:30:00Z]
      ]

      Enum.each(values, fn value ->
        assert from_struct(%Account{joined_on: value}).joined_on == value
      end)
    end

    test "drops metadata and unloaded associations" do
      unloaded = %{__struct__: Ecto.Association.NotLoaded}
      result = from_struct(%Account{association: unloaded, __meta__: %{state: :loaded}})

      refute Map.has_key?(result, :__meta__)
      refute Map.has_key?(result, :association)
    end

    test "returns plain maps unchanged" do
      map = %{profile: %Profile{name: "primary"}}

      assert from_struct(map) == map
    end

    test "keeps nested structs when deep is false" do
      profile = %Profile{name: "primary"}

      assert from_struct(%Account{profile: profile}, deep: false).profile == profile
    end
  end

  describe "flatten/2" do
    test "flattens nested map keys" do
      map = %{user: %{name: "Ada", settings: %{theme: "dark"}}}

      assert flatten(map) == %{
               "user.name" => "Ada",
               "user.settings.theme" => "dark"
             }
    end

    test "flattens nested lists using indexes" do
      map = %{profiles: [%{platform: "github"}, %{platform: "gitlab"}]}

      assert flatten(map) == %{
               "profiles.0.platform" => "github",
               "profiles.1.platform" => "gitlab"
             }
    end

    test "returns lists of path segments when key format is path" do
      map = %{user: %{name: "Ada"}, profiles: [%{platform: "github"}]}

      assert flatten(map, key_format: :path) == %{
               [:user, :name] => "Ada",
               [:profiles, 0, :platform] => "github"
             }
    end

    test "preserves structs and empty collections" do
      profile = %Profile{name: "Ada"}

      assert flatten(%{profile: profile, settings: %{}, tags: []}) == %{
               "profile" => profile,
               "settings" => %{},
               "tags" => []
             }
    end
  end

  describe "atomize_keys/3" do
    test "atomizes selected keys at the first level", context do
      assert atomize_keys(context.map, [:a]) == %{
               "b" => %{"c" => 3, "d" => 4},
               a: 1
             }
    end

    test "preserves atom and non-string keys" do
      map = %{"a" => 0, 3 => 6, {:a, :b} => 5, atom: "13"}

      assert atomize_keys(map, [:a]) == %{3 => 6, {:a, :b} => 5, a: 0, atom: "13"}
    end

    test "atomizes selected keys in nested maps when deep is true", context do
      assert atomize_keys(context.map, [:d], deep: true) == %{
               "a" => 1,
               "b" => %{"c" => 3, d: 4}
             }
    end

    test "atomizes all string keys when passed all", context do
      assert atomize_keys(context.map, :all, deep: true) == %{
               a: 1,
               b: %{c: 3, d: 4}
             }
    end

    test "drops unselected keys when drop is true" do
      map = %{"a" => 1, "b" => 2, 3 => 4, atom: 5}

      assert atomize_keys(map, [:a, :atom], drop: true) == %{a: 1, atom: 5}
    end
  end

  describe "stringify_keys/3" do
    test "stringifies selected keys at the first level", context do
      assert stringify_keys(context.atom_map, [:a]) == %{
               "a" => 1,
               b: %{c: 3, d: 4}
             }
    end

    test "preserves string and non-atom keys" do
      map = %{3 => 6, {:a, :b} => 5, "string" => "13", a: 0}

      assert stringify_keys(map, [:a, :string]) == %{
               "a" => 0,
               "string" => "13",
               3 => 6,
               {:a, :b} => 5
             }
    end

    test "stringifies selected keys in nested maps when deep is true", context do
      assert stringify_keys(context.atom_map, [:d], deep: true) == %{
               a: 1,
               b: %{"d" => 4, c: 3}
             }
    end

    test "stringifies all atom keys when passed all", context do
      assert stringify_keys(context.atom_map, :all, deep: true) == %{
               "a" => 1,
               "b" => %{"c" => 3, "d" => 4}
             }
    end

    test "drops unselected keys when drop is true" do
      map = %{3 => 4, "string" => 5, a: 1, b: 2}

      assert stringify_keys(map, [:a, :string], drop: true) == %{
               "a" => 1,
               "string" => 5
             }
    end
  end

  describe "drop_blank_values/2" do
    test "removes values considered blank by default" do
      map = %{nil: nil, string: "", list: [], false: false, zero: 0, map: %{}}

      assert drop_blank_values(map) == %{false: false, zero: 0, map: %{}}
    end

    test "uses custom blank values" do
      map = %{count: 0, active: false, name: ""}

      assert drop_blank_values(map, blanks: [nil, 0, ""]) == %{active: false}
    end
  end

  describe "maybe_put/4" do
    test "puts non-blank values" do
      assert maybe_put(%{}, :name, "John") == %{name: "John"}
      assert maybe_put(%{name: "Mary"}, :name, "John") == %{name: "John"}
      assert maybe_put(%{}, :active, false) == %{active: false}
      assert maybe_put(%{}, :count, 0) == %{count: 0}
    end

    test "ignores values considered blank by default" do
      map = %{name: "John"}

      assert maybe_put(map, :name, nil) == map
      assert maybe_put(map, :name, "") == map
      assert maybe_put(map, :name, []) == map
    end

    test "uses custom blank values" do
      assert maybe_put(%{}, :count, 0, blanks: [nil, 0]) == %{}
      assert maybe_put(%{}, :active, false, blanks: [nil, 0]) == %{active: false}
    end
  end
end
