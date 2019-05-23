defmodule OsrsGeTracker.OSBuddy do
  def getItemNames do
    url = "https://rsbuddy.com/exchange/names.json"
    %HTTPoison.Response{body: body} = HTTPoison.get!(url)
    Poison.decode!(body) |> Enum.map(fn {k, v} -> %{id: k, name: v["name"]} end)
  end
end
