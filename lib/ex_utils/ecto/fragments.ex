if ExUtils.Modules.exists?(Ecto) do
  defmodule ExUtils.Ecto.Fragments do
    @moduledoc """
    Utility macros for Ecto queries as fragments and Ecto.Query.API extensions.

    To use these, you need to import both `Ecto.Query` and this module:

    ```elixir
    import Ecto.Query
    import ExUtils.Ecto.Fragments
    ```
    """

    import Ecto.Query.API, only: [fragment: 1]

    @doc """
    Fragment helper for PG's `GREATEST()`.

    Returns the max of 2 values in an Ecto query. This is
    especially useful in aggregates (e.g. `count/1`) where
    `coalesce/2` cannot work since both values are non-nil.

    ## Example

    ```elixir
    # Get the bigger of two numbers
    from user in User,
      select: greatest(user.current_score, user.previous_score)

    # Get the bigger of two datetimes
    from file in File,
      select: greatest(file.last_synced_at, file.last_downloaded_at)

    # Compare with literals (e.g. to avoid divide-by-zero errors)
    from c in Campaign,
      join: m in assoc(c, :messages)
      group_by: c.id,
      select: %{
        open_percent: (
          (count(m.id) |> filter(m.status == :opened)) /
          (count(m.id) |> greatest(1))
        )
      }
    ```
    """
    defmacro greatest(left, right) do
      quote do: fragment("GREATEST(?, ?)", unquote(left), unquote(right))
    end
  end
end
