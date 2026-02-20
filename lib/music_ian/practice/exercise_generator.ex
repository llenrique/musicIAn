defmodule MusicIan.Practice.ExerciseGenerator do
  @moduledoc """
  Generates dynamic practice exercises on the fly.

  Each generator takes a params map and returns an exercise map:
    %{
      target_note: midi_integer,
      prompt: "Toca el Do una octava arriba",
      difficulty: 1..5
    }

  Available generators:
  - "octave_finder"    — Find a C note N octaves from a reference
  - "note_identifier"  — Find any white key note by name
  """

  # MIDI pitch classes for white key notes
  @pitch_classes %{
    "C" => 0,
    "D" => 2,
    "E" => 4,
    "F" => 5,
    "G" => 7,
    "A" => 9,
    "B" => 11
  }

  # Octave ranges by difficulty level
  @octave_ranges %{1 => 4..4, 2 => 3..5, 3 => 2..6}
  @default_octave_range 1..7

  @doc """
  Generate an exercise from a generator name and params.

  Returns %{target_note: integer, prompt: string, difficulty: integer}
  """
  def generate("octave_finder", params), do: generate_octave_finder(params)
  def generate("note_identifier", params), do: generate_note_identifier(params)

  def generate(unknown, _params) do
    %{
      target_note: 60,
      prompt: "Toca el Do central (C4)",
      difficulty: 1,
      generator: unknown,
      error: "Generador desconocido: #{unknown}"
    }
  end

  # ---------------------------------------------------------------------------
  # octave_finder
  #
  # Params:
  #   from_octave   — starting octave (0-8). If nil, random 2-5.
  #   delta_octaves — octaves to move (+/-). If nil, calculated from difficulty.
  #   direction     — "up" | "down" | "random". Default "random".
  #   difficulty    — 1..5.
  #   note_name     — "C" (default).
  # ---------------------------------------------------------------------------
  defp generate_octave_finder(params) do
    difficulty = param(params, :difficulty, 1)
    note_name = param(params, :note_name, "C")
    direction = param(params, :direction, "random")
    from_octave = param(params, :from_octave, nil) || Enum.random(2..5)

    delta =
      case param(params, :delta_octaves, nil) do
        nil -> pick_delta(difficulty, direction)
        explicit_delta -> apply_direction(explicit_delta, direction)
      end

    target_octave = clamp(from_octave + delta, 1, 7)
    target_midi = midi_c(target_octave)

    %{
      target_note: target_midi,
      prompt: build_octave_prompt(note_name, from_octave, target_octave, delta),
      difficulty: difficulty,
      generator: "octave_finder",
      from_octave: from_octave,
      target_octave: target_octave,
      delta: delta
    }
  end

  defp build_octave_prompt(note_name, from_octave, target_octave, delta) do
    dir_text = direction_text(delta)
    "Desde #{note_name}#{from_octave}, encuentra #{note_name}#{target_octave} (#{dir_text})"
  end

  defp direction_text(delta) when delta > 0, do: "#{abs(delta)} octava(s) arriba"
  defp direction_text(delta) when delta < 0, do: "#{abs(delta)} octava(s) abajo"
  defp direction_text(_), do: "misma octava"

  # ---------------------------------------------------------------------------
  # note_identifier
  #
  # Params:
  #   note_name  — "C" | "D" | "E" | "F" | "G" | "A" | "B"
  #   octave     — specific octave. If nil, random based on difficulty.
  #   difficulty — 1..5
  # ---------------------------------------------------------------------------
  defp generate_note_identifier(params) do
    difficulty = param(params, :difficulty, 1)
    note_name = param(params, :note_name, "C")
    pitch_class = Map.get(@pitch_classes, note_name, 0)

    octave_range = Map.get(@octave_ranges, difficulty, @default_octave_range)
    octave = Enum.random(octave_range)
    target_midi = midi_c(octave) + pitch_class

    %{
      target_note: target_midi,
      prompt: "Toca la nota #{note_name} en la octava #{octave}",
      difficulty: difficulty,
      generator: "note_identifier",
      note_name: note_name,
      octave: octave
    }
  end

  # ---------------------------------------------------------------------------
  # Helpers
  # ---------------------------------------------------------------------------

  # Read a param supporting both atom and string keys
  defp param(params, key, default) do
    Map.get(params, key, Map.get(params, Atom.to_string(key), default))
  end

  defp pick_delta(difficulty, direction) do
    max_delta = max_delta_for_difficulty(difficulty)
    delta = Enum.random(1..max_delta)
    apply_direction(delta, direction)
  end

  defp max_delta_for_difficulty(1), do: 1
  defp max_delta_for_difficulty(2), do: 2
  defp max_delta_for_difficulty(3), do: 3
  defp max_delta_for_difficulty(_), do: Enum.random(2..4)

  defp apply_direction(delta, "up"), do: delta
  defp apply_direction(delta, "down"), do: -delta

  defp apply_direction(delta, _random) do
    if :rand.uniform() > 0.5, do: delta, else: -delta
  end

  # MIDI note number for C in a given octave (C4 = MIDI 60)
  defp midi_c(octave), do: (octave + 1) * 12

  defp clamp(value, min_val, max_val), do: value |> max(min_val) |> min(max_val)
end
