defmodule InventoryApiWeb.InventoriesController do
  use InventoryApiWeb, :controller

  alias InventoryApi.Inventory.Inventories
  alias InventoryApi.Services.InventoryService

  action_fallback InventoryApiWeb.FallbackController

  def init_catalog(conn, %{"product_info" => product_info}) do
    case InventoryService.init_catalog(product_info) do
      {:ok, :catalog_initialized} ->
        conn
        |> put_status(:ok)
        |> json(%{message: "Product catalog initialized successfully"})

      {:error, :catalog_already_initialized} ->
        conn
        |> put_status(:bad_request)
        |> json(%{message: "Product catalog has already been initialized"})

      {:error, :empty_catalog} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{message: "Empty product catalog"})

      {:error, :duplicate_product_id} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{message: "Duplicate product_id found"})

      {:error, :invalid_mass_kg} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{message: "Invalid mass_kg value"})

      {:error, :invalid_product_name} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{message: "Missing or invalid product_name"})

      {:error, :invalid_product_id} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{message: "Missing or invalid product_id"})
    end
  end

  def re_init_catalog(conn, _params) do
    case InventoryService.reinitialize_catalog() do
      {:ok, :catalog_reinitialized} ->
        conn
        |> put_status(:ok)
        |> json(%{message: "Product catalog reinitialized successfully"})
    end
  end

  def process_restock(conn, %{"restock" => restock_params}) do
    case InventoryService.process_restock(restock_params) do
      {:ok, :restock_processed} ->
        send_resp(conn, :ok, "")
      {:error, reason} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: reason})
    end
  end

  def index(conn, _params) do
    inventories = Inventories.list_inventories()
    render(conn, "index.json", inventories: inventories)
  end

  def create(conn, %{"inventory" => inventory_params}) do
    case Inventories.create_inventory(inventory_params) do
      {:ok, inventory} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", ~p"/api/inventories/#{inventory.id}")
        |> render("show.json", inventory: inventory)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    case Inventories.get_inventory(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Inventory not found"})
      inventory ->
        render(conn, "show.json", inventory: inventory)
    end
  end

  def update(conn, %{"id" => id, "inventory" => inventory_params}) do
    case Inventories.get_inventory(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Inventory not found"})
      inventory ->
        case Inventories.update_inventory(inventory, inventory_params) do
          {:ok, updated_inventory} ->
            render(conn, "show.json", inventory: updated_inventory)
          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render("error.json", changeset: changeset)
        end
    end
  end

  def delete(conn, %{"id" => id}) do
    case Inventories.get_inventory(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Inventory not found"})
      inventory ->
        case Inventories.delete_inventory(inventory) do
          {:ok, _deleted_inventory} ->
            send_resp(conn, :no_content, "")
          {:error, reason} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{error: reason})
        end
    end
  end
end
