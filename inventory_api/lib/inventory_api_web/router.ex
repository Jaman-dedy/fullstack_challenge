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

  scope "/api/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI,
      otp_app: :inventory_api,
      swagger_file: "swagger.json",
      disable_validator: true
  end

  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "Inventory API"
      },
      schemes: ["http", "https"],
      consumes: ["application/json"],
      produces: ["application/json"],
      tags: [
        %{name: "Inventories", description: "Operations about Inventories"}
      ],

      definitions: Map.merge(
      InventoryApiWeb.InventorySchemas.swagger_definitions(),
      InventoryApiWeb.OrderSchemas.swagger_definitions()
      )
      |> Map.merge(InventoryApiWeb.ShippingSchemas.swagger_definitions())
    }
  end

  scope "/api", InventoryApiWeb do
    pipe_through :api

    post "/init_catalog", InventoriesController, :init_catalog
    get "/catalog", InventoriesController, :get_catalog
    post "/reset_catalog", InventoriesController, :re_init_catalog
    post "/process_restock", InventoriesController, :process_restock
    get "/get_inventories", InventoriesController, :get_inventories
    post "/process_order", OrdersController, :process_order
    get "/orders/:order_id", OrdersController, :get_order_by_order_id
    post "/ship_package", ShippingsController, :ship_package
    get "/shippings/:order_id", ShippingsController, :get_shipped_packages_by_order_id
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
