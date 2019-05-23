defmodule OsrsGeTracker.OSBuddy do
  def getItemNames do
    url = "https://rsbuddy.com/exchange/names.json"
    %HTTPoison.Response{body: body} = HTTPoison.get!(url)
    Poison.decode!(body) |> Enum.map(fn {k, v} -> %{id: k, name: v["name"]} end)
  end

  def getCurrentPrices do
    url = "https://storage.googleapis.com/osbuddy-exchange/summary.json"
    %HTTPoison.Response{body: body} = HTTPoison.get!(url)

    Poison.decode!(body)
    |> Enum.map(fn {k, v} ->
      %{
        item_id: k,
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
