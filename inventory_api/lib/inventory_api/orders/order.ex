defmodule InventoryApi.Orders.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field :customer_name, :string
    field :total_amount, :decimal

    timestamps()
  end

  def changeset(order, attrs) do
    order
    |> cast(attrs, [:customer_name, :total_amount])
    |> validate_required([:customer_name, :total_amount])
  end

  def create_order(attrs \\ %{}) do
    %Order{}
    |> changeset(attrs)
    |> InventoryApi.Repo.insert()
  end

  def get_order(id) do
    InventoryApi.Repo.get(Order, id)
  end

  def update_order(id, attrs) do
    get_order(id)
    |> changeset(attrs)
    |> InventoryApi.Repo.update()
  end
end
