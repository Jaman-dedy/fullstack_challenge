defmodule InventoryApiWeb.OrdersJSON do
  alias InventoryApi.Order.Orders

  @doc """
  Renders a list of orders.
  """
  def index(%{orders: orders}) do
    %{data: for(orders <- orders, do: data(orders))}
  end

  @doc """
  Renders a single orders.
  """
  def show(%{orders: orders}) do
    %{data: data(orders)}
  end

  defp data(%Orders{} = orders) do
    %{
      id: orders.id,
    }
  end
end
