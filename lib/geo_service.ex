defmodule GeoService do
  use Application
  require Logger
  
  def start(_type, _args) do
    server_host = System.get_env("SERVER_HOST") || Application.get_env(:geo_service, :host, "127.0.0.1")
                  |> String.split(".") |> Enum.map(fn(x) -> String.to_integer(x) end) |> List.to_tuple
    server_port = System.get_env("SERVER_PORT") || Application.get_env(:geo_service, :port, "4000")
                  |> String.to_integer()

    redis_host = System.get_env("REDIS_HOST") || Application.get_env(:redix, :host, "127.0.0.1")
    redis_port = System.get_env("REDIS_PORT") || Application.get_env(:redix, :port, "6379")
                 |> String.to_integer()

    children = [
      Plug.Adapters.Cowboy.child_spec(:http, GeoService.Router, [], port: server_port, ip: server_host),
      {Redix, [[host: redis_host, port: redis_port], [name: :redix]]},
    ]

    Logger.info("Server run on: #{server_host |> Tuple.to_list |> Enum.join(".")}:#{server_port}")

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
