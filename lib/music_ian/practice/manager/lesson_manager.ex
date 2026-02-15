defmodule MusicIan.Practice.Manager.LessonManager do
  @moduledoc """
  Manages lesson data retrieval from database.
  Single responsibility: Query lessons and results from BD.
  """

  import Ecto.Query, warn: false
  alias MusicIan.Repo
  alias MusicIan.Practice.Schema.LessonResult
  alias MusicIan.Curriculum.Lesson

  # --- LESSON QUERIES (from Curriculum.Lesson schema) ---

  @doc """
  Get a single lesson by ID from database.
  Returns the raw Lesson schema.
  """
  def get_lesson(lesson_id) when is_binary(lesson_id) do
    Repo.get(Lesson, lesson_id)
  end

  def get_lesson(_), do: nil

  @doc """
  Get all lessons ordered by order field, then by id.
  Returns list of raw Lesson schemas.
  """
  def list_all_lessons do
    Repo.all(from l in Lesson, order_by: [asc: l.order, asc: l.id])
  end

  @doc """
  Get lesson IDs in order (for next/prev navigation).
  """
  def get_lesson_ids do
    Repo.all(from l in Lesson, order_by: [asc: l.order, asc: l.id], select: l.id)
  end

  # --- RESULT QUERIES (from Practice.Schema.LessonResult) ---

  def create_result(attrs) do
    %LessonResult{}
    |> LessonResult.changeset(attrs)
    |> Repo.insert()
  end

  def list_results do
    Repo.all(from r in LessonResult, order_by: [desc: r.completed_at])
  end

  def get_stats do
    query = from r in LessonResult,
      select: %{
        total_lessons: count(r.id),
        total_correct: sum(r.correct_count),
        total_errors: sum(r.error_count)
      }
    
    Repo.one(query)
  end
end
