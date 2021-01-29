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

    field(:css_class, :string, virtual: true)

    timestamps()
  end

  @mood_virtual_fields [
    :mood_morning_very_good,
    :mood_morning_good,
    :mood_morning_neutral,
    :mood_morning_bad,
    :mood_morning_very_bad,
    :mood_afternoon_very_good,
    :mood_afternoon_good,
    :mood_afternoon_neutral,
    :mood_afternoon_bad,
    :mood_afternoon_very_bad,
    :mood_evening_very_good,
    :mood_evening_good,
    :mood_evening_neutral,
    :mood_evening_bad,
    :mood_evening_very_bad
  ]

  def day_changeset(changeset, day) do
    Ecto.Changeset.change(changeset, %{day: day})
  end

  def validate_changeset(changeset, params) do
    [mood_morning, mood_afternoon, mood_evening] = mood_list = build_mood_list_from_params(params)

    changeset
    |> Ecto.Changeset.cast(params, @mood_virtual_fields ++ [:day, :description])
    |> Ecto.Changeset.put_change(:mood_morning, mood_morning)
    |> Ecto.Changeset.put_change(:mood_afternoon, mood_afternoon)
    |> Ecto.Changeset.put_change(:mood_evening, mood_evening)
    |> Ecto.Changeset.put_change(:mood, mood_list |> Enum.concat())
    |> Ecto.Changeset.validate_required([:day, :mood, :description])
    |> Ecto.Changeset.validate_length(:description, max: 2_000)
    |> Ecto.Changeset.validate_length(:mood_morning, is: 1)
    |> Ecto.Changeset.validate_length(:mood_afternoon, is: 1)
    |> Ecto.Changeset.validate_length(:mood_evening, is: 1)
    |> Ecto.Changeset.validate_length(:mood, is: 3)
    |> Ecto.Changeset.unique_constraint(:day)
  end

  def populate_css_class(log) do
    [m, a, e] = log.mood
    %{log | css_class: "gradient-#{css_class(m)}-#{css_class(a)}-#{css_class(e)}"}
  end

  defp css_class("very_bad"), do: "blue"
  defp css_class("bad"), do: "blue-light"
  defp css_class("neutral"), do: "grey-light"
  defp css_class("good"), do: "orange-light"
  defp css_class("very_good"), do: "orange"

  defp build_mood_list_from_params(params) do
    [
      params |> build_mood_from_params("morning"),
      params |> build_mood_from_params("afternoon"),
      params |> build_mood_from_params("evening")
    ]
  end

  defp build_mood_from_params(params, index) do
    params
    |> Enum.filter(fn {k, v} -> String.starts_with?(k, "mood_#{index}") and v == "true" end)
    |> Enum.map(fn {k, _} -> String.replace(k, "mood_#{index}_", "") end)
  end
end
