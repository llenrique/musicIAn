defmodule MusicIanWeb.Components.PracticeComparison do
  @moduledoc """
  Integrated practice comparison panel.
  Shows expected vs actual notes in a compact format.
  Overlays on the existing theory layout during active practice.
  """

  use Phoenix.Component

  @doc """
  Renders a compact comparison panel showing:
  - Current expected note
  - Currently held notes
  - Feedback message
  - Quick stats
  """
  def practice_comparison(assigns) do
    ~H"""
    <%= if @lesson_active && @lesson_phase == :active do %>
      <div class="fixed bottom-6 right-6 w-80 bg-white border-2 border-slate-200 rounded-lg shadow-xl z-40">
        <!-- Header -->
        <div class="bg-gradient-to-r from-blue-500 to-purple-500 text-white px-4 py-3 rounded-t-lg">
          <div class="flex justify-between items-center mb-2">
            <h3 class="font-bold text-sm">📊 PRÁCTICA</h3>
            <span class="text-xs bg-white/20 px-2 py-1 rounded">
              Paso {@step_index + 1} / {length(@lesson.steps)}
            </span>
          </div>
          
    <!-- Progress bar mini -->
          <div class="w-full bg-white/30 rounded-full h-1.5 overflow-hidden">
            <div
              class="bg-white h-1.5 rounded-full transition-all duration-300"
              style={"width: #{trunc(@step_index / length(@lesson.steps) * 100)}%"}
            >
            </div>
          </div>
        </div>
        
    <!-- Content -->
        <div class="p-4 space-y-3">
          <!-- Expected Note -->
          <%= if @step_index < length(@lesson.steps) do %>
            <% 
              current_step = Enum.at(@lesson.steps, @step_index)
              duration = current_step[:duration] || 1
              # Map durations to visual representations
              note_symbol = case duration do
                2.0 -> "𝅗𝅥"  # Blanca (White note)
                1.0 -> "♩"   # Negra (Quarter note)
                0.5 -> "♪"   # Corchea (Eighth note)
                0.25 -> "𝅘𝅥𝅮"  # Semicorchea (Sixteenth note)
                _ -> "♩"
              end
            %>
            <div class="border-l-4 border-blue-500 pl-3">
              <p class="text-xs text-slate-500 uppercase font-bold">Esperado</p>
              <p class="text-lg font-bold text-blue-600">
                {current_step[:text]}
              </p>
              
              <!-- === FIX: Visual duration indicator for beginners === -->
              <div class="mt-3 space-y-2">
                <p class="text-xs text-slate-600 font-semibold">
                  Presiona {duration}x
                </p>
                
                <!-- Visual bar showing note duration -->
                <div class="flex items-center gap-2">
                  <svg class="w-20 h-6">
                    <!-- Background bar -->
                    <rect x="0" y="10" width="80" height="6" fill="#e2e8f0" rx="3" />
                    <!-- Duration fill -->
                    <rect 
                      x="0" y="10" 
                      width={duration * 20}
                      height="6" 
                      fill="#3b82f6" 
                      rx="3"
                    />
                  </svg>
                  <span class="text-2xl text-blue-600">{note_symbol}</span>
                </div>
                
                <p class="text-xs text-slate-400">
                  {cond do
                    duration == 2.0 -> "Mantén la tecla presionada el doble"
                    duration == 1.0 -> "Nota regular"
                    duration == 0.5 -> "Nota rápida"
                    true -> "Duración especial"
                  end}
                </p>
              </div>
            </div>
          <% end %>
          
    <!-- Actual Notes -->
          <div class="border-l-4 border-green-500 pl-3">
            <p class="text-xs text-slate-500 uppercase font-bold">Tu Input</p>
            <%= if MapSet.size(@held_notes) > 0 do %>
              <div class="flex flex-wrap gap-1 mt-1">
                <%= for midi <- @held_notes |> MapSet.to_list() |> Enum.sort() do %>
                  <span class="bg-green-100 text-green-700 px-2 py-1 rounded text-xs font-mono font-bold">
                    {get_note_name(midi)}
                  </span>
                <% end %>
              </div>
            <% else %>
              <p class="text-xs text-slate-400 italic mt-1">
                Presiona notas...
              </p>
            <% end %>
          </div>
          
    <!-- Feedback -->
          <% feedback_color =
            case @feedback[:status] do
              :success -> "bg-green-50 border-green-300 text-green-700"
              :error -> "bg-red-50 border-red-300 text-red-700"
              _ -> "bg-slate-50 border-slate-300 text-slate-700"
            end %>
          <div class={"border px-3 py-2 rounded #{feedback_color}"}>
            <p class="text-sm font-semibold">
              {@feedback[:message] || "En espera..."}
            </p>
          </div>
          
    <!-- Stats Row -->
          <div class="grid grid-cols-2 gap-2 pt-2 border-t border-slate-200">
            <div class="text-center">
              <p class="text-2xl font-bold text-green-600">
                {@stats.correct}
              </p>
              <p class="text-xs text-slate-500">Correctas</p>
            </div>
            <div class="text-center">
              <p class="text-2xl font-bold text-red-600">
                {@stats.errors}
              </p>
              <p class="text-xs text-slate-500">Errores</p>
            </div>
          </div>
          
    <!-- Accuracy -->
          <% accuracy = trunc(@stats.correct / max(@stats.correct + @stats.errors, 1) * 100) %>
          <div class="bg-slate-50 rounded p-2 text-center">
            <p class="text-sm font-bold text-slate-700">
              {accuracy}% Exactitud
            </p>
          </div>
        </div>
      </div>
    <% end %>
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
