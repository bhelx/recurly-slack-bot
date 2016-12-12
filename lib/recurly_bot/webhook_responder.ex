defmodule RecurlyBot.WebhookResponder do
  alias Recurly.Webhooks.{NewSubscriptionNotification, CanceledSubscriptionNotification}

  def to_chat_message(%NewSubscriptionNotification{} = n) do
    %{
      text: ":chart_with_upwards_trend: #{n.account.email} just subscribed to \"#{n.subscription.plan.name}\"",
      icon_emoji: ":moneybag:"
    }
  end
  def to_chat_message(%CanceledSubscriptionNotification{} = n) do
    %{
      text: ":chart_with_downwards_trend: #{n.account.email} just canceled their subscription to \"#{n.subscription.plan.name}\"",
      icon_emoji: ":moneybag:"
    }
  end
  def to_chat_message(_), do: nil
end
