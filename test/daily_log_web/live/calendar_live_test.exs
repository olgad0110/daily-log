defmodule DailyLogWeb.CalendarLiveTest do
  use DailyLogWeb.ConnCase
  import Phoenix.LiveViewTest
  alias DailyLog.Calendar

  setup do
    calendar = Calendar.build_month()

    %{
      calendar: calendar
    }
  end

  test "renders current calendar view", %{conn: conn, calendar: calendar} do
    expected_header = "#{calendar.month_name} #{calendar.year}"

    {:ok, live_view, disconnected_html} = live(conn, "/")

    assert disconnected_html =~ "<div class=\"calendar-box\">"
    assert disconnected_html =~ expected_header

    assert render(live_view) =~ "<div class=\"calendar-box\">"
    assert render(live_view) =~ expected_header
  end

  test "changes month to previous one on link click", %{conn: conn, calendar: calendar} do
    prev_month = calendar |> Calendar.build_prev_month()

    {:ok, live_view, _} = live(conn, "/")
    assert render(live_view) =~ "#{calendar.month_name} #{calendar.year}"

    assert render_click(live_view, "prev-month", %{}) =~
             "#{prev_month.month_name} #{prev_month.year}"
  end

  test "changes month to next one on link click", %{conn: conn, calendar: calendar} do
    next_month = calendar |> Calendar.build_next_month()

    {:ok, live_view, _} = live(conn, "/")
    assert render(live_view) =~ "#{calendar.month_name} #{calendar.year}"

    assert render_click(live_view, "next-month", %{}) =~
             "#{next_month.month_name} #{next_month.year}"
  end

  test "changes month to previous one on keyup [", %{conn: conn, calendar: calendar} do
    prev_month = calendar |> Calendar.build_prev_month()

    {:ok, live_view, _} = live(conn, "/")
    assert render(live_view) =~ "#{calendar.month_name} #{calendar.year}"

    assert render_keyup(live_view, "update-calendar-month", %{"key" => "["}) =~
             "#{prev_month.month_name} #{prev_month.year}"
  end

  test "changes month to next one on keyup ]", %{conn: conn, calendar: calendar} do
    next_month = calendar |> Calendar.build_next_month()

    {:ok, live_view, _} = live(conn, "/")
    assert render(live_view) =~ "#{calendar.month_name} #{calendar.year}"

    assert render_keyup(live_view, "update-calendar-month", %{"key" => "]"}) =~
             "#{next_month.month_name} #{next_month.year}"
  end
end
