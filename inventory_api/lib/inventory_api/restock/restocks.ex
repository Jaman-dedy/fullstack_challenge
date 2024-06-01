defmodule InventoryApi.Restock.Restocks do
  use Ecto.Schema
  import Ecto.Changeset

  schema "restocks" do
    field :quantity, :integer
    field :product_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(restocks, attrs) do
    restocks
    |> cast(attrs, [:quantity])
    |> validate_required([:quantity])
  end
end
