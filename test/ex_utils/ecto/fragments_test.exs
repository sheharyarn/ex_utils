defmodule ExUtils.Tests.Ecto.Fragments do
  use ExUnit.Case, async: true

  import Kernel, except: [ceil: 1, floor: 1, round: 1]
  import Ecto.Query
  import ExUtils.Ecto.Fragments

  describe "greatest/2" do
    test "builds a greatest fragment" do
      query = from score in "scores", select: greatest(score.current, score.previous)
      expected = from score in "scores", select: fragment("GREATEST(?, ?)", score.current, score.previous)

      assert_query(query, expected)
    end
  end

  describe "pg_case/1" do
    test "builds a case fragment from each condition and result" do
      query =
        from user in "users",
          select: %{
            group:
              pg_case do
                user.age < 1 -> :infant
                user.age < 3 -> :toddler
                user.age < 13 -> :child
                user.age < 18 -> :teenager
                true -> :adult
              end
          }

      expected =
        from user in "users",
          select: %{
            group:
              fragment(
                "CASE WHEN ? THEN ? WHEN ? THEN ? WHEN ? THEN ? WHEN ? THEN ? WHEN ? THEN ? END",
                user.age < 1,
                :infant,
                user.age < 3,
                :toddler,
                user.age < 13,
                :child,
                user.age < 18,
                :teenager,
                true,
                :adult
              )
          }

      assert_query(query, expected)
    end
  end

  describe "round/2" do
    test "rounds to zero precision by default" do
      query = from measurement in "measurements", select: round(measurement.value)
      expected = from measurement in "measurements", select: fragment("ROUND(?, ?)", measurement.value, 0)

      assert_query(query, expected)
    end

    test "rounds to a positive precision" do
      query = from measurement in "measurements", select: round(measurement.value, 3)
      expected = from measurement in "measurements", select: fragment("ROUND(?, ?)", measurement.value, 3)

      assert_query(query, expected)
    end

    test "rounds to a negative precision" do
      query = from invoice in "invoices", select: round(invoice.total, -2)
      expected = from invoice in "invoices", select: fragment("ROUND(?, ?)", invoice.total, -2)

      assert_query(query, expected)
    end
  end

  describe "floor/2" do
    test "rounds down to zero precision by default" do
      query = from measurement in "measurements", select: floor(measurement.value)

      expected =
        from measurement in "measurements",
          select: fragment("FLOOR(? * POWER(10, ?)) / POWER(10, ?)", measurement.value, 0, 0)

      assert_query(query, expected)
    end

    test "rounds down to a positive precision" do
      query = from measurement in "measurements", select: floor(measurement.value, 3)

      expected =
        from measurement in "measurements",
          select: fragment("FLOOR(? * POWER(10, ?)) / POWER(10, ?)", measurement.value, 3, 3)

      assert_query(query, expected)
    end

    test "rounds down to a negative precision" do
      query = from invoice in "invoices", select: floor(invoice.total, -2)

      expected =
        from invoice in "invoices",
          select: fragment("FLOOR(? * POWER(10, ?)) / POWER(10, ?)", invoice.total, -2, -2)

      assert_query(query, expected)
    end
  end

  describe "ceil/2" do
    test "rounds up to zero precision by default" do
      query = from measurement in "measurements", select: ceil(measurement.value)

      expected =
        from measurement in "measurements",
          select: fragment("CEIL(? * POWER(10, ?)) / POWER(10, ?)", measurement.value, 0, 0)

      assert_query(query, expected)
    end

    test "rounds up to a positive precision" do
      query = from measurement in "measurements", select: ceil(measurement.value, 3)

      expected =
        from measurement in "measurements",
          select: fragment("CEIL(? * POWER(10, ?)) / POWER(10, ?)", measurement.value, 3, 3)

      assert_query(query, expected)
    end

    test "rounds up to a negative precision" do
      query = from invoice in "invoices", select: ceil(invoice.total, -2)

      expected =
        from invoice in "invoices",
          select: fragment("CEIL(? * POWER(10, ?)) / POWER(10, ?)", invoice.total, -2, -2)

      assert_query(query, expected)
    end
  end

  defp assert_query(query, expected) do
    [query, expected] =
      for q <- [query, expected] do
        %{q | from: %{q.from | file: nil, line: nil}, select: %{q.select | file: nil, line: nil}}
      end

    assert query == expected
  end
end
