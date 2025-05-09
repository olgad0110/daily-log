defmodule DailyLog.Logs.LogTest do
  use DailyLog.DataCase
  alias DailyLog.Logs.Log

  describe "changeset/2" do
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
             } = Log.changeset(%Log{}, %{})
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
               Log.changeset(%Log{}, %{
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

  describe "populate_virtual_fields/1" do
    test "returns css class for all neutral" do
      assert %Log{css_class: "gradient-grey-light-grey-light-grey-light"} =
               Log.populate_virtual_fields(%Log{mood: ["neutral", "neutral", "neutral"]})
    end

    test "returns css class for bad and very bad" do
      assert %Log{css_class: "gradient-blue-light-blue-light-blue"} =
               Log.populate_virtual_fields(%Log{mood: ["bad", "bad", "very_bad"]})
    end

    test "returns css class for good and very good" do
      assert %Log{css_class: "gradient-orange-orange-orange-light"} =
               Log.populate_virtual_fields(%Log{mood: ["very_good", "very_good", "good"]})
    end

    test "returns mood fields for morning" do
      assert %Log{
               mood_morning: ["neutral"],
               mood_morning_very_good: "false",
               mood_morning_good: "false",
               mood_morning_neutral: "true",
               mood_morning_bad: "false",
               mood_morning_very_bad: "false"
             } = Log.populate_virtual_fields(%Log{mood: ["neutral", "bad", "very_good"]})
    end

    test "returns mood fields for afternoon" do
      assert %Log{
               mood_afternoon: ["bad"],
               mood_afternoon_very_good: "false",
               mood_afternoon_good: "false",
               mood_afternoon_neutral: "false",
               mood_afternoon_bad: "true",
               mood_afternoon_very_bad: "false"
             } = Log.populate_virtual_fields(%Log{mood: ["neutral", "bad", "very_good"]})
    end

    test "returns mood fields for evening" do
      assert %Log{
               mood_evening: ["very_good"],
               mood_evening_very_good: "true",
               mood_evening_good: "false",
               mood_evening_neutral: "false",
               mood_evening_bad: "false",
               mood_evening_very_bad: "false"
             } = Log.populate_virtual_fields(%Log{mood: ["neutral", "bad", "very_good"]})
    end
  end
end
