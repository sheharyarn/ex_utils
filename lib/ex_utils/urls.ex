defmodule ExUtils.URLs do
  @moduledoc """
  Elixir utility functions to work with URLs and URI structs.
  """

  @type t :: String.t()

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

  Already encoded characters are not double-encoded.

  ## Examples

  ```elixir
  iex> normalize_encoding("/search results?q=hello world")
  "/search%20results?q=hello%20world"

  iex> normalize_encoding("/café/menu")
  "/caf%C3%A9/menu"

  iex> normalize_encoding(~s'/files/{draft}|notes"')
  "/files/%7Bdraft%7D%7Cnotes%22"

  iex> normalize_encoding("https://example.com/some%2Fpath")
  "https://example.com/some/path"
  ```
  """
  @spec normalize_encoding(t()) :: t()
  def normalize_encoding(url) when is_binary(url) do
    url
    |> URI.decode()
    |> URI.encode()
  end
end
