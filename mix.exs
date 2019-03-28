defmodule FirebaseJwt.MixProject do
  use Mix.Project

  def project do
    [
      app: :firebase_jwt,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      name: "Firebase JWT Veirifer",
      description: "Verifying Firebase JWT with PEM from Google",
      source_url: "https://github.com/ecpplus/ex-firebase-jwt"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:timex, :httpoison],
      mod: {FirebaseJwt.App, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jose, "~> 1.9"},
      {:jason, "~> 1.1"},
      {:httpoison, "~> 1.4"},
      {:timex, "~> 3.5"},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp package do
    [
      name: :firebase_jwt,
      files: ["lib", "mix.exs", "README*"],
      maintainers: ["chu"],
      licenses: ["Apache 2.0"],
      links: %{"GitHub" => "https://github.com/ecpplus/ex-firebase-jwt"}
    ]
  end
end
