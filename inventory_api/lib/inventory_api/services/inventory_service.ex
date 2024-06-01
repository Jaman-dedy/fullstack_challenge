defmodule InventoryApi.Services.InventoryService do
  use GenServer
  alias InventoryApi.Inventory.Inventories

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def init_catalog(product_info) do
    GenServer.call(__MODULE__, {:init_catalog, product_info})
  end

  def process_restock(restock_params) do
    GenServer.call(__MODULE__, {:process_restock, restock_params})
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

  # Callback functions

  # def handle_call({:init_catalog, product_info}, _from, state) do
  #   # Implement the logic to initialize the catalog
  #   # Example:
  #   Enum.each(product_info, fn product ->
  #     Inventories.create_product(product)
  #   end)

  #   {:reply, {:ok, :catalog_initialized}, state}
  # end

  # def handle_call({:process_restock, restock_params}, _from, state) do
  #   # Implement the logic to process the restock
  #   # Example:
  #   Enum.each(restock_params, fn restock ->
  #     product_id = restock["product_id"]
  #     quantity = restock["quantity"]
  #     Inventories.update_product_quantity(product_id, quantity)
  #   end)

  #   {:reply, {:ok, :restock_processed}, state}
  # end

  def handle_call({:create_inventory, attrs}, _from, state) do
    case Inventories.create_inventory(attrs) do
      {:ok, inventory} ->
        {:reply, {:ok, inventory}, state}
      {:error, changeset} ->
        {:reply, {:error, changeset}, state}
    end
  end

  def handle_call({:get_inventory, id}, _from, state) do
    case Inventories.get_inventory(id) do
      nil ->
        {:reply, {:error, :not_found}, state}
      inventory ->
        {:reply, {:ok, inventory}, state}
    end
  end

  def handle_call({:update_inventory, id, attrs}, _from, state) do
    case Inventories.get_inventory(id) do
      nil ->
        {:reply, {:error, :not_found}, state}
      inventory ->
        case Inventories.update_inventory(inventory, attrs) do
          {:ok, updated_inventory} ->
            {:reply, {:ok, updated_inventory}, state}
          {:error, changeset} ->
            {:reply, {:error, changeset}, state}
        end
    end
  end
end
