defmodule OsrsGeTracker.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items, primary_key: false) do
      add :id, :id, primary_key: true
      add :name, :string

      timestamps()
    end
  end
end
