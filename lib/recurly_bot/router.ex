defmodule RecurlyBot.Router do
  use Plug.Router
  import RecurlyBot.Messages, only: [to_chat_message: 1]
  alias Slack.Web.Chat
  alias Recurly.Webhooks

  plug RecurlyBot.IpWhitelist, allowed: RecurlyBot.ip_whitelist
  plug :match
  plug :dispatch

  def start_link do
    Plug.Adapters.Cowboy.http(Plugger.Router, [])
  end

  post "/webhooks" do
    conn
    |> parse_webhook
    |> send_resp(200, "OK")
  end

  defp parse_webhook(conn) do
    {:ok, body, conn} = Plug.Conn.read_body(conn)

    body
    |> Webhooks.parse
    |> to_chat_message
    |> apply_message_defaults
    |> report_to_chat

    conn
  end

  defp apply_message_defaults(nil), do: nil
  defp apply_message_defaults(message) do
    Map.merge(message, %{as_user: false, username: RecurlyBot.username})
  end

  defp report_to_chat(nil), do: nil
  defp report_to_chat(message) do
    {text, opts} = Map.pop(message, :text)
    Chat.post_message(RecurlyBot.channel, text, opts)
  end
end
