defmodule InventoryApi.InventoryFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `InventoryApi.Inventory` context.
  """

  @doc """
  Generate a inventories.
  """
  def inventories_fixture(attrs \\ %{}) do
    {:ok, inventories} =
      attrs
      |> Enum.into(%{
        quantity: 42
      })
      |> InventoryApi.Inventory.create_inventories()

    inventories
  end
end
