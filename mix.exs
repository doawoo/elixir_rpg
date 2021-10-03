defmodule ElixirRPG.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_rpg,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:typed_struct, "~> 0.2.1"},
      {:phoenix_live_view, "~> 0.16.3"},
      {:qex, "~> 0.5"}
    ]
  end
end
