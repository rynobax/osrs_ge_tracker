defmodule OsrsGeTracker.GE.Price do
  defstruct [:buy_avg, :buy_qty, :overall_avg, :overall_qty, :sell_avg, :sell_qty, :item_id]

  def from_daily_price(%OsrsGeTracker.GE.DailyPrice{} = daily) do
    struct(OsrsGeTracker.GE.Price, Map.from_struct(daily))
  end

  def to_daily_price(%OsrsGeTracker.GE.Price{} = price) do
    struct(OsrsGeTracker.GE.DailyPrice, Map.from_struct(price))
  end
end
