defmodule InventoryApi.InventoryTest do
  use InventoryApi.DataCase

  alias InventoryApi.Inventory

  describe "inventories" do
    alias InventoryApi.Inventory.Inventories

    import InventoryApi.InventoryFixtures

    @invalid_attrs %{quantity: nil}

    test "list_inventories/0 returns all inventories" do
      inventories = inventories_fixture()
      assert Inventory.list_inventories() == [inventories]
    end

    test "get_inventories!/1 returns the inventories with given id" do
      inventories = inventories_fixture()
      assert Inventory.get_inventories!(inventories.id) == inventories
    end

    test "create_inventories/1 with valid data creates a inventories" do
      valid_attrs = %{quantity: 42}

      assert {:ok, %Inventories{} = inventories} = Inventory.create_inventories(valid_attrs)
      assert inventories.quantity == 42
    end

    test "create_inventories/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Inventory.create_inventories(@invalid_attrs)
    end

    test "update_inventories/2 with valid data updates the inventories" do
      inventories = inventories_fixture()
      update_attrs = %{quantity: 43}

      assert {:ok, %Inventories{} = inventories} = Inventory.update_inventories(inventories, update_attrs)
      assert inventories.quantity == 43
    end

    test "update_inventories/2 with invalid data returns error changeset" do
      inventories = inventories_fixture()
      assert {:error, %Ecto.Changeset{}} = Inventory.update_inventories(inventories, @invalid_attrs)
      assert inventories == Inventory.get_inventories!(inventories.id)
    end

    test "delete_inventories/1 deletes the inventories" do
      inventories = inventories_fixture()
      assert {:ok, %Inventories{}} = Inventory.delete_inventories(inventories)
      assert_raise Ecto.NoResultsError, fn -> Inventory.get_inventories!(inventories.id) end
    end

    test "change_inventories/1 returns a inventories changeset" do
      inventories = inventories_fixture()
      assert %Ecto.Changeset{} = Inventory.change_inventories(inventories)
    end
  end
end
