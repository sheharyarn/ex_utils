defmodule ExUtils.MixProject do
  use Mix.Project

  @app :ex_utils
  @name "ExUtils"
  @version "0.1.7"
  @github "https://github.com/sheharyarn/#{@app}"

  def project do
    [
      # Project
      app: @app,
      version: @version,
      elixir: "~> 1.14.1",
      description: description(),
      package: package(),
      aliases: aliases(),
      deps: deps(),

      # ExDoc
      name: @name,
      source_url: @github,
      homepage_url: @github,
      docs: [
        main: @name,
        canonical: "https://hexdocs.pm/#{@app}",
        extras: ["README.md"]
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
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:inch_ex, ">= 0.0.0", only: :docs},
      {:sobelow, "~> 0.13.0", only: :dev}
    ]
  end

  defp description do
    """
    Elixir utilities, helpers and shortcuts ⚡
    """
  end

  defp aliases do
    [
      sobelow: ["sobelow --strict --skip --exit"],
      quality: [
        "format --check-formatted",
        "sobelow"
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
