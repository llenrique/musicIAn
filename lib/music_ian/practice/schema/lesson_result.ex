defmodule MusicIan.Practice.Schema.LessonResult do
  @moduledoc "Schema Ecto para el resultado de una lección completada."
  use Ecto.Schema
  import Ecto.Changeset

  schema "lesson_results" do
    field :lesson_id, :string
    field :correct_count, :integer
    field :error_count, :integer
    field :completed_at, :naive_datetime
    field :accuracy_percent, :integer
    field :timing_score, :integer
    field :step_analysis, :string
    field :bpm_used, :integer

    timestamps()
  end

  @doc false
  def changeset(lesson_result, attrs) do
    lesson_result
    |> cast(attrs, [
      :lesson_id,
      :correct_count,
      :error_count,
      :completed_at,
      :accuracy_percent,
      :timing_score,
      :step_analysis,
      :bpm_used
    ])
    |> validate_required([:lesson_id, :correct_count, :error_count, :completed_at])
  end
end
