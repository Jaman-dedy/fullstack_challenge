defmodule InventoryApi.Services.OrderService do
  use GenServer
  alias InventoryApi.Orders.Order

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
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

  def handle_call({:create_order, attrs}, _from, state) do
    order = Order.create_order(attrs)
    {:reply, order, state}
  end

  def handle_call({:get_order, id}, _from, state) do
    order = Order.get_order(id)
    {:reply, order, state}
  end

  def handle_call({:update_order, id, attrs}, _from, state) do
    order = Order.update_order(id, attrs)
    {:reply, order, state}
  end
end
