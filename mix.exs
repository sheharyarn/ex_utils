defmodule ExUtils.Mixfile do
  use Mix.Project

  @name    "ExUtils"
  @version "0.1.0"
  @github  "https://github.com/sheharyarn/ex_utils"

  def project do
    [
      # Project
      app:          :ex_utils,
      version:      @version,
      elixir:       "~> 1.0",
      description:  description(),
      package:      package(),
      deps:         deps(),

      # ExDoc
      name:         @name,
      source_url:   @github,
      homepage_url: @github,
      docs: [
        main:       @name,
        canonical:  "https://hexdocs.com/ex_utils",
        extras:     ["README.md"]
      ]
    ]
  end

  def application do
    [applications: []]
  end

  defp deps do
    [{:ex_doc, ">= 0.0.0", only: :dev}]
  end

  defp description do
    """
    Collection of Awesome Elixir shortcuts and utilities ⚡
    """
  end

  defp package do
    [
      name: :ecto_rut,
      maintainers: ["Sheharyar Naseer"],
      licenses: ["MIT"],
      files: ~w(mix.exs lib README.md),
      links: %{"Github" => @github}
    ]
  end
end
