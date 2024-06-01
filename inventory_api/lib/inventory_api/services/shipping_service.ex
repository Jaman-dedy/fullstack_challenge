defmodule InventoryApi.Services.ShippingService do
  use GenServer
  alias InventoryApi.Shipping.Shippings

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
    case Shippings.create_shipping(shipment_params) do
      {:ok, shipping} ->
        {:reply, {:ok, shipping}, state}
      {:error, changeset} ->
        {:reply, {:error, changeset}, state}
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
end
