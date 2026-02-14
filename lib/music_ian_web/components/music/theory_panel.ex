defmodule MusicIanWeb.Components.Music.TheoryPanel do
  use Phoenix.Component

  attr :root_note, :integer, required: true
  attr :scale_type, :atom, required: true
  attr :scale_info, :map, required: true
  attr :theory_context, :map, required: true

  def theory_panel(assigns) do
    ~H"""
    <div class="bg-white rounded-lg shadow-sm border border-slate-200 p-4 h-full overflow-y-auto">
      <div class="mb-4 border-b border-slate-100 pb-2">
        <span class="text-xs font-bold text-slate-500 uppercase tracking-wider">Análisis Teórico</span>
      </div>

      <div class="space-y-6">
        <!-- Scale Structure -->
        <div>
          <h4 class="text-[10px] uppercase text-slate-400 font-bold mb-2">Estructura Interválica</h4>
          <div class="bg-slate-50 p-3 rounded border border-slate-100">
            <p class="text-sm text-slate-700 font-mono"><%= @theory_context.formula %></p>
          </div>
        </div>

        <!-- Mood/Description -->
        <div>
          <h4 class="text-[10px] uppercase text-slate-400 font-bold mb-2">Carácter</h4>
          <p class="text-sm text-slate-700 mb-1 font-medium">"<%= @scale_info.mood %>"</p>
          <p class="text-xs text-slate-500 leading-relaxed"><%= @scale_info.description %></p>
        </div>

        <!-- Usage Tips (Placeholder for future expansion) -->
        <div>
          <h4 class="text-[10px] uppercase text-slate-400 font-bold mb-2">Uso Común</h4>
          <ul class="text-xs text-slate-600 list-disc list-inside space-y-1">
            <li>Composición melódica</li>
            <li>Improvisación sobre acordes diatónicos</li>
            <li>Entrenamiento auditivo</li>
          </ul>
        </div>
      </div>
    </div>
    """
  end
end
