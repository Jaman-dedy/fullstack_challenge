defmodule InventoryApi.Services.ProductService do
  use GenServer
  alias InventoryApi.Catalog.Products

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def create_product(attrs \\ %{}) do
    GenServer.call(__MODULE__, {:create_product, attrs})
  end

  def get_product(id) do
    GenServer.call(__MODULE__, {:get_product, id})
  end

  def update_product(id, attrs) do
    GenServer.call(__MODULE__, {:update_product, id, attrs})
  end

  def delete_product(id) do
    GenServer.call(__MODULE__, {:delete_product, id})
  end

  def list_products() do
    GenServer.call(__MODULE__, :list_products)
  end

  def handle_call({:create_product, attrs}, _from, state) do
    case Products.create_product(attrs) do
      {:ok, product} ->
        {:reply, {:ok, product}, state}
      {:error, changeset} ->
        {:reply, {:error, changeset}, state}
    end
  end

  def handle_call({:get_product, id}, _from, state) do
    case Products.get_product(id) do
      nil ->
        {:reply, {:error, :not_found}, state}
      product ->
        {:reply, {:ok, product}, state}
    end
  end

  def handle_call({:update_product, id, attrs}, _from, state) do
    case Products.get_product(id) do
      nil ->
        {:reply, {:error, :not_found}, state}
      product ->
        case Products.update_product(product, attrs) do
          {:ok, updated_product} ->
            {:reply, {:ok, updated_product}, state}
          {:error, changeset} ->
            {:reply, {:error, changeset}, state}
        end
    end
  end

  def handle_call({:delete_product, id}, _from, state) do
    case Products.get_product(id) do
      nil ->
        {:reply, {:error, :not_found}, state}
      product ->
        case Products.delete_product(product) do
          {:ok, deleted_product} ->
            {:reply, {:ok, deleted_product}, state}
          {:error, reason} ->
            {:reply, {:error, reason}, state}
        end
    end
  end

  def handle_call(:list_products, _from, state) do
    case Products.list_products() do
      products ->
        {:reply, {:ok, products}, state}
    end
  end
end
