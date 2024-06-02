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

  def create_order(attrs \\ %{}) do
    GenServer.call(__MODULE__, {:create_order, attrs})
  end

  def get_order(id) do
    GenServer.call(__MODULE__, {:get_order, id})
  end

  def update_order(id, attrs) do
    GenServer.call(__MODULE__, {:update_order, id, attrs})
  end

  def handle_call({:process_order, order_params}, _from, state) do
    case validate_order(order_params) do
      {:ok, order} ->
        requested_items = order["requested"]
        case create_order_items(order["order_id"], requested_items) do
          {:ok, _order_items} ->
            {:reply, {:ok, "Order created successfully"}, state}
          {:error, :insufficient_inventory} ->
            {:reply, {:error, :insufficient_inventory}, state}
        end
      {:error, reason} ->
        {:reply, {:error, reason}, state}
    end
  end

  def handle_call({:create_order, attrs}, _from, state) do
    case Orders.create_order(attrs) do
      {:ok, order} ->
        {:reply, {:ok, order}, state}
      {:error, changeset} ->
        {:reply, {:error, changeset}, state}
    end
  end

  def handle_call({:get_order, id}, _from, state) do
    case Orders.get_order(id) do
      nil ->
        {:reply, {:error, :not_found}, state}
      order ->
        {:reply, {:ok, order}, state}
    end
  end

  def handle_call({:update_order, id, attrs}, _from, state) do
    case Orders.get_order(id) do
      nil ->
        {:reply, {:error, :not_found}, state}
      order ->
        case Orders.update_order(order, attrs) do
          {:ok, updated_order} ->
            {:reply, {:ok, updated_order}, state}
          {:error, changeset} ->
            {:reply, {:error, changeset}, state}
        end
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

  defp create_order_items(order_id, requested_items) do
    # Check if all requested items are available in the inventory
    available? = Enum.all?(requested_items, fn item ->
      product_id = item["product_id"]
      quantity = item["quantity"]
      case Inventories.get_inventory_by_product_id(product_id) do
        nil -> false
        inventory -> inventory.quantity >= quantity
      end
    end)

    if available? do
      # Create or update order items and update inventory quantities
      Enum.each(requested_items, fn item ->
        product_id = item["product_id"]
        quantity = item["quantity"]

        # Check if an order item with the same order_id and product_id already exists

        case Orders.get_order_item_by_order_and_product(order_id, product_id) do
          nil ->
            # Create a new order item
            attrs = %{order_id: order_id, product_id: product_id, quantity: quantity, status: "pending"}
            {:ok, _order_item} = Orders.create_order_item(attrs)
          order_item ->
            # Update the quantity of the existing order item
            updated_quantity = order_item.quantity + quantity
            Orders.update_order_item(order_item, %{quantity: updated_quantity})
        end

        # Update the inventory quantity
        inventory = Inventories.get_inventory_by_product_id(product_id)
        updated_quantity = inventory.quantity - quantity
        Inventories.update_inventory(inventory, %{quantity: updated_quantity})
      end)

      {:ok, "Order items created successfully"}
    else
      {:error, :insufficient_inventory}
    end
  end
end
