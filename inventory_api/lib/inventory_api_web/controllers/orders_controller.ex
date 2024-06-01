defmodule InventoryApiWeb.OrdersController do
  use InventoryApiWeb, :controller

  alias InventoryApi.Order
  alias InventoryApi.Order.Orders

  action_fallback InventoryApiWeb.FallbackController

  def process_order(conn, %{"order" => order_params}) do
    case OrderService.process_order(order_params) do
      {:ok, order} ->
        render(conn, "process_order.json", order: order)
      {:error, reason} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: reason})
    end
  end

  def index(conn, _params) do
    orders = Order.list_orders()
    render(conn, :index, orders: orders)
  end

  def create(conn, %{"orders" => orders_params}) do
    with {:ok, %Orders{} = orders} <- Order.create_orders(orders_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/orders/#{orders}")
      |> render(:show, orders: orders)
    end
  end

  def show(conn, %{"id" => id}) do
    orders = Order.get_orders!(id)
    render(conn, :show, orders: orders)
  end

  def update(conn, %{"id" => id, "orders" => orders_params}) do
    orders = Order.get_orders!(id)

    with {:ok, %Orders{} = orders} <- Order.update_orders(orders, orders_params) do
      render(conn, :show, orders: orders)
    end
  end

  def delete(conn, %{"id" => id}) do
    orders = Order.get_orders!(id)

    with {:ok, %Orders{}} <- Order.delete_orders(orders) do
      send_resp(conn, :no_content, "")
    end
  end
end
