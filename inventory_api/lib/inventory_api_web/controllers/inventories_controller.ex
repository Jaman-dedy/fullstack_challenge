defmodule InventoryApiWeb.InventoriesController do
  use InventoryApiWeb, :controller

  alias InventoryApi.Inventory.Inventories
  alias InventoryApi.Services.InventoryService

  action_fallback(InventoryApiWeb.FallbackController)

  def init_catalog(conn, %{"product_info" => product_info}) do
    case InventoryService.init_catalog(product_info) do
      {:ok, catalog} ->
        catalog_map =
          Enum.map(catalog, fn product ->
            %{
              id: product.id,
              product_name: product.product_name,
              mass_kg: product.mass_kg,
              product_id: product.product_id
            }
          end)

        conn
        |> put_status(:ok)
        |> json(%{
          status: "success",
          message: "Product catalog initialized successfully",
          catalog: catalog_map
        })

      {:error, errors} when is_list(errors) ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{
          status: "error",
          message: "Failed to initialize product catalog",
          errors: Enum.map(errors, &changeset_errors/1)
        })

      {:error, :catalog_already_initialized} ->
        conn
        |> put_status(:bad_request)
        |> json(%{
          status: "error",
          message: "Product catalog has already been initialized"
        })

      {:error, :empty_catalog} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{
          status: "error",
          message: "Empty product catalog"
        })

      {:error, :duplicate_product_id} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{
          status: "error",
          message: "Duplicate product_id found"
        })

      {:error, :invalid_mass_kg} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{
          status: "error",
          message: "Invalid mass_kg value"
        })

      {:error, :invalid_product_name} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{
          status: "error",
          message: "Missing or invalid product_name"
        })

      {:error, :invalid_product_id} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{
          status: "error",
          message: "Missing or invalid product_id"
        })
    end
  end

  defp changeset_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Regex.replace(~r"%{(\w+)}", msg, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end

  def re_init_catalog(conn, _params) do
    case InventoryService.reinitialize_catalog() do
      {:ok, :catalog_reinitialized} ->
        conn
        |> put_status(:ok)
        |> json(%{message: "Product catalog was successfully reset"})
    end
  end

  def process_restock(conn, %{"_json" => restock_params}) when is_list(restock_params) do
    case InventoryService.is_catalog_initialized?() do
      true ->
        case InventoryService.process_restock(restock_params) do
          {:ok, inventories} ->
            inventories_map =
              inventories
              |> Enum.group_by(& &1.product_id)
              |> Enum.map(fn {_product_id, inventories_group} ->
                inventories_group
                |> Enum.max_by(& &1.quantity)
                |> Map.take([:id, :quantity, :product_id, :inserted_at, :updated_at])
              end)

            conn
            |> put_status(:ok)
            |> json(%{
              status: "success",
              message: "Restock processed successfully",
              inventories: inventories_map
            })

          {:error, :empty_restock_payload} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{status: "error", message: "Empty restock payload"})

          {:error, :invalid_product_id} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{status: "error", message: "Invalid or missing product_id"})

          {:error, :invalid_quantity} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{status: "error", message: "Invalid or missing quantity value"})

          {:error, :missing_quantity} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{status: "error", message: "Missing quantity value"})
        end

      false ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{message: "Catalog not initialized. Please call init_catalog first."})
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
