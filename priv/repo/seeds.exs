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
alias OsrsGeTracker.GE.{Item, Price}
alias OsrsGeTracker.OSBuddy

Repo.truncate(Price)
Repo.truncate(Item)

OSBuddy.getItemNames |> Enum.map(&Repo.insert!/1)
OSBuddy.getCurrentPrices |> Enum.map(&Repo.insert!/1)
