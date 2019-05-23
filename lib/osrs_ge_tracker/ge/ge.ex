defmodule OsrsGeTracker.GE do
  import Ecto.Query
  alias OsrsGeTracker.Repo
  alias OsrsGeTracker.GE.{Item, Price}

  def get_item(name) do
    Repo.get_by!(Item, name: name |> String.downcase)
  end
end
