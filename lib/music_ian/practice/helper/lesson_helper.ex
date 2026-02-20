defmodule MusicIan.Practice.Helper.LessonHelper do
  @moduledoc "Helper para guardar y analizar resultados de lecciones en base de datos."
  alias MusicIan.Practice.Manager.LessonManager

  @doc """
  Guarda el resultado de una lección completada, incluyendo análisis de timing.
  Acepta opcionalmente el BPM usado durante la práctica.
  """
  def save_lesson_completion(lesson_id, stats, step_analysis \\ [], bpm_used \\ nil) do
    attrs = %{
      lesson_id: lesson_id,
      correct_count: stats.correct,
      error_count: stats.errors,
      step_analysis: Jason.encode!(step_analysis),
      accuracy_percent: calculate_accuracy(stats),
      timing_score: calculate_timing_score(step_analysis),
      bpm_used: bpm_used,
      completed_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
    }

    LessonManager.create_result(attrs)
  end

  defp calculate_accuracy(%{correct: correct, errors: errors} = stats) do
    total = correct + errors

    if total > 0 do
      base = correct / total * 100
      penalty = Map.get(stats, :timing_penalty_total, 0)
      max(0, round(base - penalty))
    else
      0
    end
  end

  defp calculate_timing_score(step_analysis) do
    timings =
      step_analysis
      |> Enum.filter(&(&1[:status] == :success))
      |> Enum.map(& &1[:timing_status])
      |> Enum.reject(&is_nil/1)

    total = length(timings)

    if total > 0 do
      on_time = Enum.count(timings, &(&1 == :on_time))
      round(on_time / total * 100)
    else
      0
    end
  end
end
