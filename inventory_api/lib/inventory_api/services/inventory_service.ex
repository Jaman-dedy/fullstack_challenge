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

  def is_catalog_initialized?() do
    GenServer.call(__MODULE__, :is_catalog_initialized)
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

  def get_catalog() do
    GenServer.call(__MODULE__, :get_catalog)
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
        {catalog, errors} = Enum.reduce(product_info, {[], []}, fn product, {catalog, errors} ->
          case Products.insert_or_update_product(product) do
            {:ok, created_product} ->
              {[created_product | catalog], errors}
            {:error, changeset} ->
              {catalog, [changeset | errors]}
          end
        end)

        if Enum.empty?(errors) do
          {:reply, {:ok, Enum.reverse(catalog)}, %{state | catalog_initialized: true}}
        else
          {:reply, {:error, errors}, state}
        end
    end
  end

  def handle_call({:reinitialize_catalog, _product_info}, _from, state) do
    {:reply, {:ok, :catalog_reinitialized}, %{state | catalog_initialized: false}}
  end

  def handle_call(:is_catalog_initialized, _from, state) do
    {:reply, state.catalog_initialized, state}
  end

  def handle_call({:process_restock, restock_params}, _from, state) do
    cond do
      not is_list(restock_params) or Enum.empty?(restock_params) ->
        {:reply, {:error, :empty_restock_payload}, state}

      Enum.any?(restock_params, fn item ->
        case item do
          %{"product_id" => product_id} ->
            not is_integer(product_id) or product_id < 0 or is_nil(Products.get_product(product_id))
          _ ->
            true
        end
      end) ->
        {:reply, {:error, :invalid_product_id}, state}

      Enum.any?(restock_params, fn item ->
        case item do
          %{"quantity" => quantity} ->
            not is_integer(quantity)
          _ ->
            true
        end
      end) ->
        {:reply, {:error, :invalid_quantity}, state}

      true ->
        inventories =
          restock_params
          |> Enum.map(fn item ->
            case item do
              %{"product_id" => product_id, "quantity" => quantity} ->
                if quantity == 0 do
                  nil
                else
                  case Inventories.get_inventory_by_product_id(product_id) do
                    nil ->
                      {:ok, inventory} = Inventories.create_inventory(%{product_id: product_id, quantity: quantity})
                      inventory
                    inventory ->
                      {:ok, updated_inventory} = Inventories.update_inventory(inventory, %{quantity: inventory.quantity + quantity})
                      updated_inventory
                  end
                end
              %{"product_id" => _product_id} ->
                {:reply, {:error, :missing_quantity}, state}
              _ ->
                nil
            end
          end)
          |> Enum.reject(&is_nil/1)

        if Enum.any?(restock_params, fn item -> item["quantity"] == 0 end) do
          {:reply, {:error, :zero_quantity}, state}
        else
          {:reply, {:ok, inventories}, state}
        end
    end
  end

  def handle_call(:get_catalog, _from, state) do
    if state.catalog_initialized do
      catalog = Products.list_products()
      {:reply, {:ok, catalog}, state}
    else
      {:reply, {:error, :catalog_not_initialized}, state}
    end
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
