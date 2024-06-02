defmodule InventoryApiWeb.ProductsJSON do
  alias InventoryApi.Catalog.Products

  @doc """
  Renders a list of products.
  """
  def index(%{products: products}) do
    %{data: for(products <- products, do: data(products))}
  end

  @doc """
  Renders a single products.
  """
  def show(%{products: products}) do
    %{data: data(products)}
  end

  defp data(%Products{} = products) do
    %{
      id: products.id,
      product_name: products.product_name,
      mass_kg: products.mass_kg,
      product_id: products.product_id,
    }
  end
end
