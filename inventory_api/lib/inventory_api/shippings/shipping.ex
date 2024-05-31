defmodule InventoryApi.Shippings.Shipping do
  use Ecto.Schema
  import Ecto.Changeset

  schema "shippings" do
    field :tracking_number, :string
    field :status, :string

    timestamps()
  end

  def changeset(shipping, attrs) do
    shipping
    |> cast(attrs, [:tracking_number, :status])
    |> validate_required([:tracking_number, :status])
  end

  def create_shipping(attrs \\ %{}) do
    %Shipping{}
    |> changeset(attrs)
    |> InventoryApi.Repo.insert()
  end

  def get_shipping(id) do
    InventoryApi.Repo.get(Shipping, id)
  end

  def update_shipping(id, attrs) do
    get_shipping(id)
    |> changeset(attrs)
    |> InventoryApi.Repo.update()
  end
end
