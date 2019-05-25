defmodule OsrsGeTracker.OSBuddyMock do
  alias OsrsGeTracker.GE.{Item, Price}

  @prices %{
    "2": %{
      id: 2,
      name: "Cannonball",
      members: true,
      sp: 5,
      buy_average: 165,
      buy_quantity: 205_787,
      sell_average: 164,
      sell_quantity: 442_688,
      overall_average: 164,
      overall_quantity: 648_475
    },
    "44": %{
      id: 44,
      name: "Rune arrowtips",
      members: true,
      sp: 200,
      buy_average: 231,
      buy_quantity: 1,
      sell_average: 228,
      sell_quantity: 315,
      overall_average: 228,
      overall_quantity: 316
    }
  }

  @names %{
    "2": %{
      name: "Cannonball",
      store: 5
    },
    "44": %{
      name: "Rune arrowtips",
      store: 200
    }
  }

  def getItems do
    @names
    |> Enum.map(fn {k, v} ->
      {id, ""} = Integer.parse(k)
      price = @prices |> Map.fetch!(id |> Integer.to_string())

      %Item{
        id: id,
        name: v["name"] |> String.downcase(),
        buy_avg: price["buy_average"],
        buy_qty: price["buy_quantity"],
        overall_avg: price["overall_average"],
        overall_qty: price["overall_quantity"],
        sell_avg: price["sell_average"],
        sell_qty: price["sell_quantity"]
      }
    end)
  end

  def getCurrentPrices do
    @prices
    |> Enum.map(fn {_, v} ->
      %Price{
        item_id: v["id"],
        buy_avg: v["buy_average"],
        buy_qty: v["buy_quantity"],
        overall_avg: v["overall_average"],
        overall_qty: v["overall_quantity"],
        sell_avg: v["sell_average"],
        sell_qty: v["sell_quantity"]
      }
    end)
  end
end
