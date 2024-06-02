defmodule InventoryApiWeb.OrdersController do
  use InventoryApiWeb, :controller

  alias InventoryApi.Order.Orders
  alias InventoryApi.Services.OrderService

  action_fallback InventoryApiWeb.FallbackController

  def process_order(conn, %{"order_id" => order_id, "requested" => requested}) do
    order_params = %{"order_id" => order_id, "requested" => requested}
    case validate_order_params(order_params) do
      {:ok, order_params} ->
        case OrderService.process_order(order_params) do
          {:ok, message} ->
            conn
            |> put_status(:ok)
            |> json(%{message: message})
          {:error, :invalid_order} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{error: "Invalid order"})
          {:error, :insufficient_inventory} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{error: "Insufficient inventory"})
        end
      {:error, reason} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: reason})
    end
  end

  def index(conn, _params) do
    orders = Orders.list_orders()
    render(conn, "index.json", orders: orders)
  end

  def create(conn, %{"order" => order_params}) do
    case validate_create_order_params(order_params) do
      {:ok, order_params} ->
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
      {:error, reason} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: reason})
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
    case validate_update_order_params(order_params) do
      {:ok, order_params} ->
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
      {:error, reason} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: reason})
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

  defp validate_order_params(order_params) do
    cond do
      !Map.has_key?(order_params, "order_id") ->
        {:error, "Missing order_id parameter"}
      !Map.has_key?(order_params, "requested") ->
        {:error, "Missing requested parameter"}
      !is_list(order_params["requested"]) ->
        {:error, "Requested parameter must be a list"}
      true ->
        {:ok, order_params}
    end
  end

  defp validate_create_order_params(order_params) do
    cond do
      !Map.has_key?(order_params, "customer_id") ->
        {:error, "Missing customer_id parameter"}
      !Map.has_key?(order_params, "items") ->
        {:error, "Missing items parameter"}
      !is_list(order_params["items"]) ->
        {:error, "Items parameter must be a list"}
      true ->
        {:ok, order_params}
    end
  end

  defp validate_update_order_params(order_params) do
    cond do
      !Map.has_key?(order_params, "status") ->
        {:error, "Missing status parameter"}
      true ->
        {:ok, order_params}
    end
  end
end
