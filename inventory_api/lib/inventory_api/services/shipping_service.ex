defmodule InventoryApi.Services.ShippingService do
  use GenServer
  alias InventoryApi.Shipping.Shippings
  alias InventoryApi.Order.Orders

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

  def get_shipped_packages_by_order_id(order_id) do
    GenServer.call(__MODULE__, {:get_shipped_packages_by_order_id, order_id})
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
                  case all_products_exist?(shipment["shipped"]) do
                    true ->
                      total_order_quantity = Enum.reduce(order_items, 0, &(&1.quantity + &2))

                      total_shipped_quantity =
                        Enum.reduce(shipment["shipped"], 0, &(&1["quantity"] + &2))

                      order_status =
                        if total_shipped_quantity < total_order_quantity,
                          do: "processing",
                          else: "completed"

                      shipped_package_itinerary =
                        Enum.map(shipment["shipped"], fn item ->
                          product_id = item["product_id"]
                          quantity = item["quantity"]

                          attrs = %{
                            order_id: shipment["order_id"],
                            product_id: product_id,
                            quantity: quantity,
                            status: order_status
                          }

                          {:ok, shipping} = Shippings.create_shipping(attrs)

                          Orders.update_order_item_quantity(
                            shipment["order_id"],
                            product_id,
                            -quantity
                          )

                          %{
                            product_id: product_id,
                            quantity: quantity,
                            status: shipping.status,
                            updated_at: shipping.updated_at
                          }
                        end)

                      Orders.update_order_items_status(shipment["order_id"], order_status)

                      {:reply,
                       {:ok, order_status, "Package shipped successfully",
                        shipped_package_itinerary}, state}

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

  def handle_call({:get_shipped_packages_by_order_id, order_id}, _from, state) do
    case Shippings.get_shipping_records_by_order_id(order_id) do
      [] ->
        {:reply, {:error, :shipped_packages_not_found}, state}

      shipped_packages ->
        {:reply, {:ok, shipped_packages}, state}
    end
  end

  defp all_products_exist?(shipped_items) do
    product_ids = Enum.map(shipped_items, & &1["product_id"])

    order_items = Orders.get_order_items_by_product_ids(product_ids)

    Enum.all?(product_ids, fn product_id ->
      Enum.any?(order_items, &(&1.product_id == product_id))
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
                    valid_items? =
                      Enum.all?(shipped_items, fn item ->
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
    total_quantity =
      Enum.reduce(shipped_items, 0, fn item, acc ->
        quantity = item["quantity"]
        acc + quantity
      end)

    total_quantity <= @max_package_size
  end
end
