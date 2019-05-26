defmodule OsrsGeTracker.OSBuddy do
  alias OsrsGeTracker.GE.{Item, Price}

  # / 1 to convert to float

  def getItems do
    nameUrl = "https://rsbuddy.com/exchange/names.json"
    %HTTPoison.Response{body: nameBody} = HTTPoison.get!(nameUrl)

    priceUrl = "https://storage.googleapis.com/osbuddy-exchange/summary.json"
    %HTTPoison.Response{body: priceBody} = HTTPoison.get!(priceUrl)

    prices = Poison.decode!(priceBody)

    Poison.decode!(nameBody)
    |> Enum.map(fn {k, v} ->
      {id, ""} = Integer.parse(k)
      price = prices |> Map.fetch!(id |> Integer.to_string())

      %Item{
        id: id,
        name: v["name"] |> String.downcase(),
        buy_avg: price["buy_average"] / 1,
        buy_qty: price["buy_quantity"] / 1,
        overall_avg: price["overall_average"] / 1,
        overall_qty: price["overall_quantity"] / 1,
        sell_avg: price["sell_average"] / 1,
        sell_qty: price["sell_quantity"] / 1
      }
    end)
  end

  def getCurrentPrices do
    url = "https://storage.googleapis.com/osbuddy-exchange/summary.json"
    %HTTPoison.Response{body: body} = HTTPoison.get!(url)

    Poison.decode!(body)
    |> Enum.map(fn {_, v} ->
      %Price{
        item_id: v["id"],
        buy_avg: v["buy_average"] / 1,
        buy_qty: v["buy_quantity"] / 1,
        overall_avg: v["overall_average"] / 1,
        overall_qty: v["overall_quantity"] / 1,
        sell_avg: v["sell_average"] / 1,
        sell_qty: v["sell_quantity"] / 1
      }
    end)
  end
end
