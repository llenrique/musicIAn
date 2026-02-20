defmodule MusicIanWeb.TheoryLive do
  use MusicIanWeb, :live_view
  alias MusicIan.Curriculum
  alias MusicIan.MCPClientHelper
  alias MusicIan.MusicCore
  alias MusicIan.MusicCore.Note
  alias MusicIan.MusicCore.Theory
  alias MusicIan.Practice.FSM.LessonFSM
  alias MusicIan.Practice.Helper.LessonHelper

  alias MusicIanWeb.Components.Music.{
    CircleOfFifths,
    Controls,
    Footer,
    Keyboard,
    LessonModals,
    Staff,
    TheoryPanel
  }

  alias MusicIanWeb.Components.PracticeComparison

  def mount(params, _session, socket) do
    # Default state: C Major Scale
    socket =
      socket
      |> assign(:active_tab, :explorer)
      # C4
      |> assign(:root_note, 60)
      |> assign(:scale_type, :major)
      |> assign(:active_notes, [])
      |> assign(:keyboard_notes, [])
      |> assign(:vexflow_notes, [])
      |> assign(:vexflow_key, "C")
      |> assign(:scale_info, %{description: "", mood: ""})
      |> assign(:show_help, true)
      |> assign(:midi_connected, false)
      |> assign(:midi_inputs, [])
      |> assign(:hands_mode, :single)
      |> assign(:right_octave, 4)
      |> assign(:left_octave, 3)
      |> assign(:virtual_velocity, 100)
      |> assign(:metronome_active, false)
      |> assign(:tempo, 60)
      |> assign(:detected_bpm, nil)
      |> assign(:held_notes, MapSet.new())
      # Maps midi -> timestamp when note was pressed
      |> assign(:note_timings, %{})
      # MCP Analysis
      |> assign(:detected_chord, nil)
      |> assign(:scale_info_enriched, nil)
      # Lesson State
      |> assign(:lesson_active, false)
      # Holds the LessonFSM struct
      |> assign(:lesson_state, nil)
      |> assign(:current_lesson, nil)
      |> assign(:current_step_index, 0)
      |> assign(:lesson_phase, nil)
      |> assign(:lesson_feedback, nil)
      |> assign(:lesson_stats, %{correct: 0, errors: 0})
      |> assign(:lesson_time_signature, "4/4")
      |> assign(:countdown, 0)
      |> assign(:keyboard_base, 48)
      |> assign(:circle_mode, :major)
      |> assign(:theory_panel_open, true)
      |> update_active_notes()

    # Auto-start lesson if start_lesson parameter is provided
    socket =
      case Map.get(params, "start_lesson") do
        nil ->
          socket

        lesson_id ->
          case LessonFSM.new(lesson_id) do
            {:ok, fsm_state} ->
              socket
              |> assign(:show_help, false)
              |> assign_fsm_state(fsm_state)

            {:error, _reason} ->
              socket
          end
      end

    {:ok, socket}
  end

  defp assign_lesson_state(socket, nil) do
    socket
    |> assign(:lesson_active, false)
    |> assign(:lesson_state, nil)
    |> assign(:current_lesson, nil)
    |> assign(:current_step_index, 0)
    |> assign(:lesson_phase, nil)
    |> assign(:lesson_feedback, nil)
    |> assign(:lesson_stats, %{correct: 0, errors: 0})
    # === FIX: Clear held_notes when lesson ends ===
    |> assign(:held_notes, MapSet.new())
    |> assign(:metronome_active, false)
    |> push_event("toggle_metronome", %{active: false, bpm: socket.assigns.tempo})
    |> update_active_notes()
  end

  defp assign_fsm_state(socket, %LessonFSM{} = fsm) do
    socket
    |> assign(:lesson_active, true)
    |> assign(:lesson_state, fsm)
    |> assign(:current_lesson, fsm.lesson)
    |> assign(:current_step_index, fsm.step_index)
    |> assign(:lesson_phase, fsm.current_state)
    |> assign(:lesson_feedback, fsm.feedback)
    |> assign(:lesson_stats, fsm.stats)
    |> assign(:held_notes, MapSet.new())
    |> assign(:metronome_active, fsm.metronome_active)
    |> assign(:tempo, fsm.bpm || socket.assigns.tempo)
    |> update_active_notes()
  end

  def handle_event("bpm_detected", %{"bpm" => bpm}, socket) do
    {:noreply, assign(socket, :detected_bpm, bpm)}
  end

  def handle_event("set_virtual_velocity", %{"velocity" => velocity}, socket) do
    {:noreply, assign(socket, :virtual_velocity, String.to_integer(velocity))}
  end

  def handle_event("toggle_metronome", _, socket) do
    # === GUARD: Only allow metronome toggle during active practice ===
    # During countdown or demo, metronome state is controlled by system
    lesson_phase = socket.assigns.lesson_phase

    if lesson_phase in [:countdown, :demo] do
      # Ignore user toggle during countdown or demo
      {:noreply, socket}
    else
      # Allow toggle only during practice or exploration mode
      active = !socket.assigns.metronome_active
      socket = assign(socket, :metronome_active, active)

      {:noreply,
       push_event(socket, "toggle_metronome", %{active: active, bpm: socket.assigns.tempo})}
    end
  end

  def handle_event("set_tempo", %{"bpm" => bpm}, socket) do
    bpm = String.to_integer(bpm)
    socket = assign(socket, :tempo, bpm)

    if socket.assigns.metronome_active do
      {:noreply, push_event(socket, "update_metronome_tempo", %{bpm: bpm})}
    else
      {:noreply, socket}
    end
  end

  def handle_event("start_lesson", %{"id" => lesson_id}, socket) do
    # === FSM: Load new lesson in :intro phase ===
    case LessonFSM.new(lesson_id) do
      {:ok, fsm_state} ->
        {:noreply,
         socket
         |> assign(:show_help, false)
         |> assign_fsm_state(fsm_state)}

      {:error, _reason} ->
        {:noreply, put_flash(socket, :error, "Lección no encontrada")}
    end
  end

  # === Alias: play_demo is same as start_demo (for post-demo modal) ===
  def handle_event("play_demo", _, socket) do
    handle_event("start_demo", nil, socket)
  end

  def handle_event("start_demo", _, socket) do
    if socket.assigns.lesson_active do
      # === FSM TRANSITION: intro/post_demo → demo ===
      fsm = socket.assigns.lesson_state

      case LessonFSM.transition_to_demo(fsm) do
        {:ok, new_fsm} ->
          # Prepare sequence for client-side playback
          lesson = new_fsm.lesson
          tempo = socket.assigns.tempo

          sequence_steps = build_sequence_steps(lesson.steps)

          # Push event to client to start the sequencer
          {:noreply,
           socket
           |> assign(:lesson_state, new_fsm)
           |> assign(:lesson_phase, :demo)
           |> assign(:current_step_index, 0)
           |> update_active_notes()
           |> push_event("play_demo_sequence", %{
             tempo: tempo,
             steps: sequence_steps
           })}

        {:error, _reason} ->
          {:noreply, socket}
      end
    else
      {:noreply, socket}
    end
  end

  def handle_event("stop_demo", _, socket) do
    if socket.assigns.lesson_active do
      # === FSM TRANSITION: demo → post_demo ===
      fsm = socket.assigns.lesson_state

      case LessonFSM.transition_to_post_demo(fsm) do
        {:ok, new_fsm} ->
          {:noreply,
           socket
           |> assign(:lesson_state, new_fsm)
           |> assign(:lesson_phase, :post_demo)
           |> assign(:lesson_feedback, %{
             status: :info,
             message: "Demo completado. ¿Repetir o comenzar a practicar?"
           })
           |> push_event("stop_demo_sequence", %{})}

        {:error, _} ->
          {:noreply, socket}
      end
    else
      {:noreply, socket}
    end
  end

  def handle_event("demo_step_update", %{"step_index" => index}, socket) do
    {:noreply, assign(socket, :current_step_index, index)}
  end

  def handle_event("demo_finished", _, socket) do
    if socket.assigns.lesson_active do
      # === FSM TRANSITION: demo → post_demo ===
      # Client notifies server that demo playback finished
      fsm = socket.assigns.lesson_state

      case LessonFSM.transition_to_post_demo(fsm) do
        {:ok, new_fsm} ->
          {:noreply,
           socket
           |> assign(:lesson_state, new_fsm)
           |> assign(:current_step_index, 0)
           |> assign(:lesson_phase, :post_demo)
           |> assign(:lesson_feedback, %{
             status: :info,
             message: "Demo completado. ¿Repetir o comenzar a practicar?"
           })}

        {:error, _reason} ->
          {:noreply, socket}
      end
    else
      {:noreply, socket}
    end
  end

  # REMOVED: handle_info(:next_demo_step) and related demo loop functions
  # as they are now handled client-side.

  def handle_event("begin_practice", _, socket) do
    if socket.assigns.lesson_active do
      # === FSM TRANSITION: intro/post_demo → countdown ===
      # Pasar el tempo actual (el usuario pudo haberlo cambiado)
      case LessonFSM.transition_to_countdown(socket.assigns.lesson_state, socket.assigns.tempo) do
        {:ok, new_fsm_state} ->
          # Start countdown (10 seconds) - first tick will activate metronome
          Process.send_after(self(), :countdown_tick, 1000)

          {:noreply,
           socket
           |> assign(:lesson_state, new_fsm_state)
           |> assign(:current_step_index, 0)
           |> assign(:lesson_phase, :countdown)
           |> assign(:countdown, 10)
           |> assign(:countdown_stage, :counting)
           |> assign(:metronome_active, false)
           |> update_active_notes()}

        {:error, _} ->
          {:noreply, socket}
      end
    else
      {:noreply, socket}
    end
  end

  def handle_event("stop_lesson", _, socket) do
    {:noreply, assign_lesson_state(socket, nil)}
  end

  def handle_event("toggle_help", _, socket) do
    {:noreply, update(socket, :show_help, &(!&1))}
  end

  def handle_event("toggle_theory_panel", _, socket) do
    {:noreply, update(socket, :theory_panel_open, &(!&1))}
  end

  def handle_event("midi_status_update", %{"connected" => connected, "inputs" => inputs}, socket) do
    {:noreply,
     socket
     |> assign(:midi_connected, connected)
     |> assign(:midi_inputs, inputs)}
  end

  def handle_event("reconnect_midi", _, socket) do
    {:noreply, push_event(socket, "reconnect_midi", %{})}
  end

  def handle_event("toggle_hands", _, socket) do
    new_mode = if socket.assigns.hands_mode == :single, do: :double, else: :single
    {:noreply, socket |> assign(:hands_mode, new_mode) |> update_active_notes()}
  end

  def handle_event("shift_keyboard", %{"direction" => direction}, socket) do
    current_base = socket.assigns.keyboard_base
    delta = if direction == "up", do: 12, else: -12
    # C1 (MIDI 24) to C7 (MIDI 96) — keeps 3-octave keyboard in valid range
    new_base = (current_base + delta) |> max(24) |> min(84)
    {:noreply, assign(socket, :keyboard_base, new_base)}
  end

  def handle_event("change_octave_right", %{"octave" => octave_str}, socket) do
    octave = String.to_integer(octave_str)
    # Clamp octave between 2 and 6
    octave = max(2, min(6, octave))

    # Recalculate root note based on new octave
    current_root = socket.assigns.root_note
    pitch_class = rem(current_root, 12)
    new_root = (octave + 1) * 12 + pitch_class

    {:noreply,
     socket
     |> assign(:right_octave, octave)
     |> assign(:root_note, new_root)
     |> update_active_notes()}
  end

  def handle_event("change_octave_left", %{"octave" => octave_str}, socket) do
    octave = String.to_integer(octave_str)
    # Clamp octave between 1 and 5 (Left hand usually lower)
    octave = max(1, min(5, octave))

    {:noreply,
     socket
     |> assign(:left_octave, octave)
     |> update_active_notes()}
  end

  def handle_event("select_circle_mode", %{"mode" => mode_str}, socket) do
    mode = String.to_existing_atom(mode_str)
    {:noreply, assign(socket, :circle_mode, mode)}
  end

  def handle_event("select_root", %{"note" => note_str, "mode" => mode_str}, socket) do
    base_midi = String.to_integer(note_str)
    mode = String.to_existing_atom(mode_str)

    # Adjust midi to current right_octave
    pitch_class = rem(base_midi, 12)
    octave = socket.assigns.right_octave
    root_note = (octave + 1) * 12 + pitch_class

    # When selecting a minor, switch scale_type to :minor
    scale_type = if mode == :minor, do: :minor, else: socket.assigns.scale_type

    socket =
      socket
      |> assign(:root_note, root_note)
      |> assign(:scale_type, scale_type)
      |> assign(:circle_mode, mode)
      |> update_active_notes()

    # Refresh enriched scale info with new root
    case MCPClientHelper.scale_notes(root_note, scale_type) do
      {:ok, enriched_scale} ->
        {:noreply, assign(socket, :scale_info_enriched, enriched_scale)}

      {:error, _} ->
        {:noreply, socket}
    end
  end

  def handle_event("select_root", %{"note" => note_str}, socket) do
    base_midi = String.to_integer(note_str)
    pitch_class = rem(base_midi, 12)
    octave = socket.assigns.right_octave
    root_note = (octave + 1) * 12 + pitch_class

    socket = socket |> assign(:root_note, root_note) |> update_active_notes()

    # Refresh enriched scale info with new root
    case MCPClientHelper.scale_notes(root_note, socket.assigns.scale_type) do
      {:ok, enriched_scale} ->
        {:noreply, assign(socket, :scale_info_enriched, enriched_scale)}

      {:error, _} ->
        {:noreply, socket}
    end
  end

  def handle_event("select_scale", %{"type" => type_str}, socket) do
    type = String.to_existing_atom(type_str)
    socket = socket |> assign(:scale_type, type) |> update_active_notes()

    # Use MCP to get enriched scale information
    case MCPClientHelper.scale_notes(socket.assigns.root_note, type) do
      {:ok, enriched_scale} ->
        {:noreply, assign(socket, :scale_info_enriched, enriched_scale)}

      {:error, _} ->
        {:noreply, socket}
    end
  end

  def handle_event("play_note", %{"midi" => midi_str}, socket) do
    midi = if is_integer(midi_str), do: midi_str, else: String.to_integer(midi_str)
    {:noreply, push_event(socket, "play_note", %{midi: midi, duration: 0.5})}
  end

  def handle_event("midi_note_on", %{"midi" => midi, "velocity" => _velocity} = params, socket) do
    # 1. Optimistic UI handled in JS (MidiDevice -> AudioEngine/MusicStaff)
    # 2. Server logic: Validate note, track progress, etc.
    # We DO NOT push "play_note" back to avoid double playing/latency
    if midi == 108 do
      handle_c8_action(socket)
    else
      timing_info = extract_timing_info(params)
      socket = update_held_notes(socket, midi)
      handle_note_in_context(socket, midi, timing_info)
    end
  end

  def handle_event("midi_note_off", %{"midi" => midi}, socket) do
    # Remove from held notes
    held_notes = MapSet.delete(socket.assigns[:held_notes] || MapSet.new(), midi)
    {:noreply, assign(socket, :held_notes, held_notes)}
  end

  defp build_sequence_steps(steps) do
    steps
    |> Enum.with_index()
    |> Enum.map(fn {step, index} ->
      note_value = step[:note]
      notes = if is_nil(note_value) or note_value == 0, do: [], else: [note_value]

      %{
        notes: notes,
        duration_beats: step[:duration] || 1,
        step_index: index,
        text: step[:text] || "Step #{index + 1}"
      }
    end)
  end

  defp extract_timing_info(params) do
    %{
      # Path primario: recalcula la desviación en el servidor
      "noteRelativeTime" => params["noteRelativeTime"],
      "expectedBeat" => params["expectedBeat"],
      "beatDurationMs" => params["beatDurationMs"],
      "toleranceMs" => params["toleranceMs"],
      # Path fallback: usa el status pre-calculado por el cliente
      "timingStatus" => params["timingStatus"],
      "timingDeviation" => params["timingDeviation"],
      "timingSeverity" => params["timingSeverity"]
    }
  end

  defp update_held_notes(socket, midi) do
    held_notes = MapSet.put(socket.assigns[:held_notes] || MapSet.new(), midi)
    socket = assign(socket, :held_notes, held_notes)

    if MapSet.size(held_notes) >= 2 do
      held_list = held_notes |> MapSet.to_list() |> Enum.sort()

      case MCPClientHelper.chord_from_midi_notes(held_list) do
        {:ok, chord_info} -> assign(socket, :detected_chord, chord_info)
        {:error, _} -> assign(socket, :detected_chord, nil)
      end
    else
      assign(socket, :detected_chord, nil)
    end
  end

  defp handle_note_in_context(socket, midi, timing_info) do
    if socket.assigns.lesson_active && socket.assigns.lesson_phase == :active do
      fsm = socket.assigns.lesson_state
      held_list = socket.assigns.held_notes |> MapSet.to_list()
      handle_lesson_note(socket, fsm, held_list, midi, timing_info)
    else
      {:noreply, socket}
    end
  end

  defp handle_lesson_note(socket, fsm, held_list, midi, timing_info) do
    case LessonFSM.validate_note(fsm, held_list, midi, timing_info) do
      {:continue, new_fsm} ->
        {:noreply,
         socket
         |> assign(:lesson_state, new_fsm)
         |> assign(:current_lesson, new_fsm.lesson)
         |> assign(:current_step_index, new_fsm.step_index)
         |> assign(:lesson_stats, new_fsm.stats)
         |> assign(:lesson_feedback, new_fsm.feedback)
         |> assign(:held_notes, MapSet.new())
         |> update_active_notes()
         |> push_event("step_advanced", %{step_index: new_fsm.step_index})}

      {:completed, new_fsm} ->
        LessonHelper.save_lesson_completion(
          new_fsm.lesson_id,
          new_fsm.stats,
          new_fsm.step_analysis,
          new_fsm.bpm
        )

        {:noreply,
         socket
         |> assign(:lesson_state, new_fsm)
         |> assign(:lesson_phase, :summary)
         |> assign(:current_step_index, new_fsm.step_index)
         |> assign(:lesson_stats, new_fsm.stats)
         |> assign(:lesson_feedback, new_fsm.feedback)
         |> assign(:held_notes, MapSet.new())
         |> assign(:metronome_active, false)
         |> push_event("toggle_metronome", %{active: false, bpm: socket.assigns.tempo})}

      {:error, new_fsm} ->
        {:noreply,
         socket
         |> assign(:lesson_state, new_fsm)
         |> assign(:lesson_stats, new_fsm.stats)
         |> assign(:lesson_feedback, new_fsm.feedback)}

      {:ignore, _} ->
        {:noreply, socket}
    end
  end

  # C8 key: context-aware action (start lesson if none active, or FSM-based action)
  defp handle_c8_action(socket) do
    if socket.assigns.lesson_active do
      c8_lesson_action(socket, socket.assigns.lesson_state)
    else
      c8_start_first_lesson(socket)
    end
  end

  defp c8_start_first_lesson(socket) do
    case List.first(Curriculum.list_lessons()) do
      nil ->
        {:noreply, socket}

      first_lesson ->
        case LessonFSM.new(first_lesson.id) do
          {:ok, fsm_state} ->
            {:noreply, socket |> assign(:show_help, false) |> assign_fsm_state(fsm_state)}

          _error ->
            {:noreply, socket}
        end
    end
  end

  # Dispatch C8 action based on current FSM phase
  defp c8_lesson_action(socket, %{current_state: phase} = state)
       when phase in [:intro, :demo] do
    case LessonFSM.transition_to_countdown(state) do
      {:ok, new_fsm} -> {:noreply, assign(socket, :lesson_state, new_fsm)}
      _ -> {:noreply, socket}
    end
  end

  defp c8_lesson_action(socket, %{current_state: :active}), do: {:noreply, socket}

  defp c8_lesson_action(socket, %{current_state: :summary} = state) do
    if LessonFSM.passed?(state) do
      c8_advance_to_next_lesson(socket, state)
    else
      c8_retry_lesson(socket, state)
    end
  end

  defp c8_lesson_action(socket, _state), do: {:noreply, socket}

  defp c8_advance_to_next_lesson(socket, state) do
    case Curriculum.get_next_lesson_id(state.lesson_id) do
      nil ->
        {:noreply,
         socket
         |> assign(:lesson_state, nil)
         |> assign(:lesson_active, false)
         |> put_flash(:info, "¡Has completado todo el curso!")}

      next_id ->
        case LessonFSM.new(next_id) do
          {:ok, next_fsm} -> {:noreply, assign_fsm_state(socket, next_fsm)}
          _ -> {:noreply, socket}
        end
    end
  end

  defp c8_retry_lesson(socket, state) do
    case LessonFSM.new(state.lesson_id) do
      {:ok, retry_fsm} -> {:noreply, assign_fsm_state(socket, retry_fsm)}
      _ -> {:noreply, socket}
    end
  end

  # === COUNTDOWN TIMER FOR PRACTICE START ===
  # Countdown: 10 → 0 seconds
  # Metronome is already active (started in begin_practice)
  # At 3,2,1: show "Listo, Set, ¡Vamos!" with beeps
  def handle_info(:countdown_tick, socket) do
    countdown = socket.assigns[:countdown] || 0
    fsm = socket.assigns.lesson_state

    case LessonFSM.handle_countdown_tick(fsm) do
      {:countdown_tick_10, new_fsm} ->
        # COUNTDOWN TICK 10: Activate metronome ALWAYS during countdown
        # (so the student hears beats while counting down).
        # After countdown ends, it will be turned off if lesson.metronome == false.
        Process.send_after(self(), :countdown_tick, 1000)

        {:noreply,
         socket
         |> assign(:lesson_state, new_fsm)
         |> assign(:countdown, 9)
         |> assign(:countdown_stage, :counting)
         |> assign(:metronome_active, true)
         |> push_event("toggle_metronome", %{active: true, bpm: socket.assigns.tempo})}

      {:countdown_tick, new_fsm} when countdown > 3 ->
        # === STAGE 1: Normal countdown (10 → 4) ===
        Process.send_after(self(), :countdown_tick, 1000)

        {:noreply,
         socket
         |> assign(:lesson_state, new_fsm)
         |> assign(:countdown, new_fsm.countdown)
         |> assign(:countdown_stage, :counting)}

      {:countdown_tick, new_fsm} when countdown > 0 ->
        # === STAGE 2: "Listo, Set, ¡Vamos!" (3 → 1) ===
        Process.send_after(self(), :countdown_tick, 1000)

        {:noreply,
         socket
         |> assign(:lesson_state, new_fsm)
         |> assign(:countdown, new_fsm.countdown)
         |> assign(:countdown_stage, :final)
         |> push_event("countdown_tick", %{countdown: new_fsm.countdown, stage: "final"})}

      {:transition_to_active, new_fsm} ->
        # === Countdown finished - start active practice ===
        steps = new_fsm.lesson.steps
        tempo = new_fsm.bpm
        metronome_enabled = new_fsm.metronome_active

        {:noreply,
         socket
         |> assign(:lesson_state, new_fsm)
         |> assign(:lesson_phase, :active)
         |> assign(:countdown, 0)
         |> assign(:countdown_stage, nil)
         |> assign(:metronome_active, metronome_enabled)
         |> assign(:tempo, tempo)
         |> push_event("lesson_started", %{
           steps: steps,
           tempo: tempo,
           metronome_active: metronome_enabled,
           timing_strictness: new_fsm.timing_strictness,
           beat_map: new_fsm.beat_map
         })}

      {:error, _} ->
        {:noreply, socket}
    end
  end

  # Calculate keyboard base note so the target note of the current step
  # is visible in the 3-octave keyboard window.
  # Returns a MIDI note that is a C (multiple of 12) — the leftmost C shown.
  defp lesson_keyboard_base(nil, _idx, _active), do: 48
  defp lesson_keyboard_base(_lesson, _idx, false), do: 48

  defp lesson_keyboard_base(lesson, step_index, true) do
    step = Enum.at(lesson.steps, step_index)
    target_midi = step && (step[:note] || 0)

    if is_nil(target_midi) or target_midi == 0 do
      # Observation / generated step with no hardcoded note — default to C3-C6
      48
    else
      # Find which octave the note is in and show it centered:
      # The keyboard shows 3 octaves. We want the note's octave to be in the middle octave.
      # Octave of note: div(midi, 12) - 1 (MIDI convention)
      note_octave = div(target_midi, 12) - 1
      # Start one octave below the note's octave so it's in the middle
      start_octave = max(0, note_octave - 1)
      # Convert back to MIDI C of that octave: (octave + 1) * 12
      # Clamp max to 84 (C6) so 3-octave keyboard stays within MIDI 0-127
      base = (start_octave + 1) * 12
      min(base, 84)
    end
  end

  defp update_active_notes(socket) do
    if socket.assigns.lesson_active do
      update_lesson_notes(socket)
    else
      update_explorer_notes(socket)
    end
  end

  defp update_lesson_notes(socket) do
    lesson = socket.assigns.current_lesson
    steps = lesson.steps
    current_idx = socket.assigns[:current_step_index] || 0
    time_signature = lesson[:time_signature] || "4/4"

    # Mostrar TODOS los pasos sin ventana deslizante. El cursor (data-step-index)
    # avanza por posición absoluta. Esto evita que la partitura "scrollee"
    # durante la práctica, igualando el comportamiento de la fase demo.
    vexflow_notes = Enum.map(steps, &step_to_vexflow/1)

    lesson_midis =
      steps
      |> Enum.flat_map(fn step ->
        note_val = step[:note]
        if is_nil(note_val) or note_val == 0, do: [], else: [note_val]
      end)
      |> Enum.uniq()
      |> Enum.sort()

    keyboard_base = lesson_keyboard_base(socket.assigns.current_lesson, current_idx, true)

    socket
    |> assign(:active_notes, lesson_midis)
    |> assign(:keyboard_notes, lesson_midis)
    |> assign(:vexflow_notes, vexflow_notes)
    |> assign(:lesson_time_signature, time_signature)
    |> assign(:keyboard_base, keyboard_base)
    |> assign(:vexflow_key, "C")
    |> assign(:scale_info, %{description: "Lección Activa", mood: "Práctica"})
    |> assign(:suggested_keys, [])
    |> assign(:suggestion_reason, "")
    |> assign(:theory_context, %{
      title: "Modo Lección",
      description: "Sigue la partitura.",
      intervals: [],
      chord_suggestions: [],
      circle: "Lección Activa",
      key_sig: "Do Mayor (C)",
      formula: "Práctica Guiada"
    })
  end

  defp step_to_vexflow(step) do
    midis = step_midi_list(step)
    notes_info = Enum.map(midis, &midi_to_note_info/1)
    %{notes: notes_info, duration: duration_to_char(step[:duration] || 1)}
  end

  defp step_midi_list(step) do
    note_value = step[:note]
    empty_note? = is_nil(note_value) or note_value == 0
    if empty_note?, do: [], else: [note_value]
  end

  defp midi_to_note_info(midi) do
    n = Note.new(midi)
    {base, acc} = Theory.parse_note_name(n.name)
    acc = if acc != "", do: acc, else: nil

    %{
      key: "#{String.downcase(base)}/#{n.octave}",
      accidental: acc,
      midi: midi,
      clef: if(midi >= 60, do: "treble", else: "bass")
    }
  end

  # Convierte duración numérica (beats) a código VexFlow.
  # Valores válidos: 4=redonda, 2=blanca, 1=negra, 0.5=corchea.
  # Duraciones mayores a 4 (p.ej. 8) no existen en notación estándar —
  # se mapean a la redonda para evitar compases rotos.
  defp duration_to_char(dur) do
    case dur do
      4 -> "w"
      2 -> "h"
      1 -> "q"
      0.5 -> "8"
      d when is_number(d) and d > 4 -> "w"
      _ -> "q"
    end
  end

  defp update_explorer_notes(socket) do
    root = socket.assigns.root_note
    type = socket.assigns.scale_type

    use_flats = rem(root, 12) in [5, 10, 3, 8, 1, 6]
    opts = [use_flats: use_flats]

    scale_right = MusicCore.get_scale(root, type, opts)

    scale_notes =
      if socket.assigns.hands_mode == :double do
        pitch_class = rem(root, 12)
        left_root = (socket.assigns.left_octave + 1) * 12 + pitch_class
        scale_left = MusicCore.get_scale(left_root, type, opts)
        scale_left.notes ++ scale_right.notes
      else
        scale_right.notes
      end

    # active_notes: all scale notes (used by staff/pentagrama)
    active_midis = Enum.map(scale_notes, & &1.midi)
    # keyboard_notes: only right-hand scale (one octave, for keyboard highlight)
    keyboard_midis = Enum.map(scale_right.notes, & &1.midi)

    vexflow_key = Theory.determine_key_signature(root, type, opts)
    key_accidentals = Theory.get_key_signature_accidentals(vexflow_key)

    vexflow_notes =
      scale_notes
      |> Enum.map(&note_to_vexflow(&1, key_accidentals, opts))
      |> maybe_append_octave_note(scale_notes, key_accidentals, opts)

    theory_context = Theory.analyze_context(root, type, scale_right.notes, use_flats)

    socket
    |> assign(:active_notes, active_midis)
    |> assign(:keyboard_notes, keyboard_midis)
    |> assign(:vexflow_notes, vexflow_notes)
    |> assign(:vexflow_key, vexflow_key)
    |> assign(:scale_info, %{description: scale_right.description, mood: scale_right.mood})
    |> assign(:suggested_keys, scale_right.suggested_keys)
    |> assign(:suggestion_reason, scale_right.suggestion_reason)
    |> assign(:theory_context, theory_context)
    |> assign(:note_explanations, scale_right.note_explanations)
  end

  defp note_to_vexflow(n, key_accidentals, _opts) do
    {base, acc} = Theory.parse_note_name(n.name)

    %{
      notes: [
        %{
          key: "#{String.downcase(base)}/#{n.octave}",
          accidental: vexflow_accidental(acc, Map.get(key_accidentals, base, "")),
          midi: n.midi,
          clef: if(n.midi >= 60, do: "treble", else: "bass")
        }
      ],
      duration: "q"
    }
  end

  defp maybe_append_octave_note(vexflow_notes, scale_notes, key_accidentals, opts) do
    if length(scale_notes) == 7 do
      first_note = List.first(scale_notes)
      octave_note = Note.new(first_note.midi + 12, opts)
      vexflow_notes ++ [note_to_vexflow(octave_note, key_accidentals, opts)]
    else
      vexflow_notes
    end
  end

  defp vexflow_accidental(acc, expected_acc) do
    cond do
      acc == expected_acc -> nil
      acc == "" and expected_acc != "" -> "n"
      true -> acc
    end
  end

  defp circle_of_fifths_data do
    Theory.generate_circle_of_fifths()
  end

  def render(assigns) do
    # Re-compiled for updated components
    ~H"""
    <div
      id="theory-live"
      phx-hook="MidiDevice"
      class="h-full bg-slate-100 text-slate-800 flex flex-col overflow-hidden"
    >
      <div id="audio-engine" phx-hook="AudioEngine"></div>
      
    <!-- Top Bar: Workspace Controls -->
      <header class="bg-white border-b border-slate-200 px-6 py-3 flex justify-between items-center shrink-0 z-20 shadow-sm">
        <div class="flex items-center gap-4 relative">
          <!-- Lesson Controls -->
          <%= if !@lesson_active do %>
            <.link
              navigate={~p"/modules"}
              class="flex items-center gap-2 px-3 py-1.5 bg-emerald-600 hover:bg-emerald-500 text-white text-sm font-medium rounded transition-colors"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                stroke-width="2"
                stroke="currentColor"
                class="w-4 h-4"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  d="M12 6.042A8.967 8.967 0 006 3.75c-1.052 0-2.062.18-3 .512v14.25A8.987 8.987 0 016 18c2.305 0 4.408.867 6 2.292m0-14.25a8.966 8.966 0 016-2.292c1.052 0 2.062.18 3 .512v14.25A8.987 8.987 0 0018 18a8.967 8.967 0 00-6 2.292m0-14.25v14.25"
                />
              </svg>
              Lecciones
            </.link>
          <% else %>
            <div class="flex items-center gap-3 bg-emerald-50 px-3 py-1 rounded border border-emerald-100">
              <span class="text-xs font-bold text-emerald-700 uppercase tracking-wider">
                Lección: {@current_lesson.title}
              </span>
              <button
                phx-click="stop_lesson"
                class="text-xs text-red-500 hover:text-red-700 font-medium underline"
              >
                Terminar
              </button>
            </div>
          <% end %>
        </div>

        <div class="flex items-center gap-3">
          <.link
            navigate={~p"/dashboard"}
            class="hidden md:flex items-center gap-2 text-sm font-medium text-slate-500 hover:text-purple-600 transition-colors mr-2"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 24 24"
              stroke-width="2"
              stroke="currentColor"
              class="w-4 h-4"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                d="M3 13.125C3 12.504 3.504 12 4.125 12h2.25c.621 0 1.125.504 1.125 1.125v6.75C7.5 20.496 6.996 21 6.375 21h-2.25A1.125 1.125 0 013 19.875v-6.75zM9.75 8.625c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125v11.25c0 .621-.504 1.125-1.125 1.125h-2.25a1.125 1.125 0 01-1.125-1.125V8.625zM16.5 4.125c0-.621.504-1.125 1.125-1.125h2.25C20.496 3 21 3.504 21 4.125v15.75c0 .621-.504 1.125-1.125 1.125h-2.25a1.125 1.125 0 01-1.125-1.125V4.125z"
              />
            </svg>
            Progreso
          </.link>
          
    <!-- MIDI Status Indicator -->
          <div class="hidden md:flex items-center gap-2 px-3 py-1.5 bg-slate-50 rounded border border-slate-200 transition-all">
            <div class="flex items-center gap-2 mr-2 border-r border-slate-200 pr-2">
              <button
                phx-click="toggle_metronome"
                class={"p-1 rounded transition-all duration-100 " <> if(@metronome_active, do: "bg-emerald-100 text-emerald-600", else: "text-slate-400 hover:text-slate-600")}
                title="Metrónomo"
              >
                <div
                  id="metronome-indicator"
                  class={"w-4 h-4 rounded-full flex items-center justify-center transition-all duration-75 " <> if(@metronome_active, do: "bg-emerald-200", else: "")}
                >
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    fill="none"
                    viewBox="0 0 24 24"
                    stroke-width="2"
                    stroke="currentColor"
                    class="w-3 h-3"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      d="M12 6v6h4.5m4.5 0a9 9 0 11-18 0 9 9 0 0118 0z"
                    />
                  </svg>
                </div>
              </button>
              <form phx-submit="set_tempo" phx-change="set_tempo" class="flex flex-col items-center">
                <div class="relative group">
                  <input
                    type="number"
                    min="30"
                    max="250"
                    value={@tempo}
                    class="w-16 py-1 px-1 text-sm font-bold font-mono text-center bg-slate-50 border border-slate-200 rounded focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 transition-all hover:border-emerald-300"
                    name="bpm"
                    phx-debounce="500"
                  />
                </div>
                <%= if @detected_bpm do %>
                  <span
                    class="text-[9px] font-mono text-emerald-600 font-bold animate-pulse whitespace-nowrap leading-none mt-0.5"
                    title="BPM Detectado"
                  >
                    IN:{@detected_bpm}
                  </span>
                <% end %>
              </form>
            </div>

            <div class="flex flex-col leading-none">
              <span class="text-[10px] uppercase font-bold text-slate-400">Virtual Vel</span>
              <input
                type="range"
                min="1"
                max="127"
                value={@virtual_velocity}
                class="w-20 h-1 bg-slate-200 rounded-lg appearance-none cursor-pointer mt-1"
                phx-debounce="100"
                phx-change="set_virtual_velocity"
                name="velocity"
              />
            </div>
          </div>

          <div class="hidden md:flex items-center gap-2 px-3 py-1.5 bg-slate-50 rounded border border-slate-200 transition-all">
            <div class={"w-2 h-2 rounded-full transition-colors " <> if(@midi_connected, do: "bg-emerald-500 shadow-[0_0_8px_rgba(16,185,129,0.5)]", else: "bg-red-300")}>
            </div>
            <div class="flex flex-col leading-none">
              <span class="text-[10px] uppercase font-bold text-slate-400">Estado MIDI</span>
              <span class="text-xs font-medium text-slate-600 truncate max-w-[150px]">
                {if @midi_connected && length(@midi_inputs) > 0,
                  do: List.first(@midi_inputs),
                  else: "Desconectado"}
              </span>
            </div>
            <button
              phx-click="reconnect_midi"
              class="ml-1 p-1 text-slate-400 hover:text-blue-600 transition-colors"
              title="Reconectar dispositivos MIDI"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                stroke-width="2"
                stroke="currentColor"
                class="w-3 h-3"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  d="M16.023 9.348h4.992v-.001M2.985 19.644v-4.992m0 0h4.992m-4.993 0l3.181 3.183a8.25 8.25 0 0013.803-3.7M4.031 9.865a8.25 8.25 0 0113.803-3.7l3.181 3.182m0-4.991v4.99"
                />
              </svg>
            </button>
          </div>
        </div>
      </header>
      
    <!-- Main Workspace -->
      <main class="flex-grow p-4 overflow-hidden relative">
        
    <!-- Lesson Intro Modal -->
        <%= if @lesson_active && @lesson_phase == :intro do %>
          <LessonModals.lesson_intro_modal lesson={@current_lesson} />
        <% end %>
        
    <!-- Demo Overlay -->
        <%= if @lesson_active && @lesson_phase == :demo do %>
          <LessonModals.demo_overlay />
        <% end %>
        
    <!-- Countdown Timer Modal -->
        <%= if @lesson_active && @lesson_phase == :countdown do %>
          <LessonModals.countdown_modal countdown={@countdown} countdown_stage={@countdown_stage} />
        <% end %>
        
    <!-- Post-Demo Confirmation Modal -->
        <%= if @lesson_active && @lesson_phase == :post_demo do %>
          <LessonModals.post_demo_modal />
        <% end %>
        
    <!-- Lesson Overlay (Floating) - MOVED BELOW KEYBOARD -->


         <!-- Lesson Completion Modal -->
        <%= if @lesson_active && @lesson_phase == :summary do %>
          <LessonModals.lesson_summary_modal lesson={@current_lesson} lesson_stats={@lesson_stats} />
        <% end %>

        <div class="grid grid-cols-12 gap-4 h-full">
          <!-- LEFT: Configuration -->
          <div class="col-span-12 lg:col-span-2 flex flex-col gap-4 h-full overflow-hidden">
            <CircleOfFifths.circle_of_fifths
              root_note={@root_note}
              suggested_keys={@suggested_keys}
              theory_context={@theory_context}
              circle_data={circle_of_fifths_data()}
              suggestion_reason={@suggestion_reason}
              circle_mode={@circle_mode}
            />
            <div class="flex-grow overflow-hidden">
              <Controls.scale_controls
                scale_type={@scale_type}
                theory_context={@theory_context}
                hands_mode={@hands_mode}
                right_octave={@right_octave}
                left_octave={@left_octave}
              />
            </div>
          </div>

          <!-- CENTER + RIGHT: flex para que el centro se expanda al colapsar el panel -->
          <div class="col-span-12 lg:col-span-10 flex gap-4 h-full">
            <!-- CENTER: flex-1 se expande automáticamente -->
            <div class="flex-1 min-w-0 flex flex-col gap-4 h-full">
              <div class="h-2/5">
                <Staff.music_staff
                  vexflow_notes={@vexflow_notes}
                  vexflow_key={@vexflow_key}
                  theory_context={@theory_context}
                  current_step_index={@current_step_index}
                  lesson_active={@lesson_active}
                  note_explanations={@note_explanations || []}
                  time_signature={@lesson_time_signature}
                />
              </div>
              <div class="h-3/5 flex flex-col gap-4">
                <Keyboard.virtual_keyboard
                  root_note={@root_note}
                  active_notes={@keyboard_notes}
                  lesson_active={@lesson_active}
                  lesson_phase={@lesson_phase}
                  current_lesson={@current_lesson}
                  current_step_index={@current_step_index}
                  virtual_velocity={@virtual_velocity}
                  keyboard_base={@keyboard_base}
                />
                <%= if @lesson_active && @lesson_phase == :active do %>
                  <LessonModals.lesson_step_indicator
                    lesson={@current_lesson}
                    current_step_index={@current_step_index}
                    lesson_feedback={@lesson_feedback}
                  />
                <% end %>
              </div>
            </div>

            <!-- RIGHT: Análisis Teórico colapsable -->
            <%= if @theory_panel_open do %>
              <div class="w-72 flex-shrink-0 h-full">
                <TheoryPanel.theory_panel
                  root_note={@root_note}
                  scale_type={@scale_type}
                  scale_info={@scale_info}
                  theory_context={@theory_context}
                  on_collapse="toggle_theory_panel"
                />
              </div>
            <% else %>
              <!-- Botón flotante para reabrir el panel -->
              <div class="flex-shrink-0 flex items-start pt-2">
                <button
                  phx-click="toggle_theory_panel"
                  class="bg-white border border-slate-200 rounded-md p-1.5 shadow-sm hover:bg-slate-50 text-slate-400 hover:text-slate-600 transition-colors"
                  title="Mostrar Análisis Teórico"
                >
                  <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-4 h-4">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M15.75 19.5L8.25 12l7.5-7.5" />
                  </svg>
                </button>
              </div>
            <% end %>
          </div>
        </div>
      </main>
      
    <!-- Integrated Practice Comparison Panel (bottom-right corner) -->
      <PracticeComparison.practice_comparison
        lesson={@current_lesson}
        lesson_active={@lesson_active}
        lesson_phase={@lesson_phase}
        step_index={@current_step_index}
        held_notes={@held_notes}
        feedback={@lesson_feedback || %{status: nil, message: "Esperando..."}}
        stats={@lesson_stats}
      />
      
    <!-- Footer Status Bar -->
      <Footer.status_bar
        midi_connected={@midi_connected}
        midi_inputs={@midi_inputs}
      />
    </div>
    """
  end
end
