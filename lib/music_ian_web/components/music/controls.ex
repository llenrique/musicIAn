defmodule MusicIanWeb.Components.Music.Controls do
  @moduledoc "Componente Phoenix para los controles de tonalidad y escala."
  use Phoenix.Component
  alias MusicIan.MusicCore.Scale

  attr :scale_type, :atom, required: true
  attr :theory_context, :map, required: true

  attr :hands_mode, :atom, default: :single
  attr :right_octave, :integer, default: 4
  attr :left_octave, :integer, default: 3

  def scale_controls(assigns) do
    ~H"""
    <div class="bg-white rounded-lg shadow-sm border border-slate-200 p-4 flex flex-col overflow-hidden">
      <div class="mb-4 border-b border-slate-100 pb-2 flex justify-between items-center">
        <span class="text-xs font-bold text-slate-500 uppercase tracking-wider">Modo / Escala</span>
      </div>
      
    <!-- Hands Mode Toggle -->
      <div class="mb-4 px-1">
        <button
          phx-click="toggle_hands"
          class={"w-full flex items-center justify-between px-3 py-2 rounded-lg border transition-all " <> if(@hands_mode == :double, do: "bg-purple-50 border-purple-200 text-purple-700", else: "bg-slate-50 border-slate-200 text-slate-600")}
        >
          <span class="text-xs font-bold uppercase tracking-wider">
            {if @hands_mode == :double, do: "Modo Piano (2 Manos)", else: "Modo Simple (1 Mano)"}
          </span>
          <div class={"w-8 h-4 rounded-full relative transition-colors " <> if(@hands_mode == :double, do: "bg-purple-500", else: "bg-slate-300")}>
            <div class={"w-3 h-3 bg-white rounded-full absolute top-0.5 transition-all " <> if(@hands_mode == :double, do: "left-4.5", else: "left-0.5")}>
            </div>
          </div>
        </button>
      </div>
      
    <!-- Octave Selectors -->
      <div class="mb-4 space-y-2 px-1">
        <!-- Right Hand (Always visible) -->
        <div class="flex items-center justify-between bg-slate-50 rounded-lg p-1 border border-slate-200">
          <button
            phx-click="change_octave_right"
            phx-value-octave={@right_octave - 1}
            class="p-1 text-slate-400 hover:text-slate-600 hover:bg-white rounded shadow-sm transition-all"
            disabled={@right_octave <= 2}
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 24 24"
              stroke-width="2"
              stroke="currentColor"
              class="w-4 h-4"
            >
              <path stroke-linecap="round" stroke-linejoin="round" d="M19.5 12h-15" />
            </svg>
          </button>
          <div class="flex flex-col items-center leading-none">
            <span class="text-[10px] text-slate-400 uppercase font-bold">Mano Derecha</span>
            <span class="text-xs font-bold text-slate-600">Octava {@right_octave}</span>
          </div>
          <button
            phx-click="change_octave_right"
            phx-value-octave={@right_octave + 1}
            class="p-1 text-slate-400 hover:text-slate-600 hover:bg-white rounded shadow-sm transition-all"
            disabled={@right_octave >= 6}
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 24 24"
              stroke-width="2"
              stroke="currentColor"
              class="w-4 h-4"
            >
              <path stroke-linecap="round" stroke-linejoin="round" d="M12 4.5v15m7.5-7.5h-15" />
            </svg>
          </button>
        </div>
        
    <!-- Left Hand (Conditional) -->
        <%= if @hands_mode == :double do %>
          <div class="flex items-center justify-between bg-slate-50 rounded-lg p-1 border border-slate-200">
            <button
              phx-click="change_octave_left"
              phx-value-octave={@left_octave - 1}
              class="p-1 text-slate-400 hover:text-slate-600 hover:bg-white rounded shadow-sm transition-all"
              disabled={@left_octave <= 1}
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                stroke-width="2"
                stroke="currentColor"
                class="w-4 h-4"
              >
                <path stroke-linecap="round" stroke-linejoin="round" d="M19.5 12h-15" />
              </svg>
            </button>
            <div class="flex flex-col items-center leading-none">
              <span class="text-[10px] text-slate-400 uppercase font-bold">Mano Izquierda</span>
              <span class="text-xs font-bold text-slate-600">Octava {@left_octave}</span>
            </div>
            <button
              phx-click="change_octave_left"
              phx-value-octave={@left_octave + 1}
              class="p-1 text-slate-400 hover:text-slate-600 hover:bg-white rounded shadow-sm transition-all"
              disabled={@left_octave >= 5}
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                stroke-width="2"
                stroke="currentColor"
                class="w-4 h-4"
              >
                <path stroke-linecap="round" stroke-linejoin="round" d="M12 4.5v15m7.5-7.5h-15" />
              </svg>
            </button>
          </div>
        <% end %>
      </div>
      
    <!-- Scale Selector (Dropdown) -->
      <div class="mb-4 px-1">
        <label class="block text-[10px] uppercase font-bold text-slate-400 mb-1">Escala / Modo</label>
        <form phx-change="select_scale" class="relative">
          <select
            name="type"
            class="w-full text-sm border border-slate-200 rounded-lg focus:border-purple-500 focus:ring-2 focus:ring-purple-100 bg-slate-50 py-2.5 pl-3 pr-10 appearance-none cursor-pointer hover:bg-slate-100 transition-colors shadow-sm text-slate-700 font-medium"
          >
            <%= for type <- Scale.types() do %>
              <option value={type} selected={@scale_type == type}>
                {String.replace(to_string(type), "_", " ") |> String.capitalize()}
              </option>
            <% end %>
          </select>
          <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center px-3 text-slate-500">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 24 24"
              stroke-width="2"
              stroke="currentColor"
              class="w-4 h-4"
            >
              <path stroke-linecap="round" stroke-linejoin="round" d="M19.5 8.25l-7.5 7.5-7.5-7.5" />
            </svg>
          </div>
        </form>
      </div>
    </div>
    """
  end
end
