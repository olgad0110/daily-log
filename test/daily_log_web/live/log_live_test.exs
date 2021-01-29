defmodule DailyLogWeb.LogLiveTest do
  use DailyLogWeb.ConnCase
  import Phoenix.LiveViewTest

  @valid_params %{
    "log" => %{
      "description" => "a description",
      "mood_afternoon_bad" => "false",
      "mood_afternoon_good" => "false",
      "mood_afternoon_neutral" => "true",
      "mood_afternoon_very_bad" => "false",
      "mood_afternoon_very_good" => "false",
      "mood_evening_bad" => "true",
      "mood_evening_good" => "false",
      "mood_evening_neutral" => "false",
      "mood_evening_very_bad" => "false",
      "mood_evening_very_good" => "false",
      "mood_morning_bad" => "false",
      "mood_morning_good" => "false",
      "mood_morning_neutral" => "false",
      "mood_morning_very_bad" => "false",
      "mood_morning_very_good" => "true"
    }
  }

  test "renders new log view", %{conn: conn} do
    {:ok, live_view, disconnected_html} = live(conn, "/logs?day=2020-01-01")

    assert disconnected_html =~ "Log for 2020-01-01"
    assert render(live_view) =~ "Log for 2020-01-01"
  end

  test "renders error messages on form change", %{conn: conn} do
    {:ok, live_view, disconnected_html} = live(conn, "/logs?day=2020-01-01")
    assert disconnected_html =~ "Log for 2020-01-01"
    assert render(live_view) =~ "Log for 2020-01-01"

    render_change(live_view, :validate, %{"log" => %{"mood_afternoon_bad" => "false"}})

    assert render(live_view) =~
             "<p class=\"orange-light\">mood_morning should have 1 item(s)</p>"

    assert render(live_view) =~
             "<p class=\"orange-light\">mood_afternoon should have 1 item(s)</p>"

    assert render(live_view) =~
             "<p class=\"orange-light\">mood_evening should have 1 item(s)</p>"

    assert render(live_view) =~ "<p class=\"orange-light\">description can&apos;t be blank</p>"
  end

  test "stops rendering error messages on form change with valid params", %{conn: conn} do
    {:ok, live_view, disconnected_html} = live(conn, "/logs?day=2020-01-01")
    assert disconnected_html =~ "Log for 2020-01-01"
    assert render(live_view) =~ "Log for 2020-01-01"

    render_change(live_view, :validate, @valid_params)

    refute render(live_view) =~
             "<p class=\"orange-light\">mood_morning should have 1 item(s)</p>"

    refute render(live_view) =~
             "<p class=\"orange-light\">mood_afternoon should have 1 item(s)</p>"

    refute render(live_view) =~
             "<p class=\"orange-light\">mood_evening should have 1 item(s)</p>"

    refute render(live_view) =~ "<p class=\"orange-light\">description can&apos;t be blank</p>"
  end

  test "saves valid log on form submit", %{conn: conn} do
    {:ok, live_view, disconnected_html} = live(conn, "/logs?day=2020-01-01")
    assert disconnected_html =~ "Log for 2020-01-01"
    assert render(live_view) =~ "Log for 2020-01-01"

    render_change(live_view, :validate, @valid_params)
    render_submit(live_view, :save, @valid_params)

    assert assert_redirect(live_view, "/")

    assert [
             %DailyLog.Logs.Log{
               day: ~D[2020-01-01],
               description: "a description",
               mood: ["very_good", "neutral", "bad"]
             }
           ] = DailyLog.Repo.all(DailyLog.Logs.Log)
  end

  test "updates valid existin log on form submit", %{conn: conn} do
    insert(:log, day: ~D[2020-01-01])

    {:ok, live_view, disconnected_html} = live(conn, "/logs?day=2020-01-01")
    assert disconnected_html =~ "Log for 2020-01-01"
    assert render(live_view) =~ "Log for 2020-01-01"

    render_change(live_view, :validate, @valid_params)
    render_submit(live_view, :save, @valid_params)

    assert assert_redirect(live_view, "/")

    assert [
             %DailyLog.Logs.Log{
               day: ~D[2020-01-01],
               description: "a description",
               mood: ["very_good", "neutral", "bad"]
             }
           ] = DailyLog.Repo.all(DailyLog.Logs.Log)
  end
end
