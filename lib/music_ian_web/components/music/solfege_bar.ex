defmodule MusicIanWeb.Components.Music.SolfegeBar do
  @moduledoc """
  Barra de solfeo interactiva: conecta visualmente las notas del pentagrama
  con sus sílabas Do-Re-Mi (Do movible), nombre de nota y posición en la pauta.
  Cada grado tiene un color único y consistente con el pentagrama.
  """
  use Phoenix.Component

  @solfege_syllables ~w(Do Re Mi Fa Sol La Si Do)

  # Colores por grado (0=Do, 1=Re, ..., 7=Do octava). El 7 repite el color del 0.
  @degree_styles [
    %{bg: "bg-rose-50", border: "border-rose-300", solfege: "text-rose-600", name: "text-rose-800"},
    %{bg: "bg-orange-50", border: "border-orange-300", solfege: "text-orange-600", name: "text-orange-800"},
    %{bg: "bg-amber-50", border: "border-amber-300", solfege: "text-amber-600", name: "text-amber-800"},
    %{bg: "bg-lime-50", border: "border-lime-300", solfege: "text-lime-700", name: "text-lime-900"},
    %{bg: "bg-teal-50", border: "border-teal-300", solfege: "text-teal-600", name: "text-teal-800"},
    %{bg: "bg-blue-50", border: "border-blue-300", solfege: "text-blue-600", name: "text-blue-800"},
    %{bg: "bg-violet-50", border: "border-violet-300", solfege: "text-violet-600", name: "text-violet-800"},
    %{bg: "bg-rose-50", border: "border-rose-300", solfege: "text-rose-600", name: "text-rose-800"}
  ]

  # Mapa de letra de nota → paso genérico (C=0, D=1, E=2, F=3, G=4, A=5, B=6)
  @letter_to_step %{"C" => 0, "D" => 1, "E" => 2, "F" => 3, "G" => 4, "A" => 5, "B" => 6}

  # Línea inferior del pentagrama en pitch genérico
  # Clave de Sol: E4 = paso 2 + octava 4 * 7 = 30
  @treble_bottom_line 30
  # Clave de Fa: G2 = paso 4 + octava 2 * 7 = 18
  @bass_bottom_line 18

  attr :note_explanations, :list, required: true
  attr :scale_type, :atom, required: true

  def solfege_bar(assigns) do
    assigns =
      assigns
      |> assign(:solfege_notes, build_solfege_notes(assigns.note_explanations))
      |> assign(:degree_styles, @degree_styles)

    ~H"""
    <div class="bg-white rounded-lg border border-slate-200 shadow-sm px-3 py-2 shrink-0">
      <div class="flex items-center gap-2 mb-1.5">
        <span class="text-[10px] font-bold text-slate-400 uppercase tracking-wider">
          Solfeo · Do movible
        </span>
        <div class="flex-1 h-px bg-slate-100"></div>
        <span class="text-[9px] text-slate-300">▲ Clave de Sol</span>
      </div>

      <div class="flex gap-1">
        <%= for {note, idx} <- Enum.with_index(@solfege_notes) do %>
          <% style = Enum.at(@degree_styles, idx) %>
          <div class={"flex-1 flex flex-col items-center rounded border py-1.5 px-0.5 gap-0.5 #{style.bg} #{style.border}"}>
            <span class={"text-sm font-black leading-tight #{style.solfege}"}>{note.solfege}</span>
            <span class={"text-[10px] font-bold leading-none #{style.name}"}>{note.display_name}</span>
            <span class="text-[8px] text-slate-400 leading-none text-center">{note.position_label}</span>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  defp build_solfege_notes([]), do: []

  defp build_solfege_notes(note_explanations) do
    notes =
      note_explanations
      |> Enum.with_index()
      |> Enum.map(fn {note, idx} ->
        octave = div(note.midi, 12) - 1

        %{
          solfege: Enum.at(@solfege_syllables, idx),
          display_name: "#{note.name}#{octave}",
          position_label: staff_position_label(note.name, note.midi)
        }
      end)

    first = List.first(note_explanations)
    octave_midi = first.midi + 12
    octave_num = div(octave_midi, 12) - 1

    notes ++
      [
        %{
          solfege: "Do",
          display_name: "#{first.name}#{octave_num}",
          position_label: staff_position_label(first.name, octave_midi)
        }
      ]
  end

  defp staff_position_label(note_name, midi) do
    base = String.first(note_name)
    letter_step = Map.get(@letter_to_step, base, 0)
    octave = div(midi, 12) - 1
    generic_pitch = letter_step + octave * 7
    bottom_line = if midi >= 60, do: @treble_bottom_line, else: @bass_bottom_line
    position_to_label(generic_pitch - bottom_line)
  end

  # Posición par → la nota cae en una Línea
  defp position_to_label(position) when rem(abs(position), 2) == 0 do
    line_num = div(position, 2) + 1

    cond do
      line_num < 1 -> "L.aux. ↓"
      line_num > 5 -> "L.aux. ↑"
      true -> "#{line_num}ª Línea"
    end
  end

  # Posición impar → la nota cae en un Espacio
  defp position_to_label(position) do
    space_num = div(position + 1, 2)

    cond do
      space_num < 1 -> "Esp. ↓"
      space_num > 4 -> "Esp. ↑"
      true -> "#{space_num}º Esp."
    end
  end
end
