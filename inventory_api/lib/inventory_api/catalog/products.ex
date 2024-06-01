defmodule InventoryApi.Catalog.Products do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :product_name, :string
    field :mass_kg, :float

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(products, attrs) do
    products
    |> cast(attrs, [:product_name, :mass_kg])
    |> validate_required([:product_name, :mass_kg])
  end
end
