defmodule MusicIan.Repo.Migrations.CreateLessonResults do
  use Ecto.Migration

  def change do
    create table(:lesson_results) do
      add :lesson_id, :string, null: false
      add :correct_count, :integer, default: 0
      add :error_count, :integer, default: 0
      add :completed_at, :naive_datetime, null: false

      timestamps()
    end

    create index(:lesson_results, [:lesson_id])
  end
end
