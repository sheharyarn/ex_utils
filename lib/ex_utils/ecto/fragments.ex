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

    @doc """
    Use conditionals in Ecto queries with PG's `CASE(...)` statement.

    ## Example

    ```elixir
    # Use `pg_case` to represent Postgres' `CASE` statement
    from user in User,
      select: %{
        name: user.name,
        group:
          pg_case do
            user.age < 1 -> :infant
            user.age < 3 -> :toddler
            user.age < 13 -> :child
            user.age < 18 -> :teenager
            true -> :adult
          end
      }
    ```
    """
    defmacro pg_case(do: block) do
      bindings =
        block
        |> Enum.reduce([], fn {:->, _, [[clause], branch]}, acc -> [branch, clause | acc] end)
        |> Enum.reverse()

      sql =
        IO.iodata_to_binary([
          "CASE",
          List.duplicate(" WHEN ? THEN ?", div(length(bindings), 2)),
          " ",
          "END"
        ])

      quote do
        fragment(unquote(sql), unquote_splicing(bindings))
      end
    end

    @doc """
    Round a numeric value to the given precision.

    The `precision` must be an integer. When positive, it rounds to the given
    decimal places and when negative, it rounds to the left of the decimal (in
    the tens, hundreds, etc. places). It defaults to `0`.

    Using this may conflict with the Kernel's default imports, so you may have
    to exclude it with `import Kernel, except: [round: 1]`.

    Also see `ceil/2` and `floor/2`.

    ## Examples

    ```elixir
    # Round to a whole number
    from measurement in "measurements",
      select: round(measurement.value)

    # Round to 3 decimal places
    from measurement in "measurements",
      select: round(measurement.value, 3)

    # Round to the hundreds
    from invoice in Invoice,
      select: round(invoice.total, -2)
    ```
    """
    defmacro round(value, precision \\ 0) do
      precision = expand_precision!(precision, __CALLER__)

      quote do: fragment("ROUND(?, ?)", unquote(value), unquote(precision))
    end

    @doc """
    Round a numeric value down to the given precision.

    The `precision` must be an integer. When positive, it rounds down to the
    given decimal places and when negative, it rounds down to the left of the
    decimal (in the tens, hundreds, etc. places). It defaults to `0`.

    Using this may conflict with the Kernel's default imports, so you may have
    to exclude it with `import Kernel, except: [floor: 1]`.

    Also see `round/2` and `ceil/2`.

    ## Examples

    ```elixir
    # Round down to a whole number
    from measurement in "measurements",
      select: floor(measurement.value)

    # Round down to 3 decimal places
    from measurement in "measurements",
      select: floor(measurement.value, 3)

    # Round down to the hundreds
    from invoice in Invoice,
      select: floor(invoice.total, -2)
    ```
    """
    defmacro floor(value, precision \\ 0) do
      precision = expand_precision!(precision, __CALLER__)

      quote do
        fragment(
          "FLOOR(? * POWER(10, ?)) / POWER(10, ?)",
          unquote(value),
          unquote(precision),
          unquote(precision)
        )
      end
    end

    @doc """
    Round a numeric value up to the given precision.

    The `precision` must be an integer. When positive, it rounds up to the
    given decimal places and when negative, it rounds up to the left of the
    decimal (in the tens, hundreds, etc. places). It defaults to `0`.

    Using this may conflict with the Kernel's default imports, so you may have
    to exclude it with `import Kernel, except: [ceil: 1]`.

    Also see `round/2` and `floor/2`.

    ## Examples

    ```elixir
    # Round up to a whole number
    from measurement in "measurements",
      select: ceil(measurement.value)

    # Round up to 3 decimal places
    from measurement in "measurements",
      select: ceil(measurement.value, 3)

    # Round up to the hundreds
    from invoice in Invoice,
      select: ceil(invoice.total, -2)
    ```
    """
    defmacro ceil(value, precision \\ 0) do
      precision = expand_precision!(precision, __CALLER__)

      quote do
        fragment(
          "CEIL(? * POWER(10, ?)) / POWER(10, ?)",
          unquote(value),
          unquote(precision),
          unquote(precision)
        )
      end
    end

    defp expand_precision!(precision, caller) do
      case Macro.expand(precision, caller) do
        precision when is_integer(precision) -> precision
        _other -> raise ArgumentError, "precision must be an integer"
      end
    end
  end
end
