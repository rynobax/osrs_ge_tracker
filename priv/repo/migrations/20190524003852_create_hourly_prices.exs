defmodule OsrsGeTracker.Repo.Migrations.CreateHourlyPrices do
  use Ecto.Migration

  def change do
    create table(:hourly_prices) do
      add :item_id, references(:items)
      add :buy_avg, :float
      add :sell_avg, :float
      add :overall_avg, :float
      add :buy_qty, :float
      add :sell_qty, :float
      add :overall_qty, :float

      timestamps(updated_at: false)
    end
  end
end
