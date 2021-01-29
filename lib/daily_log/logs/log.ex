defmodule DailyLog.Logs.Log do
  use Ecto.Schema

  schema "logs" do
    field(:day, :date)
    field(:mood, {:array, :string})
    field(:description, :string)

    field(:mood_morning, :string, virtual: true)
    field(:mood_morning_very_good, :string, virtual: true)
    field(:mood_morning_good, :string, virtual: true)
    field(:mood_morning_neutral, :string, virtual: true)
    field(:mood_morning_bad, :string, virtual: true)
    field(:mood_morning_very_bad, :string, virtual: true)
    field(:mood_afternoon, :string, virtual: true)
    field(:mood_afternoon_very_good, :string, virtual: true)
    field(:mood_afternoon_good, :string, virtual: true)
    field(:mood_afternoon_neutral, :string, virtual: true)
    field(:mood_afternoon_bad, :string, virtual: true)
    field(:mood_afternoon_very_bad, :string, virtual: true)
    field(:mood_evening, :string, virtual: true)
    field(:mood_evening_very_good, :string, virtual: true)
    field(:mood_evening_good, :string, virtual: true)
    field(:mood_evening_neutral, :string, virtual: true)
    field(:mood_evening_bad, :string, virtual: true)
    field(:mood_evening_very_bad, :string, virtual: true)

    timestamps()
  end
end
