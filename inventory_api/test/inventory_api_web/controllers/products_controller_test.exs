defmodule InventoryApiWeb.ProductsControllerTest do
  use InventoryApiWeb.ConnCase

  import InventoryApi.CatalogFixtures

  alias InventoryApi.Catalog.Products

  @create_attrs %{
    product_name: "some product_name",
    mass_kg: 120.5
  }
  @update_attrs %{
    product_name: "some updated product_name",
    mass_kg: 456.7
  }
  @invalid_attrs %{product_name: nil, mass_kg: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all products", %{conn: conn} do
      conn = get(conn, ~p"/api/products")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create products" do
    test "renders products when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/products", products: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/products/#{id}")

      assert %{
               "id" => ^id,
               "mass_kg" => 120.5,
               "product_name" => "some product_name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/products", products: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update products" do
    setup [:create_products]

    test "renders products when data is valid", %{conn: conn, products: %Products{id: id} = products} do
      conn = put(conn, ~p"/api/products/#{products}", products: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/products/#{id}")

      assert %{
               "id" => ^id,
               "mass_kg" => 456.7,
               "product_name" => "some updated product_name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, products: products} do
      conn = put(conn, ~p"/api/products/#{products}", products: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete products" do
    setup [:create_products]

    test "deletes chosen products", %{conn: conn, products: products} do
      conn = delete(conn, ~p"/api/products/#{products}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/products/#{products}")
      end
    end
  end

  defp create_products(_) do
    products = products_fixture()
    %{products: products}
  end
end
