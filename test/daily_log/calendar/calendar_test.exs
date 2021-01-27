defmodule DailyLog.CalendarTest do
  use DailyLog.DataCase
  alias DailyLog.Calendar

  setup do
    december_2020_calendar = %Calendar.Month{
      days: [
        %Calendar.Day{day: 1, day_of_the_week: 2},
        %Calendar.Day{day: 2, day_of_the_week: 3},
        %Calendar.Day{day: 3, day_of_the_week: 4},
        %Calendar.Day{day: 4, day_of_the_week: 5},
        %Calendar.Day{day: 5, day_of_the_week: 6},
        %Calendar.Day{day: 6, day_of_the_week: 7},
        %Calendar.Day{day: 7, day_of_the_week: 1},
        %Calendar.Day{day: 8, day_of_the_week: 2},
        %Calendar.Day{day: 9, day_of_the_week: 3},
        %Calendar.Day{day: 10, day_of_the_week: 4},
        %Calendar.Day{day: 11, day_of_the_week: 5},
        %Calendar.Day{day: 12, day_of_the_week: 6},
        %Calendar.Day{day: 13, day_of_the_week: 7},
        %Calendar.Day{day: 14, day_of_the_week: 1},
        %Calendar.Day{day: 15, day_of_the_week: 2},
        %Calendar.Day{day: 16, day_of_the_week: 3},
        %Calendar.Day{day: 17, day_of_the_week: 4},
        %Calendar.Day{day: 18, day_of_the_week: 5},
        %Calendar.Day{day: 19, day_of_the_week: 6},
        %Calendar.Day{day: 20, day_of_the_week: 7},
        %Calendar.Day{day: 21, day_of_the_week: 1},
        %Calendar.Day{day: 22, day_of_the_week: 2},
        %Calendar.Day{day: 23, day_of_the_week: 3},
        %Calendar.Day{day: 24, day_of_the_week: 4},
        %Calendar.Day{day: 25, day_of_the_week: 5},
        %Calendar.Day{day: 26, day_of_the_week: 6},
        %Calendar.Day{day: 27, day_of_the_week: 7},
        %Calendar.Day{day: 28, day_of_the_week: 1},
        %Calendar.Day{day: 29, day_of_the_week: 2},
        %Calendar.Day{day: 30, day_of_the_week: 3},
        %Calendar.Day{day: 31, day_of_the_week: 4}
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
