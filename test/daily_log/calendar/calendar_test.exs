defmodule DailyLog.CalendarTest do
  use DailyLog.DataCase
  alias DailyLog.Calendar

  setup do
    december_2020_calendar = %Calendar.Month{
      days: [
        %Calendar.Day{day: 1, date: ~D[2020-12-01], day_of_the_week: 2},
        %Calendar.Day{day: 2, date: ~D[2020-12-02], day_of_the_week: 3},
        %Calendar.Day{day: 3, date: ~D[2020-12-03], day_of_the_week: 4},
        %Calendar.Day{day: 4, date: ~D[2020-12-04], day_of_the_week: 5},
        %Calendar.Day{day: 5, date: ~D[2020-12-05], day_of_the_week: 6},
        %Calendar.Day{day: 6, date: ~D[2020-12-06], day_of_the_week: 7},
        %Calendar.Day{day: 7, date: ~D[2020-12-07], day_of_the_week: 1},
        %Calendar.Day{day: 8, date: ~D[2020-12-08], day_of_the_week: 2},
        %Calendar.Day{day: 9, date: ~D[2020-12-09], day_of_the_week: 3},
        %Calendar.Day{day: 10, date: ~D[2020-12-10], day_of_the_week: 4},
        %Calendar.Day{day: 11, date: ~D[2020-12-11], day_of_the_week: 5},
        %Calendar.Day{day: 12, date: ~D[2020-12-12], day_of_the_week: 6},
        %Calendar.Day{day: 13, date: ~D[2020-12-13], day_of_the_week: 7},
        %Calendar.Day{day: 14, date: ~D[2020-12-14], day_of_the_week: 1},
        %Calendar.Day{day: 15, date: ~D[2020-12-15], day_of_the_week: 2},
        %Calendar.Day{day: 16, date: ~D[2020-12-16], day_of_the_week: 3},
        %Calendar.Day{day: 17, date: ~D[2020-12-17], day_of_the_week: 4},
        %Calendar.Day{day: 18, date: ~D[2020-12-18], day_of_the_week: 5},
        %Calendar.Day{day: 19, date: ~D[2020-12-19], day_of_the_week: 6},
        %Calendar.Day{day: 20, date: ~D[2020-12-20], day_of_the_week: 7},
        %Calendar.Day{day: 21, date: ~D[2020-12-21], day_of_the_week: 1},
        %Calendar.Day{day: 22, date: ~D[2020-12-22], day_of_the_week: 2},
        %Calendar.Day{day: 23, date: ~D[2020-12-23], day_of_the_week: 3},
        %Calendar.Day{day: 24, date: ~D[2020-12-24], day_of_the_week: 4},
        %Calendar.Day{day: 25, date: ~D[2020-12-25], day_of_the_week: 5},
        %Calendar.Day{day: 26, date: ~D[2020-12-26], day_of_the_week: 6},
        %Calendar.Day{day: 27, date: ~D[2020-12-27], day_of_the_week: 7},
        %Calendar.Day{day: 28, date: ~D[2020-12-28], day_of_the_week: 1},
        %Calendar.Day{day: 29, date: ~D[2020-12-29], day_of_the_week: 2},
        %Calendar.Day{day: 30, date: ~D[2020-12-30], day_of_the_week: 3},
        %Calendar.Day{day: 31, date: ~D[2020-12-31], day_of_the_week: 4}
      ],
      empty_days_after: 1..3,
      empty_days_before: 1..1,
      month: 12,
      month_name: "December",
      year: 2020
    }

    %{december_2020_calendar: december_2020_calendar}
  end

  describe "build_month/1" do
    test "builds monthly calendar structure for passed date", %{
      december_2020_calendar: expected_calendar
    } do
      assert ^expected_calendar = Calendar.build_month(~D[2020-12-04])
    end

    test "builds monthly calendar structure for current date" do
      %Date{year: current_year, month: current_month} = Date.utc_today()

      assert %Calendar.Month{month: ^current_month, year: ^current_year} = Calendar.build_month()
    end

    test "builds monthly calendar structure with logs fetched from database", %{
      december_2020_calendar: calendar
    } do
      [first_day | days] = calendar.days

      first_day_with_log = %{
        first_day
        | log: DailyLog.Logs.Log.populate_virtual_fields(insert(:log, day: ~D[2020-12-01]))
      }

      expected_calendar = %{calendar | days: [first_day_with_log | days]}

      assert ^expected_calendar = Calendar.build_month(~D[2020-12-04])
    end
  end

  describe "build_prev_month/1" do
    test "builds monthly calendar structure that is before passed calendar", %{
      december_2020_calendar: expected_calendar
    } do
      assert ^expected_calendar =
               ~D[2021-01-28] |> Calendar.build_month() |> Calendar.build_prev_month()
    end
  end

  describe "build_next_month/1" do
    test "builds monthly calendar structure that is after passed calendar", %{
      december_2020_calendar: expected_calendar
    } do
      assert ^expected_calendar =
               ~D[2020-11-15] |> Calendar.build_month() |> Calendar.build_next_month()
    end
  end
end
