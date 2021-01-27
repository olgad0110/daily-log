defmodule DailyLogWeb.CalendarLive do
  use DailyLogWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, calendar: DailyLog.Calendar.build_month())}
  end

  @impl true
  def handle_event("prev-month", _params, socket) do
    {:noreply, assign(socket, calendar: prev_month(socket))}
  end

  @impl true
  def handle_event("next-month", _params, socket) do
    {:noreply, assign(socket, calendar: next_month(socket))}
  end

  @impl true
  def handle_event("update-calendar-month", %{"key" => "["}, socket) do
    {:noreply, assign(socket, calendar: prev_month(socket))}
  end

  @impl true
  def handle_event("update-calendar-month", %{"key" => "]"}, socket) do
    {:noreply, assign(socket, calendar: next_month(socket))}
  end

  @impl true
  def handle_event("update-calendar-month", %{"key" => _}, socket) do
    {:noreply, socket}
  end

  defp prev_month(%{assigns: %{calendar: calendar}}),
    do: calendar |> DailyLog.Calendar.build_prev_month()

  defp next_month(%{assigns: %{calendar: calendar}}),
    do: calendar |> DailyLog.Calendar.build_next_month()
end
