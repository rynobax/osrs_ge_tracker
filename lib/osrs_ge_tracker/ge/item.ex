defmodule OsrsGeTracker.GE.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    # Item md
    field :name, :string

    # Relations
    has_many :daily_prices, OsrsGeTracker.GE.DailyPrice
    has_many :minutely_prices, OsrsGeTracker.GE.MinutelyPrice
    has_many :hourly_prices, OsrsGeTracker.GE.HourlyPrice

    # Current price
    field :buy_avg, :float
    field :sell_avg, :float
    field :overall_avg, :float
    field :buy_qty, :float
    field :sell_qty, :float
    field :overall_qty, :float

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [
      :buy_avg,
      :sell_avg,
      :overall_avg,
      :buy_qty,
      :sell_qty,
      :overall_qty
    ])
    |> validate_required([])
  end
end
