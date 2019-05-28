# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     OsrsGeTracker.Repo.insert!(%OsrsGeTracker.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias OsrsGeTracker.Repo
alias OsrsGeTracker.GE.{Item, DailyPrice, HourlyPrice, MinutelyPrice, Price}
alias OsrsGeTracker.OSBuddy

Repo.truncate(DailyPrice)
Repo.truncate(HourlyPrice)
Repo.truncate(MinutelyPrice)
Repo.truncate(Item)

# OSBuddy.getItems |> Enum.map(&Repo.insert!/1)
# OSBuddy.getCurrentPrices |> Enum.map(&Price.to_daily_price/1) |> Enum.map(&Repo.insert!/1)
