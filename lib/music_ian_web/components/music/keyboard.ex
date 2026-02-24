defmodule MusicIanWeb.Components.Music.Keyboard do
  @moduledoc """
  Piano de 88 teclas (A0-C8) que ocupa todo el ancho del contenedor.
  """
  use Phoenix.Component
  alias Phoenix.LiveView.JS

  @first_midi 21
  @last_midi 108
  @total_white_keys 52

  attr :root_note, :integer, required: true
  attr :active_notes, :list, required: true
  attr :lesson_active, :boolean, default: false
  attr :lesson_phase, :atom, default: nil
  attr :current_lesson, :map, default: nil
  attr :current_step_index, :integer, default: 0
  attr :virtual_velocity, :integer, default: 100
  attr :keyboard_base, :integer, default: 48

  def virtual_keyboard(assigns) do
    active_set = MapSet.new(assigns.active_notes)
    keys = build_keys()
    white_width = 100.0 / @total_white_keys

    current_step =
      if assigns.lesson_active and assigns.lesson_phase in [:active, :demo] and
           assigns.current_lesson &&
           assigns.current_step_index < length(assigns.current_lesson.steps) do
        Enum.at(assigns.current_lesson.steps, assigns.current_step_index)
      else
        nil
      end

    target_notes =
      if current_step do
        (Map.get(current_step, :notes) || [Map.get(current_step, :note)])
        |> List.wrap()
        |> List.flatten()
        |> Enum.reject(&is_nil/1)
      else
        []
      end

    finger_map = build_finger_map(current_step)

    assigns =
      assigns
      |> assign(:active_set, active_set)
      |> assign(:keys, keys)
      |> assign(:white_width, white_width)
      |> assign(:target_notes, target_notes)
      |> assign(:finger_map, finger_map)

    ~H"""
    <div
      class="w-full bg-slate-100 rounded-lg border border-slate-200 overflow-hidden"
      style="height: 140px;"
    >
      <div class="relative w-full h-full">
        <%!-- White Keys --%>
        <%= for key <- Enum.filter(@keys, & &1.type == :white) do %>
          <% midi = key.midi
          is_active = MapSet.member?(@active_set, midi)
          is_root = rem(midi, 12) == rem(@root_note, 12)
          is_target = midi in @target_notes
          finger = Map.get(@finger_map, midi) %>
          <div
            id={"key-#{midi}"}
            phx-mousedown={
              JS.dispatch("local-midi-note",
                detail: %{
                  midi: midi,
                  velocity: @virtual_velocity,
                  isOn: true,
                  source: "virtual-keyboard"
                }
              )
              |> JS.push("midi_note_on", value: %{midi: midi, velocity: @virtual_velocity})
            }
            phx-mouseup={
              JS.dispatch("local-midi-note",
                detail: %{midi: midi, velocity: 0, isOn: false, source: "virtual-keyboard"}
              )
              |> JS.push("midi_note_off", value: %{midi: midi})
            }
            class={"absolute top-0 h-full border-r border-slate-300 rounded-b cursor-pointer transition-colors " <>
              cond do
                is_target -> "bg-blue-200"
                is_active -> if(is_root, do: "bg-purple-100", else: "bg-emerald-100")
                true -> "bg-white hover:bg-slate-50"
              end}
            style={"left: #{key.left}%; width: #{@white_width}%;"}
          >
            <%= if finger do %>
              <div class="absolute bottom-10 left-1/2 -translate-x-1/2 w-5 h-5 bg-blue-600 text-white rounded-full flex items-center justify-center text-[10px] font-bold">
                {finger}
              </div>
            <% end %>
            <%= if rem(midi, 12) == 0 do %>
              <div class="absolute bottom-1 left-1/2 -translate-x-1/2 text-[8px] text-slate-400">
                C{div(midi, 12) - 1}
              </div>
            <% end %>
          </div>
        <% end %>

        <%!-- Black Keys --%>
        <%= for key <- Enum.filter(@keys, & &1.type == :black) do %>
          <% midi = key.midi
          is_active = MapSet.member?(@active_set, midi)
          is_root = rem(midi, 12) == rem(@root_note, 12)
          is_target = midi in @target_notes
          finger = Map.get(@finger_map, midi) %>
          <div
            id={"key-#{midi}"}
            phx-mousedown={
              JS.dispatch("local-midi-note",
                detail: %{
                  midi: midi,
                  velocity: @virtual_velocity,
                  isOn: true,
                  source: "virtual-keyboard"
                }
              )
              |> JS.push("midi_note_on", value: %{midi: midi, velocity: @virtual_velocity})
            }
            phx-mouseup={
              JS.dispatch("local-midi-note",
                detail: %{midi: midi, velocity: 0, isOn: false, source: "virtual-keyboard"}
              )
              |> JS.push("midi_note_off", value: %{midi: midi})
            }
            class={"absolute top-0 h-[60%] border border-slate-900 rounded-b z-10 cursor-pointer transition-colors " <>
              cond do
                is_target -> "bg-blue-600"
                is_active -> if(is_root, do: "bg-purple-700", else: "bg-slate-600")
                true -> "bg-slate-800 hover:bg-slate-700"
              end}
            style={"left: #{key.left}%; width: #{@white_width * 0.6}%;"}
          >
            <%= if finger do %>
              <div class="absolute bottom-2 left-1/2 -translate-x-1/2 w-4 h-4 bg-white text-blue-600 rounded-full flex items-center justify-center text-[8px] font-bold">
                {finger}
              </div>
            <% end %>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  defp build_keys do
    white_width = 100.0 / @total_white_keys
    black_offsets = %{1 => 0.55, 3 => 0.75, 6 => 0.5, 8 => 0.65, 10 => 0.8}

    {keys, _} =
      Enum.reduce(@first_midi..@last_midi, {[], 0}, fn midi, {acc, w_idx} ->
        semitone = rem(midi, 12)
        is_black = semitone in [1, 3, 6, 8, 10]

        if is_black do
          offset = Map.get(black_offsets, semitone, 0.6)
          left = (w_idx - 1 + offset) * white_width
          {[%{midi: midi, type: :black, left: left} | acc], w_idx}
        else
          left = w_idx * white_width
          {[%{midi: midi, type: :white, left: left} | acc], w_idx + 1}
        end
      end)

    Enum.reverse(keys)
  end

  defp build_finger_map(nil), do: %{}

  defp build_finger_map(step) do
    notes = Map.get(step, :notes) || [Map.get(step, :note)]
    fingers = Map.get(step, :fingers) || [Map.get(step, :finger)]

    if notes && fingers do
      notes_list = List.wrap(notes) |> List.flatten()
      fingers_list = List.wrap(fingers) |> List.flatten()

      if length(fingers_list) == 1 and length(notes_list) > 1 do
        val = List.first(fingers_list)
        Map.new(notes_list, fn n -> {n, val} end)
      else
        Enum.zip(notes_list, fingers_list) |> Map.new()
      end
    else
      %{}
    end
  end
end
