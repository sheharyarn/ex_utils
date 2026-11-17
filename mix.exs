defmodule ExUtils.MixProject do
  use Mix.Project

  @app :ex_utils
  @name "ExUtils"
  @version "1.0.1"
  @github "https://github.com/sheharyarn/#{@app}"

  def project do
    [
      # Project
      app: @app,
      version: @version,
      elixir: "~> 1.14",
      description: description(),
      package: package(),
      aliases: aliases(),
      deps: deps(),
      dialyzer: dialyzer(),

      # ExDoc
      name: @name,
      source_url: @github,
      homepage_url: @github,
      docs: [
        main: @name,
        canonical: "https://hexdocs.pm/#{@app}",
        extras: ["README.md"],
        groups_for_modules: [
          ExUtils: ~r/^ExUtils\.(?!(?:Ecto|Modules)(?:\.|$)).+/,
          "ExUtils.Modules": ~r/^ExUtils\.Modules(?:\.|$)/,
          "ExUtils.Ecto": ~r/^ExUtils\.Ecto(?:\.|$)/
        ]
      ]
    ]
  end

  def application do
    [
      env: [
        otp_app: nil,
        testing?: false
      ],
      extra_applications: [:crypto, :logger]
    ]
  end

  defp deps do
    [
      {:decimal, "~> 2.0 or ~> 3.0", optional: true},
      {:ecto, "~> 3.10", optional: true},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:inch_ex, ">= 0.0.0", only: :docs},
      {:sobelow, "~> 0.16", only: :dev},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false}
    ]
  end

  # Optional dependencies are added to the PLT so Dialyzer can check the
  # Ecto and Decimal modules. PLTs are cached in priv/plts (git-ignored).
  defp dialyzer do
    [
      plt_add_apps: [:ecto, :decimal],
      plt_local_path: "priv/plts",
      plt_core_path: "priv/plts",
      flags: [:error_handling]
    ]
  end

  defp description do
    """
    Elixir utilities, helpers and shortcuts ⚡
    """
  end

  defp aliases do
    [
      sobelow: ["sobelow --strict --skip --exit --no-router"],
      quality: [
        "format --check-formatted",
        "sobelow",
        "dialyzer"
      ]
    ]
  end

  defp package do
    [
      name: @app,
      maintainers: ["Sheharyar Naseer"],
      licenses: ~w[MIT],
      files: ~w(mix.exs lib README.md),
      links: %{"GitHub" => @github}
    ]
  end
end
