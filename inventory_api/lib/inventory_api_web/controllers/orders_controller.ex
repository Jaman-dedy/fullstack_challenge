defmodule InventoryApiWeb.OrdersController do
  use InventoryApiWeb, :controller

  alias InventoryApi.Order.Orders
  alias InventoryApi.Services.OrderService
  alias InventoryApi.Services.InventoryService

  action_fallback(InventoryApiWeb.FallbackController)

  def process_order(conn, %{"requested" => requested} = params) do
    case InventoryService.is_catalog_initialized?() do
      true ->
        case Map.fetch(params, "order_id") do
          {:ok, order_id} ->
            order_params = %{"order_id" => order_id, "requested" => requested}

            case validate_order_params(order_params) do
              {:ok, order_params} ->
                case OrderService.process_order(order_params) do
                  {:ok, order_items, message} ->
                    conn
                    |> put_status(:ok)
                    |> json(%{status: "success", message: message, order_items: order_items})

                  {:error, :order_completed} ->
                    conn
                    |> put_status(:unprocessable_entity)
                    |> json(%{
                      status: "error",
                      message: "Order already completed. Please initiate a new order."
                    })

                  {:error, :invalid_order} ->
                    conn
                    |> put_status(:unprocessable_entity)
                    |> json(%{status: "error", message: "Invalid order"})

                  {:error, :insufficient_inventory} ->
                    conn
                    |> put_status(:unprocessable_entity)
                    |> json(%{
                      status: "error",
                      message: "Insufficient inventory or invalid format"
                    })
                end

              {:error, "Invalid product_id or quantity in requested items"} ->
                conn
                |> put_status(:bad_request)
                |> json(%{
                  status: "error",
                  message: "Invalid product_id or quantity in requested items"
                })

              {:error, :empty_requested_items} ->
                conn
                |> put_status(:bad_request)
                |> json(%{status: "error", message: "Empty requested items"})

              {:error, reason} ->
                conn
                |> put_status(:bad_request)
                |> json(%{status: "error", message: reason})
            end

          :error ->
            conn
            |> put_status(:bad_request)
            |> json(%{status: "error", message: "Missing order_id parameter"})
        end

      false ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{
          status: "error",
          message: "Catalog not initialized. Please call init_catalog first."
        })
    end
  end

  # def index(conn, _params) do
  #   orders = Orders.list_orders()
  #   render(conn, "index.json", orders: orders)
  # end

  # def create(conn, %{"order" => order_params}) do
  #   case validate_create_order_params(order_params) do
  #     {:ok, order_params} ->
  #       case OrderService.create_order(order_params) do
  #         {:ok, order} ->
  #           conn
  #           |> put_status(:created)
  #           |> put_resp_header("location", ~p"/api/orders/#{order.id}")
  #           |> render("show.json", order: order)

  #         {:error, changeset} ->
  #           conn
  #           |> put_status(:unprocessable_entity)
  #           |> render("error.json", changeset: changeset)
  #       end

  #     {:error, reason} ->
  #       conn
  #       |> put_status(:bad_request)
  #       |> json(%{error: reason})
  #   end
  # end

  # def show(conn, %{"id" => id}) do
  #   case OrderService.get_order(id) do
  #     {:ok, order} ->
  #       render(conn, "show.json", order: order)

  #     {:error, :not_found} ->
  #       conn
  #       |> put_status(:not_found)
  #       |> json(%{error: "Order not found"})
  #   end
  # end

  # def update(conn, %{"id" => id, "order" => order_params}) do
  #   case validate_update_order_params(order_params) do
  #     {:ok, order_params} ->
  #       case OrderService.update_order(id, order_params) do
  #         {:ok, updated_order} ->
  #           render(conn, "show.json", order: updated_order)

  #         {:error, :not_found} ->
  #           conn
  #           |> put_status(:not_found)
  #           |> json(%{error: "Order not found"})

  #         {:error, changeset} ->
  #           conn
  #           |> put_status(:unprocessable_entity)
  #           |> render("error.json", changeset: changeset)
  #       end

  #     {:error, reason} ->
  #       conn
  #       |> put_status(:bad_request)
  #       |> json(%{error: reason})
  #   end
  # end

  # def delete(conn, %{"id" => id}) do
  #   case Orders.get_order(id) do
  #     nil ->
  #       conn
  #       |> put_status(:not_found)
  #       |> json(%{error: "Order not found"})

  #     order ->
  #       case Orders.delete_order(order) do
  #         {:ok, _deleted_order} ->
  #           send_resp(conn, :no_content, "")

  #         {:error, reason} ->
  #           conn
  #           |> put_status(:unprocessable_entity)
  #           |> json(%{error: reason})
  #       end
  #   end
  # end

  defp validate_order_params(order_params) do
    cond do
      !Map.has_key?(order_params, "order_id") ->
        {:error, "Missing order_id parameter"}

      !Map.has_key?(order_params, "requested") ->
        {:error, "Missing requested parameter"}

      !is_list(order_params["requested"]) ->
        {:error, "Requested parameter must be a list"}

      order_params["requested"] == [] ->
        {:error, :empty_requested_items}

      !all_items_valid?(order_params["requested"]) ->
        {:error, "Invalid product_id or quantity in requested items"}

      true ->
        {:ok, order_params}
    end
  end

  defp all_items_valid?(requested_items) do
    Enum.all?(requested_items, fn item ->
      is_valid_item?(item)
    end)
  end

  defp is_valid_item?(item) do
    with true <- is_map(item),
         true <- Map.has_key?(item, "product_id"),
         true <- Map.has_key?(item, "quantity"),
         {product_id, ""} <- Integer.parse(to_string(item["product_id"])),
         {quantity, ""} <- Integer.parse(to_string(item["quantity"])),
         true <- is_integer(product_id) and product_id > 0,
         true <- is_integer(quantity) and quantity > 0 do
      true
    else
      _ -> false
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

  def get_order_by_order_id(conn, %{"order_id" => order_id}) do
    case OrderService.get_order_by_order_id(order_id) do
      {:ok, order_items} ->
        order_map = %{
          order_id: order_id,
          items:
            Enum.map(order_items, fn item ->
              %{
                id: item.id,
                product: %{
                id: item.product.id,
                product_name: item.product.product_name,
                mass_kg: item.product.mass_kg,
                product_id: item.product.product_id
              },
                quantity: item.quantity,
                status: item.status,
                inserted_at: item.inserted_at,
                updated_at: item.updated_at
              }
            end)
        }

        conn
        |> put_status(:ok)
        |> json(%{status: "success", order: order_map})

      {:error, :order_not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{status: "error", message: "Order not found"})
    end
  end
end
