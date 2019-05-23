defmodule OsrsGeTracker.OSBuddy do
  alias OsrsGeTracker.GE.{Item, Price}

  def getItemNames do
    url = "https://rsbuddy.com/exchange/names.json"
    %HTTPoison.Response{body: body} = HTTPoison.get!(url)

    Poison.decode!(body)
    |> Enum.map(fn {k, v} ->
      {id, ""} = Integer.parse(k)
      %Item{id: id, name: v["name"]}
    end)
  end

  def getCurrentPrices do
    url = "https://storage.googleapis.com/osbuddy-exchange/summary.json"
    %HTTPoison.Response{body: body} = HTTPoison.get!(url)

    Poison.decode!(body)
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
