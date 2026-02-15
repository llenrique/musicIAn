defmodule MusicIan.Practice.Helper.LessonHelperConvert do
  @moduledoc """
  Transforms lesson data from database format to frontend/engine format.
  Single responsibility: Convert schemas to maps, handle JSON keys.
  """

  @doc """
  Convert Lesson schema to map for frontend use.
  Handles JSON key conversion (strings → atoms).
  """
  def schema_to_map(%MusicIan.Curriculum.Lesson{} = lesson) do
    %{
      id: lesson.id,
      title: lesson.title,
      description: lesson.description,
      intro: lesson.intro,
      steps: convert_steps_keys(lesson.steps || []),
      metronome: lesson.metronome
    }
  end

  def schema_to_map(nil), do: nil

  @doc """
  Convert a list of Lesson schemas to maps.
  """
  def schemas_to_maps(lessons) when is_list(lessons) do
    Enum.map(lessons, &schema_to_map/1)
  end

  # Private helpers

  # Convert string keys to atom keys in steps (from JSON storage)
  defp convert_steps_keys(steps) when is_list(steps) do
    Enum.map(steps, fn step ->
      case step do
        %{} = map when is_map(map) ->
          # If it's already a map with atom keys, keep it
          if Enum.any?(map, fn {k, _} -> is_atom(k) end) do
            map
          else
            # Convert string keys to atom keys
            Map.new(map, fn {k, v} -> {to_atom(k), v} end)
          end

        other ->
          other
      end
    end)
  end

  defp convert_steps_keys(other), do: other

  # Helper to safely convert string to atom
  defp to_atom(value) when is_binary(value) do
    String.to_atom(value)
  end

  defp to_atom(value) when is_atom(value) do
    value
  end

  defp to_atom(value), do: value
end
