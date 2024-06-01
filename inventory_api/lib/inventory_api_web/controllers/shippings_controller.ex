defmodule InventoryApiWeb.ShippingsController do
  use InventoryApiWeb, :controller

  alias InventoryApi.Shipping.Shippings
  alias InventoryApi.Services.ShippingService

  action_fallback InventoryApiWeb.FallbackController

  def ship_package(conn, %{"shipment" => shipment_params}) do
    case ShippingService.ship_package(shipment_params) do
      {:ok, shipping} ->
        conn
        |> put_status(:created)
        |> render("show.json", shipping: shipping)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", changeset: changeset)
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
