defmodule OsrsGeTracker.Repo do
  use Ecto.Repo,
    otp_app: :osrs_ge_tracker,
    adapter: Ecto.Adapters.Postgres
end
