defmodule InventoryApiWeb.InventoryController do
  use InventoryApiWeb, :controller
  alias InventoryApi.Services.InventoryService

  def create(conn, %{"product_info" => product_info}) do
    case InventoryService.init_catalog(product_info) do
      {:ok, inventory} ->
        conn
        |> put_status(:created)
        |> render("show.json", inventory: inventory)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", changeset: changeset)
    end
  end

  def process_restock(conn, %{"restock" => restock_params}) do
    case InventoryService.process_restock(restock_params) do
      :ok ->
        conn
        |> put_status(:ok)
        |> json(%{message: "Restock processed successfully"})
      {:error, reason} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: reason})
    end
  end
end
