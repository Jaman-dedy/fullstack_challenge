defmodule InventoryApi.RestockFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `InventoryApi.Restock` context.
  """

  @doc """
  Generate a restocks.
  """
  def restocks_fixture(attrs \\ %{}) do
    {:ok, restocks} =
      attrs
      |> Enum.into(%{
        quantity: 42
      })
      |> InventoryApi.Restock.create_restocks()

    restocks
  end
end
