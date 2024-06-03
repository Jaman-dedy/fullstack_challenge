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

                    # Update inventory quantity
                    Inventories.update_inventory_quantity(product_id, -quantity)
                  end)

                  # Print the shipment details
                  IO.puts("Shipment created:")
                  IO.puts("Order ID: #{shipment["order_id"]}")
                  IO.puts("Shipped Items:")
                  Enum.each(shipment["shipped"], fn item ->
                    IO.puts("- Product ID: #{item["product_id"]}, Quantity: #{item["quantity"]}")
                  end)

                  {:reply, :ok, state}
                else
                  {:reply, {:error, :package_too_large}, state}
                end
              false ->
                {:reply, {:error, :invalid_shipped_quantities}, state}
            end
        end
      {:error, reason} ->
        {:reply, {:error, reason}, state}
    end
  end

  defp validate_shipment(shipment_params) do
    case Map.has_key?(shipment_params, "order_id") do
      true ->
        case Map.has_key?(shipment_params, "shipped") do
          true ->
            shipped_items = shipment_params["shipped"]
            case is_list(shipped_items) do
              true ->
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

  # defp is_valid_product_id?(product_id) do
  #   is_integer(product_id)
  # end

  # defp is_valid_quantity?(quantity) do
  #   case Integer.parse(quantity) do
  #     {parsed_quantity, ""} when parsed_quantity > 0 -> true
  #     _ -> false
  #   end
  # end

  defp valid_shipped_quantities?(shipped_items, order_items) do
    Enum.all?(shipped_items, fn item ->
      product_id = item["product_id"]
      quantity = item["quantity"]
      Enum.any?(order_items, fn order_item ->
        order_item.product_id == product_id and order_item.quantity >= quantity
      end)
    end)
  end

  defp valid_package_size?(shipped_items) do
    total_mass = Enum.reduce(shipped_items, 0, fn item, acc ->
      product_id = item["product_id"]
      quantity = item["quantity"]
      inventory = Inventories.get_inventory_by_product_id(product_id)
      acc + quantity * inventory.quantity
    end)
    total_mass <= @max_package_size
  end
end
