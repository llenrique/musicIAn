defmodule MusicIanWeb.Components.Music.MidiAnalysisPanel do
  @moduledoc """
  Panel de análisis MIDI en tiempo real.
  Aparece automáticamente cuando hay notas presionadas en el piano MIDI.
  Muestra: notas con solfeo, acorde detectado, intervalos y escalas compatibles.
  """
  use Phoenix.Component

  @solfege_syllables ~w(Do Do# Re Re# Mi Fa Fa# Sol Sol# La La# Si)

  @quality_names %{
    major: "Mayor",
    minor: "Menor",
    diminished: "Disminuido",
    augmented: "Aumentado",
    sus2: "Sus2",
    sus4: "Sus4",
    major7: "Mayor 7",
    dominant7: "Dominante 7",
    minor7: "Menor 7",
    minor7b5: "m7b5",
    diminished7: "Disminuido 7",
    unknown: "Cluster"
  }

  attr :midi_analysis, :map, required: true

  def midi_analysis_panel(assigns) do
    ~H"""
    <div class="bg-slate-900 rounded-lg border border-slate-700 px-3 py-2 shrink-0">
      <div class="flex items-center gap-2 mb-2">
        <span class="flex h-2 w-2 rounded-full bg-emerald-400 animate-pulse"></span>
        <span class="text-[10px] font-bold text-slate-300 uppercase tracking-wider">
          Análisis en Vivo
        </span>
      </div>

      <div class="flex gap-3">
        <%!-- Notas presionadas --%>
        <div class="flex-1 min-w-0">
          <p class="text-[9px] text-slate-500 uppercase font-bold mb-1">Notas</p>
          <div class="flex flex-wrap gap-1">
            <%= for note <- @midi_analysis.notes do %>
              <span class="bg-slate-700 text-white text-xs font-bold px-2 py-0.5 rounded">
                {note.name}<span class="text-slate-400 text-[9px]">{note.octave}</span>
                <span class="text-emerald-400 ml-0.5">{solfege_for(note.pitch_class)}</span>
              </span>
            <% end %>
          </div>
        </div>

        <%!-- Acorde detectado --%>
        <div class="shrink-0">
          <p class="text-[9px] text-slate-500 uppercase font-bold mb-1">Acorde</p>
          <%= if @midi_analysis.chord do %>
            <% chord = @midi_analysis.chord %>
            <div class="text-center">
              <span class="text-yellow-300 font-black text-sm leading-none">
                {chord.root.name}
              </span>
              <span class="text-yellow-500 text-xs ml-0.5">
                {quality_name(chord.quality)}
              </span>
              <%= if chord.inversion > 0 do %>
                <span class="text-slate-500 text-[9px] block">
                  {inversion_label(chord.inversion)}
                </span>
              <% end %>
            </div>
          <% else %>
            <span class="text-slate-500 text-xs">—</span>
          <% end %>
        </div>

        <%!-- Intervalos --%>
        <%= if length(@midi_analysis.intervals) > 0 do %>
          <div class="shrink-0">
            <p class="text-[9px] text-slate-500 uppercase font-bold mb-1">Intervalos</p>
            <div class="flex flex-col gap-0.5">
              <%= for interval <- @midi_analysis.intervals do %>
                <span class="text-[10px] text-cyan-300 font-mono whitespace-nowrap">
                  {interval.abbrev}
                  <span class="text-slate-500">·{interval.name}</span>
                </span>
              <% end %>
            </div>
          </div>
        <% end %>

        <%!-- Escalas compatibles --%>
        <%= if length(@midi_analysis.compatible_scales) > 0 do %>
          <div class="flex-1 min-w-0">
            <p class="text-[9px] text-slate-500 uppercase font-bold mb-1">Encaja en</p>
            <div class="flex flex-col gap-0.5 max-h-12 overflow-y-auto">
              <%= for scale <- Enum.take(@midi_analysis.compatible_scales, 5) do %>
                <span class="text-[10px] text-slate-300 whitespace-nowrap">{scale.label}</span>
              <% end %>
            </div>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  defp solfege_for(pitch_class) do
    Enum.at(@solfege_syllables, pitch_class, "?")
  end

  defp quality_name(quality) do
    Map.get(@quality_names, quality, "?")
  end

  defp inversion_label(1), do: "1ª inv."
  defp inversion_label(2), do: "2ª inv."
  defp inversion_label(n), do: "#{n}ª inv."
end
