defmodule OsrsGeTracker.GE do
  alias OsrsGeTracker.Repo
  alias OsrsGeTracker.GE.{Item}
  import Ecto.Query

  def item_table_populated do
    Repo.exists?(Item)
  end

  def get_item(name) do
    Repo.get_by!(Item, name: name |> String.downcase() |> String.replace("-", " "))
  end

  def get_merchable_items() do
    query = from Item, order_by: [desc_nulls_last: :margin_perc], limit: 10
    Repo.all(query)
  end
end
