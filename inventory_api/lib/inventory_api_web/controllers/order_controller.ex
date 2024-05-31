defmodule InventoryApiWeb.OrderController do
  use InventoryApiWeb, :controller
  alias InventoryApi.Services.OrderService

  def process_order(conn, %{"order" => order_params}) do
    case OrderService.process_order(order_params) do
      {:ok, order} ->
        conn
        |> put_status(:created)
        |> render("show.json", order: order)
      {:error, reason} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: reason})
    end
  end
end
