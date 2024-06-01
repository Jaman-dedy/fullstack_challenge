defmodule InventoryApiWeb.RestocksController do
  use InventoryApiWeb, :controller

  alias InventoryApi.Restock
  alias InventoryApi.Restock.Restocks

  action_fallback InventoryApiWeb.FallbackController

  def index(conn, _params) do
    restocks = Restock.list_restocks()
    render(conn, :index, restocks: restocks)
  end

  def create(conn, %{"restocks" => restocks_params}) do
    with {:ok, %Restocks{} = restocks} <- Restock.create_restocks(restocks_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/restocks/#{restocks}")
      |> render(:show, restocks: restocks)
    end
  end

  def show(conn, %{"id" => id}) do
    restocks = Restock.get_restocks!(id)
    render(conn, :show, restocks: restocks)
  end

  def update(conn, %{"id" => id, "restocks" => restocks_params}) do
    restocks = Restock.get_restocks!(id)

    with {:ok, %Restocks{} = restocks} <- Restock.update_restocks(restocks, restocks_params) do
      render(conn, :show, restocks: restocks)
    end
  end

  def delete(conn, %{"id" => id}) do
    restocks = Restock.get_restocks!(id)

    with {:ok, %Restocks{}} <- Restock.delete_restocks(restocks) do
      send_resp(conn, :no_content, "")
    end
  end
end
