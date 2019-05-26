defmodule OsrsGeTracker.Minutely do
  alias OsrsGeTracker.{Repo}
  alias OsrsGeTracker.GE.{Price, Item}

  def start do
    prices = OsrsGeTracker.OSBuddy.getCurrentPrices()
    update_current_prices(prices)
    update_minutely_prices(prices)
  end

  def update_current_prices(prices) do
    # cast to item changeset
    # call repo.update
    # mb create custom changeset for this
    prices
    |> Enum.map(fn price ->
      price
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
