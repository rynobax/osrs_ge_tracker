defmodule OsrsGeTracker.Repo.Migrations.CreatePrices do
  use Ecto.Migration

  def change do
    create table(:prices) do
      add :item_id, references(:items)
      add :buy_avg, :integer
      add :sell_avg, :integer
      add :overall_avg, :integer
      add :buy_qty, :integer
      add :sell_qty, :integer
      add :overall_qty, :integer

      timestamps(updated_at: false)
    end
  end
end
