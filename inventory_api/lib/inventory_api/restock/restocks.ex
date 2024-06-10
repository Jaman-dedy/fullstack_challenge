# defmodule InventoryApi.Restock.Restocks do
#   use Ecto.Schema
#   import Ecto.Changeset
#   alias InventoryApi.Repo

#   schema "restocks" do
#     field :product_id, :integer
#     field :quantity, :integer

#     timestamps(type: :utc_datetime)
#   end

#   @doc false
#   def changeset(restocks, attrs) do
#     restocks
#     |> cast(attrs, [:product_id, :quantity])
#     |> validate_required([:product_id, :quantity])
#   end

#   def create_restock(attrs \\ %{}) do
#     %__MODULE__{}
#     |> changeset(attrs)
#     |> Repo.insert()
#   end

#   def get_restock(id) do
#     Repo.get(__MODULE__, id)
#   end
# end
