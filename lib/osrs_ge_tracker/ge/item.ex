defmodule OsrsGeTracker.GE.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :name, :string
    has_many :prices, OsrsGeTracker.GE.Price

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:item_id, :name])
    |> validate_required([:item_id, :name])
  end
end
