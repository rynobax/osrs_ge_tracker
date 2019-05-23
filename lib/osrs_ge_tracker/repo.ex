defmodule OsrsGeTracker.Repo do
  use Ecto.Repo,
    otp_app: :osrs_ge_tracker,
    adapter: Ecto.Adapters.Postgres

  if Mix.env() in [:dev, :test] do
    @spec truncate(atom()) :: :ok
    def truncate(schema) do
      table_name = schema.__schema__(:source)
      query("TRUNCATE #{table_name} CASCADE", [])
      :ok
    end
  end
end
