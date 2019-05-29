# Script for getting item image assets
#
#     mix run priv/repo/item_images.exs
#

defmodule OsrsGeTracker.ItemImages do
  alias OsrsGeTracker.OSBuddy
  require Logger

  defp getFP(id) do
    "./assets/static/images/items/#{id}.png"
  end

  defp getWikiURL(id) do
    "https://oldschool.runescape.wiki/w/Special:Lookup?type=item&id=#{id}"
  end

  def main do
    OSBuddy.getItems()
    |> Enum.map(&Map.from_struct/1)
    |> Enum.filter(fn e -> e.id == 2 end)
    |> Enum.map(fn %{:id => id} ->
      Logger.info(id)

      # check if file exists
      fp = getFP(id)

      case File.read(fp) do
        # Do nothing
        {:ok, _} ->
          Logger.info("already have it")
          nil

        # Need to add image
        {:error, :enoent} ->
          # Use lookup to get real page url
          %HTTPoison.Response{headers: headers} = HTTPoison.get!(getWikiURL(id))
          {_, redirect_url} = List.keyfind(headers, "Location", 0)
          Logger.info(redirect_url)

          # Get wiki page html
          %HTTPoison.Response{body: body} = HTTPoison.get!(redirect_url)

          # Will look something like:
          # https://oldschool.runescape.wiki/images/7/73/Cannonball_detail.png?3f7a7

          [image_url] =
            body
            |> String.split("\"")
            |> Enum.filter(fn s -> String.match?(s, ~r/.*\.wiki\/.*_detail\.png\?\w*$/) end)

          Logger.info(image_url)

          %HTTPoison.Response{body: image} = HTTPoison.get!(image_url)
          :ok = File.write(fp, image)
      end

      # if it does, do nothing
      # if it doesnt, get image
    end)
  end
end

OsrsGeTracker.ItemImages.main()
