use Mix.Config

config :daily_log,
  ecto_repos: [DailyLog.Repo]

config :daily_log, DailyLogWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ex+ZW/xXTZ177nr1ONi2sWs7nXPGQWc5wFCTPSypX89hWU3pMKDAvtCJIG5bvFzq",
  render_errors: [view: DailyLogWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: DailyLog.PubSub,
  live_view: [signing_salt: "9NJGJp4d"]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

if File.exists?("config/#{Mix.env()}.exs"), do: import_config("#{Mix.env()}.exs")
