defmodule ExUtils.Mixfile do
  use Mix.Project

  @app     :ex_utils
  @name    "ExUtils"
  @version "0.1.7"
  @github  "https://github.com/sheharyarn/#{@app}"

  def project do
    [
      # Project
      app:          @app,
      version:      @version,
      elixir:       "~> 1.3",
      description:  description(),
      package:      package(),
      deps:         deps(),

      # ExDoc
      name:         @name,
      source_url:   @github,
      homepage_url: @github,
      docs: [
        main:       @name,
        canonical:  "https://hexdocs.pm/#{@app}",
        extras:     ["README.md"]
      ]
    ]
  end

  def application do
    [applications: []]
  end

  defp deps do
    [
      {:ex_doc,  ">= 0.0.0", only: :dev },
      {:inch_ex, ">= 0.0.0", only: :docs}
    ]
  end

  defp description do
    """
    Collection of Awesome Elixir shortcuts and utilities ⚡
    """
  end

  defp package do
    [
      name: @app,
      maintainers: ["Sheharyar Naseer"],
      licenses: ["MIT"],
      files: ~w(mix.exs lib README.md),
      links: %{"Github" => @github}
    ]
  end
end
