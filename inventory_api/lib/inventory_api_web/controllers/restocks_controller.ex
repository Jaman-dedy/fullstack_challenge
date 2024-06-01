defmodule InventoryApiWeb.RestocksController do
  use InventoryApiWeb, :controller

  alias InventoryApi.Services.RestockService

  action_fallback InventoryApiWeb.FallbackController

  def create(conn, %{"restock" => restock_params}) do
    case RestockService.create_restock(restock_params) do
      {:ok, restock} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", ~p"/api/restocks/#{restock.id}")
        |> render("show.json", restock: restock)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    case RestockService.get_restock(id) do
      {:ok, restock} ->
        render(conn, "show.json", restock: restock)
      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Restock not found"})
    end
  end
end
