defmodule InventoryApiWeb.InventoriesControllerTest do
  use InventoryApiWeb.ConnCase

  import InventoryApi.InventoryFixtures

  alias InventoryApi.Inventory.Inventories

  @create_attrs %{
    quantity: 42
  }
  @update_attrs %{
    quantity: 43
  }
  @invalid_attrs %{quantity: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all inventories", %{conn: conn} do
      conn = get(conn, ~p"/api/inventories")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create inventories" do
    test "renders inventories when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/inventories", inventories: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/inventories/#{id}")

      assert %{
               "id" => ^id,
               "quantity" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/inventories", inventories: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update inventories" do
    setup [:create_inventories]

    test "renders inventories when data is valid", %{conn: conn, inventories: %Inventories{id: id} = inventories} do
      conn = put(conn, ~p"/api/inventories/#{inventories}", inventories: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/inventories/#{id}")

      assert %{
               "id" => ^id,
               "quantity" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, inventories: inventories} do
      conn = put(conn, ~p"/api/inventories/#{inventories}", inventories: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete inventories" do
    setup [:create_inventories]

    test "deletes chosen inventories", %{conn: conn, inventories: inventories} do
      conn = delete(conn, ~p"/api/inventories/#{inventories}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/inventories/#{inventories}")
      end
    end
  end

  defp create_inventories(_) do
    inventories = inventories_fixture()
    %{inventories: inventories}
  end
end
