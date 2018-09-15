defmodule GeoService.MixProject do
  use Mix.Project

  def project do
    [
      app: :geo_service,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :redix],
      mod: {GeoService, []},
      env: [cowboy_port: 8080]
    ]
  end

  defp deps do
    [
      {:cowboy, "~> 1.0.0"},
      {:plug, "~> 1.2.0"},
      {:redix, ">= 0.7.0"},
      {:iptools, "~> 0.0.2"},
      {:poison, "~> 1.4.0"},
      {:remote_ip, "~> 0.1.0"}
    ]
  end
end
