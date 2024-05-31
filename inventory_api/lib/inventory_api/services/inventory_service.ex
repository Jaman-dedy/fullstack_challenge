defmodule InventoryApi.Services.InventoryService do
  use GenServer
  alias InventoryApi.Inventories.Inventory

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def create_inventory(attrs \\ %{}) do
    GenServer.call(__MODULE__, {:create_inventory, attrs})
  end

  def get_inventory(id) do
    GenServer.call(__MODULE__, {:get_inventory, id})
  end

  def update_inventory(id, attrs) do
    GenServer.call(__MODULE__, {:update_inventory, id, attrs})
  end

  def handle_call({:create_inventory, attrs}, _from, state) do
    inventory = Inventory.create_inventory(attrs)
    {:reply, inventory, state}
  end

  def handle_call({:get_inventory, id}, _from, state) do
    inventory = Inventory.get_inventory(id)
    {:reply, inventory, state}
  end

  def handle_call({:update_inventory, id, attrs}, _from, state) do
    inventory = Inventory.update_inventory(id, attrs)
    {:reply, inventory, state}
  end
end
