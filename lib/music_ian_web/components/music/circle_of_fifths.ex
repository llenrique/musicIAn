defmodule MusicIanWeb.Components.Music.CircleOfFifths do
  use Phoenix.Component
  alias MusicIan.MusicCore.Note

  attr :root_note, :integer, required: true
  attr :suggested_keys, :list, default: []
  attr :theory_context, :map, required: true
  attr :circle_data, :list, required: true
  attr :suggestion_reason, :string, default: nil

  def circle_of_fifths(assigns) do
    ~H"""
    <div class="bg-white rounded-lg shadow-sm border border-slate-200 p-4 flex flex-col items-center">
       <div class="w-full flex justify-between items-center mb-4 border-b border-slate-100 pb-2">
         <span class="text-xs font-bold text-slate-500 uppercase tracking-wider">Selector de Tonalidad</span>
         <span class="text-[10px] bg-slate-100 text-slate-500 px-2 py-0.5 rounded">Quintas</span>
       </div>

       <div class="relative w-48 h-48">
         <svg viewBox="0 0 100 100" class="w-full h-full transform -rotate-90">
           <!-- Outer Ring -->
           <circle cx="50" cy="50" r="49" fill="none" stroke="#e2e8f0" stroke-width="1" />

           <%= for sector <- @circle_data do %>
             <%
               start_angle = sector.angle - 15
               end_angle = sector.angle + 15
               start_rad = start_angle * :math.pi() / 180
               end_rad = end_angle * :math.pi() / 180
               r_outer = 48
               r_inner = 32
               x1 = 50 + r_outer * :math.cos(start_rad); y1 = 50 + r_outer * :math.sin(start_rad)
               x2 = 50 + r_outer * :math.cos(end_rad); y2 = 50 + r_outer * :math.sin(end_rad)
               x3 = 50 + r_inner * :math.cos(end_rad); y3 = 50 + r_inner * :math.sin(end_rad)
               x4 = 50 + r_inner * :math.cos(start_rad); y4 = 50 + r_inner * :math.sin(start_rad)
               is_active = @root_note == sector.midi or @root_note == sector.midi + 12 or @root_note == sector.midi - 12
               is_suggested = rem(sector.midi, 12) in (@suggested_keys || [])
             %>
             <path
               d={"M #{x1} #{y1} A #{r_outer} #{r_outer} 0 0 1 #{x2} #{y2} L #{x3} #{y3} A #{r_inner} #{r_inner} 0 0 0 #{x4} #{y4} Z"}
               fill={if is_active, do: "#9333ea", else: if(is_suggested, do: "#f1f5f9", else: "#ffffff")}
               stroke={if is_suggested, do: "#cbd5e1", else: "#e2e8f0"}
               stroke-width="0.5"
               class={"cursor-pointer transition-colors duration-200 " <> if(is_suggested, do: "hover:fill-slate-200", else: "hover:fill-slate-50")}
               phx-click="select_root" phx-value-note={sector.midi}
             />
             <%
               label_r = 40
               label_x = 50 + label_r * :math.cos(sector.angle * :math.pi() / 180)
               label_y = 50 + label_r * :math.sin(sector.angle * :math.pi() / 180)
             %>
             <text x={label_x} y={label_y} text-anchor="middle" dominant-baseline="middle"
                   fill={if is_active, do: "white", else: "#475569"}
                   font-size="4"
                   font-weight="bold"
                   transform={"rotate(90, #{label_x}, #{label_y})"}
                   class="pointer-events-none select-none"><%= sector.label %></text>
           <% end %>

           <!-- Center Info -->
           <circle cx="50" cy="50" r="30" fill="white" />
           <text x="50" y="50" text-anchor="middle" dominant-baseline="middle" fill="#9333ea" font-size="8" font-weight="bold" transform="rotate(90, 50, 50)">
             <%= Note.new(@root_note, use_flats: rem(@root_note, 12) in [5, 10, 3, 8, 1, 6]).name %>
           </text>
         </svg>
       </div>

       <div class="mt-4 w-full text-center">
         <p class="text-sm text-slate-600 font-medium"><%= @theory_context.circle %></p>
         <%= if @suggestion_reason do %>
           <p class="text-xs text-slate-400 mt-1 italic"><%= @suggestion_reason %></p>
         <% end %>
       </div>
    </div>
    """
  end
end
