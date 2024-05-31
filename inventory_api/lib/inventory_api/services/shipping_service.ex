defmodule InventoryApi.Services.ShippingService do
  use GenServer
  alias InventoryApi.Shippings.Shipping

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
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

  def handle_call({:create_shipping, attrs}, _from, state) do
    shipping = Shipping.create_shipping(attrs)
    {:reply, shipping, state}
  end

  def handle_call({:get_shipping, id}, _from, state) do
    shipping = Shipping.get_shipping(id)
    {:reply, shipping, state}
  end

  def handle_call({:update_shipping, id, attrs}, _from, state) do
    shipping = Shipping.update_shipping(id, attrs)
    {:reply, shipping, state}
  end
end
