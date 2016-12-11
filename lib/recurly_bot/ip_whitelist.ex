defmodule RecurlyBot.IpWhitelist do
  import Plug.Conn, only: [send_resp: 3, halt: 1]
  require Logger

  def init(opts), do: opts

  def call(%Plug.Conn{} = conn, opts) do
    # May need a different way of getting the IP
    # this is where heroku puts it
    ip =
      conn
      |> Map.get(:req_headers)
      |> Enum.into(%{})
      |> Map.get("x-forwarded-for")

    if check_whitelist(ip, opts) do
      conn
    else
      conn
      |> send_resp(403, "Forbidden")
      |> halt
    end
  end

  # always return true if allowed whitelist not set
  def check_whitelist(_ip, allowed: nil), do: true
  def check_whitelist(ip, allowed: whitelist) do
    ip in whitelist
  end
end
