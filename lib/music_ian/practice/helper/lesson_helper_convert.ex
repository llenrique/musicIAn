defmodule MusicIan.Practice.Helper.LessonHelperConvert do
  @moduledoc """
  Transforms lesson data from database format to engine/frontend format.
  Single responsibility: convert Ecto schemas to plain maps with atom keys.

  Step field keys are converted from strings (JSON storage) to atoms using a
  safe allowlist to avoid atom table exhaustion.
  """

  # Allowlist of all valid step field keys (strings → atoms, safe conversion)
  @step_keys ~w(
    type text note notes hint finger duration
    generator params
  )a

  # Allowlist for nested :params map keys
  @param_keys ~w(
    from_octave delta_octaves direction difficulty note_name octave
  )a

  @doc """
  Convert Lesson schema to map for frontend/engine use.
  """
  def schema_to_map(%MusicIan.Curriculum.Lesson{} = lesson) do
    %{
      id: lesson.id,
      title: lesson.title,
      description: lesson.description,
      intro: lesson.intro,
      steps: convert_steps(lesson.steps || []),
      metronome: lesson.metronome,
      bpm: lesson.bpm || 60,
      time_signature: lesson.time_signature || "4/4",
      timing_strictness: lesson.timing_strictness || 0,
      # Pedagogical metadata
      focus: lesson.focus,
      new_concepts: lesson.new_concepts || [],
      confidence_level_target: lesson.confidence_level_target,
      cognitive_complexity: lesson.cognitive_complexity || "basic",
      motor_complexity: lesson.motor_complexity || "basic",
      duration_minutes: lesson.duration_minutes,
      loop: lesson.loop || false,
      module_id: lesson.module_id,
      order: lesson.order
    }
  end

  def schema_to_map(nil), do: nil

  @doc """
  Convert a list of Lesson schemas to maps.
  """
  def schemas_to_maps(lessons) when is_list(lessons) do
    Enum.map(lessons, &schema_to_map/1)
  end

  # ---------------------------------------------------------------------------
  # Private helpers
  # ---------------------------------------------------------------------------

  defp convert_steps(steps) when is_list(steps) do
    Enum.map(steps, &convert_step/1)
  end

  defp convert_step(%{} = step) do
    # If already atom-keyed (e.g. from seed before DB round-trip), keep as-is
    # but still normalize the params submap.
    if atom_keyed?(step) do
      normalize_params(step)
    else
      # Convert string keys → atom keys using allowlist
      step
      |> Map.new(fn {k, v} -> {safe_to_atom(k, @step_keys), v} end)
      |> normalize_params()
    end
  end

  defp convert_step(other), do: other

  # Convert the nested :params map (if present) to atom keys
  defp normalize_params(%{params: params} = step) when is_map(params) do
    atomized_params =
      if atom_keyed?(params) do
        params
      else
        Map.new(params, fn {k, v} -> {safe_to_atom(k, @param_keys), v} end)
      end

    %{step | params: atomized_params}
  end

  defp normalize_params(step), do: step

  # Check if a map already has any atom key (fast heuristic)
  defp atom_keyed?(%{} = map) do
    map |> Map.keys() |> List.first() |> is_atom()
  end

  defp atom_keyed?(_), do: false

  # Safe atom conversion: only converts if the string is in the allowlist.
  # Unknown keys are kept as strings to avoid crashing or exhausting atom table.
  defp safe_to_atom(key, allowlist) when is_binary(key) do
    if Enum.member?(Enum.map(allowlist, &Atom.to_string/1), key) do
      String.to_existing_atom(key)
    else
      key
    end
  end

  defp safe_to_atom(key, _allowlist) when is_atom(key), do: key
  defp safe_to_atom(key, _allowlist), do: key
end
