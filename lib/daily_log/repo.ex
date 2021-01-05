defmodule DailyLog.Repo do
  use Ecto.Repo,
    otp_app: :daily_log,
    adapter: Ecto.Adapters.Postgres
end
