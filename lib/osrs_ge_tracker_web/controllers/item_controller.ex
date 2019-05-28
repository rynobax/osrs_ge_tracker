defmodule OsrsGeTrackerWeb.ItemController do
  use OsrsGeTrackerWeb, :controller
  alias OsrsGeTracker.GE

  def index(conn, _params) do
    items = GE.get_merchable_items()
    render(conn, "list.html", items: items)
  end

  def show(conn, %{"name" => name}) do
    item = GE.get_item(name)
    [%GE.Price{ :buy_avg => price } | _] = item.prices
    render(conn, "index.html", name: name, id: item.id, price: price)
  end
end
