defmodule OsrsGeTracker.GE do
  alias OsrsGeTracker.Repo
  alias OsrsGeTracker.GE.{Item}

  def get_item(name) do
    Repo.get_by!(Item, name: name |> String.downcase() |> String.replace("-", " "))
    |> Repo.preload([:prices])
  end
end
