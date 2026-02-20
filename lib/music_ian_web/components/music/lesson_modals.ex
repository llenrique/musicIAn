defmodule MusicIanWeb.Components.Music.LessonModals do
  @moduledoc """
  Componentes de modales para el flujo de lecciones.

  Agrupa los 6 modales/indicadores del ciclo de vida de una lección:
  - `lesson_intro_modal/1`    — fase `:intro`
  - `demo_overlay/1`          — fase `:demo`
  - `countdown_modal/1`       — fase `:countdown`
  - `post_demo_modal/1`       — fase `:post_demo`
  - `lesson_summary_modal/1`  — fase `:summary`
  - `lesson_step_indicator/1` — fase `:active`
  """

  use Phoenix.Component

  alias MusicIan.Curriculum

  # ---------------------------------------------------------------------------
  # lesson_intro_modal
  # ---------------------------------------------------------------------------

  @doc "Modal de introducción a la lección (fase :intro)."
  attr :lesson, :map, required: true

  def lesson_intro_modal(assigns) do
    ~H"""
    <div class="absolute inset-0 z-50 bg-slate-900/60 backdrop-blur-sm flex items-center justify-center p-4">
      <div class="bg-white rounded-xl shadow-2xl max-w-lg w-full overflow-hidden animate-fade-in-up">
        <div class="bg-emerald-600 p-6 text-white">
          <h2 class="text-2xl font-bold mb-2">{@lesson.title}</h2>
          <div class="h-1 w-12 bg-emerald-400 rounded"></div>
        </div>
        <div class="p-8">
          <p class="text-slate-600 text-lg leading-relaxed mb-8">
            {@lesson[:intro] || @lesson.description}
          </p>

          <div class="flex justify-end gap-3">
            <button
              phx-click="stop_lesson"
              class="px-4 py-2 text-slate-500 hover:text-slate-700 font-medium transition-colors"
            >
              Cancelar
            </button>
            <button
              phx-click="start_demo"
              class="px-4 py-2 bg-blue-100 text-blue-700 hover:bg-blue-200 font-medium rounded-lg transition-colors flex items-center gap-2"
            >
              <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                stroke-width="2"
                stroke="currentColor"
                class="w-4 h-4"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  d="M5.25 5.653c0-.856.917-1.398 1.667-.986l11.54 6.348a1.125 1.125 0 010 1.971l-11.54 6.347a1.125 1.125 0 01-1.667-.985V5.653z"
                />
              </svg>
              Ver Demo
            </button>
            <button
              phx-click="begin_practice"
              class="px-6 py-2 bg-emerald-600 hover:bg-emerald-500 text-white font-bold rounded-lg shadow-lg shadow-emerald-200 transition-all transform hover:-translate-y-0.5"
            >
              Comenzar Práctica
            </button>
          </div>
        </div>
      </div>
    </div>
    """
  end

  # ---------------------------------------------------------------------------
  # demo_overlay
  # ---------------------------------------------------------------------------

  @doc "Indicador flotante de reproducción de demo (fase :demo)."
  def demo_overlay(assigns) do
    ~H"""
    <div class="absolute top-20 left-1/2 -translate-x-1/2 z-40 bg-blue-600 text-white px-6 py-3 rounded-full shadow-xl flex items-center gap-4 animate-pulse">
      <span class="font-bold flex items-center gap-2">
        <svg
          xmlns="http://www.w3.org/2000/svg"
          fill="none"
          viewBox="0 0 24 24"
          stroke-width="2"
          stroke="currentColor"
          class="w-5 h-5"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            d="M5.25 5.653c0-.856.917-1.398 1.667-.986l11.54 6.348a1.125 1.125 0 010 1.971l-11.54 6.347a1.125 1.125 0 01-1.667-.985V5.653z"
          />
        </svg>
        Reproduciendo Demostración...
      </span>
      <button
        phx-click="stop_demo"
        class="bg-white/20 hover:bg-white/30 rounded-full p-1 transition-colors"
      >
        <svg
          xmlns="http://www.w3.org/2000/svg"
          fill="none"
          viewBox="0 0 24 24"
          stroke-width="2"
          stroke="currentColor"
          class="w-4 h-4"
        >
          <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
        </svg>
      </button>
    </div>
    """
  end

  # ---------------------------------------------------------------------------
  # countdown_modal
  # ---------------------------------------------------------------------------

  @doc "Modal de cuenta regresiva (fase :countdown)."
  attr :countdown, :integer, required: true
  attr :countdown_stage, :atom, required: true

  def countdown_modal(assigns) do
    final_words = %{3 => "Listo", 2 => "Set", 1 => "¡Vamos!"}
    assigns = assign(assigns, :final_display, Map.get(final_words, assigns.countdown, ""))

    ~H"""
    <div class="absolute inset-0 z-50 bg-slate-900/60 backdrop-blur-sm flex items-center justify-center">
      <div class="bg-white rounded-2xl shadow-2xl p-12 max-w-md w-full text-center">
        <%= if @countdown_stage == :counting do %>
          <p class="text-slate-600 text-xl mb-4 font-semibold">Metrónomo Activo</p>
          <div class="text-8xl font-black text-blue-600 animate-pulse mb-6">
            {@countdown}
          </div>
          <p class="text-slate-500 text-sm">
            Escucha el metrónomo y adapta tu ritmo
          </p>
        <% else %>
          <div class="text-7xl font-black text-green-600 animate-pulse">
            {@final_display}
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  # ---------------------------------------------------------------------------
  # post_demo_modal
  # ---------------------------------------------------------------------------

  @doc "Modal de confirmación post-demo (fase :post_demo)."
  def post_demo_modal(assigns) do
    ~H"""
    <div class="absolute inset-0 z-50 bg-slate-900/60 backdrop-blur-sm flex items-center justify-center">
      <div class="bg-white rounded-2xl shadow-2xl p-8 max-w-md w-full text-center">
        <h2 class="text-2xl font-bold text-slate-800 mb-2">Demostración Completada</h2>
        <p class="text-slate-600 text-base mb-6">
          ¿Deseas ver la demostración de nuevo o comenzar a practicar?
        </p>

        <div class="space-y-3">
          <button
            phx-click="start_demo"
            class="bg-blue-500 hover:bg-blue-600 text-white font-bold py-3 px-6 rounded-lg transition-colors w-full flex items-center justify-center gap-2"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 24 24"
              stroke-width="2"
              stroke="currentColor"
              class="w-5 h-5"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                d="M5.25 5.653c0-.856.917-1.398 1.667-.986l11.54 6.348a1.125 1.125 0 010 1.971l-11.54 6.347a1.125 1.125 0 01-1.667-.985V5.653z"
              />
            </svg>
            Ver Demo de Nuevo
          </button>

          <button
            phx-click="begin_practice"
            class="bg-emerald-500 hover:bg-emerald-600 text-white font-bold py-3 px-6 rounded-lg transition-colors w-full flex items-center justify-center gap-2"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 24 24"
              stroke-width="2"
              stroke="currentColor"
              class="w-5 h-5"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                d="M13.5 6H5.25A2.25 2.25 0 003 8.25v10.5A2.25 2.25 0 005.25 21h10.5A2.25 2.25 0 0018 18.75V10.5m-10.5 6L21 3m0 0h-5.25M21 3v5.25"
              />
            </svg>
            Comenzar Práctica
          </button>
        </div>
      </div>
    </div>
    """
  end

  # ---------------------------------------------------------------------------
  # lesson_summary_modal
  # ---------------------------------------------------------------------------

  @doc "Modal de resumen al completar una lección (fase :summary)."
  attr :lesson, :map, required: true
  attr :lesson_stats, :map, required: true

  def lesson_summary_modal(assigns) do
    total = assigns.lesson_stats.correct + assigns.lesson_stats.errors
    base = if total > 0, do: assigns.lesson_stats.correct / total * 100, else: 0.0
    penalty = Map.get(assigns.lesson_stats, :timing_penalty_total, 0)
    accuracy = max(0.0, base - penalty)
    passed = accuracy >= 80
    next_lesson_id = Curriculum.get_next_lesson_id(assigns.lesson.id)

    assigns =
      assigns
      |> assign(:accuracy, accuracy)
      |> assign(:passed, passed)
      |> assign(:next_lesson_id, next_lesson_id)

    ~H"""
    <div class="absolute inset-0 z-50 bg-slate-900/50 backdrop-blur-sm flex items-center justify-center">
      <div class="bg-white rounded-xl shadow-2xl p-8 max-w-md w-full text-center animate-fade-in-up">
        <div class={"w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4 " <> if(@passed, do: "bg-emerald-100 text-emerald-600", else: "bg-red-100 text-red-500")}>
          <%= if @passed do %>
            <svg
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 24 24"
              stroke-width="2"
              stroke="currentColor"
              class="w-8 h-8"
            >
              <path stroke-linecap="round" stroke-linejoin="round" d="M4.5 12.75l6 6 9-13.5" />
            </svg>
          <% else %>
            <svg
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 24 24"
              stroke-width="2"
              stroke="currentColor"
              class="w-8 h-8"
            >
              <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
            </svg>
          <% end %>
        </div>

        <h2 class="text-2xl font-bold text-slate-800 mb-2">
          {if @passed, do: "¡Lección Completada!", else: "Inténtalo de nuevo"}
        </h2>
        <p class="text-slate-500 mb-6">
          Has finalizado <span class="font-medium text-slate-700">{@lesson.title}</span>
          con una precisión del <span class={"font-bold " <> if(@passed, do: "text-emerald-600", else: "text-red-500")}>
            <%= round(@accuracy) %>%
          </span>.
        </p>

        <div class="grid grid-cols-2 gap-4 mb-6">
          <div class="bg-slate-50 p-3 rounded border border-slate-100">
            <div class="text-2xl font-bold text-emerald-600">{@lesson_stats.correct}</div>
            <div class="text-xs text-slate-400 uppercase font-bold">Aciertos</div>
          </div>
          <div class="bg-slate-50 p-3 rounded border border-slate-100">
            <div class="text-2xl font-bold text-red-500">{@lesson_stats.errors}</div>
            <div class="text-xs text-slate-400 uppercase font-bold">Errores</div>
          </div>
        </div>

        <div class="flex flex-col gap-3">
          <%= if @next_lesson_id do %>
            <button
              phx-click="start_lesson"
              phx-value-id={@next_lesson_id}
              class={"w-full py-3 font-bold rounded-lg transition-colors shadow-lg " <> if(@passed, do: "bg-emerald-600 hover:bg-emerald-500 text-white shadow-emerald-200", else: "bg-slate-200 text-slate-400 cursor-not-allowed")}
              disabled={!@passed}
            >
              {if @passed,
                do: "Siguiente Lección (Do8)",
                else: "Siguiente Lección (Bloqueado - Requiere 80%)"}
            </button>
          <% end %>

          <button
            phx-click="start_lesson"
            phx-value-id={@lesson.id}
            class={"w-full py-3 font-bold rounded-lg transition-colors " <> if(!@passed, do: "bg-slate-800 text-white hover:bg-slate-700", else: "bg-slate-100 text-slate-600 hover:bg-slate-200")}
          >
            Repetir Lección {if !@passed, do: "(Do8)"}
          </button>

          <button
            phx-click="stop_lesson"
            class="text-sm text-slate-400 hover:text-slate-600 underline"
          >
            Volver al menú
          </button>
        </div>
      </div>
    </div>
    """
  end

  # ---------------------------------------------------------------------------
  # lesson_step_indicator
  # ---------------------------------------------------------------------------

  @doc "Indicador de paso activo durante la práctica (fase :active)."
  attr :lesson, :map, required: true
  attr :current_step_index, :integer, required: true
  attr :lesson_feedback, :map, default: nil
  attr :lesson_state, :map, default: nil

  def lesson_step_indicator(assigns) do
    {progress_percent, progress_text} =
      calculate_progress(assigns.lesson, assigns.current_step_index, assigns.lesson_state)

    assigns =
      assigns
      |> assign(:progress_percent, progress_percent)
      |> assign(:progress_text, progress_text)

    ~H"""
    <% current_step = Enum.at(@lesson.steps, @current_step_index) %>
    <div class={"w-full bg-white border shadow-sm rounded-lg p-4 flex items-center gap-4 transition-all " <>
      case @lesson_feedback do
        %{status: :success} -> "border-emerald-500 ring-2 ring-emerald-100"
        %{status: :error} -> "border-red-500 ring-2 ring-red-100"
        _ -> "border-blue-500"
      end
    }>
      <div class="flex-grow">
        <div class="flex justify-between text-xs text-slate-400 mb-1 uppercase font-bold tracking-wider">
          <span>{@progress_text}</span>
          <span>
            {if @lesson_feedback, do: @lesson_feedback.message, else: "En espera..."}
          </span>
        </div>
        <h2 class="text-lg font-bold text-slate-800">{current_step.text}</h2>
        <p class="text-sm text-slate-500">{current_step.hint}</p>
      </div>

      <div class="relative w-12 h-12 flex items-center justify-center shrink-0">
        <svg class="w-full h-full transform -rotate-90">
          <circle cx="24" cy="24" r="20" stroke="#f1f5f9" stroke-width="4" fill="none" />
          <circle
            cx="24"
            cy="24"
            r="20"
            stroke="#3b82f6"
            stroke-width="4"
            fill="none"
            stroke-dasharray="125.6"
            stroke-dashoffset={125.6 - 125.6 * @progress_percent}
            class="transition-all duration-500 ease-out"
          />
        </svg>
      </div>
    </div>
    """
  end

  defp calculate_progress(lesson, current_index, lesson_state) do
    if lesson_state && Map.get(lesson_state, :target_duration_ms, 0) > 0 do
      elapsed = Map.get(lesson_state, :elapsed_practice_ms, 0)
      target = lesson_state.target_duration_ms
      percent = min(1.0, elapsed / target)

      remaining_ms = max(0, target - elapsed)
      remaining_mins = div(remaining_ms, 60_000)
      remaining_secs = div(rem(remaining_ms, 60_000), 1_000)

      time_text =
        "#{remaining_mins}:#{remaining_secs |> Integer.to_string() |> String.pad_leading(2, "0")}"

      loop_text =
        if Map.get(lesson_state, :loop_count, 0) > 0,
          do: " (Vuelta #{lesson_state.loop_count + 1})",
          else: ""

      {percent, "Tiempo restante: #{time_text}#{loop_text}"}
    else
      total = length(lesson.steps)
      percent = if total > 0, do: current_index / total, else: 0
      {percent, "Paso #{current_index + 1} de #{total}"}
    end
  end
end
