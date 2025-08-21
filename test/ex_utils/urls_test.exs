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

  describe "normalize_encoding/1" do
    test "encodes spaces in paths and query values" do
      assert normalize_encoding("/search results?q=hello world") ==
               "/search%20results?q=hello%20world"
    end

    test "encodes Unicode characters" do
      assert normalize_encoding("/café/menu") == "/caf%C3%A9/menu"
    end

    test "encodes unsafe punctuation" do
      assert normalize_encoding(~s'/files/{draft}|notes"') ==
               "/files/%7Bdraft%7D%7Cnotes%22"
    end

    test "does not double-encode encoded characters" do
      assert normalize_encoding("https://example.com/some%20path") ==
               "https://example.com/some%20path"
    end

    test "turns an encoded slash into a path separator" do
      assert normalize_encoding("/files/folder%2Freport.pdf") == "/files/folder/report.pdf"
    end

    test "turns encoded query delimiters into URL syntax" do
      assert normalize_encoding("/redirect?next=%2Faccount%3Ftab%3Dsettings") ==
               "/redirect?next=/account?tab=settings"
    end

    test "turns an encoded hash into a fragment marker" do
      assert normalize_encoding("/search?q=section%23details") == "/search?q=section#details"
    end
  end
end
