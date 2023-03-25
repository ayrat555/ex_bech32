defmodule ExBech32.MixProject do
  use Mix.Project

  @source_url "https://github.com/ayrat555/ex_bech32"

  @version "0.5.0"

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
      {:dialyxir, "~> 1.0", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:rustler, ">= 0.0.0", optional: true},
      {:rustler_precompiled, "~> 0.6"}
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
        "native/exbech32/.cargo",
        "native/exbech32/src",
        "native/exbech32/Cargo.toml",
        "native/exbech32/Cargo.lock",
        "mix.exs",
        "README.md",
        "LICENSE"
      ]
    ]
  end
end
