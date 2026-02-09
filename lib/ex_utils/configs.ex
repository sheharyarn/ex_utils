defmodule ExUtils.Configs do
  @moduledoc """
  Simplified helpers to work with Application configs in Elixir.

  Before using this module, you must add the following to your
  `config.exs` file:

  ```elixir
  config :ex_utils, otp_app: :your_app
  ```

  Replace `:your_app` with the actual OTP app atom.
  """

  @doc """
  Reads the application configs of the OTP app.

  Raises if the value is nil or does not exist.

  ## Example

  Given the following application config:

  ```elixir
  config :your_app, :mailer, adapter: MyApp.LocalAdapter
  ```

  It can be retrieved with:

  ```elixir
  iex> ExUtils.Configs.get!(:mailer)
  [adapter: MyApp.LocalAdapter]
  ```
  """
  @spec get!(atom()) :: any()
  def get!(context) do
    Application.fetch_env!(otp_app(), context)
  end

  @doc """
  Gets a config value for the given access path.

  Returns the given default when the value is `nil` or does not exist.

  ## Examples

  Given `config :your_app, :features, uploads: [enabled: true]`:

  ```elixir
  iex> ExUtils.Configs.get(:features, [:uploads, :enabled])
  true
  iex> ExUtils.Configs.get(:features, [:uploads, :max_size], :unlimited)
  :unlimited
  ```
  """
  @spec get(atom(), atom() | list(), any()) :: any()
  def get(context, keys, default \\ nil) do
    keys = List.wrap(keys)

    context
    |> get!()
    |> Kernel.get_in(keys)
    |> case do
      nil -> default
      val -> val
    end
  end

  @doc """
  Same as `get/3` but raises when the value is `nil` or not found and no
  default is provided.
  """
  @spec get!(atom(), atom() | list(), any()) :: any()
  def get!(context, keys, default \\ nil) do
    case get(context, keys, default) do
      nil -> raise(ArgumentError, "Context #{inspect(context)} value #{inspect(keys)} is nil")
      val -> val
    end
  end

  @doc """
  Build the absolute path of a file in the `priv/` directory,
  given its relative path.

  This is especially useful in compiled elixir releases.

  ## Examples

  During development, the returned path might look like:

  ```elixir
  iex> ExUtils.Configs.from_priv!("templates/email.html")
  "priv/templates/email.html"
  ```

  In a compiled release, it might look like:

  ```elixir
  iex> ExUtils.Configs.from_priv!("templates/email.html")
  "/opt/my_app/lib/my_app-1.0.0/priv/templates/email.html"
  ```
  """
  @spec from_priv!(binary()) :: binary()
  def from_priv!(path) do
    priv_dir = otp_app() |> :code.priv_dir() |> to_string()

    case Path.safe_relative(path) do
      {:ok, path} -> Path.join(priv_dir, path)
      _error -> raise("invalid path #{path}")
    end
  end

  @doc """
  Read a file stored in the `priv/` directory.

  Accepts a relative path of file inside `priv`.

  ## Example

  Given a `priv/messages/welcome.txt` file containing `Welcome!`:

  ```elixir
  iex> ExUtils.Configs.read_from_priv!("messages/welcome.txt")
  "Welcome!"
  ```
  """
  # sobelow_skip ["Traversal.FileModule"]
  @spec read_from_priv!(binary()) :: binary()
  def read_from_priv!(path) do
    path
    |> from_priv!()
    |> File.read!()
  end

  defp otp_app do
    case Application.get_env(:ex_utils, :otp_app) do
      nil -> raise(":otp_app configuration missing. add `config :ex_utils, otp_app: :your_app` to config.exs.")
      app -> app
    end
  end
end
