defmodule ExUtils.Tests.URLs do
  use ExUnit.Case, async: true
  import ExUtils.URLs

  doctest ExUtils.URLs

  describe "merge_query/2" do
    test "returns the URL unchanged when both queries are empty" do
      assert merge_query("example.com", []) == "example.com"
    end

    test "adds parameters to a URL without a query" do
      assert merge_query("/path", page: 2) == "/path?page=2"
    end

    test "overwrites matching parameters and preserves unmatched parameters" do
      url = "https://app.com/path?a=1&unchanged=yes"

      assert merge_query(url, %{a: 0, b: "hello"}) ==
               "https://app.com/path?a=0&b=hello&unchanged=yes"
    end

    test "accepts string parameter keys" do
      assert merge_query("http://app.com?a=1", %{"a" => 2}) == "http://app.com?a=2"
    end

    test "encodes parameter values" do
      assert merge_query("https://app.com", q: "hello world", next: "/account?a=1") ==
               "https://app.com?next=%2Faccount%3Fa%3D1&q=hello+world"
    end

    test "preserves URL fragments" do
      assert merge_query("https://app.com/path?a=1#details", b: 2) ==
               "https://app.com/path?a=1&b=2#details"
    end
  end
end
