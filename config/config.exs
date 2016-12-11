use Mix.Config

config :recurly_bot,
  http_port: System.get_env("PORT"),
  channel: System.get_env("SLACK_CHANNEL") || "recurly",
  username: System.get_env("SLACK_BOT_NAME") || "Recurly Bot",
  # restrict to recurly production IPs
  ip_whitelist: [
    "50.18.192.88",
    "52.8.32.100",
    "52.9.209.233",
    "50.0.172.150",
    "52.203.102.94",
    "52.203.192.184"
  ]

# Allow any IPs in dev mode
if Mix.env == :dev do
  config :recurly_bot, ip_whitelist: nil
end

config :slack,
  api_token: System.get_env("SLACK_TOKEN")

