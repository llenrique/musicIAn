defmodule MusicIanWeb.TheoryLive do
  use MusicIanWeb, :live_view
  alias MusicIan.MusicCore
  alias MusicIan.MusicCore.Note
  alias MusicIan.MCPClientHelper

  alias MusicIanWeb.Components.Music.{
    Keyboard,
    CircleOfFifths,
    Controls,
    Staff,
    TheoryPanel,
    Footer
  }

  alias MusicIanWeb.Components.PracticeComparison

  def mount(_params, _session, socket) do
    # Default state: C Major Scale
    socket =
      socket
      |> assign(:active_tab, :explorer)
      # C4
      |> assign(:root_note, 60)
      |> assign(:scale_type, :major)
      |> assign(:active_notes, [])
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
      |> assign(:show_lessons_menu, false)
      # Holds the LessonEngine struct
      |> assign(:lesson_state, nil)
      |> assign(:current_lesson, nil)
      |> assign(:current_step_index, 0)
      |> assign(:lesson_phase, nil)
      |> assign(:lesson_feedback, nil)
      |> assign(:lesson_stats, %{correct: 0, errors: 0})
      |> assign(:countdown, 0)
      |> update_active_notes()

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

   defp assign_lesson_state(socket, %MusicIan.Practice.LessonEngine{} = state) do
     # DEPRECATED: Use assign_fsm_state instead
     socket
     |> assign(:lesson_active, true)
     |> assign(:lesson_state, state)
     |> assign(:current_lesson, state.lesson)
     |> assign(:current_step_index, state.step_index)
     |> assign(:lesson_phase, state.phase)
     |> assign(:lesson_feedback, state.feedback)
     |> assign(:lesson_stats, state.stats)
     |> assign(:held_notes, MapSet.new())
     |> assign(:metronome_active, false)
     |> update_active_notes()
   end

   # === NEW FSM-based assignment ===
    defp assign_fsm_state(socket, %MusicIan.Practice.FSM.LessonFSM{} = fsm) do
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
      |> update_active_notes()
    end

  defp maybe_start_metronome(socket, lesson) do
    if Map.get(lesson, :metronome, false) do
      socket
      |> assign(:metronome_active, true)
      |> push_event("toggle_metronome", %{active: true, bpm: socket.assigns.tempo})
    else
      socket
      |> assign(:metronome_active, false)
      |> push_event("toggle_metronome", %{active: false, bpm: socket.assigns.tempo})
    end
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

  def handle_event("toggle_lessons_menu", _, socket) do
    {:noreply, update(socket, :show_lessons_menu, &(!&1))}
  end

   def handle_event("start_lesson", %{"id" => lesson_id}, socket) do
     # === FSM: Load new lesson in :intro phase ===
     case MusicIan.Practice.FSM.LessonFSM.new(lesson_id) do
       {:ok, fsm_state} ->
         {:noreply,
          socket
          |> assign(:show_lessons_menu, false)
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
       case MusicIan.Practice.FSM.LessonFSM.transition_to_demo(fsm) do
         {:ok, new_fsm} ->
           # Prepare sequence for client-side playback
           lesson = new_fsm.lesson
           tempo = socket.assigns.tempo

       # Convert steps to a format JS can play
       # We need to map notes to a flat list of events or steps
       # Each step in lesson.steps corresponds to a beat or note

       sequence_steps =
         Enum.with_index(lesson.steps)
         |> Enum.map(fn {step, index} ->
           notes = step[:notes] || [step[:note]]
           notes = List.wrap(notes) |> Enum.reject(&is_nil/1)
           duration_beats = step[:duration] || 1

            %{
              notes: notes,
              duration_beats: duration_beats,
              step_index: index,
              text: step.text
            }
          end)

           # Push event to client to start the sequencer
           {:noreply,
            socket
            |> assign(:lesson_state, new_fsm)
            |> assign(:lesson_phase, :demo)
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
        case MusicIan.Practice.FSM.LessonFSM.transition_to_post_demo(fsm) do
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
       case MusicIan.Practice.FSM.LessonFSM.transition_to_post_demo(fsm) do
         {:ok, new_fsm} ->
           {:noreply,
            socket
            |> assign(:lesson_state, new_fsm)
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
        case MusicIan.Practice.FSM.LessonFSM.transition_to_countdown(socket.assigns.lesson_state) do
          {:ok, new_fsm_state} ->
            # Start countdown (10 seconds) - first tick will activate metronome
            Process.send_after(self(), :countdown_tick, 1000)

            {:noreply,
             socket
             |> assign(:lesson_state, new_fsm_state)
             |> assign(:lesson_phase, :countdown)
             |> assign(:countdown, 10)
             |> assign(:countdown_stage, :counting)
             |> assign(:metronome_active, false)}

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

  def handle_event("select_root", %{"note" => note_str}, socket) do
    base_midi = String.to_integer(note_str)
    # base_midi comes from circle_of_fifths_data which is fixed at octave 4 (60-71)
    # We need to adjust it to the currently selected octave

    # Calculate pitch class from base_midi
    pitch_class = rem(base_midi, 12)

    # Calculate target root note based on right hand octave
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

    # === EXTRACT TIMING INFO FROM PARAMS (NEW) ===
    timing_info = %{
      "timingStatus" => params["timingStatus"],
      "timingDeviation" => params["timingDeviation"],
      "timingSeverity" => params["timingSeverity"]
    }

    # C8 (MIDI 108) as Confirmation/Action Button
    if midi == 108 do
      handle_c8_action(socket)
    else
      # Update held notes and try to detect chord via MCP
      held_notes = MapSet.put(socket.assigns[:held_notes] || MapSet.new(), midi)
      socket = assign(socket, :held_notes, held_notes)

      # Use MCP to detect chord from currently held notes (if 2+ notes)
      socket =
        if MapSet.size(held_notes) >= 2 do
          held_list = MapSet.to_list(held_notes) |> Enum.sort()

          case MCPClientHelper.chord_from_midi_notes(held_list) do
            {:ok, chord_info} ->
              assign(socket, :detected_chord, chord_info)

            {:error, _} ->
              assign(socket, :detected_chord, nil)
          end
        else
          assign(socket, :detected_chord, nil)
        end

      if socket.assigns.lesson_active && socket.assigns.lesson_phase == :active do
        # Use FSM for validation
        fsm = socket.assigns.lesson_state
        
        # TODO: Implement FSM validation
        # For now, convert FSM to LessonEngine for backward compatibility
        lesson_state = %MusicIan.Practice.LessonEngine{
          lesson_id: fsm.lesson_id,
          lesson: fsm.lesson,
          phase: fsm.current_state,
          step_index: fsm.step_index,
          stats: fsm.stats,
          feedback: fsm.feedback,
          completed?: false,
          step_analysis: fsm.step_analysis
        }

        # Convert held_notes MapSet to List for validation
        held_list = MapSet.to_list(held_notes)

        # We pass 'midi' as the latest note played to detect immediate errors + TIMING INFO
        case MusicIan.Practice.LessonEngine.validate_step(
               lesson_state,
               held_list,
               midi,
               timing_info
             ) do
            {:continue, new_state} ->
              # === FIX: Update FSM (not LessonEngine) for continued practice ===
              updated_fsm = %{fsm | 
                step_index: new_state.step_index,
                stats: new_state.stats,
                feedback: new_state.feedback,
                step_analysis: new_state.step_analysis
              }
              
              {:noreply,
               socket
               |> assign(:current_step_index, new_state.step_index)
               |> assign(:lesson_stats, new_state.stats)
               |> assign(:lesson_feedback, new_state.feedback)
               |> assign(:held_notes, MapSet.new())
               # IMPORTANT: Keep FSM as the source of truth
               |> assign(:lesson_state, updated_fsm)}

            {:completed, new_state} ->
               # === FSM TRANSITION: active → summary ===
               fsm = socket.assigns.lesson_state
               case MusicIan.Practice.FSM.LessonFSM.transition_to_summary(fsm) do
                 {:ok, new_fsm} ->
                   # === NEW: Save to DB with step-by-step analysis ===
                   # Includes: stats, timing analysis, note accuracy, etc.
                   MusicIan.Practice.Helper.LessonHelper.save_lesson_completion(
                     new_state.lesson_id,
                     new_state.stats,
                     new_state.step_analysis
                   )

                   # Update FSM with completed stats
                   updated_fsm = %{new_fsm | 
                     stats: new_state.stats,
                     step_analysis: new_state.step_analysis,
                     feedback: new_state.feedback
                   }

                   # === METRONOME: Deactivate when practice completes ===
                   {:noreply,
                    socket
                    |> assign(:lesson_state, updated_fsm)
                    |> assign(:lesson_phase, :summary)
                    |> assign(:current_step_index, new_state.step_index)
                    |> assign(:lesson_stats, new_state.stats)
                    |> assign(:lesson_feedback, new_state.feedback)
                    |> assign(:held_notes, MapSet.new())
                    |> assign(:metronome_active, false)
                    |> push_event("toggle_metronome", %{active: false, bpm: socket.assigns.tempo})}

                 {:error, _} ->
                   {:noreply, socket}
               end

           {:error, new_state} ->
             # === Update FSM with error state ===
             updated_fsm = %{fsm | 
               stats: new_state.stats,
               feedback: new_state.feedback,
               step_analysis: new_state.step_analysis
             }
             
             {:noreply,
              socket
              |> assign(:lesson_stats, new_state.stats)
              |> assign(:lesson_feedback, new_state.feedback)
              # Keep FSM as source of truth
              |> assign(:lesson_state, updated_fsm)}

          {:ignore, _} ->
            {:noreply, socket}
        end
      else
        {:noreply, socket}
      end
    end
  end

  def handle_event("midi_note_off", %{"midi" => midi}, socket) do
    # Remove from held notes
    held_notes = MapSet.delete(socket.assigns[:held_notes] || MapSet.new(), midi)
    {:noreply, assign(socket, :held_notes, held_notes)}
  end

  defp handle_c8_action(socket) do
    state = socket.assigns.lesson_state

    # Global C8 action when no lesson is active
     if !socket.assigns.lesson_active do
       # Start first lesson dynamically
       first_lesson = List.first(MusicIan.Curriculum.list_lessons())

       if first_lesson do
         case MusicIan.Practice.FSM.LessonFSM.new(first_lesson.id) do
           {:ok, fsm_state} ->
             {:noreply,
              socket
              |> assign(:show_lessons_menu, false)
              |> assign(:show_help, false)
              |> assign_fsm_state(fsm_state)}

           _ ->
             {:noreply, socket}
         end
       else
         {:noreply, socket}
       end
    else
      # Context-aware actions based on FSM state
      case state.current_state do
        :intro ->
          # From intro, C8 starts practice countdown
          case MusicIan.Practice.FSM.LessonFSM.transition_to_countdown(state) do
            {:ok, new_fsm} ->
              {:noreply, assign(socket, :lesson_state, new_fsm)}

            _ ->
              {:noreply, socket}
          end

        :demo ->
          # If in demo phase, pressing C8 starts practice
          case MusicIan.Practice.FSM.LessonFSM.transition_to_countdown(state) do
            {:ok, new_fsm} ->
              {:noreply, assign(socket, :lesson_state, new_fsm)}

            _ ->
              {:noreply, socket}
          end

        :active ->
          # If in active phase, pressing C8 does nothing
          # (practice is ongoing, don't interrupt)
          {:noreply, socket}

        :summary ->
          # Check if passed (80% accuracy)
          correct = state.stats.correct || 0
          errors = state.stats.errors || 0
          total = correct + errors
          accuracy = if total > 0, do: correct / total, else: 0.0

           if accuracy >= 0.8 do
             # Passed -> Next Lesson
             next_id = MusicIan.Curriculum.get_next_lesson_id(state.lesson_id)

             if next_id do
               case MusicIan.Practice.FSM.LessonFSM.new(next_id) do
                 {:ok, next_fsm} ->
                   {:noreply, assign_fsm_state(socket, next_fsm)}

                 _ ->
                   {:noreply, socket}
               end
             else
               # Finished course
               {:noreply,
                socket
                |> assign(:lesson_state, nil)
                |> assign(:lesson_active, false)
                |> put_flash(:info, "¡Has completado todo el curso!")}
             end
           else
             # Failed -> Retry: reset to intro for same lesson
             case MusicIan.Practice.FSM.LessonFSM.new(state.lesson_id) do
               {:ok, retry_fsm} ->
                 {:noreply, assign_fsm_state(socket, retry_fsm)}

               _ ->
                 {:noreply, socket}
             end
           end

        _ ->
          {:noreply, socket}
      end
    end
  end

  defp start_lesson_state(socket, lesson) do
    # Deprecated - remove
    socket
  end

  def handle_event("midi_note_off", %{"midi" => _midi}, socket) do
    # For now we don't do anything specific on note off for visualization
    # The highlight removes itself after a timeout in the hook
    {:noreply, socket}
  end

  # Removed validate_lesson_step as it is now replaced by LessonEngine logic

   # === COUNTDOWN TIMER FOR PRACTICE START ===
   # Countdown: 10 → 0 seconds
   # Metronome is already active (started in begin_practice)
   # At 3,2,1: show "Listo, Set, ¡Vamos!" with beeps
     def handle_info(:countdown_tick, socket) do
       countdown = socket.assigns[:countdown] || 0
       fsm = socket.assigns.lesson_state

       case MusicIan.Practice.FSM.LessonFSM.handle_countdown_tick(fsm) do
         {:countdown_tick_10, new_fsm} ->
           # COUNTDOWN TICK 10: Activate metronome
           metronome_enabled = Map.get(new_fsm.lesson, :metronome, false)
           
           Process.send_after(self(), :countdown_tick, 1000)
          {:noreply,
           socket
           |> assign(:lesson_state, new_fsm)
           |> assign(:countdown, 9)
           |> assign(:countdown_stage, :counting)
           |> assign(:metronome_active, metronome_enabled)
           |> push_event("toggle_metronome", %{active: metronome_enabled, bpm: socket.assigns.tempo})}

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
          tempo = socket.assigns.tempo

          {:noreply,
           socket
           |> assign(:lesson_state, new_fsm)
           |> assign(:lesson_phase, :active)
           |> assign(:countdown, 0)
           |> assign(:countdown_stage, nil)
           |> assign(:metronome_active, true)
           |> push_event("lesson_started", %{
             steps: steps,
             tempo: tempo,
             metronome_active: true
           })}

        {:error, _} ->
          {:noreply, socket}
      end
    end

  defp update_active_notes(socket) do
    if socket.assigns.lesson_active do
      # --- LESSON MODE ---
      # Show the full melody/score (Sequence of steps)
      vexflow_notes =
        Enum.map(socket.assigns.current_lesson.steps, fn step ->
          midis = step[:notes] || [step[:note]]
          midis = List.wrap(midis) |> Enum.reject(&is_nil/1)

          notes_info =
            Enum.map(midis, fn midi ->
              n = MusicIan.MusicCore.Note.new(midi)
              {base, acc} = MusicIan.MusicCore.Theory.parse_note_name(n.name)
              acc = if acc != "", do: acc, else: nil

              %{
                key: "#{String.downcase(base)}/#{n.octave}",
                accidental: acc,
                midi: midi,
                clef: if(midi >= 60, do: "treble", else: "bass")
              }
            end)

          # Map duration to VexFlow codes
          dur_val = step[:duration] || 1

          duration_char =
            case dur_val do
              4 -> "w"
              2 -> "h"
              1 -> "q"
              0.5 -> "8"
              _ -> "q"
            end

          %{
            notes: notes_info,
            duration: duration_char
          }
        end)

      # For keyboard highlights, we still want the set of all used notes
      lesson_midis =
        socket.assigns.current_lesson.steps
        |> Enum.flat_map(fn step -> step[:notes] || [step[:note]] end)
        |> Enum.reject(&is_nil/1)
        |> Enum.uniq()
        |> Enum.sort()

      socket
      |> assign(:active_notes, lesson_midis)
      |> assign(:vexflow_notes, vexflow_notes)
      # Default to C for lessons
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
    else
      # --- EXPLORER MODE ---
      root = socket.assigns.root_note
      type = socket.assigns.scale_type

      # Determine if we should use flats based on the root note
      use_flats = rem(root, 12) in [5, 10, 3, 8, 1, 6]
      opts = [use_flats: use_flats]

      # Generate Right Hand Scale (Standard)
      scale_right = MusicCore.get_scale(root, type, opts)

      # Generate Left Hand Scale if needed
      scale_notes =
        if socket.assigns.hands_mode == :double do
          # Calculate left hand root
          right_octave = socket.assigns.right_octave
          left_octave = socket.assigns.left_octave

          # Calculate pitch class
          pitch_class = rem(root, 12)
          left_root = (left_octave + 1) * 12 + pitch_class

          scale_left = MusicCore.get_scale(left_root, type, opts)

          # Combine notes, removing duplicates if any (though octaves differ)
          scale_left.notes ++ scale_right.notes
        else
          scale_right.notes
        end

      # Map MIDI numbers for the keyboard
      active_midis = Enum.map(scale_notes, & &1.midi)

      # Determine Key Signature for VexFlow
      vexflow_key = MusicIan.MusicCore.Theory.determine_key_signature(root, type, opts)

      # Helper to get accidentals in a standard key signature
      key_accidentals = MusicIan.MusicCore.Theory.get_key_signature_accidentals(vexflow_key)

      # Map notes for VexFlow (JSON) with explicit accidental logic
      vexflow_notes =
        Enum.map(scale_notes, fn n ->
          # Determine if we need to show an accidental
          # 1. Extract the note base (e.g. "F") and accidental (e.g. "#", "b", or "")
          {base, acc} = MusicIan.MusicCore.Theory.parse_note_name(n.name)

          # 2. Check what the key signature expects for this base note
          expected_acc = Map.get(key_accidentals, base, "")

          # 3. If they differ, we need an explicit accidental
          # If they are the same, we send nil (VexFlow follows key sig)
          # Exception: If note is natural ("") but key expects something else, we send "n" (natural)

          vexflow_accidental =
            cond do
              acc == expected_acc -> nil
              acc == "" and expected_acc != "" -> "n"
              true -> acc
            end

          # Wrap in the new structure expected by JS
          %{
            notes: [
              %{
                key: "#{String.downcase(base)}/#{n.octave}",
                accidental: vexflow_accidental,
                midi: n.midi,
                clef: if(n.midi >= 60, do: "treble", else: "bass")
              }
            ],
            duration: "q"
          }
        end)

      # Add the octave note (root + 12) to complete the scale visually
      # Only if it's a standard 7-note scale (major/minor/modes)
      vexflow_notes =
        if length(scale_notes) == 7 do
          first_note = List.first(scale_notes)
          octave_midi = first_note.midi + 12
          octave_note = MusicIan.MusicCore.Note.new(octave_midi, opts)

          {base, acc} = MusicIan.MusicCore.Theory.parse_note_name(octave_note.name)
          expected_acc = Map.get(key_accidentals, base, "")

          vexflow_accidental =
            cond do
              acc == expected_acc -> nil
              acc == "" and expected_acc != "" -> "n"
              true -> acc
            end

          octave_struct = %{
            notes: [
              %{
                key: "#{String.downcase(base)}/#{octave_note.octave}",
                accidental: vexflow_accidental,
                midi: octave_note.midi,
                clef: if(octave_note.midi >= 60, do: "treble", else: "bass")
              }
            ],
            duration: "q"
          }

          vexflow_notes ++ [octave_struct]
        else
          vexflow_notes
        end

      # Generate Contextual Theory Text
      theory_context =
        MusicIan.MusicCore.Theory.analyze_context(root, type, scale_right.notes, use_flats)

       socket
       |> assign(:active_notes, active_midis)
       |> assign(:vexflow_notes, vexflow_notes)
       |> assign(:vexflow_key, vexflow_key)
       |> assign(:scale_info, %{description: scale_right.description, mood: scale_right.mood})
       |> assign(:suggested_keys, scale_right.suggested_keys)
       |> assign(:suggestion_reason, scale_right.suggestion_reason)
       |> assign(:theory_context, theory_context)
       |> assign(:note_explanations, scale_right.note_explanations)
    end
  end

  defp circle_of_fifths_data do
    MusicIan.MusicCore.Theory.generate_circle_of_fifths()
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
            <button
              phx-click="toggle_lessons_menu"
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
              <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                stroke-width="2"
                stroke="currentColor"
                class="w-3 h-3 ml-1"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  d="M19.5 8.25l-7.5 7.5-7.5-7.5"
                />
              </svg>
            </button>

            <%= if @show_lessons_menu do %>
              <div class="absolute top-full left-0 mt-2 w-80 bg-white rounded-lg shadow-xl border border-slate-200 z-50 overflow-hidden">
                <div class="bg-slate-50 px-4 py-2 border-b border-slate-100 text-xs font-bold text-slate-500 uppercase tracking-wider">
                  Selecciona una Lección
                </div>
                <div class="max-h-96 overflow-y-auto">
                  <%= for lesson <- MusicIan.Curriculum.list_lessons() do %>
                    <button
                      phx-click="start_lesson"
                      phx-value-id={lesson.id}
                      class="w-full text-left px-4 py-3 hover:bg-emerald-50 transition-colors border-b border-slate-50 last:border-0 group"
                    >
                      <div class="font-bold text-slate-800 group-hover:text-emerald-700">
                        {lesson.title}
                      </div>
                      <div class="text-xs text-slate-500 mt-0.5">{lesson.description}</div>
                    </button>
                  <% end %>
                </div>
              </div>
              <!-- Click outside overlay -->
              <div class="fixed inset-0 z-40" phx-click="toggle_lessons_menu"></div>
            <% end %>
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
          <div class="absolute inset-0 z-50 bg-slate-900/60 backdrop-blur-sm flex items-center justify-center p-4">
            <div class="bg-white rounded-xl shadow-2xl max-w-lg w-full overflow-hidden animate-fade-in-up">
              <div class="bg-emerald-600 p-6 text-white">
                <h2 class="text-2xl font-bold mb-2">{@current_lesson.title}</h2>
                <div class="h-1 w-12 bg-emerald-400 rounded"></div>
              </div>
              <div class="p-8">
                <p class="text-slate-600 text-lg leading-relaxed mb-8">
                  {@current_lesson[:intro] || @current_lesson.description}
                </p>

                <div class="flex justify-end gap-3">
                  <button
                    phx-click="stop_lesson"
                    class="px-4 py-2 text-slate-500 hover:text-slate-700 font-medium transition-colors"
                  >
                    Cancelar
                  </button>
                  <button
                    phx-click="start_demo"
                    class="px-4 py-2 bg-blue-100 text-blue-700 hover:bg-blue-200 font-medium rounded-lg transition-colors flex items-center gap-2"
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
                        d="M5.25 5.653c0-.856.917-1.398 1.667-.986l11.54 6.348a1.125 1.125 0 010 1.971l-11.54 6.347a1.125 1.125 0 01-1.667-.985V5.653z"
                      />
                    </svg>
                    Ver Demo
                  </button>
                  <button
                    phx-click="begin_practice"
                    class="px-6 py-2 bg-emerald-600 hover:bg-emerald-500 text-white font-bold rounded-lg shadow-lg shadow-emerald-200 transition-all transform hover:-translate-y-0.5"
                  >
                    Comenzar Práctica
                  </button>
                </div>
              </div>
            </div>
          </div>
        <% end %>
        
    <!-- Demo Overlay -->
        <%= if @lesson_active && @lesson_phase == :demo do %>
          <div class="absolute top-20 left-1/2 -translate-x-1/2 z-40 bg-blue-600 text-white px-6 py-3 rounded-full shadow-xl flex items-center gap-4 animate-pulse">
            <span class="font-bold flex items-center gap-2">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                stroke-width="2"
                stroke="currentColor"
                class="w-5 h-5"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  d="M5.25 5.653c0-.856.917-1.398 1.667-.986l11.54 6.348a1.125 1.125 0 010 1.971l-11.54 6.347a1.125 1.125 0 01-1.667-.985V5.653z"
                />
              </svg>
              Reproduciendo Demostración...
            </span>
            <button
              phx-click="stop_demo"
              class="bg-white/20 hover:bg-white/30 rounded-full p-1 transition-colors"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                stroke-width="2"
                stroke="currentColor"
                class="w-4 h-4"
              >
                <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>
        <% end %>
        
     <!-- Countdown Timer Modal -->
          <%= if @lesson_active && @lesson_phase == :countdown do %>
             <% 
               # Countdown: 10 → 0 seconds
               # Stage 1 (counting): 10 → 4 - show number
               # Stage 2 (final): 3 → 1 - show "Listo, Set, ¡Vamos!"
               show_counting = @countdown_stage == :counting
               show_final = @countdown_stage == :final
               
               # Map countdown to Spanish words for final stage
               final_words = %{
                 3 => "Listo",
                 2 => "Set",
                 1 => "¡Vamos!"
               }
               final_display = Map.get(final_words, @countdown, "")
             %>
             <div class="absolute inset-0 z-50 bg-slate-900/60 backdrop-blur-sm flex items-center justify-center">
               <div class="bg-white rounded-2xl shadow-2xl p-12 max-w-md w-full text-center">
                 <%= if show_counting do %>
                   <!-- Counting phase: 10 → 4 seconds -->
                   <p class="text-slate-600 text-xl mb-4 font-semibold">Metrónomo Activo</p>
                   <div class="text-8xl font-black text-blue-600 animate-pulse mb-6">
                     <%= @countdown %>
                   </div>
                   <p class="text-slate-500 text-sm">
                     Escucha el metrónomo y adapta tu ritmo
                   </p>
                 <% else %>
                   <!-- Final countdown: "Listo, Set, ¡Vamos!" (3 → 1) -->
                   <div class="text-7xl font-black text-green-600 animate-pulse">
                     <%= final_display %>
                   </div>
                 <% end %>
               </div>
             </div>
            <% end %>
         
      <!-- Post-Demo Confirmation Modal -->
          <%= if @lesson_active && @lesson_phase == :post_demo do %>
            <div class="absolute inset-0 z-50 bg-slate-900/60 backdrop-blur-sm flex items-center justify-center">
              <div class="bg-white rounded-2xl shadow-2xl p-8 max-w-md w-full text-center">
                <h2 class="text-2xl font-bold text-slate-800 mb-2">Demostración Completada</h2>
                <p class="text-slate-600 text-base mb-6">
                  ¿Deseas ver la demostración de nuevo o comenzar a practicar?
                </p>
                
                <!-- Two Action Buttons -->
                <div class="space-y-3">
                   <button
                     phx-click="start_demo"
                     class="bg-blue-500 hover:bg-blue-600 text-white font-bold py-3 px-6 rounded-lg transition-colors w-full flex items-center justify-center gap-2"
                   >
                     <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-5 h-5">
                       <path stroke-linecap="round" stroke-linejoin="round" d="M5.25 5.653c0-.856.917-1.398 1.667-.986l11.54 6.348a1.125 1.125 0 010 1.971l-11.54 6.347a1.125 1.125 0 01-1.667-.985V5.653z" />
                     </svg>
                     Ver Demo de Nuevo
                   </button>
                  
                  <button
                    phx-click="begin_practice"
                    class="bg-emerald-500 hover:bg-emerald-600 text-white font-bold py-3 px-6 rounded-lg transition-colors w-full flex items-center justify-center gap-2"
                  >
                    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-5 h-5">
                      <path stroke-linecap="round" stroke-linejoin="round" d="M13.5 6H5.25A2.25 2.25 0 003 8.25v10.5A2.25 2.25 0 005.25 21h10.5A2.25 2.25 0 0018 18.75V10.5m-10.5 6L21 3m0 0h-5.25M21 3v5.25" />
                    </svg>
                    Comenzar Práctica
                  </button>
                </div>
              </div>
            </div>
          <% end %>
         
     <!-- Lesson Overlay (Floating) - MOVED BELOW KEYBOARD -->


         <!-- Lesson Completion Modal -->
        <%= if @lesson_active && @lesson_phase == :summary do %>
          <% total = @lesson_stats.correct + @lesson_stats.errors
          accuracy = if total > 0, do: @lesson_stats.correct / total * 100, else: 0
          passed = accuracy >= 80
          next_lesson_id = MusicIan.Curriculum.get_next_lesson_id(@current_lesson.id) %>
          <div class="absolute inset-0 z-50 bg-slate-900/50 backdrop-blur-sm flex items-center justify-center">
            <div class="bg-white rounded-xl shadow-2xl p-8 max-w-md w-full text-center animate-fade-in-up">
              <div class={"w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4 " <> if(passed, do: "bg-emerald-100 text-emerald-600", else: "bg-red-100 text-red-500")}>
                <%= if passed do %>
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    fill="none"
                    viewBox="0 0 24 24"
                    stroke-width="2"
                    stroke="currentColor"
                    class="w-8 h-8"
                  >
                    <path stroke-linecap="round" stroke-linejoin="round" d="M4.5 12.75l6 6 9-13.5" />
                  </svg>
                <% else %>
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    fill="none"
                    viewBox="0 0 24 24"
                    stroke-width="2"
                    stroke="currentColor"
                    class="w-8 h-8"
                  >
                    <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
                  </svg>
                <% end %>
              </div>

              <h2 class="text-2xl font-bold text-slate-800 mb-2">
                {if passed, do: "¡Lección Completada!", else: "Inténtalo de nuevo"}
              </h2>
              <p class="text-slate-500 mb-6">
                Has finalizado <span class="font-medium text-slate-700">{@current_lesson.title}</span>
                con una precisión del <span class={"font-bold " <> if(passed, do: "text-emerald-600", else: "text-red-500")}><%= round(accuracy) %>%</span>.
              </p>

              <div class="grid grid-cols-2 gap-4 mb-6">
                <div class="bg-slate-50 p-3 rounded border border-slate-100">
                  <div class="text-2xl font-bold text-emerald-600">{@lesson_stats.correct}</div>
                  <div class="text-xs text-slate-400 uppercase font-bold">Aciertos</div>
                </div>
                <div class="bg-slate-50 p-3 rounded border border-slate-100">
                  <div class="text-2xl font-bold text-red-500">{@lesson_stats.errors}</div>
                  <div class="text-xs text-slate-400 uppercase font-bold">Errores</div>
                </div>
              </div>

              <div class="flex flex-col gap-3">
                <%= if next_lesson_id do %>
                  <button
                    phx-click="start_lesson"
                    phx-value-id={next_lesson_id}
                    class={"w-full py-3 font-bold rounded-lg transition-colors shadow-lg " <> if(passed, do: "bg-emerald-600 hover:bg-emerald-500 text-white shadow-emerald-200", else: "bg-slate-200 text-slate-400 cursor-not-allowed")}
                    disabled={!passed}
                  >
                    {if passed,
                      do: "Siguiente Lección (Do8)",
                      else: "Siguiente Lección (Bloqueado - Requiere 80%)"}
                  </button>
                <% end %>

                <button
                  phx-click="start_lesson"
                  phx-value-id={@current_lesson.id}
                  class={"w-full py-3 font-bold rounded-lg transition-colors " <> if(!passed, do: "bg-slate-800 text-white hover:bg-slate-700", else: "bg-slate-100 text-slate-600 hover:bg-slate-200")}
                >
                  Repetir Lección {if !passed, do: "(Do8)"}
                </button>

                <button
                  phx-click="stop_lesson"
                  class="text-sm text-slate-400 hover:text-slate-600 underline"
                >
                  Volver al menú
                </button>
              </div>
            </div>
          </div>
        <% end %>

        <div class="grid grid-cols-12 gap-4 h-full">
          <!-- LEFT: Configuration (20%) -->
          <div class="col-span-12 lg:col-span-2 flex flex-col gap-4 h-full overflow-hidden">
            <CircleOfFifths.circle_of_fifths
              root_note={@root_note}
              suggested_keys={@suggested_keys}
              theory_context={@theory_context}
              circle_data={circle_of_fifths_data()}
              suggestion_reason={@suggestion_reason}
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
          
    <!-- CENTER: Visualization (50%) -->
          <div class="col-span-12 lg:col-span-7 flex flex-col gap-4 h-full">
             <div class="h-2/5">
              <Staff.music_staff
                vexflow_notes={@vexflow_notes}
                vexflow_key={@vexflow_key}
                theory_context={@theory_context}
                current_step_index={@current_step_index}
                lesson_active={@lesson_active}
                note_explanations={@note_explanations || []}
              />
            </div>
            <div class="h-3/5 flex flex-col gap-4">
              <Keyboard.virtual_keyboard
                root_note={@root_note}
                active_notes={@active_notes}
                lesson_active={@lesson_active}
                lesson_phase={@lesson_phase}
                current_lesson={@current_lesson}
                current_step_index={@current_step_index}
                virtual_velocity={@virtual_velocity}
              />
              
    <!-- Lesson Step Indicator (Moved here) -->
              <%= if @lesson_active && @lesson_phase == :active do %>
                <% current_step = Enum.at(@current_lesson.steps, @current_step_index) %>
                <div class={"w-full bg-white border shadow-sm rounded-lg p-4 flex items-center gap-4 transition-all " <>
                  case @lesson_feedback do
                    %{status: :success} -> "border-emerald-500 ring-2 ring-emerald-100"
                    %{status: :error} -> "border-red-500 ring-2 ring-red-100"
                    _ -> "border-blue-500"
                  end
                }>
                  <div class="flex-grow">
                    <div class="flex justify-between text-xs text-slate-400 mb-1 uppercase font-bold tracking-wider">
                      <span>Paso {@current_step_index + 1} de {length(@current_lesson.steps)}</span>
                      <span>
                        {if @lesson_feedback, do: @lesson_feedback.message, else: "En espera..."}
                      </span>
                    </div>
                    <h2 class="text-lg font-bold text-slate-800">{current_step.text}</h2>
                    <p class="text-sm text-slate-500">{current_step.hint}</p>
                  </div>
                  
    <!-- Mini Progress Circle -->
                  <div class="relative w-12 h-12 flex items-center justify-center shrink-0">
                    <svg class="w-full h-full transform -rotate-90">
                      <circle cx="24" cy="24" r="20" stroke="#f1f5f9" stroke-width="4" fill="none" />
                      <circle
                        cx="24"
                        cy="24"
                        r="20"
                        stroke="#3b82f6"
                        stroke-width="4"
                        fill="none"
                        stroke-dasharray="125.6"
                        stroke-dashoffset={
                          125.6 - 125.6 * (@current_step_index / length(@current_lesson.steps))
                        }
                        class="transition-all duration-500 ease-out"
                      />
                    </svg>
                  </div>
                </div>
              <% end %>
            </div>
          </div>
          
    <!-- RIGHT: Analysis (30%) -->
          <div class="col-span-12 lg:col-span-3 h-full">
            <TheoryPanel.theory_panel
              root_note={@root_note}
              scale_type={@scale_type}
              scale_info={@scale_info}
              theory_context={@theory_context}
            />
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
