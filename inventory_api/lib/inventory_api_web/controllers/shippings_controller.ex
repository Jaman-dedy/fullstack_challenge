defmodule InventoryApiWeb.ShippingsController do
  use InventoryApiWeb, :controller

  alias InventoryApi.Shipping.Shippings
  alias InventoryApi.Services.ShippingService
  alias InventoryApi.Services.InventoryService

  action_fallback(InventoryApiWeb.FallbackController)

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
            |> json(%{error: "Shipped array cannot be empty"})

          {:error, :product_not_found} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{
              error: "One or more products id provided does not have a matching order, please ship what you have ordered"
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

  def show(conn, %{"id" => id}) do
    case Shippings.get_shipping(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Shipping not found"})

      shipping ->
        render(conn, "show.json", shipping: shipping)
    end
  end

  def get_shipped_packages_by_order_id(conn, %{"order_id" => order_id}) do
    case ShippingService.get_shipped_packages_by_order_id(order_id) do
      {:ok, shipped_packages} ->
        conn
        |> put_status(:ok)
        |> json(%{status: "success", shipped_packages: shipped_packages})

      {:error, :shipped_packages_not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{status: "error", message: "Shipped packages not found for the given order ID"})
    end
  end

end
