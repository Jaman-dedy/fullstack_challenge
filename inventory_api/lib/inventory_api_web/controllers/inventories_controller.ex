defmodule InventoryApiWeb.InventoriesController do
  use InventoryApiWeb, :controller
  use PhoenixSwagger

  alias InventoryApi.Services.InventoryService

  action_fallback(InventoryApiWeb.FallbackController)

  swagger_path :init_catalog do
    post "/api/init_catalog"
    summary "Initialize product catalog"
    description "Initialize the product catalog with the provided product information"
    produces "application/json"
    parameter :product_info, :body, Schema.ref(:InitCatalogRequest), "Product information", required: true
    response 200, "Success", Schema.ref(:InitCatalogResponse)
    response 400, "Bad Request", Schema.ref(:ErrorResponse)
    response 422, "Unprocessable Entity", Schema.ref(:ErrorResponse)
  end

  def init_catalog(conn, %{"product_info" => product_info}) do
    handle_init_catalog(conn, product_info)
  end

  def init_catalog(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> json(%{
      status: "error",
      message: "Missing product_info parameter"
    })
  end

  defp handle_init_catalog(conn, product_info) do
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

  swagger_path :get_catalog do
    get "/api/catalog"
    summary "Get product catalog"
    description "Retrieve the product catalog"
    produces "application/json"
    response 200, "Success", Schema.ref(:GetCatalogResponse)
    response 404, "Not Found", Schema.ref(:ErrorResponse)
  end

  def get_catalog(conn, _params) do
    case InventoryService.get_catalog() do
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
          catalog: catalog_map
        })

      {:error, :catalog_not_initialized} ->
        conn
        |> put_status(:not_found)
        |> json(%{
          status: "error",
          message: "Product catalog has not been initialized"
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

  swagger_path :re_init_catalog do
    post "/api/reset_catalog"
    summary "Reset product catalog"
    description "Reset the product catalog"
    produces "application/json"
    response 200, "Success", Schema.ref(:ReInitCatalogResponse)
    response 404, "Not Found", Schema.ref(:ErrorResponse)
  end

  def re_init_catalog(conn, _params) do
    case InventoryService.reinitialize_catalog() do
      {:ok, :catalog_reinitialized} ->
        conn
        |> put_status(:ok)
        |> json(%{message: "Product catalog was successfully reset"})
    end
  end

  swagger_path :process_restock do
    post "/api/process_restock"
    summary "Process restock"
    description "Process a restock of inventory items"
    produces "application/json"
    parameter :restock_items, :body, Schema.array(:RestockItem), "Restock items", required: true
    response 200, "Success", Schema.ref(:RestockResponse)
    response 422, "Unprocessable Entity", Schema.ref(:ErrorResponse)
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

          {:error, :zero_quantity} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{
              status: "error",
              message:
                "An inventory cannot be created with 0 quantity. Please provide the correct quantity number."
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

  swagger_path :get_inventories do
    get "/api/get_inventories"
    summary "Get inventories"
    description "Retrieve the current inventories"
    produces "application/json"
    response 200, "Success", Schema.ref(:GetInventoriesResponse)
    response 404, "Not Found", Schema.ref(:ErrorResponse)
  end

  def get_inventories(conn, _params) do
    case InventoryService.get_inventories() do
      {:ok, inventories} ->
        inventories_map =
          inventories
          |> Enum.map(fn inventory ->
            %{
              id: inventory.id,
              product: %{
                id: inventory.product.id,
                product_name: inventory.product.product_name,
                mass_kg: inventory.product.mass_kg,
                product_id: inventory.product.product_id
              },
              quantity: inventory.quantity,
              created_at: inventory.inserted_at,
              updated_at: inventory.updated_at
            }
          end)

        conn
        |> put_status(:ok)
        |> json(%{
          status: "success",
          inventories: inventories_map
        })

      {:error, :catalog_not_initialized} ->
        conn
        |> put_status(:not_found)
        |> json(%{
          status: "error",
          message: "Product catalog has not been initialized"
        })
    end
  end

end
