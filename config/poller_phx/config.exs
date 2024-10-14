# General application configuration
import Config

# Configures the endpoint
config :poller_phx, PollerPhxWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "8qFwyMrGhrNGQDjiL1DtcxxV7LGMr0RgjFuw9jHUg4ERhXstkV5WqnW1hEOxcyXD",
  render_errors: [view: PollerPhxWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: PollerPhx.PubSub,
  live_view: [signing_salt: "kXL0q5De"]

# Configures Guardian
config :poller_phx, PollerPhx.Users.Guardian,
  issuer: "poller_phx",
  secret_key: "+uHzQ7MKY72yWoGapVlwmKS7i2FIHxX0fStmYvc0o0rr1F7OizsgCkfbO5HXphsZ"


# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
