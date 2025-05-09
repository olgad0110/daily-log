defmodule DailyLogWeb.Router do
  use DailyLogWeb, :router
  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {DailyLogWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DailyLogWeb do
    pipe_through :browser

    live "/", CalendarLive
    live "/logs", LogLive

    live_dashboard "/dashboard", metrics: DailyLogWeb.Telemetry
  end
end
