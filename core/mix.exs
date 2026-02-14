defmodule ProtocolZero.MixProject do
  use Mix.Project

  def project do
    [
      app: :protocol_zero_core,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :crypto],
      mod: {ProtocolZero.Application, []}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:plug_cowboy, "~> 2.6"},
      {:cors_plug, "~> 3.0"},
      {:websock_adapter, "~> 0.5"},
      {:protobuf, "~> 0.12"},
      {:req, "~> 0.4"},
      {:jason, "~> 1.4"},
      {:dotenvy, "~> 0.8"},
      {:elixir_uuid, "~> 1.2"},
      {:typed_struct, "~> 0.3"}
    ]
  end
end
