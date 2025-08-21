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
  def merge_query(url, params) do
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
end
