# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :osrs_ge_tracker,
  ecto_repos: [OsrsGeTracker.Repo]

# Configures the endpoint
config :osrs_ge_tracker, OsrsGeTrackerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "5/0Lhej5i/cJI671Ks6eT+wmaDy3jBGCQqzWidrikixGYt47cl7L4yQjFHndaQMO",
  render_errors: [view: OsrsGeTrackerWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: OsrsGeTracker.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :osrs_ge_tracker, OsrsGeTracker.Scheduler,
  jobs: [
    # Every minute
    {"* * * * *", {Heartbeat, :send, []}},
  ]
