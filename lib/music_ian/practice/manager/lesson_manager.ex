defmodule MusicIan.Practice.Manager.LessonManager do
  import Ecto.Query
  alias MusicIan.Repo
  alias MusicIan.Practice.Schema.LessonResult

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
