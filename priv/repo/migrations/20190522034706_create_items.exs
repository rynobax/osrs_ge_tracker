defmodule OsrsGeTracker.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items, primary_key: false) do
      # Item
      add :id, :id, primary_key: true
      add :name, :string

      # Current price data
      add :buy_avg, :integer
      add :sell_avg, :integer
      add :overall_avg, :integer
      add :buy_qty, :integer
      add :sell_qty, :integer
      add :overall_qty, :integer

      timestamps()
    end
  end
end
