defmodule DailyLog.Logs do
  alias DailyLog.{Logs.Log, Repo}
  import Ecto.Query

  def new(%Date{} = day) do
    %Log{}
    |> Log.day_changeset(day)
  end

  def validate(params) do
    %Log{}
    |> Log.validate_changeset(params)
  end

  def create(changeset) do
    changeset
    |> Repo.insert()
  end

  def fetch_for_dates(start_date, end_date) do
    from(l in Log, where: l.day >= ^start_date and l.day <= ^end_date)
    |> Repo.all()
    |> Enum.map(&Log.populate_css_class(&1))
  end
end
