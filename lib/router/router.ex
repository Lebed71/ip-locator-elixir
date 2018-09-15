defmodule GeoService.Router do
    use Plug.Router

    plug(:match)
    plug(RemoteIp)
    plug(:dispatch)
  
    get "/locate" do
      ip_address_integer = conn.remote_ip |> :inet.ntoa() |> to_string() |> Iptools.to_integer()
      {:ok, position} = Redix.command(:redix, ["ZRANGEBYSCORE", "billing_geoinfo", ip_address_integer, "+inf", "LIMIT", 0, 1])
      country = position |> hd |> String.split("|") |> Enum.take(-1) |> hd
      conn |> put_resp_content_type("application/json")
           |> send_resp(200, Poison.encode!(%{country: country}))              
    end

    match(_, do: send_resp(conn, 404, "Not found!"))
  end