defmodule OsrsGeTracker.GE.Price do
  defstruct [:buy_avg, :buy_qty, :overall_avg, :overall_qty, :sell_avg, :sell_qty, :item_id]

  def to_minutely_price(%OsrsGeTracker.GE.Price{} = price) do
    struct(OsrsGeTracker.GE.MinutelyPrice, Map.from_struct(price))
  end

  def to_hourly_price(%OsrsGeTracker.GE.Price{} = price) do
    struct(OsrsGeTracker.GE.HourlyPrice, Map.from_struct(price))
  end

  def to_daily_price(%OsrsGeTracker.GE.Price{} = price) do
    struct(OsrsGeTracker.GE.DailyPrice, Map.from_struct(price))
  end
end
