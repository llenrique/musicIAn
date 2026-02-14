defmodule MusicIan.Practice.Helper.LessonHelper do
  alias MusicIan.Practice.Manager.LessonManager

  def save_lesson_completion(lesson_id, stats) do
    attrs = %{
      lesson_id: lesson_id,
      correct_count: stats.correct,
      error_count: stats.errors,
      completed_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
    }

    LessonManager.create_result(attrs)
  end
end
