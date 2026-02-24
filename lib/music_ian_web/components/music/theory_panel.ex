defmodule MusicIanWeb.Components.Music.TheoryPanel do
  @moduledoc "Componente Phoenix para el panel de teoría musical con información modal."
  use Phoenix.Component

  attr :root_note, :integer, required: true
  attr :scale_type, :atom, required: true
  attr :scale_info, :map, required: true
  attr :theory_context, :map, required: true
  attr :on_collapse, :string, default: nil

  def theory_panel(assigns) do
    ~H"""
    <div class="bg-white rounded-lg shadow-sm border border-slate-200 p-4 h-full overflow-y-auto">
      <div class="mb-4 border-b border-slate-100 pb-2 flex items-center justify-between">
        <span class="text-xs font-bold text-slate-500 uppercase tracking-wider">
          Análisis Teórico
        </span>
        <%= if @on_collapse do %>
          <button
            phx-click={@on_collapse}
            class="p-1 rounded hover:bg-slate-100 text-slate-400 hover:text-slate-600 transition-colors"
            title="Colapsar"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 24 24"
              stroke-width="2"
              stroke="currentColor"
              class="w-4 h-4"
            >
              <path stroke-linecap="round" stroke-linejoin="round" d="M8.25 4.5l7.5 7.5-7.5 7.5" />
            </svg>
          </button>
        <% end %>
      </div>

      <div class="space-y-5">
        <%!-- Modal Pattern (T/S) - Solo si es un modo --%>
        <%= if @theory_context.modal_info do %>
          <div>
            <h4 class="text-[10px] uppercase text-slate-400 font-bold mb-2">
              Patrón Modal ({@theory_context.modal_info.spanish_name})
            </h4>
            <div class="bg-slate-900 p-3 rounded">
              <.pattern_display pattern={@theory_context.modal_info.pattern_list} />
            </div>
            <%= if @theory_context.modal_info.characteristic_note do %>
              <p class="text-xs text-slate-500 mt-2">
                <span class="font-semibold text-blue-600">
                  {@theory_context.modal_info.characteristic_note}
                </span>
                — {@theory_context.modal_info.characteristic_desc}
              </p>
            <% end %>
          </div>

          <%!-- Origen Modal --%>
          <%= if @theory_context.parent_major do %>
            <div>
              <h4 class="text-[10px] uppercase text-slate-400 font-bold mb-2">Origen Modal</h4>
              <div class="bg-blue-50 p-3 rounded border border-blue-100">
                <p class="text-sm text-blue-800">
                  <span class="font-bold">{@theory_context.modal_info.degree_roman} grado</span>
                  de <span class="font-bold">{@theory_context.parent_major.name} Mayor</span>
                </p>
                <p class="text-xs text-blue-600 mt-1">
                  Mismas notas que {@theory_context.parent_major.name} Mayor, diferente centro tonal
                </p>
              </div>
            </div>
          <% end %>

          <%!-- Brillo --%>
          <%= if @theory_context.brightness do %>
            <div>
              <h4 class="text-[10px] uppercase text-slate-400 font-bold mb-2">Brillo</h4>
              <.brightness_indicator level={@theory_context.brightness} />
            </div>
          <% end %>

          <%!-- Escalas Relacionadas --%>
          <%= if @theory_context.related_modes && length(@theory_context.related_modes) > 0 do %>
            <div>
              <h4 class="text-[10px] uppercase text-slate-400 font-bold mb-2">
                Escalas Relacionadas
              </h4>
              <div class="space-y-1">
                <%= for mode <- @theory_context.related_modes do %>
                  <div class={"flex items-center justify-between text-xs px-2 py-1 rounded " <>
                    if(mode.is_current, do: "bg-emerald-100 text-emerald-800 font-semibold", else: "bg-slate-50 text-slate-600")}>
                    <span>{mode.root_name} {mode.spanish_name}</span>
                    <%= if mode.is_current do %>
                      <span class="text-[10px] bg-emerald-600 text-white px-1.5 py-0.5 rounded">
                        actual
                      </span>
                    <% end %>
                  </div>
                <% end %>
              </div>
              <p class="text-[10px] text-slate-400 mt-2 italic">
                Todas comparten las mismas notas pero diferente centro tonal
              </p>
            </div>
          <% end %>
        <% else %>
          <%!-- Estructura para escalas no-modales --%>
          <div>
            <h4 class="text-[10px] uppercase text-slate-400 font-bold mb-2">
              Estructura Interválica
            </h4>
            <div class="bg-slate-50 p-3 rounded border border-slate-100">
              <p class="text-sm text-slate-700 font-mono">{@theory_context.formula}</p>
            </div>
          </div>
        <% end %>

        <%!-- Carácter --%>
        <div>
          <h4 class="text-[10px] uppercase text-slate-400 font-bold mb-2">Carácter</h4>
          <p class="text-sm text-slate-700 mb-1 font-medium">"{@scale_info.mood}"</p>
          <p class="text-xs text-slate-500 leading-relaxed">{@scale_info.description}</p>
        </div>

        <%!-- Key Signature Info --%>
        <div>
          <h4 class="text-[10px] uppercase text-slate-400 font-bold mb-2">Armadura</h4>
          <p class="text-xs text-slate-600 leading-relaxed">{@theory_context.key_sig}</p>
        </div>
      </div>
    </div>
    """
  end

  # Componente para mostrar el patrón T/S con colores
  defp pattern_display(assigns) do
    ~H"""
    <div class="flex items-center justify-center gap-1">
      <%= for {interval, idx} <- Enum.with_index(@pattern) do %>
        <%= if idx > 0 do %>
          <span class="text-slate-500 text-xs">-</span>
        <% end %>
        <span class={
          "text-lg font-black " <>
          if(interval == :t, do: "text-green-400", else: "text-blue-400")
        }>
          {if interval == :t, do: "T", else: "S"}
        </span>
      <% end %>
    </div>
    """
  end

  # Indicador visual de brillo (1 = más brillante, 7 = más oscuro)
  defp brightness_indicator(assigns) do
    ~H"""
    <div class="flex items-center gap-2">
      <div class="flex-1 h-2 bg-slate-200 rounded-full overflow-hidden">
        <div
          class="h-full rounded-full bg-gradient-to-r from-yellow-400 to-slate-600"
          style={"width: #{(@level / 7) * 100}%"}
        />
      </div>
      <span class="text-xs text-slate-500 w-20">
        {brightness_label(@level)}
      </span>
    </div>
    """
  end

  defp brightness_label(1), do: "Muy brillante"
  defp brightness_label(2), do: "Brillante"
  defp brightness_label(3), do: "Claro"
  defp brightness_label(4), do: "Neutro"
  defp brightness_label(5), do: "Oscuro"
  defp brightness_label(6), do: "Muy oscuro"
  defp brightness_label(7), do: "Tenebroso"
  defp brightness_label(_), do: ""
end
