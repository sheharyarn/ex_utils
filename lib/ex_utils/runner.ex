defmodule ExUtils.Runner do
  @moduledoc """
  Utilities for running isolated tasks with various approaches.

  You can run tasks in the background, add delays, or run many in parallel.

  For these to work, it requires you to include `ExUtils.Runner` in
  your application supervision tree:

  ```elixir
  # in application.ex, add `ExUtils.Runner` under children
  children = [
    ExUtils.Runner,
    YourApp.Repo,
    # ...
  ]
  ```
  """

  @type background_opt :: {:delay, non_neg_integer()}
  @type parallel_opt ::
          {:concurrency, pos_integer()}
          | {:timeout, timeout()}
          | {:on_timeout, :exit | :kill_task}

  # OTP Spec
  # --------

  @doc false
  @spec child_spec(any()) :: Supervisor.child_spec()
  def child_spec(_opts) do
    %{
      id: __MODULE__,
      start: {Task.Supervisor, :start_link, [[name: __MODULE__]]}
    }
  end

  # Public API
  # ----------

  @doc """
  Runs a function in a supervised background task, returning its pid.

  When the configured application's `:testing?` value is `true`, the function
  runs synchronously and nil is returned instead of the pid.

  ## Options

  - `:delay` - the number of milliseconds to wait before running the function.

  ## Example

  ```elixir
  iex> ExUtils.Runner.background(fn -> :done end)
  {:ok, #PID<0.100.3>}
  ```
  """
  @spec background([background_opt()], (-> any())) :: {:ok, nil | pid()} | {:error, term()}
  def background(opts \\ [], fun) when is_function(fun, 0) do
    delay = Keyword.get(opts, :delay)

    if ExUtils.Configs.get!(:testing?) do
      fun.()
      {:ok, nil}
    else
      Task.Supervisor.start_child(__MODULE__, fn ->
        if delay, do: Process.sleep(delay)
        fun.()
      end)
    end
  end

  @doc """
  Runs multiple tasks concurrently.

  `parallel!/3` is the better fit in most cases since this function
  returns the raw process response after execution; returning an `:ok`
  tuple when the function executes without exceptions, and an `:exit`
  tuple otherwise.

  ## Options

  - `:concurrency` - the maximum number of tasks to run concurrently. Defaults to `5`.
  - `:timeout` - the maximum time in milliseconds each task may run. Defaults to `10_000`.
  - `:on_timeout` - either `:exit` or `:kill_task`.

  ## Example

  ```elixir
  iex> ExUtils.Runner.parallel([1, 2, 3], fn number -> number * 2 end)
  [ok: 2, ok: 4, ok: 6]
  ```
  """
  @spec parallel(Enumerable.t(), [parallel_opt()], (any() -> any())) :: [{:ok, any()} | {:exit, any()}]
  def parallel(list, opts \\ [], fun) when is_function(fun, 1) do
    run_opts = [
      max_concurrency: opts[:concurrency] || 5,
      timeout: opts[:timeout] || 10_000
    ]

    run_opts =
      if opts[:on_timeout] do
        Keyword.put(run_opts, :on_timeout, opts[:on_timeout])
      else
        run_opts
      end

    __MODULE__
    |> Task.Supervisor.async_stream_nolink(list, fun, run_opts)
    |> Enum.to_list()
  end

  @doc """
  Runs multiple tasks concurrently.

  Raises if any of them fail with an exception. Returns the results
  of all tasks.

  Accepts the same options as `parallel/3`.

  ## Example

  ```elixir
  iex> ExUtils.Runner.parallel!([1, 2, 3], &(&1 * 2))
  [2, 4, 6]
  ```
  """
  @spec parallel!(Enumerable.t(), [parallel_opt()], (any() -> any())) :: [any()]
  def parallel!(list, opts \\ [], fun) do
    list
    |> parallel(opts, fun)
    |> Enum.map(fn
      {:ok, result} -> result
      other -> raise("non-ok response received: #{inspect(other)}")
    end)
  end

  @doc """
  Groups a list of `{:ok, ...}` and `{:error, ...}` results into a map.

  Useful for grouping results from operations that return tagged tuples.

  ## Example

  ```elixir
  iex> ExUtils.Runner.group_results([ok: 1, error: :unavailable, ok: 2])
  %{ok: [1, 2], error: [:unavailable]}
  ```
  """
  @spec group_results([{:ok | :error, any()}]) :: %{ok: [any()], error: [any()]}
  def group_results(list) when is_list(list) do
    list
    |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
    |> Map.put_new(:ok, [])
    |> Map.put_new(:error, [])
  end
end
