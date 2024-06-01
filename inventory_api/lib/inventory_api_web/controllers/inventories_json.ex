defmodule InventoryApiWeb.InventoriesJSON do
  alias InventoryApi.Inventory.Inventories

  @doc """
  Renders a list of inventories.
  """
  def index(%{inventories: inventories}) do
    %{data: for(inventories <- inventories, do: data(inventories))}
  end

  @doc """
  Renders a single inventories.
  """
  def show(%{inventories: inventories}) do
    %{data: data(inventories)}
  end

  defp data(%Inventories{} = inventories) do
    %{
      id: inventories.id,
      quantity: inventories.quantity
    }
  end
end
