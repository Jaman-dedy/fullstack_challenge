defmodule InventoryApi.Services.OrderService do
  use GenServer
  alias InventoryApi.Order.Orders
  alias InventoryApi.Inventory.Inventories

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def process_order(order_params) do
    GenServer.call(__MODULE__, {:process_order, order_params})
  end

  def get_order_by_order_id(order_id) do
    GenServer.call(__MODULE__, {:get_order_by_order_id, order_id})
  end

  def handle_call({:process_order, order_params}, _from, state) do
    case validate_order(order_params) do
      {:ok, order} ->
        order_id = order["order_id"]
        requested_items = order["requested"]

        case order_completed?(order_id) do
          true ->
            {:reply, {:error, :order_completed}, state}
          false ->
            case create_order_items(order_id, requested_items) do
              {:ok, order_items} ->
                {:reply, {:ok, order_items, "Order created successfully"}, state}
              {:error, :insufficient_inventory} ->
                {:reply, {:error, :insufficient_inventory}, state}
            end
        end
      {:error, reason} ->
        {:reply, {:error, reason}, state}
    end
  end

  def handle_call({:get_order_by_order_id, order_id}, _from, state) do
    case Orders.get_order_items_by_order_id(order_id) do
      [] ->
        {:reply, {:error, :order_not_found}, state}
      order_items ->
        {:reply, {:ok, order_items}, state}
    end
  end

  defp validate_order(order_params) do
    case Map.has_key?(order_params, "order_id") do
      true ->
        case Map.has_key?(order_params, "requested") do
          true ->
            requested_items = order_params["requested"]
            case is_list(requested_items) and length(requested_items) > 0 do
              true ->
                valid_items? = Enum.all?(requested_items, fn item ->
                  is_map(item) and Map.has_key?(item, "product_id") and Map.has_key?(item, "quantity")
                end)
                if valid_items? do
                  {:ok, order_params}
                else
                  {:error, :invalid_requested_items}
                end
              false ->
                {:error, :empty_requested_items}
            end
          false ->
            {:error, :missing_requested_items}
        end
      false ->
        {:error, :missing_order_id}
    end
  end

  defp order_completed?(order_id) do
    case Orders.get_order_items_by_order_id(order_id) do
      [] ->
        false
      order_items ->
        Enum.all?(order_items, fn item ->
          item.status == "completed" && item.quantity == 0
        end)
    end
  end

  defp create_order_items(order_id, requested_items) do
    available? = Enum.all?(requested_items, fn item ->
      product_id = item["product_id"]
      quantity = item["quantity"]
      case Inventories.get_inventory_by_product_id(product_id) do
        nil -> false
        inventory -> inventory.quantity >= quantity
      end
    end)

    if available? do
      Enum.each(requested_items, fn item ->
        product_id = item["product_id"]
        quantity = item["quantity"]

        case Orders.get_order_item_by_order_and_product(order_id, product_id) do
          nil ->
            attrs = %{order_id: order_id, product_id: product_id, quantity: quantity, status: "init"}
            {:ok, _order_item} = Orders.create_order_item(attrs)
          order_item ->
            updated_quantity = order_item.quantity + quantity
            Orders.update_order_item(order_item, %{quantity: updated_quantity})
        end

        inventory = Inventories.get_inventory_by_product_id(product_id)
        updated_quantity = inventory.quantity - quantity
        Inventories.update_inventory(inventory, %{quantity: updated_quantity})
      end)

      order_items = Orders.get_order_items_by_order_id(order_id)
      {:ok, order_items}
    else
      {:error, :insufficient_inventory}
    end
  end
end
