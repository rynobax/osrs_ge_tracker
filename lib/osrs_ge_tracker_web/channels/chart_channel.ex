defmodule OsrsGeTrackerWeb.ChartChannel do
  use Phoenix.Channel
  require Logger
  alias OsrsGeTracker.{Repo, GE}

  def join("chart:" <> item_id, _params, socket) do
    item = GE.get_item_by_id(item_id) |> Repo.preload(:hourly_prices)

    hourly =
      Enum.map(item.hourly_prices, fn p ->
        Map.from_struct(p) |> Map.take([:buy_avg, :sell_avg, :created_at])
      end)

    # Logger.info(hourly)

    {:ok, %{data: hourly}, socket}
  end
end
