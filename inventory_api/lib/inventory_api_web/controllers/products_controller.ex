defmodule InventoryApiWeb.ProductsController do
  use InventoryApiWeb, :controller

  alias InventoryApi.Catalog
  alias InventoryApi.Catalog.Products

  action_fallback InventoryApiWeb.FallbackController

  def index(conn, _params) do
    products = Catalog.list_products()
    render(conn, :index, products: products)
  end

  def create(conn, %{"products" => products_params}) do
    with {:ok, %Products{} = products} <- Catalog.create_products(products_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/products/#{products}")
      |> render(:show, products: products)
    end
  end

  def show(conn, %{"id" => id}) do
    products = Catalog.get_products!(id)
    render(conn, :show, products: products)
  end

  def update(conn, %{"id" => id, "products" => products_params}) do
    products = Catalog.get_products!(id)

    with {:ok, %Products{} = products} <- Catalog.update_products(products, products_params) do
      render(conn, :show, products: products)
    end
  end

  def delete(conn, %{"id" => id}) do
    products = Catalog.get_products!(id)

    with {:ok, %Products{}} <- Catalog.delete_products(products) do
      send_resp(conn, :no_content, "")
    end
  end
end
