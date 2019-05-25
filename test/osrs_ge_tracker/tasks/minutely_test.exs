defmodule OsrsGeTrackerWeb.MinutelyTest do
  use OsrsGeTracker.DataCase
  alias OsrsGeTracker.{Minutely, Repo, GE}

  setup do
    Repo.insert!(%GE.Item{
      id: 1,
      name: "Party Hat",
      buy_avg: 0,
      buy_qty: 0,
      overall_avg: 0,
      overall_qty: 0,
      sell_avg: 0,
      sell_qty: 0
    })

    Repo.insert!(%GE.Item{
      id: 2,
      name: "Rune Scim",
      buy_avg: 0,
      buy_qty: 0,
      overall_avg: 0,
      overall_qty: 0,
      sell_avg: 0,
      sell_qty: 0
    })

    :ok
  end

  describe "update_current_prices" do
    test "Updates the items table" do
      prices = [
        %GE.Price{
          item_id: 1,
          buy_avg: 100,
          buy_qty: 5,
          overall_avg: 75,
          overall_qty: 10,
          sell_avg: 50,
          sell_qty: 5
        },
        %GE.Price{
          item_id: 2,
          buy_avg: 200,
          buy_qty: 5,
          overall_avg: 75,
          overall_qty: 10,
          sell_avg: 50,
          sell_qty: 5
        }
      ]

      assert Repo.get!(GE.Item, 1).buy_avg == 0
      assert Repo.get!(GE.Item, 2).buy_avg == 0
      Minutely.update_current_prices(prices)
      assert Repo.get!(GE.Item, 1).buy_avg == 100
      assert Repo.get!(GE.Item, 2).buy_avg == 200
    end
  end

  describe "update_minutely_prices" do
    test "Adds row to minutely table" do
      prices = [
        %GE.Price{
          item_id: 1,
          buy_avg: 100,
          buy_qty: 5,
          overall_avg: 75,
          overall_qty: 10,
          sell_avg: 50,
          sell_qty: 5
        }
      ]

      assert Repo.one(GE.MinutelyPrice) == nil
      Minutely.update_minutely_prices(prices)
      refute Repo.one(GE.MinutelyPrice) == nil
    end
  end
end
