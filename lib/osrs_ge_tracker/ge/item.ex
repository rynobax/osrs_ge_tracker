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
    field :buy_avg, :integer
    field :sell_avg, :integer
    field :overall_avg, :integer
    field :buy_qty, :integer
    field :sell_qty, :integer
    field :overall_qty, :integer

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:item_id, :name])
    |> validate_required([:item_id, :name])
  end
end
