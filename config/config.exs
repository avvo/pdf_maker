# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :pdf_maker, PdfMakerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "eEJ7RQwuqnmYzqHP0aiChBTIqGVSmSGuvxOeFn4NixRubgfmL0OArD6jmHmRaWmv",
  render_errors: [view: PdfMakerWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: PdfMaker.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :cors_plug,
       origin: ["*"],
       max_age: 86400,
       methods: ["POST"]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
