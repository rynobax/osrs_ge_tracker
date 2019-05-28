defmodule OsrsGeTracker.MinutelyTest do
  use OsrsGeTracker.DataCase
  alias OsrsGeTracker.{Minutely, Repo, GE}

  defp price(overrides) do
    struct(
      GE.Price,
      Map.merge(
        %{
          item_id: 1,
          buy_avg: 0.0,
          buy_qty: 0.0,
          overall_avg: 0.0,
          overall_qty: 0.0,
          sell_avg: 0.0,
          sell_qty: 0.0
        },
        overrides
      )
    )
  end

  setup do
    Repo.insert!(%GE.Item{
      id: 1,
      name: "Party Hat",
      buy_avg: 0.0,
      buy_qty: 0.0,
      overall_avg: 0.0,
      overall_qty: 0.0,
      sell_avg: 0.0,
      sell_qty: 0.0
    })

    Repo.insert!(%GE.Item{
      id: 2,
      name: "Rune Scim",
      buy_avg: 0.0,
      buy_qty: 0.0,
      overall_avg: 0.0,
      overall_qty: 0.0,
      sell_avg: 0.0,
      sell_qty: 0.0
    })

    :ok
  end

  describe "update_current_prices" do
    test "Updates the items table" do
      prices = [
        price(%{ item_id: 1, buy_avg: 100.0 }),
        price(%{ item_id: 2, buy_avg: 200.0 })
      ]

      assert Repo.get!(GE.Item, 1).buy_avg == 0.0
      assert Repo.get!(GE.Item, 2).buy_avg == 0.0
      Minutely.update_current_prices(prices)
      assert Repo.get!(GE.Item, 1).buy_avg == 100.0
      assert Repo.get!(GE.Item, 2).buy_avg == 200.0
    end

    test "Computes margins" do
      prices = [
        price(%{ item_id: 1, buy_avg: 100.0, sell_avg: 50.0 })
      ]
      Minutely.update_current_prices(prices)
      assert Repo.get!(GE.Item, 1).margin_abs == 50.0
      assert Repo.get!(GE.Item, 1).margin_perc == 100.0
    end
  end

  describe "update_minutely_prices" do
    test "Adds row to minutely table" do
      prices = [price(%{})]

      assert Repo.one(GE.MinutelyPrice) == nil
      Minutely.update_minutely_prices(prices)
      refute Repo.one(GE.MinutelyPrice) == nil
    end
  end

  describe "compute_margins" do
    test "handles 0 buy price" do
      prices = [
        price(%{ item_id: 1, buy_avg: 0.0, sell_avg: 100.0 })
      ]
      Minutely.update_current_prices(prices)
      assert Repo.get!(GE.Item, 1).margin_abs == -100.0
      assert Repo.get!(GE.Item, 1).margin_perc == nil
    end

    test "handles 0 sell price" do
      prices = [
        price(%{ item_id: 1, buy_avg: 100.0, sell_avg: 0.0 })
      ]
      Minutely.update_current_prices(prices)
      assert Repo.get!(GE.Item, 1).margin_abs == 100.0
      assert Repo.get!(GE.Item, 1).margin_perc == nil
    end
  end
end
