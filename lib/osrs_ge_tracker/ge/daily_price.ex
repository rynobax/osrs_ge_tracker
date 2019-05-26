defmodule OsrsGeTracker.GE.DailyPrice do
  use Ecto.Schema
  import Ecto.Changeset

  schema "daily_prices" do
    field :buy_avg, :float
    field :buy_qty, :float
    field :overall_avg, :float
    field :overall_qty, :float
    field :sell_avg, :float
    field :sell_qty, :float
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
