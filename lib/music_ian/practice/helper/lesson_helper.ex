defmodule MusicIan.Practice.Helper.LessonHelper do
  alias MusicIan.Practice.Manager.LessonManager

  def save_lesson_completion(lesson_id, stats) do
    # Backward compatibility: call with empty analysis
    save_lesson_completion(lesson_id, stats, [])
  end

  def save_lesson_completion(lesson_id, stats, step_analysis \\ []) do
    # === NEW: Save lesson with step-by-step analysis ===
    # Analyze accuracy, timing, and performance metrics
    
    attrs = %{
      lesson_id: lesson_id,
      correct_count: stats.correct,
      error_count: stats.errors,
      # === NEW: Include step analysis as JSON ===
      step_analysis: Jason.encode!(step_analysis),
      # === Calculate accuracy percentage ===
      accuracy_percent: calculate_accuracy(stats),
      # === Analyze timing performance ===
      timing_analysis: analyze_timing(step_analysis),
      completed_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
    }

    LessonManager.create_result(attrs)
  end

  # === Helper functions ===

  defp calculate_accuracy(%{correct: correct, errors: errors}) do
    total = correct + errors
    if total > 0, do: round((correct / total) * 100), else: 0
  end

  defp analyze_timing(step_analysis) do
    # Analyze timing performance across all steps
    timings = 
      step_analysis
      |> Enum.map(& &1[:timing_status])
      |> Enum.reject(&is_nil/1)

    %{
      on_time_count: Enum.count(timings, &(&1 == :on_time)),
      slightly_off_count: Enum.count(timings, &(&1 == :slightly_off)),
      late_count: Enum.count(timings, &(&1 == :late)),
      total: Enum.count(timings)
    }
    |> Jason.encode!()
  end
end
