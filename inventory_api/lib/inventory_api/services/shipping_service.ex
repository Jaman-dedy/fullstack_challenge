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

  def create_shipping(attrs \\ %{}) do
    GenServer.call(__MODULE__, {:create_shipping, attrs})
  end

  def get_shipping(id) do
    GenServer.call(__MODULE__, {:get_shipping, id})
  end

  def update_shipping(id, attrs) do
    GenServer.call(__MODULE__, {:update_shipping, id, attrs})
  end

  def handle_call({:ship_package, shipment_params}, _from, state) do
    case validate_shipment(shipment_params) do
      {:ok, shipment} ->
        case Orders.get_order(shipment_params["order_id"]) do
          nil ->
            {:reply, {:error, :order_not_found}, state}
          _order ->
            if valid_package_size?(shipment) do
              # Create the shipping record
              {:ok, shipping} = Shippings.create_shipping(shipment)

              # Update inventory
              Enum.each(shipment["shipped"], fn item ->
                product_id = item["product_id"]
                quantity = item["quantity"]
                Inventories.update_inventory_quantity(product_id, -quantity)
              end)

              # Print the shipment details
              IO.puts("Shipment created:")
              IO.puts("Order ID: #{shipping.order_id}")
              IO.puts("Shipped Items:")
              Enum.each(shipping.shipped, fn item ->
                IO.puts("- Product ID: #{item["product_id"]}, Quantity: #{item["quantity"]}")
              end)

              {:reply, :ok, state}
            else
              {:reply, {:error, :invalid_shipment}, state}
            end
        end
      {:error, reason} ->
        {:reply, {:error, reason}, state}
    end
  end

  def handle_call({:create_shipping, attrs}, _from, state) do
    case Shippings.create_shipping(attrs) do
      {:ok, shipping} ->
        {:reply, {:ok, shipping}, state}
      {:error, changeset} ->
        {:reply, {:error, changeset}, state}
    end
  end

  def handle_call({:get_shipping, id}, _from, state) do
    case Shippings.get_shipping(id) do
      nil ->
        {:reply, {:error, :not_found}, state}
      shipping ->
        {:reply, {:ok, shipping}, state}
    end
  end

  def handle_call({:update_shipping, id, attrs}, _from, state) do
    case Shippings.get_shipping(id) do
      nil ->
        {:reply, {:error, :not_found}, state}
      shipping ->
        case Shippings.update_shipping(shipping, attrs) do
          {:ok, updated_shipping} ->
            {:reply, {:ok, updated_shipping}, state}
          {:error, changeset} ->
            {:reply, {:error, changeset}, state}
        end
    end
  end

  defp validate_shipment(shipment_params) do
    case Map.has_key?(shipment_params, "order_id") do
      true ->
        case Map.has_key?(shipment_params, "shipped") do
          true ->
            shipped_items = shipment_params["shipped"]
            case is_list(shipped_items) and length(shipped_items) > 0 do
              true ->
                valid_items? = Enum.all?(shipped_items, fn item ->
                  is_map(item) and Map.has_key?(item, "product_id") and Map.has_key?(item, "quantity")
                end)
                if valid_items? do
                  {:ok, shipment_params}
                else
                  {:error, :invalid_shipped_items}
                end
              false ->
                {:error, :empty_shipped_items}
            end
          false ->
            {:error, :missing_shipped_items}
        end
      false ->
        {:error, :missing_order_id}
    end
  end

  defp valid_package_size?(shipment) do
    total_mass = Enum.reduce(shipment["shipped"], 0, fn item, acc ->
      acc + item["quantity"] * Decimal.new(item["mass_kg"])
    end)
    Decimal.compare(total_mass, Decimal.new(@max_package_size)) != :gt
  end
end
