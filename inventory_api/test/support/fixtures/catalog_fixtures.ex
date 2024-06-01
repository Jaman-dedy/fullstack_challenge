defmodule InventoryApi.CatalogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `InventoryApi.Catalog` context.
  """

  @doc """
  Generate a products.
  """
  def products_fixture(attrs \\ %{}) do
    {:ok, products} =
      attrs
      |> Enum.into(%{
        mass_kg: 120.5,
        product_name: "some product_name"
      })
      |> InventoryApi.Catalog.create_products()

    products
  end
end
