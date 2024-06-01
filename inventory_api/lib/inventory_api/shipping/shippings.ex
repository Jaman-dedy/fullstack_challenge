defmodule InventoryApi.Shipping.Shippings do
  use Ecto.Schema
  import Ecto.Changeset

  schema "shippings" do
    field :shipped, {:array, :map}
    field :order_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(shippings, attrs) do
    shippings
    |> cast(attrs, [:shipped])
    |> validate_required([:shipped])
  end
end
