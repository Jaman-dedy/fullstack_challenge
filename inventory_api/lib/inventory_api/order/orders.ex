defmodule InventoryApi.Order.Orders do
  use Ecto.Schema
  import Ecto.Changeset
  alias InventoryApi.Repo

  schema "orders" do
    field :order_id, :integer
    field :requested, {:array, :map}

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(orders, attrs) do
    orders
    |> cast(attrs, [:order_id, :requested])
    |> validate_required([:order_id, :requested])
  end

  def create_order(attrs \\ %{}) do
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
