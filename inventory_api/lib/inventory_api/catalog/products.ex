defmodule InventoryApi.Catalog.Products do
  use Ecto.Schema
  import Ecto.Changeset
  alias InventoryApi.Repo
  alias InventoryApi.Inventory.Inventories
  alias InventoryApi.Order.Orders

  schema "products" do
    field :product_name, :string
    field :mass_kg, :float
    field :product_id, :integer
    has_many :inventories, Inventories, foreign_key: :product_id
    has_many :orders, Orders, foreign_key: :product_id
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:product_name, :mass_kg, :product_id])
    |> validate_required([:product_name, :mass_kg, :product_id])
    |> validate_number(:mass_kg, greater_than: 0)
    |> validate_number(:product_id, greater_than_or_equal_to: 0)
    |> unique_constraint(:product_name)
    |> unique_constraint(:product_id)
  end

  def create_product(attrs \\ %{}) do

    result = %__MODULE__{}
             |> changeset(attrs)
             |> Repo.insert()

    case result do
      {:ok, product} ->
        {:ok, product}
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def get_product(id) do
    Repo.get(__MODULE__, id)
  end

  def get_product_by_name(name) do
    Repo.get_by(__MODULE__, name: name)
  end

  def update_product(%__MODULE__{} = product, attrs) do
    product
    |> changeset(attrs)
    |> Repo.update()
  end

  def delete_product(%__MODULE__{} = product) do
    Repo.delete(product)
  end

  def list_products() do
    Repo.all(__MODULE__)
  end
end
