# Script for getting item image assets
#
#     mix run priv/repo/item_images.exs
#

defmodule ItemImages do
  alias OsrsGeTracker.OSBuddy
  require Logger

  defp getFP(id) do
    "./assets/static/images/items/#{id}.png"
  end

  defp getMissingFP(id) do
    "./assets/static/images/items/_MISSING_#{id}.png"
  end

  defp getWikiURL(id) do
    "https://oldschool.runescape.wiki/w/Special:Lookup?type=item&id=#{id}"
  end

  def main do
    items = OSBuddy.getItems()
    i = 0
    allLen = length(items)

    items
    |> Enum.map(&Map.from_struct/1)
    # 1513 magic log
    # 3448 magic pyre log
    # 12771 volcanic whip mix
    |> Enum.filter(fn e -> e.id == 12771 end)
    |> Enum.reduce(
      0,
      fn %{:id => id}, i ->
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

            # image_urlish will look something like:
            # https://oldschool.runescape.wiki/images/7/73/Cannonball_detail.png?3f7a7
            # or
            # /images/thumb/b/b0/Dragon_javelin_detail.png/150px-Dragon_javelin_detail.png?113f4 1.5x

            reg =
              ~r/\/images\/thumb\/(?<p1>.)\/(?<p2>..)\/.*-(?<name>.*_detail).png\?(?<token>.*?)(\W|$)/

            image_urlish_list =
              body
              |> String.split("\"")
              |> Enum.filter(fn s -> String.contains?(s, "png") end)
              # |> Enum.map(fn e ->
              #   Logger.info(e)
              #   e
              # end)
              |> Enum.filter(fn s -> String.match?(s, reg) end)

            # |> Enum.map(fn e ->
            #   Logger.info("FOUND")
            #   Logger.info(e)

            #   e
            # end)

            case length(image_urlish_list) do
              0 ->
                :ok = File.write(getMissingFP(id), "")

              _ ->
                image_urlish = hd(image_urlish_list)
                Logger.info(image_urlish)

                %{"name" => name, "p1" => p1, "p2" => p2, "token" => token} =
                  Regex.named_captures(reg, image_urlish)

                # HD image looks like
                # https://oldschool.runescape.wiki/images/b/b0/Dragon_javelin_detail.png?113f4
                image_url =
                  "https://oldschool.runescape.wiki/images/#{p1}/#{p2}/#{name}.png?#{token}"

                Logger.info(image_url)

                %HTTPoison.Response{body: image} = HTTPoison.get!(image_url)
                :ok = File.write(fp, image)
            end
        end

        Logger.info("#{i} of #{allLen}")
        i + 1
      end
    )
  end
end

ItemImages.main()
