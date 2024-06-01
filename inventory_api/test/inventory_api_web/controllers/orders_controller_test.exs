defmodule InventoryApiWeb.OrdersControllerTest do
  use InventoryApiWeb.ConnCase

  import InventoryApi.OrderFixtures

  alias InventoryApi.Order.Orders

  @create_attrs %{
    requested: []
  }
  @update_attrs %{
    requested: []
  }
  @invalid_attrs %{requested: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all orders", %{conn: conn} do
      conn = get(conn, ~p"/api/orders")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create orders" do
    test "renders orders when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/orders", orders: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/orders/#{id}")

      assert %{
               "id" => ^id,
               "requested" => []
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/orders", orders: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update orders" do
    setup [:create_orders]

    test "renders orders when data is valid", %{conn: conn, orders: %Orders{id: id} = orders} do
      conn = put(conn, ~p"/api/orders/#{orders}", orders: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/orders/#{id}")

      assert %{
               "id" => ^id,
               "requested" => []
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, orders: orders} do
      conn = put(conn, ~p"/api/orders/#{orders}", orders: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete orders" do
    setup [:create_orders]

    test "deletes chosen orders", %{conn: conn, orders: orders} do
      conn = delete(conn, ~p"/api/orders/#{orders}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/orders/#{orders}")
      end
    end
  end

  defp create_orders(_) do
    orders = orders_fixture()
    %{orders: orders}
  end
end
