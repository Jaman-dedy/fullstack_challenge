defmodule InventoryApiWeb.ProductsController do
  use InventoryApiWeb, :controller

  alias InventoryApi.Services.ProductService

  action_fallback InventoryApiWeb.FallbackController

  def create(conn, %{"product" => product_params}) do
    case ProductService.create_product(product_params) do
      {:ok, product} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", ~p"/api/products/#{product.id}")
        |> render("show.json", product: product)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    case ProductService.get_product(id) do
      {:ok, product} ->
        render(conn, "show.json", product: product)
      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Product not found"})
    end
  end

  def update(conn, %{"id" => id, "product" => product_params}) do
    case ProductService.update_product(id, product_params) do
      {:ok, updated_product} ->
        render(conn, "show.json", product: updated_product)
      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Product not found"})
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    case ProductService.delete_product(id) do
      {:ok, _deleted_product} ->
        send_resp(conn, :no_content, "")
      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Product not found"})
      {:error, reason} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: reason})
    end
  end
end
