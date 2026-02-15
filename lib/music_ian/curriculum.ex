defmodule MusicIan.Curriculum do
  @moduledoc """
  The Curriculum context - manages lessons from database.
  """

  import Ecto.Query, warn: false
  alias MusicIan.Repo
  alias MusicIan.Curriculum.Lesson

  @doc """
  Get a lesson by ID from database.
  Returns a map suitable for use in lessons.
  """
  def get_lesson(lesson_id) when is_binary(lesson_id) do
    case Repo.get(Lesson, lesson_id) do
      nil -> nil
      lesson -> lesson_to_map(lesson)
    end
  end

  def get_lesson(_), do: nil

  @doc """
  Get all lessons from database ordered by order field.
  """
  def list_lessons do
    Repo.all(from l in Lesson, order_by: [asc: l.order, asc: l.id])
    |> Enum.map(&lesson_to_map/1)
  end

  # Convert Lesson schema to map for frontend
  defp lesson_to_map(%Lesson{} = lesson) do
    %{
      id: lesson.id,
      title: lesson.title,
      description: lesson.description,
      intro: lesson.intro,
      steps: lesson.steps || [],
      metronome: lesson.metronome
    }
  end
end
