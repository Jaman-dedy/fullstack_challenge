defmodule InventoryApiWeb.ShippingsController do
  use InventoryApiWeb, :controller
  use PhoenixSwagger

  alias InventoryApi.Services.ShippingService
  alias InventoryApi.Services.InventoryService

  action_fallback(InventoryApiWeb.FallbackController)

  swagger_path :ship_package do
    post "/api/ship_package"
    summary "Ship a package"
    description "Ship a package for an order"
    produces "application/json"
    parameters do
      order_id :query, :string, "ID of the order", required: true
      shipped :body, Schema.array(:ShippedItem), "List of shipped items", required: true
    end
    response 200, "Success", Schema.ref(:ShipPackageResponse)
    response 400, "Bad Request", Schema.ref(:ErrorResponse)
    response 404, "Not Found", Schema.ref(:ErrorResponse)
    response 422, "Unprocessable Entity", Schema.ref(:ErrorResponse)
  end

  def ship_package(conn, %{"order_id" => order_id, "shipped" => shipped}) do
    case InventoryService.is_catalog_initialized?() do
      true ->
        shipment_params = %{"order_id" => order_id, "shipped" => shipped}

        case ShippingService.ship_package(shipment_params) do
          {:ok, status, message, shipped_package_itinerary} ->
            conn
            |> put_status(:ok)
            |> json(%{status: status, message: message, shipped_package_itinerary: shipped_package_itinerary})

          {:error, :invalid_shipment} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{error: "Invalid shipment"})

          {:error, :order_not_found} ->
            conn
            |> put_status(:not_found)
            |> json(%{error: "Order not found"})

          {:error, :invalid_shipped_quantities} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{error: "Invalid shipped quantities, you can not ship more than your order"})

          {:error, :package_too_large} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{error: "Package size exceeds the maximum allowed size"})

          {:error, :empty_shipped_array} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{message: "Shipped array cannot be empty"})

          {:error, :product_not_found} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{
              status: "error",
              message: "One or more products id provided does not have a matching order, please ship what you have ordered"
            })

          {:error, reason} when is_binary(reason) ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{error: reason})

          {:error, reason} ->
            conn
            |> put_status(:bad_request)
            |> json(%{error: inspect(reason)})
        end

      false ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{message: "Catalog not initialized. Please call init_catalog first."})
    end
  end

  def ship_package(conn, %{"shipped" => shipped}) do
    case ShippingService.ship_package(%{"shipped" => shipped}) do
      {:error, :missing_order_id} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Missing order_id parameter"})

      {:error, :empty_shipped_array} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "Shipped array cannot be empty"})

      {:error, reason} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: reason})
    end
  end

  def ship_package(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> json(%{error: "Invalid parameters"})
  end

  swagger_path :get_shipped_packages_by_order_id do
    get "/api/shippings/{order_id}"
    summary "Get shipped packages by order ID"
    description "Retrieve shipped packages for a specific order"
    produces "application/json"
    parameters do
      order_id :path, :string, "ID of the order", required: true
    end
    response 200, "Success", Schema.ref(:GetShippedPackagesResponse)
    response 404, "Not Found", Schema.ref(:ErrorResponse)
  end

  def get_shipped_packages_by_order_id(conn, %{"order_id" => order_id}) do
    case ShippingService.get_shipped_packages_by_order_id(order_id) do
      {:ok, shipped_packages} ->
        shipped_packages_map = Enum.map(shipped_packages, fn package ->
          %{
            id: package.id,
            order_id: package.order_id,
            quantity: package.quantity,
            product: %{
              id: package.product.id,
              product_name: package.product.product_name,
              mass_kg: package.product.mass_kg,
              product_id: package.product.product_id
            },
            status: package.status,
            inserted_at: package.inserted_at,
            updated_at: package.updated_at
          }
        end)

        conn
        |> put_status(:ok)
        |> json(%{status: "success", shipped_packages: shipped_packages_map})

      {:error, :shipped_packages_not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{status: "error", message: "Shipped packages not found for the given order ID"})
    end
  end
end
