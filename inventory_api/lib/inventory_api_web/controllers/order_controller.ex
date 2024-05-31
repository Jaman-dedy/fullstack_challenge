defmodule InventoryApiWeb.ShippingController do
  use InventoryApiWeb, :controller
  alias InventoryApi.Services.ShippingService

  def ship_package(conn, %{"shipment" => shipment_params}) do
    case ShippingService.ship_package(shipment_params) do
      :ok ->
        conn
        |> put_status(:ok)
        |> json(%{message: "Package shipped successfully"})
      {:error, reason} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: reason})
    end
  end

  def create(conn, %{"shipping" => shipping_params}) do
    case ShippingService.create_shipping(shipping_params) do
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

  def show(conn, %{"id" => id}) do
    case ShippingService.get_shipping(id) do
      {:ok, shipping} ->
        conn
        |> put_status(:ok)
        |> render("show.json", shipping: shipping)
      {:error, reason} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: reason})
    end
  end

  def update(conn, %{"id" => id, "shipping" => shipping_params}) do
    case ShippingService.update_shipping(id, shipping_params) do
      {:ok, shipping} ->
        conn
        |> put_status(:ok)
        |> render("show.json", shipping: shipping)
      {:error, reason} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: reason})
    end
  end
end
