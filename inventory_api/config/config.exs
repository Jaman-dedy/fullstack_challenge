import Config

config :inventory_api, :phoenix_swagger,
  swagger_files: %{
    "priv/static/swagger.json" => [
      router: InventoryApiWeb.Router,
      endpoint: InventoryApiWeb.Endpoint
    ]
  }
config :phoenix_swagger, json_library: Jason

config :inventory_api,
  ecto_repos: [InventoryApi.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :inventory_api, InventoryApiWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: InventoryApiWeb.ErrorHTML, json: InventoryApiWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: InventoryApi.PubSub,
  live_view: [signing_salt: "7xEnRZ0+"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :inventory_api, InventoryApi.Mailer, adapter: Swoosh.Adapters.Local

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  inventory_api: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.0",
  inventory_api: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
