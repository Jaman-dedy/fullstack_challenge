defmodule InventoryApi.Catalog.Products do
  use Ecto.Schema
  import Ecto.Changeset
  alias InventoryApi.Repo

  schema "products" do
    field :name, :string
    field :mass_kg, :float

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(products, attrs) do
    products
    |> cast(attrs, [:name, :mass_kg])
    |> validate_required([:name, :mass_kg])
  end

  def create_product(attrs \\ %{}) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  def get_product(id) do
    Repo.get(__MODULE__, id)
  end

  def update_product(%__MODULE__{} = product, attrs) do
    product
    |> changeset(attrs)
    |> Repo.update()
  end

  def delete_product(%__MODULE__{} = product) do
    Repo.delete(product)
  end
end
