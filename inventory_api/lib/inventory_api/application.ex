defmodule InventoryApi.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      InventoryApiWeb.Telemetry,
      InventoryApi.Repo,
      {DNSCluster, query: Application.get_env(:inventory_api, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: InventoryApi.PubSub},
      {Finch, name: InventoryApi.Finch},
      {Phoenix.PubSub, name: InventoryApi.PubSub},
      InventoryApiWeb.Endpoint,
      {InventoryApi.Services.InventoryService, []},
      {InventoryApi.Services.OrderService, []},
      {InventoryApi.Services.ShippingService, []},
      {InventoryApi.Services.RestockService, []}

    ]

    opts = [strategy: :one_for_one, name: InventoryApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    InventoryApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
