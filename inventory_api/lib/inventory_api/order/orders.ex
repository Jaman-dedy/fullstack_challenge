defmodule InventoryApi.Order.Orders do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field :requested, {:array, :map}

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(orders, attrs) do
    orders
    |> cast(attrs, [:requested])
    |> validate_required([:requested])
  end
end
