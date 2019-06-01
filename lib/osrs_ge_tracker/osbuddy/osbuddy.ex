defmodule OsrsGeTracker.OSBuddy do
  alias OsrsGeTracker.GE.{Item, Price}
  require Logger

  def getItems do
    nameUrl = "https://rsbuddy.com/exchange/names.json"
    %HTTPoison.Response{body: nameBody} = HTTPoison.get!(nameUrl)

    priceUrl = "https://storage.googleapis.com/osbuddy-exchange/summary.json"
    %HTTPoison.Response{body: priceBody} = HTTPoison.get!(priceUrl)

    limitIdsUrl =
      "https://raw.githubusercontent.com/osrsbox/osrsbox-db/master/data/ge-limits-ids.json"

    %HTTPoison.Response{body: limitIdsBody} = HTTPoison.get!(limitIdsUrl)

    limitNamesUrl = "https://raw.githubusercontent.com/osrsbox/osrsbox-db/master/data/ge-limits-names.json"
    %HTTPoison.Response{body: limitNamesBody} = HTTPoison.get!(limitNamesUrl)

    prices = Poison.decode!(priceBody)
    limitsIds = Poison.decode!(limitIdsBody)
    limitsNames = Poison.decode!(limitNamesBody)

    Poison.decode!(nameBody)
    |> Enum.map(fn {k, v} ->
      {id, ""} = Integer.parse(k)
      price = prices |> Map.fetch!(id |> Integer.to_string())
      Logger.info("#{id}, #{v["name"]}")

      name = v["name"]

      idLimit = Map.fetch(limitsIds, id |> Integer.to_string())
      nameLimit = Map.fetch(limitsNames, name)

      buy_limit =
        case {idLimit, nameLimit} do
          {:error, :error} -> nil
          {{:ok, limit}, :error} -> limit
          {:error, {:ok, limit}} -> limit
          {{:ok, limit}, _} -> limit
        end

      %Item{
        id: id,
        name: name |> String.downcase(),
        buy_limit: buy_limit,
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
