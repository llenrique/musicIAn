defmodule MusicIanWeb.Components.DashboardComponents do
  use Phoenix.Component

  attr :title, :string, required: true
  attr :value, :any, required: true
  attr :color_class, :string, default: "text-slate-800"
  attr :icon, :string, default: nil

  def stat_card(assigns) do
    ~H"""
    <div class="bg-white p-6 rounded-lg border border-slate-200 shadow-sm flex flex-col justify-between h-full">
      <div class="flex justify-between items-start mb-2">
        <span class="text-xs font-bold text-slate-400 uppercase tracking-wider">{@title}</span>
        <%= if @icon do %>
          <div class="text-slate-300">{@icon}</div>
        <% end %>
      </div>
      <div class={"text-3xl font-bold " <> @color_class}>
        {@value}
      </div>
    </div>
    """
  end

  attr :result, :map, required: true
  attr :lesson_title, :string, required: true
  attr :analysis, :map, required: true

  def session_row(assigns) do
    ~H"""
    <div class="bg-white rounded-lg border border-slate-200 shadow-sm overflow-hidden hover:border-slate-300 transition-colors group">
      <div class="p-5 flex flex-col md:flex-row gap-6">
        <!-- Left: Basic Info -->
        <div class="md:w-1/4 flex flex-col justify-center">
          <div class="text-xs text-slate-400 font-medium mb-1">
            <%= Calendar.strftime(@result.completed_at, "%d/%m/%Y %H:%M") %>
          </div>
          <h3 class="text-lg font-bold text-slate-800 mb-2">{@lesson_title}</h3>
          
          <% 
            total = @result.correct_count + @result.error_count
            accuracy = if total > 0, do: round((@result.correct_count / total) * 100), else: 0
          %>
          
          <div class="flex items-center gap-2">
            <span class={"px-2.5 py-1 rounded-full text-xs font-bold border " <> accuracy_badge_class(accuracy)}>
              <%= accuracy %>% Precisión
            </span>
          </div>
        </div>

        <!-- Center: Metrics -->
        <div class="md:w-1/4 flex flex-col justify-center gap-3 border-l border-slate-100 pl-6">
          <div class="flex justify-between text-sm items-center">
            <span class="text-slate-500 font-medium">Aciertos</span>
            <span class="bg-emerald-50 text-emerald-700 px-2 py-0.5 rounded text-xs font-bold border border-emerald-100">
              {@result.correct_count}
            </span>
          </div>
          <div class="flex justify-between text-sm items-center">
            <span class="text-slate-500 font-medium">Errores</span>
            <span class="bg-red-50 text-red-600 px-2 py-0.5 rounded text-xs font-bold border border-red-100">
              {@result.error_count}
            </span>
          </div>
        </div>

        <!-- Right: AI Analysis -->
        <div class="md:w-1/2 bg-slate-50 rounded-lg p-4 border border-slate-100 group-hover:bg-slate-50/80 transition-colors">
          <div class="flex items-center gap-2 mb-2">
            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-4 h-4 text-purple-600">
              <path stroke-linecap="round" stroke-linejoin="round" d="M9.813 15.904L9 18.75l-.813-2.846a4.5 4.5 0 00-3.09-3.09L2.25 12l2.846-.813a4.5 4.5 0 003.09-3.09L9 5.25l.813 2.846a4.5 4.5 0 003.09 3.09L15.75 12l-2.846.813a4.5 4.5 0 00-3.09 3.09zM18.259 8.715L18 9.75l-.259-1.035a3.375 3.375 0 00-2.455-2.456L14.25 6l1.036-.259a3.375 3.375 0 002.455-2.456L18 2.25l.259 1.035a3.375 3.375 0 002.456 2.456L21.75 6l-1.035.259a3.375 3.375 0 00-2.456 2.456zM16.894 20.567L16.5 21.75l-.394-1.183a2.25 2.25 0 00-1.423-1.423L13.5 18.75l1.183-.394a2.25 2.25 0 001.423-1.423l.394-1.183.394 1.183a2.25 2.25 0 001.423 1.423l1.183.394-1.183.394a2.25 2.25 0 00-1.423 1.423z" />
            </svg>
            <span class="text-[10px] font-bold text-purple-600 uppercase tracking-wider">Diagnóstico IA</span>
          </div>
          
          <p class="text-sm text-slate-700 font-medium mb-2">{@analysis.diagnosis}</p>
          
          <%= if @analysis.cause do %>
            <div class="space-y-1">
              <div class="text-xs text-slate-600 flex gap-1">
                <span class="text-red-500 font-bold shrink-0">Causa:</span> 
                <span>{@analysis.cause}</span>
              </div>
              <div class="text-xs text-slate-600 flex gap-1">
                <span class="text-emerald-600 font-bold shrink-0">Solución:</span> 
                <span>{@analysis.solution}</span>
              </div>
            </div>
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  defp accuracy_badge_class(acc) do
    cond do
      acc >= 90 -> "bg-emerald-50 text-emerald-700 border-emerald-200"
      acc >= 70 -> "bg-amber-50 text-amber-700 border-amber-200"
      true -> "bg-red-50 text-red-700 border-red-200"
    end
  end
end
