defmodule OsrsGeTrackerWeb.ItemController do
  use OsrsGeTrackerWeb, :controller
  alias OsrsGeTracker.GE

  def index(conn, _params) do
    items = GE.get_merchable_items()
    render(conn, "list.html", items: items)
  end

  def show(conn, %{"name" => name}) do
    item = GE.get_item_by_name(name)
    render(conn, "details.html", name: name, id: item.id, price: item.buy_avg)
  end
end
