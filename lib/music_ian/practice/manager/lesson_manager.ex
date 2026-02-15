defmodule MusicIan.Practice.Manager.LessonManager do
  @moduledoc """
  Manages lesson data retrieval from database.
  Single responsibility: Query lessons and results from BD.
  """

  import Ecto.Query, warn: false
  alias MusicIan.Repo
  alias MusicIan.Practice.Schema.LessonResult
  alias MusicIan.Curriculum.Lesson
  alias MusicIan.Curriculum.Module

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

  @doc """
  Get all modules ordered by order field.
  Returns list of raw Module schemas with their lessons preloaded.
  """
  def list_all_modules do
    Repo.all(from m in Module, order_by: [asc: m.order, asc: m.id], preload: :lessons)
  end

  @doc """
  Get a single module by ID with its lessons preloaded.
  """
  def get_module(module_id) when is_binary(module_id) do
    Repo.get(Module, module_id)
    |> Repo.preload(:lessons)
  end

  def get_module(_), do: nil

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

  @doc """
  Get all results for a specific lesson, ordered by completion date (most recent first).
  """
  def list_results_for_lesson(lesson_id) when is_binary(lesson_id) do
    Repo.all(from r in LessonResult, where: r.lesson_id == ^lesson_id, order_by: [desc: r.completed_at])
  end

  def list_results_for_lesson(_), do: []

  @doc """
  Get the latest result for a lesson (most recent attempt).
  """
  def get_latest_result_for_lesson(lesson_id) when is_binary(lesson_id) do
    Repo.one(from r in LessonResult, where: r.lesson_id == ^lesson_id, order_by: [desc: r.completed_at], limit: 1)
  end

  def get_latest_result_for_lesson(_), do: nil

  @doc """
  Get aggregate stats for a specific lesson.
  """
  def get_lesson_stats(lesson_id) when is_binary(lesson_id) do
    query = from r in LessonResult,
      where: r.lesson_id == ^lesson_id,
      select: %{
        attempts: count(r.id),
        total_correct: sum(r.correct_count),
        total_errors: sum(r.error_count),
        latest_accuracy: max(r.accuracy)
      }
    
    Repo.one(query)
  end

  def get_lesson_stats(_), do: nil
end
