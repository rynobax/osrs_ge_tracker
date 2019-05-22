use Mix.Config

# Configure your database
config :osrs_ge_tracker, OsrsGeTracker.Repo,
  username: "elixir",
  password: "elixir",
  database: "osrs_ge_tracker_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :osrs_ge_tracker, OsrsGeTrackerWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
