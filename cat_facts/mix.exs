defmodule CatFacts.MixProject do
  use Mix.Project

  def project do
    [
      app: :cat_facts,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {CatFacts, []}
    ]
  end

  defp deps do
    [
      {:tesla, "~> 1.3"},
      {:hackney, "~> 1.14.0"},
      {:jason, ">= 1.0.0"}
    ]
  end
end
