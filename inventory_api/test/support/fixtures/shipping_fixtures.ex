defmodule InventoryApi.ShippingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `InventoryApi.Shipping` context.
  """

  @doc """
  Generate a shippings.
  """
  def shippings_fixture(attrs \\ %{}) do
    {:ok, shippings} =
      attrs
      |> Enum.into(%{
        shipped: []
      })
      |> InventoryApi.Shipping.create_shippings()

    shippings
  end
end
