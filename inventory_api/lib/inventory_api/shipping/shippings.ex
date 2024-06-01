defmodule InventoryApi.Shipping.Shippings do
  use Ecto.Schema
  import Ecto.Changeset
  alias InventoryApi.Repo

  schema "shippings" do
    field :shipped, {:array, :map}
    field :order_id, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(shippings, attrs) do
    shippings
    |> cast(attrs, [:shipped, :order_id])
    |> validate_required([:shipped, :order_id])
  end

  def create_shipping(attrs \\ %{}) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  def get_shipping(id) do
    Repo.get(__MODULE__, id)
  end

  def update_shipping(%__MODULE__{} = shipping, attrs) do
    shipping
    |> changeset(attrs)
    |> Repo.update()
  end

  def delete_shipping(%__MODULE__{} = shipping) do
    Repo.delete(shipping)
  end

  def list_shippings() do
    Repo.all(__MODULE__)
  end
end
