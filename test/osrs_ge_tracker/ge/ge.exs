defmodule OsrsGeTracker.GETest do
  use OsrsGeTracker.DataCase
  alias OsrsGeTracker.{Repo, GE}

  defp item(overrides) do
    struct(
      GE.Item,
      Map.merge(
        %{
          item_id: 1,
          buy_avg: 0.0,
          buy_qty: 0.0,
          overall_avg: 0.0,
          overall_qty: 0.0,
          sell_avg: 0.0,
          sell_qty: 0.0,
          margin_abs: 0.0,
          margin_perc: 0.0,
        },
        overrides
      )
    )
  end

  describe "item_table_populated" do
    test "returns false if no data" do
      assert GE.item_table_populated() == false
    end

    test "returns true if there is data" do
      Repo.insert!(item(%{
        id: 1,
        name: "Party Hat",
      }))
      assert GE.item_table_populated() == true
    end
  end

  describe "get_item" do
    setup do
      Repo.insert!(item(%{
        id: 1,
        name: "party hat",
      }))

      :ok
    end

    test "can get item" do
      assert GE.get_item("party-hat").id == 1
    end
  end
end
