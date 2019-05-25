defmodule OsrsGeTrackerWeb.PageControllerTest do
  use OsrsGeTrackerWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Click here to see the items"
  end
end
