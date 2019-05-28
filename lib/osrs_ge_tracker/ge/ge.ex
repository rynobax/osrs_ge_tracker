defmodule OsrsGeTracker.GE do
  alias OsrsGeTracker.Repo
  alias OsrsGeTracker.GE.{Item}

  def item_table_populated do
    Repo.exists?(Item)
  end

  def get_item(name) do
    Repo.get_by!(Item, name: name |> String.downcase() |> String.replace("-", " "))
  end
end
