# Recurly Slack Bot

This is a starter project to make a slack bot for Recurly. It uses [Elixir](http://elixir-lang.org/), [Plug](https://github.com/elixir-lang/plug), and the
[Recurly Elixir library](https://github.com/bhelx/recurly-client-elixir).


All it currently does is log into a slack channel that you specify and post when a new user has subscribed or unsubscribed
and gives their email. It could be extended to give you more actionable details, or even accept commands
from the people in the chat and do some actions on your recurly site.

![Recurly Bot Example](/images/bot_example.png "Recurly Bot Example")

## Deploying to Heroku

It's built to assume you are running on Heroku. If you wish to run in some other way, changes may need to be made.

After cloning this repo, create your heroku app. I'm calling this one `recurly-bot`

```
heroku apps:create --buildpack https://github.com/HashNuke/heroku-buildpack-elixir.git recurly-bot
```

Then set some configs. You'll need to get a token from slack and you'll want to create the channel ahead of time:

```
heroku config:set SLACK_TOKEN=xoxp-abdb393813-123812838213-12838183128-398481
heroku config:set SLACK_CHANNEL=recurly
heroku config:set SLACK_BOT_NAME="Recurly Bot"
```

Then push to heroku:

```
git push heroku master
```

## Local Setup

To set locally, first run:

```
mix deps.get
```

To run, try something like this

```
SLACK_TOKEN=xoxp-whatever SLACK_CHANNEL=test PORT=4001 mix run --no-halt
```

You can get some example webhooks from here [https://dev.recurly.com/page/webhooks](https://dev.recurly.com/page/webhooks)
and use curl to pipe them in. For example, save the new subscription webhook to a file `new_sub.xml`:

```
curl -X POST -d @new_sub.xml http://127.0.0.1:4001/webhooks
```

To setup on Recurly, you can go the [webhooks configuration page](https://app.recurly.com/go/configuration/notifications) and add
your heroku url. Make sure you use the path `/webhooks`.

![Recurly Setup](/images/recurly_setup.png "Recurly Setup")

## Customizing

If you want to customize what is displayed for each webhook, or maybe add some webhook events, you can do so in the [RecurlyBot.Messages](lib/recurly_bot/messages.ex) module.
This takes a notification object and returns a Map which gets passed along to slack. You can add more `to_chat_message` functions to match for new notifications. If you want to
know more about which notifications are available and how to use them, see the [recurly-client-elixir webhooks docs](https://hexdocs.pm/recurly/Recurly.Webhooks.html).

