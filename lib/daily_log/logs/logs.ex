defmodule DailyLog.Logs do
  alias DailyLog.{Logs.Log, Repo}

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

  def new(day) do
    %Log{}
    |> Ecto.Changeset.change(%{day: day})
  end

  def validate(params) do
    [mood_morning, mood_afternoon, mood_evening] = mood_list = build_mood_list_from_params(params)

    %Log{}
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

  def create(changeset) do
    changeset
    |> Repo.insert()
  end

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
