defmodule InventoryApi.RestockTest do
  use InventoryApi.DataCase

  alias InventoryApi.Restock

  describe "restocks" do
    alias InventoryApi.Restock.Restocks

    import InventoryApi.RestockFixtures

    @invalid_attrs %{quantity: nil}

    test "list_restocks/0 returns all restocks" do
      restocks = restocks_fixture()
      assert Restock.list_restocks() == [restocks]
    end

    test "get_restocks!/1 returns the restocks with given id" do
      restocks = restocks_fixture()
      assert Restock.get_restocks!(restocks.id) == restocks
    end

    test "create_restocks/1 with valid data creates a restocks" do
      valid_attrs = %{quantity: 42}

      assert {:ok, %Restocks{} = restocks} = Restock.create_restocks(valid_attrs)
      assert restocks.quantity == 42
    end

    test "create_restocks/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Restock.create_restocks(@invalid_attrs)
    end

    test "update_restocks/2 with valid data updates the restocks" do
      restocks = restocks_fixture()
      update_attrs = %{quantity: 43}

      assert {:ok, %Restocks{} = restocks} = Restock.update_restocks(restocks, update_attrs)
      assert restocks.quantity == 43
    end

    test "update_restocks/2 with invalid data returns error changeset" do
      restocks = restocks_fixture()
      assert {:error, %Ecto.Changeset{}} = Restock.update_restocks(restocks, @invalid_attrs)
      assert restocks == Restock.get_restocks!(restocks.id)
    end

    test "delete_restocks/1 deletes the restocks" do
      restocks = restocks_fixture()
      assert {:ok, %Restocks{}} = Restock.delete_restocks(restocks)
      assert_raise Ecto.NoResultsError, fn -> Restock.get_restocks!(restocks.id) end
    end

    test "change_restocks/1 returns a restocks changeset" do
      restocks = restocks_fixture()
      assert %Ecto.Changeset{} = Restock.change_restocks(restocks)
    end
  end
end
