defmodule MusicIanWeb.DashboardLive do
  use MusicIanWeb, :live_view
  alias MusicIan.Practice.Manager.LessonManager
  alias MusicIan.Curriculum
  alias MusicIanWeb.Components.DashboardComponents

  def mount(_params, _session, socket) do
    results = LessonManager.list_results()
    stats = LessonManager.get_stats()
    
    # Calculate accuracy
    total_notes = (stats.total_correct || 0) + (stats.total_errors || 0)
    accuracy = if total_notes > 0, do: round((stats.total_correct / total_notes) * 100), else: 0

    {:ok, 
     socket
     |> assign(:active_tab, :dashboard)
     |> assign(:results, results)
     |> assign(:stats, Map.put(stats, :accuracy, accuracy))
     |> assign(:page_title, "Mi Progreso")}
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-full bg-slate-50 text-slate-800 p-8 font-sans">
      <!-- Header -->
      <header class="mb-8 border-b border-slate-200 pb-6">
        <h1 class="text-3xl font-bold text-slate-900 tracking-tight mb-2">
          Panel de Progreso
        </h1>
        <p class="text-slate-500 text-lg">
          Resumen de tu actividad y análisis de rendimiento.
        </p>
      </header>

      <!-- Global Stats -->
      <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-12">
        <DashboardComponents.stat_card 
          title="Lecciones Completadas" 
          value={@stats.total_lessons || 0} 
          color_class="text-slate-900"
          icon={stat_icon(:check)}
        />
        
        <DashboardComponents.stat_card 
          title="Precisión Global" 
          value={"#{@stats.accuracy}%"} 
          color_class={accuracy_text_color(@stats.accuracy)}
          icon={stat_icon(:target)}
        />
        
        <DashboardComponents.stat_card 
          title="Notas Tocadas" 
          value={(@stats.total_correct || 0) + (@stats.total_errors || 0)} 
          color_class="text-blue-600"
          icon={stat_icon(:music)}
        />
      </div>

      <!-- Recent Activity -->
      <div class="mb-6 flex items-center justify-between">
        <h2 class="text-xl font-bold text-slate-800">Historial de Sesiones</h2>
        <span class="text-xs font-medium text-slate-400 uppercase tracking-wider">Últimas actividades</span>
      </div>
      
      <div class="space-y-4">
        <%= if Enum.empty?(@results) do %>
          <div class="text-center py-12 bg-white rounded-lg border border-slate-200 border-dashed">
            <div class="text-slate-300 mb-3">
              <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="w-12 h-12 mx-auto">
                <path stroke-linecap="round" stroke-linejoin="round" d="M19.5 14.25v-2.625a3.375 3.375 0 00-3.375-3.375h-1.5A1.125 1.125 0 0113.5 7.125v-1.5a3.375 3.375 0 00-3.375-3.375H8.25m0 12.75h7.5m-7.5 3H12M10.5 2.25H5.625c-.621 0-1.125.504-1.125 1.125v17.25c0 .621.504 1.125 1.125 1.125h12.75c.621 0 1.125-.504 1.125-1.125V11.25a9 9 0 00-9-9z" />
              </svg>
            </div>
            <p class="text-slate-500 font-medium">No hay sesiones registradas aún.</p>
            <p class="text-sm text-slate-400 mt-1">Completa una lección en el Explorador para ver tus resultados aquí.</p>
          </div>
        <% else %>
          <%= for result <- @results do %>
            <% 
              lesson_info = Curriculum.get_lesson(result.lesson_id) 
              total = result.correct_count + result.error_count
              session_accuracy = if total > 0, do: round((result.correct_count / total) * 100), else: 0
              analysis = analyze_performance(result.lesson_id, session_accuracy, result.error_count)
            %>
            
            <DashboardComponents.session_row 
              result={result} 
              lesson_title={lesson_info[:title] || result.lesson_id} 
              analysis={analysis} 
            />
          <% end %>
        <% end %>
      </div>
    </div>
    """
  end

  defp accuracy_text_color(acc) do
    cond do
      acc >= 90 -> "text-emerald-600"
      acc >= 70 -> "text-amber-500"
      true -> "text-red-500"
    end
  end

  defp stat_icon(:check) do
    assigns = %{}
    ~H"""
    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-5 h-5">
      <path stroke-linecap="round" stroke-linejoin="round" d="M9 12.75L11.25 15 15 9.75M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
    </svg>
    """
  end

  defp stat_icon(:target) do
    assigns = %{}
    ~H"""
    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-5 h-5">
      <path stroke-linecap="round" stroke-linejoin="round" d="M15.042 21.672L13.684 16.6m0 0l-2.51 2.225.569-9.47 5.227 7.917-3.286-.672zM12 2.25V4.5m5.834 1.666l-1.591 1.591M20.25 10.5H18M7.757 14.743l-1.59 1.59M6 10.5H3.75m4.007-4.243l-1.59-1.59" />
    </svg>
    """
  end

  defp stat_icon(:music) do
    assigns = %{}
    ~H"""
    <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" class="w-5 h-5">
      <path stroke-linecap="round" stroke-linejoin="round" d="M9 9l10.5-3m0 6.553v3.75a2.25 2.25 0 01-1.632 2.163l-1.32.377a1.803 1.803 0 11-.99-3.467l2.31-.66a2.25 2.25 0 001.632-2.163zm0 0V2.25L9 5.25v10.303m0 0v3.75a2.25 2.25 0 01-1.632 2.163l-1.32.377a1.803 1.803 0 01-.99-3.467l2.31-.66A2.25 2.25 0 009 15.553z" />
    </svg>
    """
  end

  # This simulates an AI analysis based on the lesson type and error rate
  # In the future, this could use detailed error logs (e.g. specific wrong notes played)
  defp analyze_performance(lesson_id, accuracy, error_count) do
    cond do
      accuracy == 100 ->
        %{
          diagnosis: "¡Ejecución Perfecta!",
          cause: nil,
          solution: nil
        }
      
      accuracy >= 90 ->
        %{
          diagnosis: "Muy buen desempeño, con errores menores.",
          cause: "Falta de atención momentánea o un pequeño desliz de dedo.",
          solution: "Intenta tocar un poco más lento para asegurar el 100%."
        }

      true ->
        # Specific advice based on lesson content
        case lesson_id do
          "c_major_intro" ->
            %{
              diagnosis: "Dificultades con la escala básica.",
              cause: "Es probable que estés confundiendo la posición de las teclas (ej. Fa vs Sol) o perdiendo la referencia del Do central.",
              solution: "Observa el patrón de teclas negras. El Fa siempre está a la izquierda del grupo de tres negras."
            }
          _ ->
            %{
              diagnosis: "Errores frecuentes detectados.",
              cause: "Posible falta de familiaridad con las notas o velocidad excesiva.",
              solution: "Repite la lección enfocándote en la precisión, no en la velocidad."
            }
        end
    end
  end
end
