defmodule OsrsGeTrackerWeb.ItemController do
  use OsrsGeTrackerWeb, :controller
  alias OsrsGeTracker.GE

  def show(conn, %{"name" => name}) do
    item = GE.get_item(name)
    render(conn, "index.html", name: name, id: item.id)
  end
end
