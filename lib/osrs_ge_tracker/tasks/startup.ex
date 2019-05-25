defmodule OsrsGeTracker.Startup do
  use GenServer
  require Logger

  alias OsrsGeTracker.{GE, Repo, OSBuddy}

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: Startup)
  end

  def init(init_arg) do
    maybe_init_items()
    {:ok, init_arg}
  end

  defp maybe_init_items do
    unless GE.item_table_populated() or Mix.env() == :test do
      Logger.info("Items were not populated, populating them now!")
      OSBuddy.getItems() |> Enum.map(&Repo.insert!/1)
    end
  end
end
