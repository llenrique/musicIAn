defmodule MusicIanWeb.ModulesLive do
  use MusicIanWeb, :live_view
  alias MusicIan.Practice.Manager.LessonManager
  alias MusicIan.Curriculum

  def mount(_params, _session, socket) do
    modules = LessonManager.list_all_modules()
    
    # Enrich modules with lesson results
    enriched_modules = Enum.map(modules, fn module ->
      lessons_with_results = Enum.map(module.lessons, fn lesson ->
        latest_result = LessonManager.get_latest_result_for_lesson(lesson.id)
        lesson_stats = LessonManager.get_lesson_stats(lesson.id)
        
        %{
          lesson: lesson,
          latest_result: latest_result,
          stats: lesson_stats
        }
      end)
      
      %{
        module: module,
        lessons_with_results: lessons_with_results
      }
    end)

    {:ok,
     socket
     |> assign(:active_tab, :modules)
     |> assign(:enriched_modules, enriched_modules)
     |> assign(:page_title, "Módulos")}
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-full bg-slate-50 text-slate-800 p-8 font-sans">
      <!-- Header -->
      <header class="mb-8 border-b border-slate-200 pb-6">
        <h1 class="text-3xl font-bold text-slate-900 tracking-tight mb-2">
          📚 Módulos de Aprendizaje
        </h1>
        <p class="text-slate-500 text-lg">
          Explora los módulos organizados con tus lecciones y progreso.
        </p>
      </header>

      <!-- Modules Grid -->
      <div class="space-y-8">
        <%= if Enum.empty?(@enriched_modules) do %>
          <div class="text-center py-12 bg-white rounded-lg border border-slate-200 border-dashed">
            <div class="text-slate-300 mb-3">
              <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-12 h-12 mx-auto">
                <path stroke-linecap="round" stroke-linejoin="round" d="M12 6.042A8.967 8.967 0 006 3.75c-1.052 0-2.062.18-3 .512v14.25A8.987 8.987 0 016 18c2.305 0 4.408.867 6 2.292m0-14.25a8.966 8.966 0 016-2.292c1.052 0 2.062.18 3 .512v14.25A8.987 8.987 0 0018 18a8.967 8.967 0 00-6 2.292m0-14.25v14.25" />
              </svg>
            </div>
            <p class="text-slate-500 font-medium">No hay módulos disponibles.</p>
          </div>
        <% else %>
          <%= for module_item <- @enriched_modules do %>
            <div class="bg-white rounded-lg border border-slate-200 shadow-sm overflow-hidden">
              <!-- Module Header -->
              <div class="bg-gradient-to-r from-purple-50 to-purple-100 border-b border-purple-200 p-6">
                <div class="flex items-start justify-between mb-2">
                  <div>
                    <h2 class="text-2xl font-bold text-purple-900 mb-1">
                      <%= module_item.module.title %>
                    </h2>
                    <%= if module_item.module.description do %>
                      <p class="text-purple-700 text-sm">
                        <%= module_item.module.description %>
                      </p>
                    <% end %>
                  </div>
                  <%= if module_item.module.icon do %>
                    <div class="text-3xl">
                      <%= module_item.module.icon %>
                    </div>
                  <% end %>
                </div>

                <!-- Module Progress Summary -->
                <% completed_lessons = Enum.count(module_item.lessons_with_results, fn item -> 
                  item.latest_result != nil 
                end)
                total_lessons = Enum.count(module_item.lessons_with_results) %>
                
                <div class="flex items-center gap-4 mt-4">
                  <div class="flex-1">
                    <div class="w-full bg-purple-200 rounded-full h-2 overflow-hidden">
                      <div 
                        class="bg-gradient-to-r from-purple-500 to-purple-600 h-full transition-all"
                        style={"width: #{if total_lessons > 0, do: round((completed_lessons / total_lessons) * 100), else: 0}%"}
                      />
                    </div>
                  </div>
                  <span class="text-sm font-semibold text-purple-700 whitespace-nowrap">
                    <%= completed_lessons %>/<%= total_lessons %>
                  </span>
                </div>
              </div>

              <!-- Lessons List -->
              <div class="divide-y divide-slate-100">
                <%= for lesson_item <- module_item.lessons_with_results do %>
                  <div class="p-6 hover:bg-slate-50 transition-colors">
                    <div class="flex items-start justify-between gap-4">
                      <!-- Lesson Info -->
                      <div class="flex-1 min-w-0">
                        <h3 class="font-semibold text-slate-900 mb-1">
                          <%= lesson_item.lesson.title %>
                        </h3>
                        <p class="text-sm text-slate-600 mb-3">
                          <%= lesson_item.lesson.description %>
                        </p>

                        <!-- Lesson Metadata -->
                        <div class="flex flex-wrap gap-2 items-center">
                          <%= if lesson_item.lesson.duration_minutes do %>
                            <span class="inline-flex items-center gap-1 text-xs bg-blue-50 text-blue-700 px-2 py-1 rounded">
                              <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-3 h-3">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M12 6v6h4.5m4.5-15a9 9 0 11-18 0 9 9 0 0118 0z" />
                              </svg>
                              <%= lesson_item.lesson.duration_minutes %> min
                            </span>
                          <% end %>

                          <%= if lesson_item.lesson.cognitive_complexity do %>
                            <span class="inline-flex items-center gap-1 text-xs bg-amber-50 text-amber-700 px-2 py-1 rounded">
                              <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-3 h-3">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M9.663 17h4.673M12 3v1m6.364 1.636l-.707.707M21 12a9 9 0 11-18 0 9 9 0 0118 0zm-9 5a4 4 0 100-8 4 4 0 000 8z" />
                              </svg>
                              <%= String.capitalize(lesson_item.lesson.cognitive_complexity) %>
                            </span>
                          <% end %>
                        </div>
                      </div>

                      <!-- Lesson Score -->
                      <div class="flex flex-col items-end gap-2">
                        <%= if lesson_item.latest_result do %>
                          <% 
                            total_notes = lesson_item.latest_result.correct_count + lesson_item.latest_result.error_count
                            accuracy = if total_notes > 0, do: round((lesson_item.latest_result.correct_count / total_notes) * 100), else: 0
                          %>
                          <div class="text-center">
                            <div class="text-3xl font-bold text-purple-600">
                              <%= accuracy %>%
                            </div>
                            <p class="text-xs text-slate-500 mt-1">Última puntuación</p>
                          </div>

                          <%= if lesson_item.stats do %>
                            <div class="text-xs text-slate-600 space-y-1 border-t border-slate-200 pt-2 mt-2">
                              <div>
                                <span class="text-slate-500">Intentos:</span>
                                <span class="font-semibold"><%= lesson_item.stats.attempts || 0 %></span>
                              </div>
                              <div>
                                <span class="text-slate-500">Aciertos:</span>
                                <span class="font-semibold text-emerald-600"><%= lesson_item.stats.total_correct || 0 %></span>
                              </div>
                              <div>
                                <span class="text-slate-500">Errores:</span>
                                <span class="font-semibold text-red-600"><%= lesson_item.stats.total_errors || 0 %></span>
                              </div>
                            </div>
                          <% end %>
                        <% else %>
                          <div class="text-center">
                            <div class="w-16 h-16 bg-slate-100 rounded-full flex items-center justify-center">
                              <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-8 h-8 text-slate-400">
                                <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v3m0 0v3m0-3h3m-3 0H9m12 0a9 9 0 11-18 0 9 9 0 0118 0z" />
                              </svg>
                            </div>
                            <p class="text-xs text-slate-500 mt-2">No iniciada</p>
                          </div>
                        <% end %>
                      </div>
                    </div>
                  </div>
                <% end %>
              </div>
            </div>
          <% end %>
        <% end %>
      </div>
    </div>
    """
  end
end
