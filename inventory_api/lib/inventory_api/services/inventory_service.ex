defmodule InventoryApi.Services.InventoryService do
  use GenServer
  alias InventoryApi.Inventory.Inventories
  alias InventoryApi.Catalog.Products

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_state) do
    {:ok, %{catalog_initialized: false}}
  end

  def init_catalog(product_info) do
    GenServer.call(__MODULE__, {:init_catalog, product_info})
  end

  def reinitialize_catalog() do
    GenServer.call(__MODULE__, {:reinitialize_catalog, nil})
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

  def handle_call({:init_catalog, _product_info}, _from, %{catalog_initialized: true} = state) do
    {:reply, {:error, :catalog_already_initialized}, state}
  end

  def handle_call({:init_catalog, product_info}, _from, state) do
    cond do
      not is_list(product_info) ->
        {:reply, {:error, :invalid_payload}, state}

      length(product_info) == 0 ->
        {:reply, {:error, :empty_catalog}, state}

      has_duplicate_product_ids?(product_info) ->
        {:reply, {:error, :duplicate_product_id}, state}

      has_invalid_mass_kg?(product_info) ->
        {:reply, {:error, :invalid_mass_kg}, state}

      has_invalid_product_name?(product_info) ->
        {:reply, {:error, :invalid_product_name}, state}

      has_invalid_product_id?(product_info) ->
        {:reply, {:error, :invalid_product_id}, state}

      true ->
        Enum.each(product_info, fn product ->
          Products.create_product(product)
        end)
        {:reply, {:ok, :catalog_initialized}, %{state | catalog_initialized: true}}
    end
  end

  def handle_call({:reinitialize_catalog, _product_info}, _from, state) do
    {:reply, {:ok, :catalog_reinitialized}, %{state | catalog_initialized: false}}
  end

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

  defp has_duplicate_product_ids?(product_info) do
    product_ids = Enum.map(product_info, & &1["product_id"])
    length(Enum.uniq(product_ids)) != length(product_ids)
  end

  defp has_invalid_mass_kg?(product_info) do
    Enum.any?(product_info, fn product ->
      not is_number(product["mass_kg"]) or product["mass_kg"] <= 0
    end)
  end

  defp has_invalid_product_name?(product_info) do
    Enum.any?(product_info, fn product ->
      not is_binary(product["product_name"]) or product["product_name"] == ""
    end)
  end

  defp has_invalid_product_id?(product_info) do
    Enum.any?(product_info, fn product ->
      not is_integer(product["product_id"]) or product["product_id"] < 0
    end)
  end

end
