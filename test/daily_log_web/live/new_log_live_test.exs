defmodule DailyLogWeb.NewLogLiveTest do
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
    {:ok, new_log_live, disconnected_html} = live(conn, "/logs/new?day=2020-01-01")

    assert disconnected_html =~ "New log for 2020-01-01"
    assert render(new_log_live) =~ "New log for 2020-01-01"

    assert disconnected_html =~ "<p class=\"orange-light\">mood_morning should have 1 item(s)</p>"

    assert disconnected_html =~
             "<p class=\"orange-light\">mood_afternoon should have 1 item(s)</p>"

    assert disconnected_html =~ "<p class=\"orange-light\">mood_evening should have 1 item(s)</p>"
    assert disconnected_html =~ "<p class=\"orange-light\">description can&apos;t be blank</p>"
  end

  test "stops rendering error messages on form change", %{conn: conn} do
    {:ok, new_log_live, disconnected_html} = live(conn, "/logs/new?day=2020-01-01")
    assert disconnected_html =~ "New log for 2020-01-01"
    assert render(new_log_live) =~ "New log for 2020-01-01"

    render_change(new_log_live, :validate, @valid_params)

    refute render(new_log_live) =~
             "<p class=\"orange-light\">mood_morning should have 1 item(s)</p>"

    refute render(new_log_live) =~
             "<p class=\"orange-light\">mood_afternoon should have 1 item(s)</p>"

    refute render(new_log_live) =~
             "<p class=\"orange-light\">mood_evening should have 1 item(s)</p>"

    refute render(new_log_live) =~ "<p class=\"orange-light\">description can&apos;t be blank</p>"
  end

  test "renders error messages about day not unique on form submit", %{conn: conn} do
    insert(:log, day: ~D[2020-01-01])

    assert [%DailyLog.Logs.Log{day: ~D[2020-01-01]}] = DailyLog.Repo.all(DailyLog.Logs.Log)

    {:ok, new_log_live, disconnected_html} = live(conn, "/logs/new?day=2020-01-01")
    assert disconnected_html =~ "New log for 2020-01-01"
    assert render(new_log_live) =~ "New log for 2020-01-01"

    render_change(new_log_live, :validate, @valid_params)

    assert render_submit(new_log_live, :save, @valid_params) =~
             "<p class=\"orange-light\">day has already been taken</p>"

    assert [%DailyLog.Logs.Log{day: ~D[2020-01-01]}] = DailyLog.Repo.all(DailyLog.Logs.Log)
  end

  test "saves valid log on form submit", %{conn: conn} do
    {:ok, new_log_live, disconnected_html} = live(conn, "/logs/new?day=2020-01-01")
    assert disconnected_html =~ "New log for 2020-01-01"
    assert render(new_log_live) =~ "New log for 2020-01-01"

    render_change(new_log_live, :validate, @valid_params)
    render_submit(new_log_live, :save, @valid_params)

    assert assert_redirect(new_log_live, "/")

    assert [
             %DailyLog.Logs.Log{
               day: ~D[2020-01-01],
               description: "a description",
               mood: ["very_good", "neutral", "bad"]
             }
           ] = DailyLog.Repo.all(DailyLog.Logs.Log)
  end
end
