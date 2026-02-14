defmodule MusicIan.Practice.LessonEngine do
  @moduledoc """
  Pure functional core for managing the state of a music lesson.
  This module handles the logic of progression, validation, and scoring,
  decoupling it from the LiveView UI process.
  """

  alias MusicIan.MusicCore.Note
  alias MusicIan.Curriculum

  # The State Struct
  defstruct [
    :lesson_id,
    :lesson,
    # :intro, :active, :demo, :summary
    :phase,
    # Current step (0-based)
    :step_index,
    # %{correct: 0, errors: 0}
    :stats,
    # %{status: :success/:error, message: String}
    :feedback,
    # boolean
    :completed?
  ]

  @type t :: %__MODULE__{}

  # --- Initialization ---

  def new(lesson_id) do
    case Curriculum.get_lesson(lesson_id) do
      nil ->
        {:error, :not_found}

      lesson ->
        {:ok,
         %__MODULE__{
           lesson_id: lesson_id,
           lesson: lesson,
           phase: :intro,
           step_index: 0,
           stats: %{correct: 0, errors: 0},
           feedback: nil,
           completed?: false
         }}
    end
  end

  # --- State Transitions ---

  def start_practice(%__MODULE__{} = state) do
    %{state | phase: :active, feedback: nil}
  end

  def start_demo(%__MODULE__{} = state) do
    %{state | phase: :demo, step_index: 0, feedback: nil}
  end

  def stop_demo(%__MODULE__{} = state) do
    %{state | phase: :intro, step_index: 0, feedback: nil}
  end

  def next_demo_step(%__MODULE__{} = state) do
    next_idx = state.step_index + 1

    if next_idx < length(state.lesson.steps) do
      {:continue, %{state | step_index: next_idx}}
    else
      {:finished, stop_demo(state)}
    end
  end

  def retry(%__MODULE__{} = state) do
    %{
      state
      | phase: :active,
        step_index: 0,
        stats: %{correct: 0, errors: 0},
        feedback: nil,
        completed?: false
    }
  end

  # --- Core Logic: Timing Validation ---

  @doc """
  Validates the timing of a note against the expected beat.
  Expects timing information from the client (JavaScript).

  timing_info: %{status: 'on-time'|'early'|'late', deviation: number, severity: 'ok'|'warning'|'error'}
  """
  def validate_timing(timing_info) do
    case timing_info do
      %{"timingSeverity" => severity} when severity in ["error", "warning"] ->
        # Timing error detected
        {:error, format_timing_error(timing_info)}

      %{"timingStatus" => "on-time"} ->
        # Good timing
        {:ok, "✓ Ritmo perfecto"}

      _ ->
        # Unknown or no timing info (skip validation)
        {:ignore, "Sin información de ritmo"}
    end
  end

  defp format_timing_error(%{"timingStatus" => status, "timingDeviation" => deviation}) do
    case status do
      "between-beats" ->
        "❌ Nota entre beats. No pertenece al ritmo esperado."

      "early" when deviation < -150 ->
        "⚠️  Demasiado rápido (#{abs(trunc(deviation))}ms antes del beat)"

      "early" ->
        "⚠️  Un poco rápido"

      "late" when deviation > 150 ->
        "⚠️  Demasiado lento (#{trunc(deviation)}ms después del beat)"

      "late" ->
        "⚠️  Un poco lento"

      _ ->
        "⚠️  Ritmo fuera de tiempo"
    end
  end

  # --- Core Logic: Note Validation ---

  def validate_note(%__MODULE__{phase: :active} = state, played_midi) do
    # This function is now deprecated for polyphonic support, but kept for backward compatibility
    # It treats a single note event as a potential step completion if the step is single-note.
    # For polyphonic steps, we need `validate_step(state, held_notes)`.

    # However, since TheoryLive calls this on every note_on, we can adapt it.
    # But it's better to use `validate_step` with the full context of held notes.

    # For now, let's assume this is called when a single note is played for a single-note step.
    current_step = Enum.at(state.lesson.steps, state.step_index)

    # Normalize target notes
    target_notes = current_step[:notes] || [current_step[:note]]

    if length(target_notes) == 1 do
      target_note = List.first(target_notes)

      if played_midi == target_note do
        handle_success(state)
      else
        handle_error(state, played_midi, target_note)
      end
    else
      # For polyphonic steps, a single note event is not enough to validate.
      # We need to wait for all notes.
      # This function signature is insufficient for chords.
      {:ignore, state}
    end
  end

  def validate_step(%__MODULE__{phase: :active} = state, held_notes) do
    current_step = Enum.at(state.lesson.steps, state.step_index)

    # Normalize target notes (support both :note and :notes)
    target_notes = current_step[:notes] || [current_step[:note]]
    target_set = MapSet.new(target_notes)
    held_set = MapSet.new(held_notes)

    # Check if all target notes are currently held
    if MapSet.subset?(target_set, held_set) do
      handle_success(state)
    else
      # Check for wrong notes (optional: strictly enforce only target notes?)
      # For now, we just check if the target subset is present.
      # If user plays extra notes, we could ignore or penalize.
      # Let's check if the *latest* added note (if we knew it) was wrong?
      # Or just check if any held note is WAY off?

      # Simple logic: If they hold the right notes, success.
      # If they hold wrong notes but NOT the right ones, we wait.
      # If they hold wrong notes AND right ones, success (lenient).

      # If user is holding notes that are definitely NOT in the target set, maybe warn them?
      # But we don't want to spam errors while they are building the chord.

      # Let's only error if they play a single note that is clearly wrong and they aren't holding anything else?
      # Or if they hold a wrong note for a long time? (Hard to detect here).

      # Current compromise: Only error if they play a single note that is wrong and not part of the chord.
      # But we don't have "latest played note" here easily unless we pass it.

      {:ignore, state}
    end
  end

  def validate_step(
        %__MODULE__{phase: :active} = state,
        held_notes,
        latest_note,
        timing_info \\ nil
      ) do
    current_step = Enum.at(state.lesson.steps, state.step_index)

    # Normalize target notes
    target_notes = current_step[:notes] || [current_step[:note]]
    target_set = MapSet.new(target_notes)
    held_set = MapSet.new(held_notes)

    # Check if all target notes are held
    all_target_notes_held = MapSet.subset?(target_set, held_set)
    
    # Check for extra notes (strict mode: no extra notes allowed)
    has_extra_notes = not MapSet.equal?(target_set, held_set)

    if all_target_notes_held and not has_extra_notes do
      # ✅ Perfect: All required notes, no extra notes
      handle_success(state, timing_info)
    else
      # ❌ Error conditions:
      # 1. Latest note is not in target set
      # 2. Extra notes are being held (strict validation)
      
      if not MapSet.member?(target_set, latest_note) do
        # Wrong note played
        handle_error(state, latest_note, target_notes, timing_info)
      else if has_extra_notes do
        # Extra notes held (user building chord messily)
        # Only error if extra notes are WAY off (more than 2 semitones away)
        extra_notes = MapSet.difference(held_set, target_set)
        wrong_extra = Enum.any?(extra_notes, fn note -> 
          # Check if extra note is at least 2 semitones away from any target note
          Enum.all?(target_notes, fn target -> abs(note - target) > 1 end)
        end)
        
        if wrong_extra do
          handle_error(state, latest_note, target_notes, timing_info)
        else
          # Extra notes are close/adjacent - user building slowly. Wait.
          {:ignore, state}
        end
      else
        # It's a correct note, but the chord is incomplete. Wait.
        {:ignore, state}
      end
    end
  end

  # Catch-all for inactive phases (ignore validation when not in :active phase)
  def validate_step(state, _, _, _), do: {:ignore, state}
  def validate_step(state, _), do: {:ignore, state}
  def validate_note(state, _), do: {:ignore, state}

  # --- Private Helpers ---

  defp handle_success(state, timing_info \\ nil) do
    new_stats = Map.update!(state.stats, :correct, &(&1 + 1))
    next_index = state.step_index + 1
    total_steps = length(state.lesson.steps)

    # === TIMING VALIDATION ===
    # Check if note was played on time
    timing_message =
      if timing_info do
        case validate_timing(timing_info) do
          {:ok, msg} -> msg
          # Warning but still success
          {:error, msg} -> "⚠️  " <> msg
          _ -> ""
        end
      else
        ""
      end

    message =
      if timing_message == "" do
        "¡Correcto! Siguiente nota."
      else
        "¡Correcto! #{timing_message}"
      end

    if next_index < total_steps do
      # Continue Lesson
      new_state = %{
        state
        | stats: new_stats,
          step_index: next_index,
          feedback: %{status: :success, message: message}
      }

      {:continue, new_state}
    else
      # Lesson Completed
      new_state = %{
        state
        | stats: new_stats,
          # Keep index at end to show completion state
          step_index: next_index,
          phase: :summary,
          completed?: true,
          feedback: %{status: :success, message: "¡Lección Completada!"}
      }

      {:completed, new_state}
    end
  end

  defp handle_error(state, played_midi, target_note, timing_info \\ nil) do
    new_stats = Map.update!(state.stats, :errors, &(&1 + 1))

    target_name =
      if is_list(target_note) do
        Enum.map(target_note, fn n -> Note.new(n).name end) |> Enum.join(" + ")
      else
        Note.new(target_note).name
      end

    played_name = Note.new(played_midi).name

    # === TIMING VALIDATION ===
    # Add timing error if available
    base_message =
      if is_list(target_note) do
        "Has tocado #{played_name}. Busca las notas: #{target_name}."
      else
        generate_error_message(played_midi, played_name, target_note, target_name)
      end

    # Append timing error if present
    message =
      if timing_info do
        case validate_timing(timing_info) do
          {:error, timing_msg} -> base_message <> " " <> timing_msg
          _ -> base_message
        end
      else
        base_message
      end

    new_state = %{state | stats: new_stats, feedback: %{status: :error, message: message}}

    {:error, new_state}
  end

  defp generate_error_message(_played_midi, played_name, _target_note, target_name)
       when played_name == target_name do
    "Es la nota correcta (#{played_name}), pero en la octava equivocada."
  end

  defp generate_error_message(played_midi, _played_name, target_note, _target_name)
       when abs(played_midi - target_note) <= 2 do
    diff = abs(played_midi - target_note)
    "¡Casi! Estás muy cerca (a #{diff} semitonos)."
  end

  defp generate_error_message(_played_midi, played_name, _target_note, target_name) do
    "Has tocado #{played_name}. Busca la nota #{target_name}."
  end

  # --- Utility / Query functions ---

  def current_step(%__MODULE__{} = state) do
    Enum.at(state.lesson.steps, state.step_index)
  end

  def calculate_accuracy(%__MODULE__{stats: stats}) do
    total = stats.correct + stats.errors
    if total > 0, do: stats.correct / total * 100, else: 0
  end

  def passed?(%__MODULE__{} = state) do
    calculate_accuracy(state) >= 80
  end
end
