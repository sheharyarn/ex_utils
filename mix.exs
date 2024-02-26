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
      elixir: "~> 1.14",
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
    [extra_applications: [:crypto]]
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
      quality: [
        "format --check-formatted",
        "sobelow --strict --skip --exit --quiet"
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
