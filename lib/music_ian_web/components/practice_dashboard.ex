defmodule MusicIanWeb.Components.PracticeDashboard do
  @moduledoc """
  Real-time practice comparison dashboard.

  Shows side-by-side:
  - LEFT: Expected score (what should be played)
  - RIGHT: Actual input (what user is playing)
  - CENTER: Comparison and feedback

  Updates in real-time as user plays.
  """

  use Phoenix.Component

  @doc """
  Renders the practice dashboard with dual view.

  Assigns:
  - lesson: Current lesson data
  - step_index: Current step number
  - held_notes: MapSet of currently pressed MIDI notes
  - feedback: %{status: atom, message: string}
  - stats: %{correct: int, errors: int}
  """
  def practice_dashboard(assigns) do
    ~H"""
    <div class="grid grid-cols-3 gap-4 p-6 bg-gradient-to-b from-slate-900 to-slate-800 min-h-screen text-white">
      
    <!-- LEFT PANEL: EXPECTED SCORE -->
      <div class="col-span-1 border-2 border-blue-500 rounded-lg p-4 bg-slate-800/50">
        <h2 class="text-lg font-bold text-blue-400 mb-4">📝 PARTITURA</h2>
        
    <!-- Expected notes list -->
        <div class="space-y-2 max-h-96 overflow-y-auto">
          <%= for {step, idx} <- Enum.with_index(@lesson.steps) do %>
            <% step_class =
              cond do
                idx < @step_index -> "bg-green-900/30 border-green-500 opacity-50"
                idx == @step_index -> "bg-blue-900/50 border-blue-400 ring-2 ring-blue-300 scale-105"
                true -> "bg-slate-700 border-slate-600"
              end %>
            <div class={"p-3 rounded-lg border-2 transition-all #{step_class}"}>
              <div class="flex justify-between items-center">
                <span class="font-mono font-bold text-sm">
                  {if idx == @step_index, do: "▶ ", else: ""} Paso {idx + 1}
                </span>
                <span class="text-xs text-slate-400">
                  {step[:duration] || 1} beat
                </span>
              </div>

              <div class="mt-2">
                <p class="text-base font-semibold">
                  {step[:text]}
                </p>
              </div>
              
    <!-- Expected notes display -->
              <div class="mt-2 flex flex-wrap gap-2">
                <%= if step[:notes] do %>
                  <%= for midi <- step[:notes] do %>
                    <span class="bg-blue-600 px-2 py-1 rounded text-xs font-mono">
                      MIDI {midi}
                    </span>
                  <% end %>
                <% else %>
                  <span class="bg-blue-600 px-2 py-1 rounded text-xs font-mono">
                    MIDI {step[:note]}
                  </span>
                <% end %>
              </div>
            </div>
          <% end %>
        </div>
      </div>
      
    <!-- CENTER PANEL: COMPARISON & FEEDBACK -->
      <div class="col-span-1 border-2 border-purple-500 rounded-lg p-4 bg-slate-800/50 flex flex-col justify-between">
        <div>
          <h2 class="text-lg font-bold text-purple-400 mb-4">⚖️ COMPARACIÓN</h2>
          
    <!-- Current step info -->
          <%= if @step_index < length(@lesson.steps) do %>
            <% current_step = Enum.at(@lesson.steps, @step_index) %>

            <div class="bg-slate-700/50 p-4 rounded-lg mb-4">
              <p class="text-sm text-slate-400">Nota esperada:</p>
              <p class="text-xl font-bold text-blue-300 mt-1">
                {current_step[:text]}
              </p>
            </div>
          <% end %>
          
    <!-- Feedback message -->
          <% feedback_class =
            case @feedback[:status] do
              :success -> "bg-green-900/30 border-green-500 text-green-300"
              :error -> "bg-red-900/30 border-red-500 text-red-300"
              _ -> "bg-slate-700/30 border-slate-600 text-slate-300"
            end %>
          <div class={"p-4 rounded-lg border-2 mb-4 min-h-20 flex items-center justify-center #{feedback_class}"}>
            <p class="text-center font-semibold">
              {@feedback[:message] || "Esperando input..."}
            </p>
          </div>
          
    <!-- Timing visual indicator -->
          <div class="bg-slate-700/50 p-3 rounded-lg">
            <p class="text-xs text-slate-400 mb-2">SINCRONIZACIÓN:</p>
            <div class="flex gap-1 items-center">
              <div class="flex-1 bg-slate-600 rounded-full h-2">
                <div class="bg-gradient-to-r from-red-500 via-green-500 to-red-500 h-2 rounded-full w-1/3">
                </div>
              </div>
              <span class="text-xs text-slate-300">On-time</span>
            </div>
          </div>
        </div>
        
    <!-- Stats -->
        <div class="grid grid-cols-2 gap-2 mt-auto pt-4 border-t border-slate-600">
          <div class="bg-green-900/30 border border-green-500 rounded p-3 text-center">
            <p class="text-xs text-slate-400">Correctas</p>
            <p class="text-2xl font-bold text-green-400">{@stats.correct}</p>
          </div>
          <div class="bg-red-900/30 border border-red-500 rounded p-3 text-center">
            <p class="text-xs text-slate-400">Errores</p>
            <p class="text-2xl font-bold text-red-400">{@stats.errors}</p>
          </div>
        </div>
      </div>
      
    <!-- RIGHT PANEL: ACTUAL INPUT -->
      <div class="col-span-1 border-2 border-green-500 rounded-lg p-4 bg-slate-800/50">
        <h2 class="text-lg font-bold text-green-400 mb-4">🎹 TU INPUT</h2>
        
    <!-- Currently held notes -->
        <div class="mb-4">
          <p class="text-sm text-slate-400 mb-2">Notas presionadas:</p>
          <%= if MapSet.size(@held_notes) > 0 do %>
            <div class="flex flex-wrap gap-2">
              <%= for midi <- @held_notes |> MapSet.to_list() |> Enum.sort() do %>
                <div class="bg-green-600 px-3 py-2 rounded-lg font-mono font-bold">
                  <div class="text-sm">MIDI {midi}</div>
                  <div class="text-xs text-slate-200">
                    {get_note_name(midi)}
                  </div>
                </div>
              <% end %>
            </div>
          <% else %>
            <div class="text-slate-500 italic p-4 text-center bg-slate-700/30 rounded-lg">
              Sin notas presionadas
            </div>
          <% end %>
        </div>
        
    <!-- Validation indicator -->
        <% input_class =
          if MapSet.size(@held_notes) > 0 do
            "border-green-500 bg-green-900/30 text-green-400"
          else
            "border-slate-600 bg-slate-700/30 text-slate-400"
          end %>
        <div class={"p-4 rounded-lg border-2 text-center font-bold text-lg mb-4 #{input_class}"}>
          {if MapSet.size(@held_notes) > 0, do: "✓ Presionando", else: "⏸ Esperando..."}
        </div>
        
    <!-- Input history (last 5 notes) -->
        <div class="bg-slate-700/50 p-3 rounded-lg">
          <p class="text-xs text-slate-400 mb-2">Historial (últimas notas):</p>
          <div class="text-xs font-mono space-y-1 max-h-24 overflow-y-auto">
            <p class="text-slate-500">[Tu secuencia aparecerá aquí]</p>
          </div>
        </div>
      </div>
      
    <!-- BOTTOM: PROGRESS BAR -->
      <div class="col-span-3 border-2 border-yellow-500 rounded-lg p-4 bg-slate-800/50">
        <div class="flex justify-between items-center mb-2">
          <h3 class="font-bold text-yellow-400">📊 PROGRESO</h3>
          <span class="text-sm text-slate-400">
            Paso {@step_index + 1} de {length(@lesson.steps)}
          </span>
        </div>

        <div class="w-full bg-slate-700 rounded-full h-3 overflow-hidden">
          <% progress_pct = trunc(@step_index / length(@lesson.steps) * 100) %>
          <div
            class="bg-gradient-to-r from-yellow-500 to-orange-500 h-3 rounded-full transition-all duration-300"
            style={"width: #{progress_pct}%"}
          >
          </div>
        </div>

        <div class="mt-2 grid grid-cols-3 gap-2 text-xs text-center">
          <div class="text-slate-400">
            Tempo: {@tempo} BPM
          </div>
          <div class="text-slate-400">
            Accuracy: {trunc(@stats.correct / max(@stats.correct + @stats.errors, 1) * 100)}%
          </div>
          <div class="text-slate-400">
            Metrónomo: {if @metronome_active, do: "🔊 Activo", else: "🔇 Inactivo"}
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp get_note_name(midi) do
    case midi do
      60 -> "C4"
      61 -> "C#4"
      62 -> "D4"
      63 -> "D#4"
      64 -> "E4"
      65 -> "F4"
      66 -> "F#4"
      67 -> "G4"
      68 -> "G#4"
      69 -> "A4"
      70 -> "A#4"
      71 -> "B4"
      72 -> "C5"
      48 -> "C3"
      50 -> "D3"
      52 -> "E3"
      53 -> "F3"
      55 -> "G3"
      _ -> "?"
    end
  end
end
