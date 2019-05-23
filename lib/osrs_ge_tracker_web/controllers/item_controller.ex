defmodule OsrsGeTrackerWeb.ItemController do
  use OsrsGeTrackerWeb, :controller
  alias OsrsGeTracker.GE

  def show(conn, %{"name" => name}) do
    item = GE.get_item(name)
    [%GE.Price{ :buy_avg => price } | _] = item.prices
    render(conn, "index.html", name: name, id: item.id, price: price)
  end
end
