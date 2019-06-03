defmodule OsrsGeTrackerWeb.ItemView do
  use OsrsGeTrackerWeb, :view
  alias OsrsGeTracker.GE

  def pretty_name(%GE.Item{ :name => name }) do
    name |> String.capitalize
  end
end
