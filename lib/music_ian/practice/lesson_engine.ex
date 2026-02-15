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
    :completed?,
    # === NEW: Análisis de cada paso ===
    # [%{step_index: 0, note: 60, timing: :on_time, tempo_deviation: 0, status: :success}, ...]
    step_analysis: []
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
           completed?: false,
           step_analysis: []
         }}
    end
  end

  # --- State Transitions ---

  def start_practice(%__MODULE__{} = state) do
    # === IMPORTANT: Reset step analysis for new practice session ===
    # Each practice session starts fresh with empty analysis
    # But accumulated stats are preserved (optional, based on requirements)
    %{state | phase: :active, feedback: nil, step_analysis: []}
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

   timing_info: %{
     notePlayedAtMs: number,
     expectedBeat: number,
     metronomeStartTimeMs: number,
     beatDurationMs: number,
     noteRelativeTime: number,
     toleranceMs: number,
     timingStatus: 'on-time'|'early'|'late'
   }
   """
   def validate_timing(timing_info) do
     # Extract raw timing data from client
     note_played_at = Map.get(timing_info, "notePlayedAtMs", 0)
     expected_beat = Map.get(timing_info, "expectedBeat")
     metronome_start = Map.get(timing_info, "metronomeStartTimeMs")
     beat_duration = Map.get(timing_info, "beatDurationMs", 500)
     note_relative_time = Map.get(timing_info, "noteRelativeTime", 0)
     tolerance_ms = Map.get(timing_info, "toleranceMs", 150)
     
     # If we don't have the raw timing data, fall back to pre-calculated status
     if is_nil(metronome_start) or is_nil(expected_beat) or is_nil(beat_duration) do
       validate_timing_fallback(timing_info)
     else
       # === SERVER-SIDE TIMING ANALYSIS ===
       # Calculate where the note was relative to expected beat
       expected_beat_time_ms = expected_beat * beat_duration
       deviation_ms = note_relative_time - expected_beat_time_ms
       
       # Determine if early, late, or on-time
       status = cond do
         abs(deviation_ms) <= tolerance_ms -> :on_time
         deviation_ms < -tolerance_ms -> :early
         deviation_ms > tolerance_ms -> :late
         true -> :unknown
       end
       
       format_timing_result(status, deviation_ms, tolerance_ms)
     end
   end

   defp validate_timing_fallback(timing_info) do
     case timing_info do
       %{"timingSeverity" => "error"} ->
         # === HARD TIMING ERROR: Note too far from beat ===
         {:error, format_timing_error(timing_info)}

       %{"timingSeverity" => "warning"} ->
         # === SOFT TIMING WARNING: Note slightly off but acceptable ===
         {:warning, format_timing_error(timing_info)}

       %{"timingStatus" => "on-time"} ->
         # Good timing
         {:ok, "✓ Ritmo perfecto"}

       _ ->
         # Unknown or no timing info (skip validation)
         {:ignore, "Sin información de ritmo"}
     end
   end

   defp format_timing_result(status, deviation_ms, tolerance_ms) do
     case status do
       :on_time ->
         {:ok, "✓ Ritmo perfecto"}

       :early ->
         abs_dev = abs(trunc(deviation_ms))
         if abs_dev > 300 do
           {:warning, "⚠️  Demasiado rápido (#{abs_dev}ms antes del beat esperado)"}
         else
           {:ok, "✓ Un poco rápido pero aceptable (#{abs_dev}ms)"}
         end

       :late ->
         dev = trunc(deviation_ms)
         if dev > 300 do
           {:warning, "⚠️  Demasiado lento (#{dev}ms después del beat esperado)"}
         else
           {:ok, "✓ Un poco lento pero aceptable (#{dev}ms)"}
         end

       _ ->
         {:ignore, "Sin información clara de ritmo"}
     end
   end

   defp format_timing_error(%{"timingStatus" => status, "timingDeviation" => deviation}) do
     case status do
       "between-beats" ->
         "❌ Nota entre beats. No pertenece al ritmo esperado."

       "early" when deviation < -300 ->
         "⚠️  Demasiado rápido (#{abs(trunc(deviation))}ms antes del beat)"

       "early" when deviation < -150 ->
         "⚠️  Un poco rápido (#{abs(trunc(deviation))}ms)"

       "early" ->
         "⚠️  Un poco rápido"

       "late" when deviation > 300 ->
         "⚠️  Demasiado lento (#{trunc(deviation)}ms después del beat)"

       "late" when deviation > 150 ->
         "⚠️  Un poco lento (#{trunc(deviation)}ms)"

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
    current_step_text = current_step[:text] || "???"

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
        # 1. Latest note is not in target set (wrong note)
        # 2. Not all target notes are held yet (incomplete chord)
        # 3. Extra notes are being held (strict validation for multi-hand lessons)
        
        if not MapSet.member?(target_set, latest_note) do
          # Wrong note played - error!
          handle_error(state, latest_note, target_notes, timing_info)
        else if not all_target_notes_held do
          # All held notes are correct, but chord is incomplete. Wait for more.
          {:ignore, state}
        else if has_extra_notes do
          # Extra notes held along with all required notes.
          # For multi-hand lessons, ANY extra note should be an error.
          # REASON: User might be holding a note from previous step + accidentally hitting wrong key
          handle_error(state, latest_note, target_notes, timing_info)
        else
          # This shouldn't happen (all checks pass but condition failed?)
          {:ignore, state}
        end
        end
        end
      end
  end

  # Catch-all for inactive phases (ignore validation when not in :active phase)
  def validate_step(state, _, _, _), do: {:ignore, state}
  def validate_step(state, _), do: {:ignore, state}
  def validate_note(state, _), do: {:ignore, state}

  # --- Private Helpers ---

   defp handle_success(state, timing_info \\ nil) do
     current_step = Enum.at(state.lesson.steps, state.step_index)
     current_step_text = current_step[:text] || "???"
     
     new_stats = Map.update!(state.stats, :correct, &(&1 + 1))
     next_index = state.step_index + 1
     total_steps = length(state.lesson.steps)

    # === TIMING VALIDATION ===
    # Check if note was played on time
    # Separate warnings (deduct style points) from hard errors
    {timing_status, timing_message} =
      if timing_info do
        case validate_timing(timing_info) do
          {:ok, msg} -> 
            {:on_time, msg}
          {:warning, msg} -> 
            # === FIX: Warning means correct note but timing slightly off ===
            # Still counts as correct, but with feedback
            {:slightly_off, msg}
          {:error, msg} -> 
            # === This shouldn't happen in handle_success, but include for safety ===
            {:late, "⚠️  " <> msg}
          _ -> 
            {:unknown, ""}
        end
      else
        {:unknown, ""}
      end

    message =
      if timing_message == "" do
        "¡Correcto! Siguiente nota."
      else
        "¡Correcto! #{timing_message}"
      end

    # === NEW: Build step analysis record ===
    step_analysis_record = %{
      step_index: state.step_index,
      step_text: current_step_text,
      notes: current_step[:notes] || [current_step[:note]],
      timing_status: timing_status,
      timing_deviation: timing_info["timingDeviation"] || 0,
      status: :success,
      timestamp: NaiveDateTime.utc_now()
    }

    # === Append to step_analysis list ===
    new_step_analysis = state.step_analysis ++ [step_analysis_record]

    # === FIX: Correct off-by-one error ===
    # total_steps is the count (e.g., 9)
    # But valid indices are 0-8, so last_step_index = 8 = total_steps - 1
    # We should check if current step_index < last_step_index to know if there are more steps
    last_step_index = total_steps - 1

    if state.step_index < last_step_index do
      # Continue Lesson - there are more steps after the current one
      new_state = %{
        state
        | stats: new_stats,
           step_index: next_index,
           step_analysis: new_step_analysis,
           feedback: %{status: :success, message: message}
       }

       {:continue, new_state}
     else
       # Lesson Completed - we just completed the last step
       new_state = %{
         state
         | stats: new_stats,
           # Keep index at end to show completion state
           step_index: next_index,
           step_analysis: new_step_analysis,
           phase: :summary,
           completed?: true,
           feedback: %{status: :success, message: "¡Lección Completada!"}
       }

       {:completed, new_state}
     end
  end

  defp handle_error(state, played_midi, target_note, timing_info \\ nil) do
    new_stats = Map.update!(state.stats, :errors, &(&1 + 1))

    current_step = Enum.at(state.lesson.steps, state.step_index)
    current_step_text = current_step[:text] || "???"

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
    {timing_status, message} =
      if timing_info do
        case validate_timing(timing_info) do
          {:error, timing_msg} -> {:late, base_message <> " " <> timing_msg}
          _ -> {:unknown, base_message}
        end
      else
        {:unknown, base_message}
      end

    # === NEW: Build error step analysis record ===
    step_analysis_record = %{
      step_index: state.step_index,
      step_text: current_step_text,
      notes: current_step[:notes] || [current_step[:note]],
      played_note: played_midi,
      timing_status: timing_status,
      timing_deviation: timing_info["timingDeviation"] || 0,
      status: :error,
      timestamp: NaiveDateTime.utc_now()
    }

    # === Append to step_analysis list ===
    new_step_analysis = state.step_analysis ++ [step_analysis_record]

    new_state = %{
      state 
      | stats: new_stats, 
        step_analysis: new_step_analysis,
        feedback: %{status: :error, message: message}
    }

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
