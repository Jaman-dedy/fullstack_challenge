defmodule InventoryApiWeb.InventoriesController do
  use InventoryApiWeb, :controller

  alias InventoryApi.Inventory
  alias InventoryApi.Inventory.Inventories

  action_fallback InventoryApiWeb.FallbackController

  def init_catalog(conn, %{"product_info" => product_info}) do
    case InventoryService.init_catalog(product_info) do
      {:ok, inventory} ->
        render(conn, "init_catalog.json", inventory: inventory)
      {:error, reason} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: reason})
    end
  end

  def process_restock(conn, %{"restock" => restock_params}) do
    case InventoryService.process_restock(restock_params) do
      :ok ->
        send_resp(conn, :ok, "")
      {:error, reason} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: reason})
    end
  end

  def index(conn, _params) do
    inventories = Inventory.list_inventories()
    render(conn, :index, inventories: inventories)
  end

  def create(conn, %{"inventories" => inventories_params}) do
    with {:ok, %Inventories{} = inventories} <- Inventory.create_inventories(inventories_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/inventories/#{inventories}")
      |> render(:show, inventories: inventories)
    end
  end

  def show(conn, %{"id" => id}) do
    inventories = Inventory.get_inventories!(id)
    render(conn, :show, inventories: inventories)
  end

  def update(conn, %{"id" => id, "inventories" => inventories_params}) do
    inventories = Inventory.get_inventories!(id)

    with {:ok, %Inventories{} = inventories} <- Inventory.update_inventories(inventories, inventories_params) do
      render(conn, :show, inventories: inventories)
    end
  end

  def delete(conn, %{"id" => id}) do
    inventories = Inventory.get_inventories!(id)

    with {:ok, %Inventories{}} <- Inventory.delete_inventories(inventories) do
      send_resp(conn, :no_content, "")
    end
  end
end
