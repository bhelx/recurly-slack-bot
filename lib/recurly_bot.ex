defmodule RecurlyBot do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      Plug.Adapters.Cowboy.child_spec(:http, RecurlyBot.Router, [], [port: http_port])
    ]

    opts = [strategy: :one_for_one, name: RecurlyBot.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def http_port do
    p = Application.fetch_env!(:recurly_bot, :http_port)
    {p, _} = Integer.parse(p)
    p
  end

  def channel do
    Application.fetch_env!(:recurly_bot, :channel)
  end

  def username do
    Application.fetch_env!(:recurly_bot, :username)
  end

  def ip_whitelist do
    Application.fetch_env!(:recurly_bot, :ip_whitelist)
  end
end
