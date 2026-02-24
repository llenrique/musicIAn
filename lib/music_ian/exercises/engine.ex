defmodule MusicIan.Exercises.Engine do
  @moduledoc """
  Genera y valida ejercicios de teoría musical.
  Stateless: sin dependencias de base de datos ni efectos secundarios.
  """

  alias MusicIan.MusicCore
  alias MusicIan.MusicCore.Chord
  alias MusicIan.MusicCore.Note
  alias MusicIan.MusicCore.Theory

  @type exercise_type :: :note_reading | :interval | :chord_id | :scale

  @type exercise :: %{
          type: exercise_type(),
          prompt: String.t(),
          target_notes: [integer()],
          vexflow_notes: [map()],
          vexflow_key: String.t(),
          meta: map()
        }

  @type result :: %{
          correct: boolean(),
          completed: boolean(),
          feedback: String.t()
        }

  # Teclas blancas C4-C5 (dificultad 1)
  @white_c4_c5 [60, 62, 64, 65, 67, 69, 71, 72]

  # Teclas blancas C3-C6 (dificultad 2-3)
  @white_c3_c6 [48, 50, 52, 53, 55, 57, 59, 60, 62, 64, 65, 67, 69, 71, 72, 74, 76, 77, 79, 81,
                83, 84]

  # Intervalos por dificultad (en semitonos)
  @intervals_easy [3, 4, 5, 7]
  @intervals_medium [2, 3, 4, 5, 7, 8, 9, 12]
  @intervals_hard Enum.to_list(1..12)

  # Calidades de acorde por dificultad
  @qualities_easy [:major]
  @qualities_medium [:major, :minor, :diminished]
  @qualities_hard [:major, :minor, :diminished, :augmented, :dominant7, :minor7]

  # Tipos de escala por dificultad
  @scales_easy [:major]
  @scales_medium [:major, :minor]
  @scales_hard [:major, :minor, :dorian, :phrygian, :lydian, :mixolydian]

  @doc """
  Genera un ejercicio aleatorio del tipo y dificultad indicados.
  La dificultad va de 1 (básico) a 5 (avanzado).
  """
  @spec generate(exercise_type(), 1..5) :: exercise()
  def generate(:note_reading, difficulty) do
    midi = Enum.random(note_pool(difficulty))

    %{
      type: :note_reading,
      prompt: "Toca la nota mostrada en el pentagrama",
      target_notes: [midi],
      vexflow_notes: [note_to_step(midi)],
      vexflow_key: "C",
      meta: %{sequential: false}
    }
  end

  def generate(:interval, difficulty) do
    semitones = Enum.random(interval_pool(difficulty))
    root = Enum.random(note_pool(min(difficulty, 3)))
    target = root + semitones
    label = interval_label(semitones)

    %{
      type: :interval,
      prompt: "Toca el intervalo: #{label} desde #{Note.new(root).name}",
      target_notes: [root, target],
      vexflow_notes: [note_to_step(root), note_to_step(target)],
      vexflow_key: "C",
      meta: %{sequential: false, semitones: semitones}
    }
  end

  def generate(:chord_id, difficulty) do
    quality = Enum.random(quality_pool(difficulty))
    root = Enum.random(note_pool(min(difficulty, 3)))
    chord = Chord.new(root, quality)
    target_midis = Enum.map(chord.notes, & &1.midi)
    label = quality_label(quality)

    %{
      type: :chord_id,
      prompt: "Toca el acorde: #{Note.new(root).name} #{label}",
      target_notes: target_midis,
      vexflow_notes: [chord_to_step(target_midis)],
      vexflow_key: "C",
      meta: %{sequential: false}
    }
  end

  def generate(:scale, difficulty) do
    scale_type = Enum.random(scale_pool(difficulty))
    root = Enum.random(note_pool(min(difficulty, 3)))
    scale = MusicCore.get_scale(root, scale_type)
    note_midis = Enum.map(scale.notes, & &1.midi)
    target_midis = note_midis ++ [root + 12]
    vexflow_key = Theory.determine_key_signature(root, scale_type, [])
    label = scale_label(scale_type)

    %{
      type: :scale,
      prompt: "Toca la escala de #{Note.new(root).name} #{label} (de abajo hacia arriba)",
      target_notes: target_midis,
      vexflow_notes: Enum.map(target_midis, &note_to_step/1),
      vexflow_key: vexflow_key,
      meta: %{sequential: true, step_index: 0, step_count: length(target_midis)}
    }
  end

  @doc """
  Valida las notas tocadas contra el ejercicio actual.
  Para escalas, el campo `meta.step_index` debe actualizarse en cada paso.
  Devuelve `%{correct, completed, feedback}`.
  """
  @spec validate(exercise(), [integer()]) :: result()
  def validate(%{meta: %{sequential: true}} = exercise, [midi | _]) do
    validate_sequential(exercise, midi)
  end

  def validate(%{type: :note_reading, target_notes: [target | _]}, played_notes) do
    target_pc = rem(target, 12)

    if Enum.any?(played_notes, &(rem(&1, 12) == target_pc)),
      do: ok_result(),
      else: error_result()
  end

  def validate(%{type: :interval, meta: %{semitones: semitones}}, played_notes) do
    if match_interval?(played_notes, semitones), do: ok_result(), else: error_result()
  end

  def validate(%{type: :chord_id, target_notes: target_notes}, played_notes) do
    target_pcs = target_notes |> Enum.map(&rem(&1, 12)) |> MapSet.new()
    played_pcs = played_notes |> Enum.map(&rem(&1, 12)) |> MapSet.new()

    if MapSet.equal?(target_pcs, played_pcs), do: ok_result(), else: error_result()
  end

  def validate(_exercise, _played_notes) do
    error_result()
  end

  # --- Helpers de validación ---

  defp validate_sequential(%{target_notes: targets, meta: %{step_index: idx}}, midi) do
    target = Enum.at(targets, idx)
    correct = target != nil && rem(midi, 12) == rem(target, 12)
    last_step = idx >= length(targets) - 1

    cond do
      correct && last_step -> done_result()
      correct -> progress_result()
      true -> error_result()
    end
  end

  defp match_interval?(played_notes, semitones) do
    case Enum.sort(played_notes) do
      [a, b | _] -> abs(b - a) == semitones
      _ -> false
    end
  end

  defp ok_result, do: %{correct: true, completed: true, feedback: "¡Correcto!"}
  defp done_result, do: %{correct: true, completed: true, feedback: "¡Escala completada!"}

  defp progress_result,
    do: %{correct: true, completed: false, feedback: "¡Correcto! Siguiente nota..."}

  defp error_result,
    do: %{correct: false, completed: false, feedback: "Nota incorrecta, intenta de nuevo"}

  # --- Pools por dificultad ---

  defp note_pool(diff) when diff <= 1, do: @white_c4_c5
  defp note_pool(diff) when diff <= 3, do: @white_c3_c6
  defp note_pool(_diff), do: Enum.to_list(36..84)

  defp interval_pool(diff) when diff <= 2, do: @intervals_easy
  defp interval_pool(diff) when diff <= 4, do: @intervals_medium
  defp interval_pool(_diff), do: @intervals_hard

  defp quality_pool(diff) when diff <= 2, do: @qualities_easy
  defp quality_pool(diff) when diff <= 4, do: @qualities_medium
  defp quality_pool(_diff), do: @qualities_hard

  defp scale_pool(diff) when diff <= 2, do: @scales_easy
  defp scale_pool(diff) when diff <= 3, do: @scales_medium
  defp scale_pool(_diff), do: @scales_hard

  # --- Conversores a formato VexFlow ---

  defp note_to_step(midi) do
    note = Note.new(midi)
    {base, acc} = Theory.parse_note_name(note.name)

    %{
      notes: [
        %{
          key: "#{String.downcase(base)}/#{note.octave}",
          accidental: if(acc != "", do: acc, else: nil),
          midi: midi,
          clef: if(midi >= 60, do: "treble", else: "bass")
        }
      ],
      duration: "q"
    }
  end

  defp chord_to_step(midi_notes) do
    notes =
      Enum.map(midi_notes, fn midi ->
        note = Note.new(midi)
        {base, acc} = Theory.parse_note_name(note.name)

        %{
          key: "#{String.downcase(base)}/#{note.octave}",
          accidental: if(acc != "", do: acc, else: nil),
          midi: midi,
          clef: if(midi >= 60, do: "treble", else: "bass")
        }
      end)

    %{notes: notes, duration: "q"}
  end

  # --- Etiquetas en español ---

  defp interval_label(1), do: "2ª menor"
  defp interval_label(2), do: "2ª Mayor"
  defp interval_label(3), do: "3ª menor"
  defp interval_label(4), do: "3ª Mayor"
  defp interval_label(5), do: "4ª Justa"
  defp interval_label(6), do: "4ª Aumentada"
  defp interval_label(7), do: "5ª Justa"
  defp interval_label(8), do: "6ª menor"
  defp interval_label(9), do: "6ª Mayor"
  defp interval_label(10), do: "7ª menor"
  defp interval_label(11), do: "7ª Mayor"
  defp interval_label(12), do: "Octava"
  defp interval_label(n), do: "#{n} semitonos"

  defp quality_label(:major), do: "Mayor"
  defp quality_label(:minor), do: "menor"
  defp quality_label(:diminished), do: "disminuido"
  defp quality_label(:augmented), do: "aumentado"
  defp quality_label(:sus2), do: "sus2"
  defp quality_label(:sus4), do: "sus4"
  defp quality_label(:major7), do: "Mayor 7"
  defp quality_label(:dominant7), do: "Dominante 7"
  defp quality_label(:minor7), do: "menor 7"
  defp quality_label(:minor7b5), do: "m7b5"
  defp quality_label(:diminished7), do: "disminuido 7"
  defp quality_label(q), do: to_string(q)

  defp scale_label(:major), do: "Mayor"
  defp scale_label(:minor), do: "menor"
  defp scale_label(:dorian), do: "Dórica"
  defp scale_label(:phrygian), do: "Frigia"
  defp scale_label(:lydian), do: "Lidia"
  defp scale_label(:mixolydian), do: "Mixolidia"
  defp scale_label(:locrian), do: "Locria"
  defp scale_label(t), do: to_string(t)
end
