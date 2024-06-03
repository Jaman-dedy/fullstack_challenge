defmodule InventoryApiWeb.ShippingsJSON do
  alias InventoryApi.Shipping.Shippings

  @doc """
  Renders a list of shippings.
  """
  def index(%{shippings: shippings}) do
    %{data: for(shippings <- shippings, do: data(shippings))}
  end

  @doc """
  Renders a single shippings.
  """
  def show(%{shippings: shippings}) do
    %{data: data(shippings)}
  end

  defp data(%Shippings{} = shippings) do
    %{
      id: shippings.id,
      order_id: shippings.order_id,
      quantity: shippings.quantity,
      product_id: shippings.product_id
    }
  end
end
