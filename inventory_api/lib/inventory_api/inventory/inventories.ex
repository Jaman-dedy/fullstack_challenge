defmodule InventoryApi.Inventory.Inventories do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias InventoryApi.Repo
  alias InventoryApi.Catalog.Products

  @derive {Jason.Encoder, only: [:id, :quantity, :product_id, :inserted_at, :updated_at]}
  schema "inventories" do
    field :quantity, :integer
    belongs_to :product, Products

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(inventory, attrs) do
    inventory
    |> cast(attrs, [:quantity, :product_id])
    |> validate_required([:quantity, :product_id])
    |> foreign_key_constraint(:product_id)
    |> check_constraint(:quantity, name: :non_negative_quantity, message: "Quantity must be non-negative")
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

  def get_inventory_by_product_id(product_id) do
    Repo.one(from i in __MODULE__, where: i.product_id == ^product_id)
  end

  def update_inventory_quantity(product_id, quantity) do
    case get_inventory_by_product_id(product_id) do
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

  def list_inventories_with_products() do
    __MODULE__
    |> Repo.all()
    |> Repo.preload(:product)
  end

  def update_product_quantity(product_id, quantity) do
    from(i in __MODULE__,
      where: i.product_id == ^product_id,
      update: [set: [quantity: i.quantity + ^quantity]]
    )
    |> Repo.update_all([])
  end
end
