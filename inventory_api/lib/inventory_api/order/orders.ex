defmodule InventoryApi.Order.Orders do
  use Ecto.Schema
  import Ecto.Changeset
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

  def update_order(%__MODULE__{} = order, attrs) do
    order
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
