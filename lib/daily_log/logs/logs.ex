defmodule DailyLog.Logs do
  alias DailyLog.{Logs.Log, Repo}
  import Ecto.Query

  def validate(log, params) do
    Log.changeset(log, params)
  end

  def get_or_init_by_day(%Date{} = day) do
    Log
    |> Repo.get_by(day: day)
    |> case do
      nil -> %Log{day: day}
      log -> Log.populate_virtual_fields(log)
    end
    |> Ecto.Changeset.change(%{})
  end

  def insert_or_update(log) do
    Repo.insert_or_update(log)
  end

  def fetch_for_dates(start_date, end_date) do
    from(l in Log, where: l.day >= ^start_date and l.day <= ^end_date)
    |> Repo.all()
    |> Enum.map(&Log.populate_virtual_fields(&1))
  end
end
