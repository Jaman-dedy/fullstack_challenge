defmodule InventoryApiWeb.RestocksControllerTest do
  use InventoryApiWeb.ConnCase

  import InventoryApi.RestockFixtures

  alias InventoryApi.Restock.Restocks

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
    test "lists all restocks", %{conn: conn} do
      conn = get(conn, ~p"/api/restocks")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create restocks" do
    test "renders restocks when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/restocks", restocks: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/restocks/#{id}")

      assert %{
               "id" => ^id,
               "quantity" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/restocks", restocks: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update restocks" do
    setup [:create_restocks]

    test "renders restocks when data is valid", %{conn: conn, restocks: %Restocks{id: id} = restocks} do
      conn = put(conn, ~p"/api/restocks/#{restocks}", restocks: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/restocks/#{id}")

      assert %{
               "id" => ^id,
               "quantity" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, restocks: restocks} do
      conn = put(conn, ~p"/api/restocks/#{restocks}", restocks: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete restocks" do
    setup [:create_restocks]

    test "deletes chosen restocks", %{conn: conn, restocks: restocks} do
      conn = delete(conn, ~p"/api/restocks/#{restocks}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/restocks/#{restocks}")
      end
    end
  end

  defp create_restocks(_) do
    restocks = restocks_fixture()
    %{restocks: restocks}
  end
end
