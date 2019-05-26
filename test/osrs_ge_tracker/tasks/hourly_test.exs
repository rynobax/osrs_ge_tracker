defmodule OsrsGeTrackerWeb.HourlyTest do
  use OsrsGeTracker.DataCase
  alias OsrsGeTracker.{Hourly, Repo, GE}

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

    :ok
  end

  # Gets time x minutes ago
  defp time(mins) do
    NaiveDateTime.utc_now()
    |> NaiveDateTime.add(60 * mins * -1, :second)
    |> NaiveDateTime.truncate(:second)
  end

  describe "update_hourly_prices" do
    test "Combines data from last hour into hourly entry" do
      data = [
        # From the past hour
        %GE.MinutelyPrice{
          item_id: 1,
          buy_avg: 100.0,
          buy_qty: 5.0,
          overall_avg: 75.0,
          overall_qty: 10.0,
          sell_avg: 50.0,
          sell_qty: 5.0
        },
        %GE.MinutelyPrice{
          inserted_at: time(30),
          item_id: 1,
          buy_avg: 200.0,
          buy_qty: 10.0,
          overall_avg: 125.0,
          overall_qty: 20.0,
          sell_avg: 100.0,
          sell_qty: 10.0
        }
      ]

      data |> Enum.map(&Repo.insert!/1)

      assert Repo.one(GE.HourlyPrice) == nil
      Hourly.update_hourly_prices()

      assert Map.take(Repo.one(GE.HourlyPrice), @important_fields) == %{
               item_id: 1,
               buy_avg: 150.0,
               buy_qty: 7.5,
               overall_avg: 100.0,
               overall_qty: 15.0,
               sell_avg: 75.0,
               sell_qty: 7.5
             }
    end

    test "Combines data on a per item basis" do
      data = [
        %GE.MinutelyPrice{
          item_id: 1,
          buy_avg: 100.0,
          buy_qty: 5.0,
          overall_avg: 75.0,
          overall_qty: 10.0,
          sell_avg: 50.0,
          sell_qty: 5.0
        },
        %GE.MinutelyPrice{
          inserted_at: time(30),
          item_id: 2,
          buy_avg: 100.0,
          buy_qty: 5.0,
          overall_avg: 75.0,
          overall_qty: 10.0,
          sell_avg: 50.0,
          sell_qty: 5.0
        }
      ]

      data |> Enum.map(&Repo.insert!/1)

      assert Repo.one(GE.HourlyPrice) == nil
      assert Hourly.update_hourly_prices()
      assert length(Repo.all(GE.HourlyPrice)) == 2
    end
  end

  # describe "prune_minutely_prices" do
  #   test "Removes data older than 4 houers" do
  #     data = [
  #       # From the past hour
  #       %GE.MinutelyPrice{
  #         item_id: 1,
  #         buy_avg: 100,
  #         buy_qty: 5,
  #         overall_avg: 75,
  #         overall_qty: 10,
  #         sell_avg: 50,
  #         sell_qty: 5
  #       },
  #       # outside of past hour, inside of 4 hours
  #       %GE.MinutelyPrice{
  #         inserted_at: time(90),
  #         item_id: 2,
  #         buy_avg: 200,
  #         buy_qty: 5,
  #         overall_avg: 75,
  #         overall_qty: 10,
  #         sell_avg: 50,
  #         sell_qty: 5
  #       },
  #       # outside of 4 hours
  #       %GE.MinutelyPrice{
  #         inserted_at: time(300),
  #         item_id: 3,
  #         buy_avg: 200,
  #         buy_qty: 5,
  #         overall_avg: 75,
  #         overall_qty: 10,
  #         sell_avg: 50,
  #         sell_qty: 5
  #       }
  #     ]

  #     Hourly.prune_minutely_prices()
  #     # TODO: Check that it go removed
  #   end
  # end
end
