defmodule InventoryApi.Inventories.Inventory do
  use Ecto.Schema
  import Ecto.Changeset

  schema "inventories" do
    field :name, :string
    field :quantity, :integer

    timestamps()
  end

  def changeset(inventory, attrs) do
    inventory
    |> cast(attrs, [:name, :quantity])
    |> validate_required([:name, :quantity])
  end

  def create_inventory(attrs \\ %{}) do
    %Inventory{}
    |> changeset(attrs)
    |> InventoryApi.Repo.insert()
  end

  def get_inventory(id) do
    InventoryApi.Repo.get(Inventory, id)
  end

  def update_inventory(id, attrs) do
    get_inventory(id)
    |> changeset(attrs)
    |> InventoryApi.Repo.update()
  end
end
