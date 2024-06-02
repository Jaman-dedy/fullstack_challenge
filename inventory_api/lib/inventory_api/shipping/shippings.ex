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
    |> validate_shipment()
  end

  defp validate_shipment(changeset) do
    shipped_items = get_field(changeset, :shipped)
    if is_list(shipped_items) and length(shipped_items) > 0 do
      if Enum.all?(shipped_items, &is_valid_item?/1) do
        changeset
      else
        add_error(changeset, :shipped, "Invalid shipped items")
      end
    else
      add_error(changeset, :shipped, "Shipped items must be a non-empty list")
    end
  end

  defp is_valid_item?(item) do
    is_map(item) and Map.has_key?(item, "product_id") and Map.has_key?(item, "quantity")
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
