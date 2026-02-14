defmodule MusicIanWeb.Components.Music.Footer do
  use Phoenix.Component

  attr :midi_inputs, :list, default: []
  attr :midi_connected, :boolean, default: false
  attr :last_activity, :string, default: nil

  def status_bar(assigns) do
    ~H"""
    <div class="bg-slate-900 border-t border-slate-800 px-6 py-2 flex justify-between items-center text-xs text-slate-400 shrink-0 h-10">
      <div class="flex items-center gap-6">
        <!-- Connection Status -->
        <div class="flex items-center gap-2">
          <div class={"w-2 h-2 rounded-full " <> if(@midi_connected, do: "bg-emerald-500 shadow-[0_0_5px_#10b981]", else: "bg-red-500")}></div>
          <span class="font-mono uppercase tracking-wider">
            <%= if @midi_connected, do: "MIDI LINK ACTIVE", else: "NO MIDI DEVICE" %>
          </span>
        </div>

        <!-- Active Device -->
        <%= if @midi_connected && length(@midi_inputs) > 0 do %>
          <div class="flex items-center gap-2 text-slate-300">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-4 h-4">
              <path stroke-linecap="round" stroke-linejoin="round" d="M9 9l10.5-3m0 6.553v3.75a2.25 2.25 0 01-1.632 2.163l-1.32.377a1.803 1.803 0 11-.99-3.467l2.31-.66a2.25 2.25 0 001.632-2.163zm0 0V2.25L9 5.25v10.303m0 0v3.75a2.25 2.25 0 01-1.632 2.163l-1.32.377a1.803 1.803 0 01-.99-3.467l2.31-.66A2.25 2.25 0 009 15.553z" />
            </svg>
            <span class="font-medium"><%= List.first(@midi_inputs) %></span>
          </div>
        <% end %>
      </div>

      <div class="flex items-center gap-6">
        <!-- Test Metronome Link -->
        <a href="/metronome" class="hidden md:flex items-center gap-2 hover:text-slate-200 transition-colors">
          <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-4 h-4">
            <path stroke-linecap="round" stroke-linejoin="round" d="M9 9l10.5-3m0 6.553v3.75a2.25 2.25 0 01-1.632 2.163l-1.32.377a1.803 1.803 0 11-.99-3.467l2.31-.66a2.25 2.25 0 001.632-2.163zm0 0V2.25L9 5.25v10.303m0 0v3.75a2.25 2.25 0 01-1.632 2.163l-1.32.377a1.803 1.803 0 01-.99-3.467l2.31-.66A2.25 2.25 0 009 15.553z" />
          </svg>
          <span class="text-xs">Test Metrónomo</span>
        </a>

        <!-- Keyboard Shortcut Hint -->
        <div class="hidden md:flex items-center gap-2">
          <span class="bg-slate-800 px-1.5 py-0.5 rounded text-[10px] font-bold text-slate-300 border border-slate-700">Do8</span>
          <span>Acción Rápida</span>
        </div>

        <!-- Latency / Engine Status (Simulated for now) -->
        <div class="flex items-center gap-2">
          <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-4 h-4 text-emerald-500">
            <path stroke-linecap="round" stroke-linejoin="round" d="M3.75 13.5l10.5-11.25L12 10.5h8.25L9.75 21.75 12 13.5H3.75z" />
          </svg>
          <span class="text-emerald-500 font-bold">Low Latency</span>
        </div>
      </div>
    </div>
    """
  end
end
