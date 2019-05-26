defmodule OsrsGeTracker.Hourly do
  alias OsrsGeTracker.{Repo}
  alias OsrsGeTracker.GE.{Price, Item, MinutelyPrice, HourlyPrice}
  import Ecto.Query

  @secs_in_hr 3600

  def start do
    update_hourly_prices()
  end

  def update_hourly_prices do
    hour_ago = NaiveDateTime.utc_now() |> NaiveDateTime.add(@secs_in_hr * -1, :second)

    # Gets all prices not split buy item
    query = from p in MinutelyPrice, where: p.inserted_at > ^hour_ago
    all_prices = Repo.all(query)

    # A list for each item
    item_prices = all_prices |> Enum.group_by(fn e -> Map.get(e, :item_id) end)

    prices =
      item_prices
      |> Enum.map(fn {item_id, prices} ->
        price_count = length(prices)

        # Average
        avg =
          prices
          # Convert to map with only keys we want to average
          |> Enum.map(fn price ->
            price
            |> Map.from_struct()
            |> Map.take([:buy_avg, :buy_qty, :overall_avg, :overall_qty, :sell_avg, :sell_qty])
          end)
          # Sum the values into one map
          |> Enum.reduce(fn p, acc ->
            Map.merge(p, acc, fn _k, v1, v2 -> v1 + v2 end)
          end)
          # Average the values
          |> Enum.reduce(%{}, fn {k, v}, acc -> Map.put(acc, k, v / price_count) end)

        # Add to hourly table
        hourly = struct(HourlyPrice, Map.merge(avg, %{item_id: item_id}))

        Repo.insert!(hourly)
      end)

    prices
  end

  def prune_minutely_prices do
    # Remove minutely prices from 4 hours ago
  end
end
