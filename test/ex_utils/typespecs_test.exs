defmodule ExUtils.Tests.Typespecs do
  use ExUnit.Case, async: true
  import ExUtils.Typespecs

  doctest ExUtils.Typespecs

  {:module, Ticket, ticket_beam, _} =
    defmodule Ticket do
      # Keep debug info so `Code.Typespec` can read the typespecs back
      @compile {:debug_info, true}

      alias ExUtils.Typespecs

      @statuses [:open, :closed]
      @priorities [1, 2, 3]

      @type status :: unquote(Typespecs.from_list(@statuses))
      @type priority :: unquote(Typespecs.from_list(@priorities)) | nil
      @type optional_status :: nil | unquote(Typespecs.from_list(@statuses))

      @spec status(status()) :: unquote(Typespecs.from_list(@statuses))
      def status(status), do: status
    end

  @ticket_beam ticket_beam

  describe "from_list/1" do
    test "returns a union of the given values" do
      assert from_list([:a, :b, :c]) == quote(do: :a | :b | :c)
      assert from_list([1, 2, nil]) == quote(do: 1 | 2 | nil)
    end

    test "returns the value itself for a single-item list" do
      assert from_list([:only]) == :only
      assert from_list([42]) == 42
    end

    test "can be used in @type definitions" do
      {:ok, types} = Code.Typespec.fetch_types(@ticket_beam)

      type_strings =
        Enum.map(types, fn {_kind, type} ->
          type |> Code.Typespec.type_to_quoted() |> Macro.to_string()
        end)

      assert "status() :: :open | :closed" in type_strings
      assert "priority() :: (1 | 2 | 3) | nil" in type_strings
      assert "optional_status() :: nil | :open | :closed" in type_strings
    end

    test "can be used in @spec definitions" do
      {:ok, [{{:status, 1}, [spec]}]} = Code.Typespec.fetch_specs(@ticket_beam)
      spec_string = :status |> Code.Typespec.spec_to_quoted(spec) |> Macro.to_string()

      assert spec_string == "status(status()) :: :open | :closed"
    end

    test "raises for an empty list" do
      assert_raise ArgumentError, ~r/empty list/, fn -> from_list([]) end
    end

    test "raises for values that are not valid typespec literals" do
      assert_raise ArgumentError, ~r/invalid typespec literal: "b"/, fn ->
        from_list([:a, "b"])
      end

      assert_raise ArgumentError, ~r/invalid typespec literal: 1.5/, fn -> from_list([1.5]) end
      assert_raise ArgumentError, ~r/invalid typespec literal: 5..1/, fn -> from_list([5..1]) end
    end
  end
end
