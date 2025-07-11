defmodule ExBech32.MixProject do
  use Mix.Project

  @source_url "https://github.com/ayrat555/ex_bech32"

  @version "0.6.2"

  def project do
    [
      app: :ex_bech32,
      name: "ExBech32",
      version: @version,
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      description: description()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:rustler, ">= 0.0.0", optional: true},
      {:rustler_precompiled, "~> 0.8"}
    ]
  end

  defp description do
    """
    Nif for Bech32 format encoding and decoding.
    """
  end

  defp package do
    [
      name: :ex_bech32,
      maintainers: ["Ayrat Badykov"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => @source_url
      },
      files: [
        "lib",
        "native/ex_bech32/.cargo",
        "native/ex_bech32/src",
        "native/ex_bech32/Cargo.toml",
        "native/ex_bech32/Cargo.lock",
        "mix.exs",
        "README.md",
        "LICENSE",
        "checksum-*.exs"
      ]
    ]
  end
end
