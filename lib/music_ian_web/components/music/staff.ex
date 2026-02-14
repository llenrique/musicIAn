defmodule MusicIanWeb.Components.Music.Staff do
  use Phoenix.Component

  attr :vexflow_notes, :list, required: true
  attr :vexflow_key, :string, required: true
  attr :theory_context, :map, required: true
  attr :current_step_index, :integer, default: 0
  attr :lesson_active, :boolean, default: false
  attr :note_explanations, :list, default: []

  def music_staff(assigns) do
    ~H"""
    <div class="bg-white rounded-lg shadow-sm border border-slate-200 overflow-hidden flex flex-col h-full">
       <div class="bg-slate-50 px-4 py-2 border-b border-slate-200 flex justify-between items-center">
          <span class="text-xs font-bold text-slate-500 uppercase tracking-wider">Notación</span>
          <div class="flex items-center gap-2">
            <span class="text-[10px] text-slate-400 uppercase">Armadura:</span>
            <span class="text-xs font-bold text-slate-700"><%= @vexflow_key %></span>
          </div>
        </div>

        <div class="flex-grow flex items-center justify-center relative bg-white">
          <div
            id="staff-container"
            phx-hook="MusicStaff"
            data-notes={Jason.encode!(@vexflow_notes)}
            data-key={@vexflow_key}
            data-step-index={@current_step_index}
            data-is-lesson={"#{@lesson_active}"}
            data-explanations={Jason.encode!(@note_explanations)}
            class="w-full flex items-center justify-center"
          ></div>
        </div>

        <div class="px-4 py-2 bg-slate-50 border-t border-slate-100">
          <p class="text-xs text-slate-500 text-center"><%= @theory_context.key_sig %></p>
        </div>
     </div>
    """
  end
end
