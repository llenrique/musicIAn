defmodule MusicIan.Practice.Schema.LessonResult do
  use Ecto.Schema
  import Ecto.Changeset

  schema "lesson_results" do
    field :lesson_id, :string
    field :correct_count, :integer
    field :error_count, :integer
    field :completed_at, :naive_datetime

    timestamps()
  end

  @doc false
  def changeset(lesson_result, attrs) do
    lesson_result
    |> cast(attrs, [:lesson_id, :correct_count, :error_count, :completed_at])
    |> validate_required([:lesson_id, :correct_count, :error_count, :completed_at])
  end
end
