defmodule DailyLog.LogsTest do
  use DailyLog.DataCase
  alias DailyLog.Logs

  describe "validate/2" do
    test "returns invalid changeset with empty params" do
      assert %Ecto.Changeset{
               errors: [
                 {:mood,
                  {"should have %{count} item(s)",
                   [count: 3, validation: :length, kind: :is, type: :list]}},
                 {:mood_evening,
                  {"should have %{count} item(s)",
                   [count: 1, validation: :length, kind: :is, type: :list]}},
                 {:mood_afternoon,
                  {"should have %{count} item(s)",
                   [count: 1, validation: :length, kind: :is, type: :list]}},
                 {:mood_morning,
                  {"should have %{count} item(s)",
                   [count: 1, validation: :length, kind: :is, type: :list]}},
                 {:day, {"can't be blank", [validation: :required]}},
                 {:description, {"can't be blank", [validation: :required]}}
               ],
               valid?: false
             } = Logs.validate(%Logs.Log{}, %{})
    end

    test "returns valid changeset with validations met" do
      assert %Ecto.Changeset{
               changes: %{
                 day: ~D[2020-02-02],
                 description: "a description",
                 mood: ["very_good", "neutral", "bad"],
                 mood_afternoon: ["neutral"],
                 mood_afternoon_bad: "false",
                 mood_afternoon_good: "false",
                 mood_afternoon_neutral: "true",
                 mood_afternoon_very_bad: "false",
                 mood_afternoon_very_good: "false",
                 mood_evening: ["bad"],
                 mood_evening_bad: "true",
                 mood_evening_good: "false",
                 mood_evening_neutral: "false",
                 mood_evening_very_bad: "false",
                 mood_evening_very_good: "false",
                 mood_morning: ["very_good"],
                 mood_morning_bad: "false",
                 mood_morning_good: "false",
                 mood_morning_neutral: "false",
                 mood_morning_very_bad: "false",
                 mood_morning_very_good: "true"
               },
               errors: [],
               valid?: true
             } =
               Logs.validate(%Logs.Log{}, %{
                 "day" => ~D[2020-02-02],
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
               })
    end
  end

  describe "insert_or_update/1" do
    test "persists log if not yet in db" do
      changeset = build(:log, day: ~D[2021-01-01]) |> Ecto.Changeset.change(%{})

      assert {:ok, %Logs.Log{id: id}} = Logs.insert_or_update(changeset)

      assert [%Logs.Log{id: ^id}] = Repo.all(Logs.Log)
    end

    test "updates log if already exists" do
      changeset = insert(:log, day: ~D[2021-01-01]) |> Ecto.Changeset.change(%{description: "a"})

      assert {:ok, %Logs.Log{id: id, description: "a"}} = Logs.insert_or_update(changeset)

      assert [%Logs.Log{id: ^id}] = Repo.all(Logs.Log)
    end
  end

  describe "fetch_for_dates/2" do
    test "returns empty array if no logs between dates" do
      assert [] = Logs.fetch_for_dates(~D[2020-01-01], ~D[2020-01-21])
    end

    test "returns array with logs between dates" do
      insert(:log, day: ~D[2019-12-31])
      insert(:log, day: ~D[2020-01-01])
      insert(:log, day: ~D[2020-01-13])
      insert(:log, day: ~D[2020-01-21])
      insert(:log, day: ~D[2020-01-25])

      assert [
               %Logs.Log{day: ~D[2020-01-01]},
               %Logs.Log{day: ~D[2020-01-13]},
               %Logs.Log{day: ~D[2020-01-21]}
             ] = Logs.fetch_for_dates(~D[2020-01-01], ~D[2020-01-21])
    end

    test "returns log with populated css class" do
      insert(:log, day: ~D[2020-01-01])

      assert [
               %Logs.Log{
                 day: ~D[2020-01-01],
                 css_class: "gradient-blue-light-grey-light-orange-light"
               }
             ] = Logs.fetch_for_dates(~D[2020-01-01], ~D[2020-01-21])
    end
  end
end
