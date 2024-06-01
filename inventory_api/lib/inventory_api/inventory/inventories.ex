defmodule InventoryApi.Inventory.Inventories do
  use Ecto.Schema
  import Ecto.Changeset
  alias InventoryApi.Repo

  schema "inventories" do
    field :quantity, :integer
    field :product_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(inventories, attrs) do
    inventories
    |> cast(attrs, [:quantity, :product_id])
    |> validate_required([:quantity, :product_id])
    |> foreign_key_constraint(:product_id)
  end

  def create_inventory(attrs \\ %{}) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  def get_inventory(id) do
    Repo.get(__MODULE__, id)
  end

  def update_inventory(%__MODULE__{} = inventory, attrs) do
    inventory
    |> changeset(attrs)
    |> Repo.update()
  end

  def get_inventory_by_product(product_id) do
    Repo.get_by(__MODULE__, product_id: product_id)
  end

  def update_inventory_quantity(product_id, quantity) do
    case get_inventory_by_product(product_id) do
      nil ->
        create_inventory(%{product_id: product_id, quantity: quantity})
      inventory ->
        update_inventory(inventory, %{quantity: inventory.quantity + quantity})
    end
  end

  def delete_inventory(%__MODULE__{} = inventory) do
    Repo.delete(inventory)
  end

  def list_inventories() do
    Repo.all(__MODULE__)
  end

  # def update_product_quantity(product_id, quantity) do
  #   from(i in __MODULE__,
  #     where: i.product_id == ^product_id,
  #     update: [set: [quantity: i.quantity + ^quantity]]
  #   )
  #   |> Repo.update_all([])
  # end
end
