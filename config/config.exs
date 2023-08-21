# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :rinha_backend,
  ecto_repos: [RinhaBackend.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :rinha_backend, RinhaBackendWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [json: RinhaBackendWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: RinhaBackend.PubSub,
  live_view: [signing_salt: "tkOW4VhW"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :rinha_backend, RinhaBackend.Pessoas,
  gc_interval: :timer.hours(12),
  max_size: 1_000_000,
  allocated_memory: 2_000_000_000,
  gc_cleanup_min_timeout: :timer.seconds(10),
  gc_cleanup_max_timeout: :timer.minutes(10),
  conn_opts: [
    host: "redis",
    port: 6379
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
