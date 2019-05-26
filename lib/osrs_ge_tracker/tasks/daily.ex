defmodule OsrsGeTracker.Daily do
  alias OsrsGeTracker.{Repo}
  alias OsrsGeTracker.GE.{DailyPrice, HourlyPrice}
  import Ecto.Query

  def tick do
    update_daily_prices()
    prune_hourly_prices()
  end

  @secs_in_day 3600 * 24
  @expiration @secs_in_day * 4

  # Add a new entry in daily prices for each item
  def update_daily_prices do
    one_day_ago = NaiveDateTime.utc_now() |> NaiveDateTime.add(@secs_in_day * -1, :second)

    # Gets all prices not split by item
    query = from p in HourlyPrice, where: p.inserted_at > ^one_day_ago
    all_prices = Repo.all(query)

    # A list for each item
    item_prices = all_prices |> Enum.group_by(fn e -> Map.get(e, :item_id) end)

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

      # Add to daily table
      daily = struct(DailyPrice, Map.merge(avg, %{item_id: item_id}))

      Repo.insert!(daily)
    end)

    :ok
  end

  # Remove old hourly prices
  def prune_hourly_prices do
    expiration = NaiveDateTime.utc_now() |> NaiveDateTime.add(@expiration * -1, :second)

    query = from p in HourlyPrice, where: p.inserted_at < ^expiration
    Repo.delete_all(query)

    :ok
  end
end
