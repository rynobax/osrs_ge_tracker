defmodule OsrsGeTrackerWeb.ItemView do
  use OsrsGeTrackerWeb, :view
  alias OsrsGeTracker.GE
  require Logger

  def pretty_name(%GE.Item{:name => name}) do
    name |> String.capitalize()
  end

  def ids_json(items) do
    ids = Enum.map(items, fn item -> Map.fetch!(item, :id) end)
    Logger.info(ids)
    Poison.encode!(ids)
  end
end
