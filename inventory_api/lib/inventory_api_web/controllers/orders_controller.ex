defmodule InventoryApiWeb.OrdersController do
  use InventoryApiWeb, :controller

  alias InventoryApi.Order.Orders
  alias InventoryApi.Services.OrderService

  action_fallback InventoryApiWeb.FallbackController

  def process_order(conn, %{"order" => order_params}) do
    case OrderService.process_order(order_params) do
      {:ok, order} ->
        render(conn, "show.json", order: order)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", changeset: changeset)
    end
  end

  def index(conn, _params) do
    orders = Orders.list_orders()
    render(conn, "index.json", orders: orders)
  end

  def create(conn, %{"order" => order_params}) do
    case OrderService.create_order(order_params) do
      {:ok, order} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", ~p"/api/orders/#{order.id}")
        |> render("show.json", order: order)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    case OrderService.get_order(id) do
      {:ok, order} ->
        render(conn, "show.json", order: order)
      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Order not found"})
    end
  end

  def update(conn, %{"id" => id, "order" => order_params}) do
    case OrderService.update_order(id, order_params) do
      {:ok, updated_order} ->
        render(conn, "show.json", order: updated_order)
      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Order not found"})
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    case Orders.get_order(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Order not found"})
      order ->
        case Orders.delete_order(order) do
          {:ok, _deleted_order} ->
            send_resp(conn, :no_content, "")
          {:error, reason} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{error: reason})
        end
    end
  end
end
