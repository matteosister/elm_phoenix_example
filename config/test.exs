use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :elm_list, ElmList.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :elm_list, ElmList.Repo,
  adapter: Ecto.Adapters.MySQL,
  username: "root",
  password: "elm_list",
  database: "elm_list_test",
  hostname: "db",
  pool: Ecto.Adapters.SQL.Sandbox
