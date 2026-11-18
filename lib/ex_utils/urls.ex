defmodule ExUtils.URLs do
  @moduledoc """
  Elixir utility functions to work with URLs and URI structs.
  """

  @typedoc "A valid URI string"
  @type t :: String.t()

  @percent_escape ~r/%[0-9A-Fa-f]{2}/
  @url_regex ~r/(https?):\/\/(?:www\.)?([a-zA-Z0-9.-]+)(?::(\d+))?(\/[^\s]*)?(?:\?([^#]*))?(?:#(.*))?/

  @doc """
  Checks if a string is a valid HTTP/HTTPS URL or not.

  ## Examples

  ```elixir
  iex> valid?("https://example.com/path?view=details#results")
  true

  iex> valid?("http://localhost:4000")
  true

  iex> valid?("google.com")
  false

  iex> valid?("Visit https://example.com")
  false
  ```
  """
  @spec valid?(t()) :: boolean()
  def valid?(url) when is_binary(url) do
    match?([^url], extract(url))
  end

  @doc """
  Merges given query params to a URL's existing query params.

  ## Examples

  ```elixir
  iex> merge_query("example.com", [])
  "example.com"

  iex> merge_query("/some/path?id=5", id: 10, view: "details")
  "/some/path?id=10&view=details"

  iex> merge_query("https://app.com/path/?a=1", %{"a" => 0, "b" => "hello"})
  "https://app.com/path/?a=0&b=hello"
  ```
  """
  @spec merge_query(t(), Enumerable.t()) :: t()
  def merge_query(url, params) when is_binary(url) do
    %{query: query} = uri = URI.parse(url)
    params = params |> Map.new() |> ExUtils.Maps.stringify_keys(:all)

    new_query =
      (query || "")
      |> URI.decode_query()
      |> Map.merge(params)
      |> URI.encode_query()
      |> case do
        "" -> nil
        query -> query
      end

    URI.to_string(%{uri | query: new_query})
  end

  @doc """
  Normalizes a URL's percent encoding.

  Already encoded characters are not double-encoded. Encoded URL delimiters
  such as `%26` (`&`), `%2F` (`/`), `%23` (`#`), and `%2B` (`+`) are kept
  encoded, since decoding them would change what the URL means.

  ## Examples

  ```elixir
  iex> normalize_encoding("/search results?q=hello world")
  "/search%20results?q=hello%20world"

  iex> normalize_encoding("/café/menu")
  "/caf%C3%A9/menu"

  iex> normalize_encoding(~s'/files/{draft}|notes"')
  "/files/%7Bdraft%7D%7Cnotes%22"

  iex> normalize_encoding("/search?q=a%26b&page=2")
  "/search?q=a%26b&page=2"
  ```
  """
  @spec normalize_encoding(t()) :: t()
  def normalize_encoding(url) when is_binary(url) do
    @percent_escape
    |> Regex.split(url, include_captures: true, trim: true)
    |> Enum.map_join(&normalize_segment/1)
  end

  defp normalize_segment("%" <> hex = segment) when byte_size(hex) == 2 do
    case Base.decode16(hex, case: :mixed) do
      {:ok, <<char>>} -> if URI.char_reserved?(char), do: String.upcase(segment), else: encode_invalid(<<char>>)
      :error -> encode_invalid(segment)
    end
  end

  defp normalize_segment(text), do: encode_invalid(text)

  defp encode_invalid(text), do: URI.encode(text, &URI.char_unescaped?/1)

  @doc """
  Extracts one or more valid HTTP/HTTPS URLs from a string.

  ## Examples

  ```elixir
  iex> extract("something https://google.com other http://example.com/some/path?query=1#fragment test...")
  ["https://google.com", "http://example.com/some/path?query=1#fragment"]

  iex> extract("API: https://api.example.com:4000/v1 and website: https://www.example.com")
  ["https://api.example.com:4000/v1", "https://www.example.com"]

  iex> extract("")
  []

  iex> extract("example.com and ftp://example.com")
  []
  ```
  """
  @spec extract(String.t()) :: [t()]
  def extract(string) when is_binary(string) do
    @url_regex
    |> Regex.scan(string, capture: :first)
    |> List.flatten()
  end
end
