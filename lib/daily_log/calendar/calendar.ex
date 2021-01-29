defmodule DailyLog.Calendar do
  alias DailyLog.Logs

  defmodule Month do
    defstruct [:month, :month_name, :year, :days, :empty_days_before, :empty_days_after]
  end

  defmodule Day do
    defstruct [:day, :day_of_the_week, :date, :log]
  end

  def build_month(date \\ Date.utc_today()) do
    start_date = Date.beginning_of_month(date)
    end_date = Date.end_of_month(date)

    %Month{
      month: date.month,
      month_name: month_name(date.month),
      year: date.year,
      empty_days_before: (Date.day_of_week(start_date) - 1) |> to_range(),
      empty_days_after: (7 - Date.day_of_week(end_date)) |> to_range(),
      days: build_days(start_date, end_date)
    }
  end

  def build_prev_month(%Month{year: year, month: 1}),
    do: build_month(%Date{day: 1, month: 12, year: year - 1})

  def build_prev_month(%Month{year: year, month: month}),
    do: build_month(%Date{day: 1, month: month - 1, year: year})

  def build_next_month(%Month{year: year, month: 12}),
    do: build_month(%Date{day: 1, month: 1, year: year + 1})

  def build_next_month(%Month{year: year, month: month}),
    do: build_month(%Date{day: 1, month: month + 1, year: year})

  def month_name(1), do: "January"
  def month_name(2), do: "February"
  def month_name(3), do: "March"
  def month_name(4), do: "April"
  def month_name(5), do: "May"
  def month_name(6), do: "June"
  def month_name(7), do: "July"
  def month_name(8), do: "August"
  def month_name(9), do: "September"
  def month_name(10), do: "October"
  def month_name(11), do: "November"
  def month_name(12), do: "December"

  defp to_range(0), do: []
  defp to_range(number), do: 1..number

  defp build_days(start_date, end_date) do
    logs = Logs.fetch_for_dates(start_date, end_date)

    Date.range(start_date, end_date)
    |> Enum.map(fn d ->
      %Day{day: d.day, day_of_the_week: Date.day_of_week(d), date: d, log: Enum.find(logs, &(&1.day == d))}
    end)
  end
end
