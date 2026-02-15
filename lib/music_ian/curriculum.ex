defmodule MusicIan.Curriculum do
  @moduledoc """
  Public API for curriculum operations.
  Delegates to Manager for data retrieval and Helper for transformations.
  """

  alias MusicIan.Practice.Manager.LessonManager
  alias MusicIan.Practice.Helper.LessonHelperConvert

  @doc """
  Get a lesson by ID from database.
  Returns a map suitable for use in lessons.
  """
  def get_lesson(lesson_id) when is_binary(lesson_id) do
    case LessonManager.get_lesson(lesson_id) do
      nil -> nil
      lesson -> LessonHelperConvert.schema_to_map(lesson)
    end
  end

  def get_lesson(_), do: nil

  @doc """
  Get all lessons from database ordered by order field.
  """
  def list_lessons do
    LessonManager.list_all_lessons()
    |> LessonHelperConvert.schemas_to_maps()
  end

  @doc """
  Get the next lesson ID after the given lesson_id.
  """
  def get_next_lesson_id(lesson_id) when is_binary(lesson_id) do
    lesson_ids = LessonManager.get_lesson_ids()

    case Enum.find_index(lesson_ids, fn id -> id == lesson_id end) do
      nil -> nil
      idx -> Enum.at(lesson_ids, idx + 1)
    end
  end

  def get_next_lesson_id(_), do: nil
end
