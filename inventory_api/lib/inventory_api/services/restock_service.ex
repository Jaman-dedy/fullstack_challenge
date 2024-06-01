defmodule InventoryApi.Services.RestockService do
  use GenServer
  alias InventoryApi.Restock.Restocks

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def create_restock(attrs \\ %{}) do
    GenServer.call(__MODULE__, {:create_restock, attrs})
  end

  def get_restock(id) do
    GenServer.call(__MODULE__, {:get_restock, id})
  end

  def handle_call({:create_restock, attrs}, _from, state) do
    case Restocks.create_restock(attrs) do
      {:ok, restock} ->
        {:reply, {:ok, restock}, state}
      {:error, changeset} ->
        {:reply, {:error, changeset}, state}
    end
  end

  def handle_call({:get_restock, id}, _from, state) do
    case Restocks.get_restock(id) do
      nil ->
        {:reply, {:error, :not_found}, state}
      restock ->
        {:reply, {:ok, restock}, state}
    end
  end
end
