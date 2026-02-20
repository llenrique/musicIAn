defmodule MusicIanWeb.Components.Music.CircleOfFifths do
  @moduledoc "Componente Phoenix para la visualización del círculo de quintas con anillos Mayor/Menor."
  use Phoenix.Component
  alias MusicIan.MusicCore.Note

  # Colores arcoíris por sector (índice 0..11, sentido horario desde C)
  @sector_colors %{
    0 => {"#1a8a5a", "#0d5c3a"},
    1 => {"#2ecc71", "#1a9e52"},
    2 => {"#a8d020", "#6e8a14"},
    3 => {"#f0d000", "#b89800"},
    4 => {"#f0a020", "#c07810"},
    5 => {"#e06010", "#b04000"},
    6 => {"#cc2020", "#9a1010"},
    7 => {"#9b2d8c", "#6e1e63"},
    8 => {"#7b3fbe", "#5a2a90"},
    9 => {"#4a4abf", "#2e2e96"},
    10 => {"#2878d0", "#1a5aa8"},
    11 => {"#1aa8b0", "#107880"}
  }

  attr :root_note, :integer, required: true
  attr :suggested_keys, :list, default: []
  attr :theory_context, :map, required: true
  attr :circle_data, :list, required: true
  attr :suggestion_reason, :string, default: nil
  attr :circle_mode, :atom, default: :major

  def circle_of_fifths(assigns) do
    assigns = assign(assigns, :sector_colors, @sector_colors)

    ~H"""
    <div class="bg-white rounded-lg shadow-sm border border-slate-200 p-3 flex flex-col items-center">
      <div class="w-full flex justify-between items-center mb-2 border-b border-slate-100 pb-2">
        <span class="text-xs font-bold text-slate-500 uppercase tracking-wider">
          Selector de Tonalidad
        </span>
      </div>

      <div class="flex gap-1 mb-2 bg-slate-100 rounded-lg p-0.5 w-full">
        <button
          phx-click="select_circle_mode"
          phx-value-mode="major"
          class={"flex-1 text-xs font-bold py-1 rounded-md transition-all " <>
            if(@circle_mode == :major,
              do: "bg-white text-slate-800 shadow-sm",
              else: "text-slate-500 hover:text-slate-700")}
        >
          Mayor
        </button>
        <button
          phx-click="select_circle_mode"
          phx-value-mode="minor"
          class={"flex-1 text-xs font-bold py-1 rounded-md transition-all " <>
            if(@circle_mode == :minor,
              do: "bg-white text-slate-800 shadow-sm",
              else: "text-slate-500 hover:text-slate-700")}
        >
          Menor
        </button>
      </div>

      <div class="relative w-52 h-52">
        <svg viewBox="0 0 100 100" class="w-full h-full">
          <%= for sector <- @circle_data do %>
            <% idx = sector.index
            {color_major, color_minor} = Map.get(@sector_colors, idx, {"#94a3b8", "#64748b"})

            base_angle = sector.angle - 90
            start_deg = base_angle - 15
            end_deg = base_angle + 15

            to_rad = fn d -> d * :math.pi() / 180 end

            r_mo = 49
            r_mi_outer = 33
            x_maj1 = 50 + r_mo * :math.cos(to_rad.(start_deg))
            y_maj1 = 50 + r_mo * :math.sin(to_rad.(start_deg))
            x_maj2 = 50 + r_mo * :math.cos(to_rad.(end_deg))
            y_maj2 = 50 + r_mo * :math.sin(to_rad.(end_deg))
            x_maj3 = 50 + r_mi_outer * :math.cos(to_rad.(end_deg))
            y_maj3 = 50 + r_mi_outer * :math.sin(to_rad.(end_deg))
            x_maj4 = 50 + r_mi_outer * :math.cos(to_rad.(start_deg))
            y_maj4 = 50 + r_mi_outer * :math.sin(to_rad.(start_deg))

            r_min_outer = 33
            r_min_inner = 21
            x_min1 = 50 + r_min_outer * :math.cos(to_rad.(start_deg))
            y_min1 = 50 + r_min_outer * :math.sin(to_rad.(start_deg))
            x_min2 = 50 + r_min_outer * :math.cos(to_rad.(end_deg))
            y_min2 = 50 + r_min_outer * :math.sin(to_rad.(end_deg))
            x_min3 = 50 + r_min_inner * :math.cos(to_rad.(end_deg))
            y_min3 = 50 + r_min_inner * :math.sin(to_rad.(end_deg))
            x_min4 = 50 + r_min_inner * :math.cos(to_rad.(start_deg))
            y_min4 = 50 + r_min_inner * :math.sin(to_rad.(start_deg))

            label_r_maj = 41
            label_r_min = 27
            mid_angle_rad = to_rad.(base_angle)

            lx_maj = 50 + label_r_maj * :math.cos(mid_angle_rad)
            ly_maj = 50 + label_r_maj * :math.sin(mid_angle_rad)
            lx_min = 50 + label_r_min * :math.cos(mid_angle_rad)
            ly_min = 50 + label_r_min * :math.sin(mid_angle_rad)

            root_pc = rem(@root_note, 12)
            sector_pc = rem(sector.midi, 12)
            minor_pc = rem(sector.minor_midi, 12)
            is_major_active = @circle_mode == :major and root_pc == sector_pc
            is_minor_active = @circle_mode == :minor and root_pc == minor_pc
            is_suggested = sector_pc in (@suggested_keys || [])

            maj_stroke = if is_major_active, do: "white", else: "rgba(0,0,0,0.15)"
            min_stroke = if is_minor_active, do: "white", else: "rgba(0,0,0,0.15)"
            maj_sw = if is_major_active, do: "1.5", else: "0.5"
            min_sw = if is_minor_active, do: "1.5", else: "0.5"

            maj_opacity = if is_major_active, do: "1", else: if(is_suggested, do: "0.9", else: "0.75")
            min_opacity = if is_minor_active, do: "1", else: "0.75" %>

            <path
              d={"M #{x_maj1} #{y_maj1} A #{r_mo} #{r_mo} 0 0 1 #{x_maj2} #{y_maj2} L #{x_maj3} #{y_maj3} A #{r_mi_outer} #{r_mi_outer} 0 0 0 #{x_maj4} #{y_maj4} Z"}
              fill={color_major}
              stroke={maj_stroke}
              stroke-width={maj_sw}
              opacity={maj_opacity}
              class="cursor-pointer transition-opacity duration-150"
              phx-click="select_root"
              phx-value-note={sector.midi}
              phx-value-mode="major"
            />

            <path
              d={"M #{x_min1} #{y_min1} A #{r_min_outer} #{r_min_outer} 0 0 1 #{x_min2} #{y_min2} L #{x_min3} #{y_min3} A #{r_min_inner} #{r_min_inner} 0 0 0 #{x_min4} #{y_min4} Z"}
              fill={color_minor}
              stroke={min_stroke}
              stroke-width={min_sw}
              opacity={min_opacity}
              class="cursor-pointer transition-opacity duration-150"
              phx-click="select_root"
              phx-value-note={sector.minor_midi}
              phx-value-mode="minor"
            />

            <text
              x={lx_maj}
              y={ly_maj}
              text-anchor="middle"
              dominant-baseline="middle"
              fill="white"
              font-size={if String.length(sector.label) > 2, do: "3.2", else: "4.5"}
              font-weight="bold"
              class="pointer-events-none select-none"
            >
              {sector.label}
            </text>

            <text
              x={lx_min}
              y={ly_min}
              text-anchor="middle"
              dominant-baseline="middle"
              fill="white"
              font-size="3"
              font-weight="bold"
              class="pointer-events-none select-none"
            >
              {sector.minor}
            </text>
          <% end %>

          <circle cx="50" cy="50" r="20" fill="white" stroke="#e2e8f0" stroke-width="0.5" />
          <text
            x="50"
            y="46"
            text-anchor="middle"
            dominant-baseline="middle"
            fill="#1e293b"
            font-size="8"
            font-weight="bold"
          >
            {Note.new(@root_note, use_flats: rem(@root_note, 12) in [1, 3, 5, 8, 10]).name}
          </text>
          <text
            x="50"
            y="56"
            text-anchor="middle"
            dominant-baseline="middle"
            fill="#94a3b8"
            font-size="3.5"
          >
            {if @circle_mode == :minor, do: "menor", else: "mayor"}
          </text>
        </svg>
      </div>

      <div class="mt-2 w-full text-center">
        <p class="text-xs text-slate-600 font-medium leading-tight">{@theory_context.circle}</p>
        <%= if @suggestion_reason do %>
          <p class="text-[10px] text-slate-400 mt-1 italic leading-tight">{@suggestion_reason}</p>
        <% end %>
      </div>
    </div>
    """
  end
end
