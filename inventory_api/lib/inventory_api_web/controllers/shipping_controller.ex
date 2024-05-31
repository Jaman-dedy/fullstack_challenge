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
end
