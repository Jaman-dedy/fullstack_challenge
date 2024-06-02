import Config

# Configure your database
config :inventory_api, InventoryApi.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "db",
  database: "inventory_api_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :inventory_api, InventoryApiWeb.Endpoint,
  http: [ip: {0, 0, 0, 0}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "REr0ZwcWki7DSIbTpSj0gxp1+O8p71NKtGpc2Fw8YOWndgHt1sonRV6TXxfRFjBT"
  # watchers: [
  #   esbuild: {Esbuild, :install_and_run, [:inventory_api, ~w(--sourcemap=inline --watch)]},
  #   tailwind: {Tailwind, :install_and_run, [:inventory_api, ~w(--watch)]}
  # ]

config :inventory_api, InventoryApiWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/(?!uploads/).*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/inventory_api_web/(controllers|live|components)/.*(ex|heex)$"
    ]
  ]

# Enable dev routes for dashboard and mailbox
config :inventory_api, dev_routes: true

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

config :phoenix_live_view,
  # Include HEEx debug annotations as HTML comments in rendered markup
  debug_heex_annotations: true,
  # Enable helpful, but potentially expensive runtime checks
  enable_expensive_runtime_checks: true

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false
