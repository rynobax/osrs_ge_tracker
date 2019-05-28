defmodule OsrsGeTracker.DailyTest do
  use OsrsGeTracker.DataCase
  alias OsrsGeTracker.{Daily, Repo, GE}

  @important_fields [
    :item_id,
    :buy_avg,
    :buy_qty,
    :overall_avg,
    :overall_qty,
    :sell_avg,
    :sell_qty
  ]

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

    Repo.insert!(%GE.Item{
      id: 3,
      name: "Dragon dagger",
      buy_avg: 0.0,
      buy_qty: 0.0,
      overall_avg: 0.0,
      overall_qty: 0.0,
      sell_avg: 0.0,
      sell_qty: 0.0
    })

    :ok
  end

  # Gets time x minutes ago
  defp time(hours) do
    NaiveDateTime.utc_now()
    |> NaiveDateTime.add(3600 * hours * -1, :second)
    |> NaiveDateTime.truncate(:second)
  end

  defp price(overrides) do
    struct(
      GE.HourlyPrice,
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

  describe "update_daily_prices" do
    test "Combines data from last day into daily entry" do
      data = [
        # From the past day
        price(%{
          item_id: 1,
          buy_avg: 100.0,
          buy_qty: 5.0,
          overall_avg: 75.0,
          overall_qty: 10.0,
          sell_avg: 50.0,
          sell_qty: 5.0
        }),
        price(%{
          inserted_at: time(12),
          item_id: 1,
          buy_avg: 200.0,
          buy_qty: 10.0,
          overall_avg: 125.0,
          overall_qty: 20.0,
          sell_avg: 100.0,
          sell_qty: 10.0
        })
      ]

      data |> Enum.map(&Repo.insert!/1)

      assert Repo.one(GE.DailyPrice) == nil
      Daily.update_daily_prices()

      expected = %{
        item_id: 1,
        buy_avg: 150.0,
        buy_qty: 7.5,
        overall_avg: 100.0,
        overall_qty: 15.0,
        sell_avg: 75.0,
        sell_qty: 7.5
      }

      assert Map.take(Repo.one(GE.DailyPrice), @important_fields) == expected
    end

    test "Combines data on a per item basis" do
      data = [
        price(%{item_id: 1}),
        price(%{inserted_at: time(12), item_id: 2})
      ]

      data |> Enum.map(&Repo.insert!/1)

      assert Repo.one(GE.DailyPrice) == nil
      assert Daily.update_daily_prices()
      assert length(Repo.all(GE.DailyPrice)) == 2
    end
  end

  describe "prune_hourly_prices" do
    test "Removes data older than 4 hours" do
      data = [
        # From the past day
        price(%{item_id: 1}),
        # outside of past day, inside of 4 days
        price(%{inserted_at: time(48), item_id: 2}),
        # outside of 4 days
        price(%{inserted_at: time(100), item_id: 3})
      ]

      data |> Enum.map(&Repo.insert!/1)

      Daily.prune_hourly_prices()

      res = Repo.all(GE.HourlyPrice)
      assert Enum.map(res, fn e -> Map.get(e, :item_id) end) == [1, 2]
    end
  end
end
