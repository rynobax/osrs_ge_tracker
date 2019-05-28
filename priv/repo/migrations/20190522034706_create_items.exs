defmodule OsrsGeTracker.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items, primary_key: false) do
      # Item
      add :id, :id, primary_key: true
      add :name, :string

      # Current price data
      add :buy_avg, :float
      add :sell_avg, :float
      add :overall_avg, :float
      add :buy_qty, :float
      add :sell_qty, :float
      add :overall_qty, :float

      # Computed price data
      add :margin_abs, :float
      add :margin_perc, :float

      timestamps()
    end
  end
end
