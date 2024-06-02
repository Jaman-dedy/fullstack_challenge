defmodule InventoryApiWeb.ShippingsController do
  use InventoryApiWeb, :controller

  alias InventoryApi.Shipping.Shippings
  alias InventoryApi.Services.ShippingService

  action_fallback InventoryApiWeb.FallbackController

  defp validate_shipment_params(shipment_params) do
    cond do
      !Map.has_key?(shipment_params, "shipped") ->
        {:error, "Missing shipped parameter"}
      !is_list(shipment_params["shipped"]) ->
        {:error, "Shipped parameter must be a list"}
      true ->
        {:ok, shipment_params}
    end
  end

  def ship_package(conn, %{"shipment" => shipment_params}) do
    case validate_shipment_params(shipment_params) do
      {:ok, shipment_params} ->
        case ShippingService.ship_package(shipment_params) do
          :ok ->
            conn
            |> put_status(:ok)
            |> json(%{message: "Package shipped successfully"})
          {:error, :invalid_shipment} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{error: "Invalid shipment"})
          {:error, :order_not_found} ->
            conn
            |> put_status(:not_found)
            |> json(%{error: "Order not found"})
        end
      {:error, reason} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: reason})
    end
  end

  def index(conn, _params) do
    shippings = Shippings.list_shippings()
    render(conn, "index.json", shippings: shippings)
  end

  def create(conn, %{"shipping" => shipping_params}) do
    case ShippingService.create_shipping(shipping_params) do
      {:ok, shipping} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", ~p"/api/shippings/#{shipping.id}")
        |> render("show.json", shipping: shipping)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    case ShippingService.get_shipping(id) do
      {:ok, shipping} ->
        render(conn, "show.json", shipping: shipping)
      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Shipping not found"})
    end
  end

  def update(conn, %{"id" => id, "shipping" => shipping_params}) do
    case ShippingService.update_shipping(id, shipping_params) do
      {:ok, updated_shipping} ->
        render(conn, "show.json", shipping: updated_shipping)
      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Shipping not found"})
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    case Shippings.get_shipping(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Shipping not found"})
      shipping ->
        case Shippings.delete_shipping(shipping) do
          {:ok, _deleted_shipping} ->
            send_resp(conn, :no_content, "")
          {:error, reason} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{error: reason})
        end
    end
  end
end
