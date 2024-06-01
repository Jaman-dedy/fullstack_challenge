defmodule InventoryApi.Services.OrderService do
  use GenServer
  alias InventoryApi.Order.Orders

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def process_order(order_params) do
    GenServer.call(__MODULE__, {:process_order, order_params})
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

  def handle_call({:process_order, order_params}, _from, state) do
    case Orders.create_order(order_params) do
      {:ok, order} ->
        {:reply, {:ok, order}, state}
      {:error, changeset} ->
        {:reply, {:error, changeset}, state}
    end
  end

  def handle_call({:create_order, attrs}, _from, state) do
    case Orders.create_order(attrs) do
      {:ok, order} ->
        {:reply, {:ok, order}, state}
      {:error, changeset} ->
        {:reply, {:error, changeset}, state}
    end
  end

  def handle_call({:get_order, id}, _from, state) do
    case Orders.get_order(id) do
      nil ->
        {:reply, {:error, :not_found}, state}
      order ->
        {:reply, {:ok, order}, state}
    end
  end

  def handle_call({:update_order, id, attrs}, _from, state) do
    case Orders.get_order(id) do
      nil ->
        {:reply, {:error, :not_found}, state}
      order ->
        case Orders.update_order(order, attrs) do
          {:ok, updated_order} ->
            {:reply, {:ok, updated_order}, state}
          {:error, changeset} ->
            {:reply, {:error, changeset}, state}
        end
    end
  end
end
