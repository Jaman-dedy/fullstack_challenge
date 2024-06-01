defmodule InventoryApi.Inventory.Inventories do
  use Ecto.Schema
  import Ecto.Changeset

  schema "inventories" do
    field :quantity, :integer
    field :product_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(inventories, attrs) do
    inventories
    |> cast(attrs, [:quantity])
    |> validate_required([:quantity])
  end
end
