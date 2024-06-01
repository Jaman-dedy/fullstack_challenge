defmodule InventoryApi.ShippingTest do
  use InventoryApi.DataCase

  alias InventoryApi.Shipping

  describe "shippings" do
    alias InventoryApi.Shipping.Shippings

    import InventoryApi.ShippingFixtures

    @invalid_attrs %{shipped: nil}

    test "list_shippings/0 returns all shippings" do
      shippings = shippings_fixture()
      assert Shipping.list_shippings() == [shippings]
    end

    test "get_shippings!/1 returns the shippings with given id" do
      shippings = shippings_fixture()
      assert Shipping.get_shippings!(shippings.id) == shippings
    end

    test "create_shippings/1 with valid data creates a shippings" do
      valid_attrs = %{shipped: []}

      assert {:ok, %Shippings{} = shippings} = Shipping.create_shippings(valid_attrs)
      assert shippings.shipped == []
    end

    test "create_shippings/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Shipping.create_shippings(@invalid_attrs)
    end

    test "update_shippings/2 with valid data updates the shippings" do
      shippings = shippings_fixture()
      update_attrs = %{shipped: []}

      assert {:ok, %Shippings{} = shippings} = Shipping.update_shippings(shippings, update_attrs)
      assert shippings.shipped == []
    end

    test "update_shippings/2 with invalid data returns error changeset" do
      shippings = shippings_fixture()
      assert {:error, %Ecto.Changeset{}} = Shipping.update_shippings(shippings, @invalid_attrs)
      assert shippings == Shipping.get_shippings!(shippings.id)
    end

    test "delete_shippings/1 deletes the shippings" do
      shippings = shippings_fixture()
      assert {:ok, %Shippings{}} = Shipping.delete_shippings(shippings)
      assert_raise Ecto.NoResultsError, fn -> Shipping.get_shippings!(shippings.id) end
    end

    test "change_shippings/1 returns a shippings changeset" do
      shippings = shippings_fixture()
      assert %Ecto.Changeset{} = Shipping.change_shippings(shippings)
    end
  end
end
