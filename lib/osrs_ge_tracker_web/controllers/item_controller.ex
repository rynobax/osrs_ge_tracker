defmodule OsrsGeTrackerWeb.ItemController do
  use OsrsGeTrackerWeb, :controller

  def index(conn, %{"name" => name}) do
    render(conn, "index.html", name: name)
  end
end
