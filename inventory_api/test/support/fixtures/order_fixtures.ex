defmodule InventoryApi.OrderFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `InventoryApi.Order` context.
  """

  @doc """
  Generate a orders.
  """
  def orders_fixture(attrs \\ %{}) do
    {:ok, orders} =
      attrs
      |> Enum.into(%{
        requested: []
      })
      |> InventoryApi.Order.create_orders()

    orders
  end
end
