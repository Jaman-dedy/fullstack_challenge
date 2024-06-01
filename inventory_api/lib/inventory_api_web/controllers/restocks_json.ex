defmodule InventoryApiWeb.RestocksJSON do
  alias InventoryApi.Restock.Restocks

  @doc """
  Renders a list of restocks.
  """
  def index(%{restocks: restocks}) do
    %{data: for(restocks <- restocks, do: data(restocks))}
  end

  @doc """
  Renders a single restocks.
  """
  def show(%{restocks: restocks}) do
    %{data: data(restocks)}
  end

  defp data(%Restocks{} = restocks) do
    %{
      id: restocks.id,
      quantity: restocks.quantity
    }
  end
end
