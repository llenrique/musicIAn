defmodule MusicIanWeb.Components.Music.Keyboard do
  use Phoenix.Component
  alias MusicIan.MusicCore.Note

  alias Phoenix.LiveView.JS

  attr :root_note, :integer, required: true
  attr :active_notes, :list, required: true
  attr :lesson_active, :boolean, default: false
  attr :lesson_phase, :atom, default: nil
  attr :current_lesson, :map, default: nil
  attr :current_step_index, :integer, default: 0
  attr :virtual_velocity, :integer, default: 100

  def virtual_keyboard(assigns) do
    ~H"""
    <div class="w-full bg-white rounded-lg shadow-sm border border-slate-200 overflow-hidden flex flex-col h-full">
      <div class="bg-slate-50 px-4 py-2 border-b border-slate-200 flex justify-between items-center shrink-0">
        <span class="text-xs font-bold text-slate-500 uppercase tracking-wider">Teclado Interactivo</span>
        <span class="text-[10px] text-slate-400">C3 - C6</span>
      </div>

      <div class="relative flex-grow select-none w-full flex justify-center items-center overflow-hidden bg-slate-100">
        <div class="relative h-40" style="width: 1008px; transform: scale(0.9); transform-origin: center center;">
        <%
          # Pre-calculate target notes and finger for the current lesson step
          current_step = if @lesson_active and (@lesson_phase == :active or @lesson_phase == :demo) and @current_step_index < length(@current_lesson.steps), do: Enum.at(@current_lesson.steps, @current_step_index), else: nil

          target_notes = if current_step do
            Map.get(current_step, :notes) || [Map.get(current_step, :note)]
          else
            []
          end
          |> List.wrap()
          |> List.flatten()
          |> Enum.reject(&is_nil/1)

          # Create a map of midi -> finger
          finger_map = if current_step do
             notes = Map.get(current_step, :notes) || [Map.get(current_step, :note)]
             fingers = Map.get(current_step, :fingers) || [Map.get(current_step, :finger)]

             if notes && fingers do
                fingers_list = List.wrap(fingers) |> List.flatten()
                notes_list = List.wrap(notes) |> List.flatten()

                if length(fingers_list) == 1 and length(notes_list) > 1 do
                   val = List.first(fingers_list)
                   Map.new(notes_list, fn n -> {n, val} end)
                else
                   Enum.zip(notes_list, fingers_list) |> Map.new()
                end
             else
                %{}
             end
          else
             %{}
          end
        %>
        <%= for octave <- 0..2 do %>
          <%= for i <- 0..11 do %>
            <%
              base_note = 48
              midi = base_note + (octave * 12) + i
              is_black = i in [1, 3, 6, 8, 10]
              is_active = midi in @active_notes
              is_root = rem(midi, 12) == rem(@root_note, 12)
              is_target = midi in target_notes
              target_finger = Map.get(finger_map, midi)

              white_key_index = case i do
                0 -> 0; 2 -> 1; 4 -> 2; 5 -> 3; 7 -> 4; 9 -> 5; 11 -> 6
                _ -> nil
              end
            %>

            <!-- White Keys -->
            <%= if !is_black do %>
              <div
                id={"key-#{midi}"}
                phx-mousedown={JS.dispatch("local-midi-note", detail: %{midi: midi, velocity: @virtual_velocity, isOn: true, source: "virtual-keyboard"}) |> JS.push("midi_note_on", value: %{midi: midi, velocity: @virtual_velocity})}
                phx-mouseup={JS.dispatch("local-midi-note", detail: %{midi: midi, velocity: 0, isOn: false, source: "virtual-keyboard"}) |> JS.push("midi_note_off", value: %{midi: midi})}
                phx-mouseleave={JS.dispatch("local-midi-note", detail: %{midi: midi, velocity: 0, isOn: false, source: "virtual-keyboard"}) |> JS.push("midi_note_off", value: %{midi: midi})}
                class={"absolute top-0 w-12 h-40 border-r border-b border-slate-300 rounded-b-md transition-colors duration-75 cursor-pointer z-0 " <>
                  if(is_target,
                    do: "bg-blue-200 hover:bg-blue-300",
                    else: if(is_active,
                      do: if(is_root, do: "bg-purple-200 hover:bg-purple-300", else: "bg-emerald-100 hover:bg-emerald-200"),
                      else: "bg-white hover:bg-slate-50")
                  )
                }
                style={"left: #{(octave * 7 + white_key_index) * 3}rem;"}
              >
                <!-- Finger Indicator -->
                <%= if is_target and target_finger do %>
                  <div class="absolute bottom-8 left-1/2 -translate-x-1/2 w-6 h-6 bg-blue-600 text-white rounded-full flex items-center justify-center text-xs font-bold shadow-md animate-bounce z-20">
                    <%= target_finger %>
                  </div>
                <% end %>

                <div class={"absolute bottom-3 left-1/2 -translate-x-1/2 text-xs font-bold " <>
                  if(is_active, do: "text-slate-700", else: "text-slate-300")
                }>
                  <%= Note.new(midi, use_flats: rem(@root_note, 12) in [5, 10, 3, 8, 1, 6]).name %>
                </div>
              </div>
            <% end %>
          <% end %>
        <% end %>

        <!-- Black Keys -->
        <%= for octave <- 0..2 do %>
          <%= for i <- 0..11 do %>
            <%
              base_note = 48
              midi = base_note + (octave * 12) + i
              is_black = i in [1, 3, 6, 8, 10]
              is_active = midi in @active_notes
              is_root = rem(midi, 12) == rem(@root_note, 12)
              is_target = midi in target_notes
              target_finger = Map.get(finger_map, midi)

              black_key_left = case i do
                1 -> 1; 3 -> 2; 6 -> 4; 8 -> 5; 10 -> 6
                _ -> nil
              end
            %>

            <%= if is_black do %>
              <div
                id={"key-#{midi}"}
                phx-mousedown={JS.dispatch("local-midi-note", detail: %{midi: midi, velocity: @virtual_velocity, isOn: true, source: "virtual-keyboard"}) |> JS.push("midi_note_on", value: %{midi: midi, velocity: @virtual_velocity})}
                phx-mouseup={JS.dispatch("local-midi-note", detail: %{midi: midi, velocity: 0, isOn: false, source: "virtual-keyboard"}) |> JS.push("midi_note_off", value: %{midi: midi})}
                phx-mouseleave={JS.dispatch("local-midi-note", detail: %{midi: midi, velocity: 0, isOn: false, source: "virtual-keyboard"}) |> JS.push("midi_note_off", value: %{midi: midi})}
                class={"absolute top-0 w-8 h-24 border-x border-b border-slate-800 rounded-b-md z-10 transition-colors duration-75 cursor-pointer " <>
                  if(is_target,
                    do: "bg-blue-600",
                    else: if(is_active,
                      do: if(is_root, do: "bg-purple-600", else: "bg-emerald-600"),
                      else: "bg-slate-800 hover:bg-slate-700")
                  )
                }
                style={"left: calc(#{(octave * 7 + black_key_left) * 3}rem - 1rem);"}
              >
                <!-- Finger Indicator (Black Keys) -->
                <%= if is_target and target_finger do %>
                  <div class="absolute bottom-4 left-1/2 -translate-x-1/2 w-5 h-5 bg-white text-blue-600 rounded-full flex items-center justify-center text-[10px] font-bold shadow-md animate-bounce z-30">
                    <%= target_finger %>
                  </div>
                <% end %>
              </div>
            <% end %>
          <% end %>
        <% end %>
        </div>
      </div>
    </div>
    """
  end
end
