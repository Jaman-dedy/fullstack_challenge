defmodule InventoryApi.Services.ShippingService do
  use GenServer
  alias InventoryApi.Shipping.Shippings
  alias InventoryApi.Order.Orders
  alias InventoryApi.Inventory.Inventories

  @max_package_size 134.8

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def ship_package(shipment_params) do
    GenServer.call(__MODULE__, {:ship_package, shipment_params})
  end

  def handle_call({:ship_package, shipment_params}, _from, state) do
    case validate_shipment(shipment_params) do
      {:ok, shipment} ->
        case Orders.get_order_items_by_order_id(shipment["order_id"]) do
          [] ->
            {:reply, {:error, :order_not_found}, state}
          order_items ->
            case valid_shipped_quantities?(shipment["shipped"], order_items) do
              true ->
                if valid_package_size?(shipment["shipped"]) do
                  # Check if all products exist before creating shipping records
                  case all_products_exist?(shipment["shipped"]) do
                    true ->
                      # Create shipping records for each shipped item
                      Enum.each(shipment["shipped"], fn item ->
                        product_id = item["product_id"]
                        quantity = item["quantity"]
                        attrs = %{
                          order_id: shipment["order_id"],
                          product_id: product_id,
                          quantity: quantity
                        }
                        {:ok, _shipping} = Shippings.create_shipping(attrs)

                        # Update order item quantity
                        Orders.update_order_item_quantity(shipment["order_id"], product_id, -quantity)
                      end)

                      # Print the shipment details
                      IO.puts("Shipment created:")
                      IO.puts("Order ID: #{shipment["order_id"]}")
                      IO.puts("Shipped Items:")
                      Enum.each(shipment["shipped"], fn item ->
                        IO.puts("- Product ID: #{item["product_id"]}, Quantity: #{item["quantity"]}")
                      end)

                      {:reply, :ok, state}
                    false ->
                      {:reply, {:error, :product_not_found}, state}
                  end
                else
                  {:reply, {:error, :package_too_large}, state}
                end
              {:error, reason} ->
                {:reply, {:error, reason}, state}
              false ->
                {:reply, {:error, :invalid_shipped_quantities}, state}
            end
        end
      {:error, reason} ->
        {:reply, {:error, reason}, state}
    end
  end

  defp all_products_exist?(shipped_items) do
    product_ids = Enum.map(shipped_items, & &1["product_id"])

    order_items = Orders.get_order_items_by_product_ids(product_ids)

    Enum.all?(product_ids, fn product_id ->
      Enum.any?(order_items, & &1.product_id == product_id)
    end)
  end

  defp validate_shipment(shipment_params) do
    case Map.has_key?(shipment_params, "order_id") do
      true ->
        case Map.has_key?(shipment_params, "shipped") do
          true ->
            shipped_items = shipment_params["shipped"]
            case is_list(shipped_items) do
              true ->
                case shipped_items do
                  [] ->
                    {:error, :empty_shipped_array}
                  _ ->
                    valid_items? = Enum.all?(shipped_items, fn item ->
                      is_map(item) and
                      Map.has_key?(item, "product_id") and
                      Map.has_key?(item, "quantity") and
                      is_integer(item["product_id"]) and
                      is_integer(item["quantity"]) and
                      item["quantity"] > 0
                    end)
                    if valid_items? do
                      {:ok, shipment_params}
                    else
                      {:error, :invalid_shipped_items}
                    end
                end
              false ->
                {:error, :invalid_shipped_format}
            end
          false ->
            {:error, :missing_shipped_items}
        end
      false ->
        {:error, :missing_order_id}
    end
  end

  defp valid_shipped_quantities?(shipped_items, order_items) do
    Enum.all?(shipped_items, fn item ->
      product_id = item["product_id"]
      quantity = item["quantity"]
      case Enum.find(order_items, &(&1.product_id == product_id)) do
        nil ->
          {:error, "You did not place an order for the product with ID #{product_id}"}
        order_item ->
          order_item.quantity >= quantity
      end
    end)
  end

  defp valid_package_size?(shipped_items) do
    result = Enum.reduce_while(shipped_items, 0, fn item, acc ->
      product_id = item["product_id"]
      quantity = item["quantity"]
      inventory = Inventories.get_inventory_by_product_id(product_id)
      if inventory do
        {:cont, acc + quantity * inventory.quantity}
      else
        {:halt, {:error, "Inventory not found for product ID #{product_id}"}}
      end
    end)

    case result do
      {:error, reason} -> {:error, reason}
      total_mass -> total_mass <= @max_package_size
    end
  end
end
