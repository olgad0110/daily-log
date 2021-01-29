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

  def changeset(log, params) do
    [mood_morning, mood_afternoon, mood_evening] = mood_list = build_mood_list_from_params(params)

    log
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

  def populate_virtual_fields(%__MODULE__{mood: [m, a, e] = moods} = log) do
    %{
      log
      | css_class: css_class(moods),
        mood_morning: [m],
        mood_morning_very_good: mood_virtual_field("very_good", m),
        mood_morning_good: mood_virtual_field("good", m),
        mood_morning_neutral: mood_virtual_field("neutral", m),
        mood_morning_bad: mood_virtual_field("bad", m),
        mood_morning_very_bad: mood_virtual_field("very_bad", m),
        mood_afternoon: [a],
        mood_afternoon_very_good: mood_virtual_field("very_good", a),
        mood_afternoon_good: mood_virtual_field("good", a),
        mood_afternoon_neutral: mood_virtual_field("neutral", a),
        mood_afternoon_bad: mood_virtual_field("bad", a),
        mood_afternoon_very_bad: mood_virtual_field("very_bad", a),
        mood_evening: [e],
        mood_evening_very_good: mood_virtual_field("very_good", e),
        mood_evening_good: mood_virtual_field("good", e),
        mood_evening_neutral: mood_virtual_field("neutral", e),
        mood_evening_bad: mood_virtual_field("bad", e),
        mood_evening_very_bad: mood_virtual_field("very_bad", e)
    }
  end

  defp css_class([m, a, e]), do: "gradient-#{css_class(m)}-#{css_class(a)}-#{css_class(e)}"
  defp css_class("very_bad"), do: "blue"
  defp css_class("bad"), do: "blue-light"
  defp css_class("neutral"), do: "grey-light"
  defp css_class("good"), do: "orange-light"
  defp css_class("very_good"), do: "orange"

  defp mood_virtual_field(value, value), do: "true"
  defp mood_virtual_field(_, _), do: "false"

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
