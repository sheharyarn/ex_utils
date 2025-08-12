defmodule ExUtils.Tests.Ecto.Fragments do
  use ExUnit.Case, async: true

  import Kernel, except: [ceil: 1, floor: 1, round: 1]
  import Ecto.Query
  import ExUtils.Ecto.Fragments

  describe "greatest/2" do
    test "builds a greatest fragment" do
      query = from score in "scores", select: greatest(score.current, score.previous)
      expected_query = from score in "scores", select: fragment("GREATEST(?, ?)", score.current, score.previous)

      assert_query(query, expected_query)
    end
  end

  defp assert_query(query, expected_query) do
    assert normalize_query(query) == normalize_query(expected_query)
  end

  defp normalize_query(query) do
    %{
      query
      | from: %{query.from | file: nil, line: nil},
        select: %{query.select | file: nil, line: nil}
    }
  end
end
