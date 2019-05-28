defmodule OsrsGeTracker.Minutely do
  alias OsrsGeTracker.{Repo}
  alias OsrsGeTracker.GE.{Price, Item}

  def tick do
    prices = OsrsGeTracker.OSBuddy.getCurrentPrices()
    update_current_prices(prices)
    update_minutely_prices(prices)
  end

  def compute_margins(price) do
    # buy will typically be higher than sell
    margin_abs = price.buy_avg - price.sell_avg
    margin_perc = case {price.buy_avg, price.sell_avg} do
      {0.0, _} -> nil
      {_, 0.0} -> nil
      _ -> ((price.buy_avg / price.sell_avg) - 1) * 100
    end

    price
    |> Map.put(:margin_abs, margin_abs)
    |> Map.put(:margin_perc, margin_perc)
  end

  def update_current_prices(prices) do
    # cast to item changeset
    # call repo.update
    # mb create custom changeset for this
    prices
    |> Enum.map(fn price ->
      price
      |> compute_margins
      |> Map.from_struct()
      |> (fn item -> Item.changeset(%Item{id: price.item_id}, item) end).()
      |> Repo.update()
    end)
  end

  def update_minutely_prices(prices) do
    prices |> Enum.map(&Price.to_minutely_price/1) |> Enum.map(&Repo.insert/1)
    :ok
  end
end
