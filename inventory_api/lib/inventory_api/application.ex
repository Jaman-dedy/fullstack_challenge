defmodule InventoryApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      InventoryApiWeb.Telemetry,
      InventoryApi.Repo,
      {DNSCluster, query: Application.get_env(:inventory_api, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: InventoryApi.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: InventoryApi.Finch},
      # Start a worker by calling: InventoryApi.Worker.start_link(arg)
      # {InventoryApi.Worker, arg},
      # Start to serve requests, typically the last entry
      InventoryApiWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: InventoryApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    InventoryApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
