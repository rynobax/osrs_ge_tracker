defmodule OsrsGeTracker.GE.DailyPrice do
  use Ecto.Schema
  import Ecto.Changeset

  schema "daily_prices" do
    field :buy_avg, :integer
    field :buy_qty, :integer
    field :overall_avg, :integer
    field :overall_qty, :integer
    field :sell_avg, :integer
    field :sell_qty, :integer
    belongs_to :item, OsrsGeTracker.GE.Item

    timestamps(updated_at: false)
  end

  @doc false
  def changeset(price, attrs) do
    price
    |> cast(attrs, [:item_id, :buy_avg, :sell_avg, :overall_avg, :buy_qty, :sell_qty, :overall_qty])
    |> validate_required([:item_id, :buy_avg, :sell_avg, :overall_avg, :buy_qty, :sell_qty, :overall_qty])
  end
end
