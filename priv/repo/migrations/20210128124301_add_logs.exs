defmodule DailyLog.Repo.Migrations.AddLogs do
  use Ecto.Migration

  def change do
    create table(:logs) do
      add(:day, :date)
      add(:mood, {:array, :string})
      add(:description, :string, size: 2_000)

      timestamps()
    end

    create index(:logs, [:day], unique: true)
  end
end
