defmodule OsrsGeTracker.Minutely do
  alias OsrsGeTracker.{GE, Repo, OSBuddy}

  def start do
    prices = OsrsGeTracker.OSBuddy.getCurrentPrices()
    update_current_prices(prices)
    update_minutely_prices(prices)
  end

  def update_current_prices(prices) do
    # todo
  end

  def update_minutely_prices(prices) do
    # todo
  end
end
