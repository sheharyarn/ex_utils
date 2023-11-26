defmodule ExUtils.Tests.Maps do
  use ExUnit.Case
  import ExUtils.Maps

  doctest ExUtils.Maps

  defmodule Profile do
    defstruct [:name]
  end

  defmodule Account do
    defstruct [:profile, :profiles, :joined_on, :association, :__meta__]
  end

  setup do
    [map: %{"a" => 1, "b" => %{"c" => 3, "d" => 4}}]
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

  describe "atomize_keys/1" do
    test "converts keys at the first level", context do
      map = atomize_keys(context[:map])

      assert map[:a] == 1
      assert map["a"] == nil

      assert map[:b][:c] == nil
      assert map[:b][:d] == nil
      assert map[:b]["c"] == 3
      assert map[:b]["d"] == 4
    end

    test "only converts string keys" do
      map = atomize_keys(%{"a" => 0, 3 => 6, :atom => "13", {:a, :b} => 5})

      assert map[:a] == 0
      assert map[3] == 6
      assert map[:atom] == "13"
      assert map[{:a, :b}] == 5
    end
  end

  describe "atomize_keys/2" do
    test "recursively converts keys when deep is true", context do
      map = atomize_keys(context[:map], deep: true)

      assert map[:a] == 1
      assert map["a"] == nil

      assert map[:b][:c] == 3
      assert map[:b][:d] == 4
      assert map[:b]["c"] == nil
      assert map[:b]["d"] == nil
    end
  end
end
