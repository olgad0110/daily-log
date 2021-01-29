defmodule DailyLog.Factory do
  use ExMachina.Ecto, repo: DailyLog.Repo

  def log_factory do
    %DailyLog.Logs.Log{
      day: ~D[2021-01-01],
      description: "some short description",
      mood: ["bad", "neutral", "good"]
    }
  end
end
