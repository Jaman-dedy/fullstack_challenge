defmodule InventoryApiWeb.ShippingsControllerTest do
  use InventoryApiWeb.ConnCase

  import InventoryApi.ShippingFixtures

  alias InventoryApi.Shipping.Shippings

  @create_attrs %{
    shipped: []
  }
  @update_attrs %{
    shipped: []
  }
  @invalid_attrs %{shipped: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all shippings", %{conn: conn} do
      conn = get(conn, ~p"/api/shippings")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create shippings" do
    test "renders shippings when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/shippings", shippings: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/shippings/#{id}")

      assert %{
               "id" => ^id,
               "shipped" => []
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/shippings", shippings: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update shippings" do
    setup [:create_shippings]

    test "renders shippings when data is valid", %{conn: conn, shippings: %Shippings{id: id} = shippings} do
      conn = put(conn, ~p"/api/shippings/#{shippings}", shippings: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/shippings/#{id}")

      assert %{
               "id" => ^id,
               "shipped" => []
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, shippings: shippings} do
      conn = put(conn, ~p"/api/shippings/#{shippings}", shippings: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete shippings" do
    setup [:create_shippings]

    test "deletes chosen shippings", %{conn: conn, shippings: shippings} do
      conn = delete(conn, ~p"/api/shippings/#{shippings}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/shippings/#{shippings}")
      end
    end
  end

  defp create_shippings(_) do
    shippings = shippings_fixture()
    %{shippings: shippings}
  end
end
