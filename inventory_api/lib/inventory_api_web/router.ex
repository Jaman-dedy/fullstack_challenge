defmodule InventoryApiWeb.Router do
  use InventoryApiWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {InventoryApiWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", InventoryApiWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  scope "/api", InventoryApiWeb do
    pipe_through :api

    # Inventory endpoints
    post "/init_catalog", InventoryController, :create
    post "/process_restock", InventoryController, :process_restock
    post "/inventory", InventoryController, :create
    get "/inventory/:id", InventoryController, :show
    put "/inventory/:id", InventoryController, :update

    # Order endpoints
    post "/process_order", OrderController, :process_order
    post "/orders", OrderController, :create
    get "/orders/:id", OrderController, :show
    put "/orders/:id", OrderController, :update

    # Shipping endpoints
    post "/ship_package", ShippingController, :ship_package
    post "/shipping", ShippingController, :create
    get "/shipping/:id", ShippingController, :show
    put "/shipping/:id", ShippingController, :update

  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:inventory_api, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: InventoryApiWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
