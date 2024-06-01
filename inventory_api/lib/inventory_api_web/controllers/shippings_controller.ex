defmodule InventoryApiWeb.ShippingsController do
  use InventoryApiWeb, :controller

  alias InventoryApi.Shipping
  alias InventoryApi.Shipping.Shippings

  action_fallback InventoryApiWeb.FallbackController

  def ship_package(conn, %{"shipment" => shipment_params}) do
    case ShippingService.ship_package(shipment_params) do
      :ok ->
        send_resp(conn, :ok, "")
      {:error, reason} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: reason})
    end
  end

  def index(conn, _params) do
    shippings = Shipping.list_shippings()
    render(conn, :index, shippings: shippings)
  end

  def create(conn, %{"shippings" => shippings_params}) do
    with {:ok, %Shippings{} = shippings} <- Shipping.create_shippings(shippings_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/shippings/#{shippings}")
      |> render(:show, shippings: shippings)
    end
  end

  def show(conn, %{"id" => id}) do
    shippings = Shipping.get_shippings!(id)
    render(conn, :show, shippings: shippings)
  end

  def update(conn, %{"id" => id, "shippings" => shippings_params}) do
    shippings = Shipping.get_shippings!(id)

    with {:ok, %Shippings{} = shippings} <- Shipping.update_shippings(shippings, shippings_params) do
      render(conn, :show, shippings: shippings)
    end
  end

  def delete(conn, %{"id" => id}) do
    shippings = Shipping.get_shippings!(id)

    with {:ok, %Shippings{}} <- Shipping.delete_shippings(shippings) do
      send_resp(conn, :no_content, "")
    end
  end
end
