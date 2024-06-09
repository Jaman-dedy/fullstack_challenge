defmodule InventoryApi.Shipping.Shippings do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias InventoryApi.Repo
  alias InventoryApi.Catalog.Products

  @derive {Jason.Encoder, only: [:id, :order_id, :quantity, :product_id, :status, :inserted_at, :updated_at]}
  schema "shippings" do
    field :order_id, :integer
    field :quantity, :integer
    field :status, :string, default: "in_progress"
    belongs_to :product, Products

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(shippings, attrs) do
    shippings
    |> cast(attrs, [:order_id, :quantity, :product_id, :status])
    |> validate_required([:order_id, :quantity, :product_id])
    |> validate_number(:quantity, greater_than: 0)
    |> foreign_key_constraint(:product_id)
  end

  def create_shipping(attrs \\ %{}) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  def get_shipping(id) do
    Repo.get(__MODULE__, id)
  end

  def get_shipping_records_by_order_id(order_id) do
    Repo.all(from s in __MODULE__,
    where: s.order_id == ^order_id,
    preload: [:product]
    )
  end

  def update_shipping(%__MODULE__{} = shipping, attrs) do
    shipping
    |> changeset(attrs)
    |> Repo.update()
  end

  def delete_shipping(%__MODULE__{} = shipping) do
    Repo.delete(shipping)
  end
end
