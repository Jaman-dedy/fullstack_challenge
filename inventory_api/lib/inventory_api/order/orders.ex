defmodule InventoryApi.Order.Orders do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias InventoryApi.Repo
  alias InventoryApi.Catalog.Products

  schema "orders" do
    field :order_id, :integer
    field :quantity, :integer
    field :status, :string, default: "pending"
    belongs_to :product, Products
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(orders, attrs) do
    orders
    |> cast(attrs, [:order_id, :product_id, :quantity, :status])
    |> validate_required([:order_id, :product_id, :quantity])
    |> foreign_key_constraint(:product_id)
  end

  def create_order(attrs \\ %{}) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  def create_order_item(attrs \\ %{}) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  def get_order(id) do
    Repo.get(__MODULE__, id)
  end

  def get_order_item_by_order_and_product(order_id, product_id) do
    Repo.one(
      from order_item in __MODULE__,
      where: order_item.order_id == ^order_id and order_item.product_id == ^product_id,
      limit: 1
    )
  end

  def get_order_items_by_order_id(order_id) do
    Repo.all(
      from order_item in __MODULE__,
      where: order_item.order_id == ^order_id
    )
  end

  defp get_order_item_by_order_id_and_product_id(order_id, product_id) do
    Repo.get_by(OrderItem, order_id: order_id, product_id: product_id)
  end

  def update_order_item_quantity(order_id, product_id, quantity_change) do
    order_item = get_order_item_by_order_id_and_product_id(order_id, product_id)
    if order_item do
      new_quantity = order_item.quantity + quantity_change
      update_order_item(order_item, %{quantity: new_quantity})
    else
      {:error, "Order item not found for order ID #{order_id} and product ID #{product_id}"}
    end
  end

  def get_order_items_by_product_ids(product_ids) do
    Repo.all(
      from order_item in __MODULE__,
      where: order_item.product_id in ^product_ids
    )
  end

  def update_order(%__MODULE__{} = order, attrs) do
    order
    |> changeset(attrs)
    |> Repo.update()
  end

  def update_order_item(%__MODULE__{} = order_item, attrs) do
    order_item
    |> changeset(attrs)
    |> Repo.update()
  end

  def delete_order(%__MODULE__{} = order) do
    Repo.delete(order)
  end

  def list_orders() do
    Repo.all(__MODULE__)
  end
end
