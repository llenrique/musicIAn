defmodule MusicIan.Repo.Migrations.AddTimingFieldsToLessonResults do
  @moduledoc "Agrega campos de timing (accuracy, timing_score, step_analysis, bpm_used) a lesson_results."
  use Ecto.Migration

  def change do
    alter table(:lesson_results) do
      add :accuracy_percent, :integer
      add :timing_score, :integer
      add :step_analysis, :text
      add :bpm_used, :integer
    end
  end
end
