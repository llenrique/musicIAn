defmodule MusicIan.Practice.FSM.LessonFSM do
  @moduledoc """
  Finite State Machine for lesson flow control.
  
  States:
  - :intro - Lesson loaded, waiting for user choice (demo or practice)
  - :demo - Playing automated demo
  - :post_demo - Demo finished, user can retry or go to practice
  - :countdown - 10 second countdown before practice (metronome activates at tick 10)
  - :active - Practice phase, user plays, system validates
  - :summary - Practice finished, showing results and options
  
  Transitions:
  intro → demo (user clicks "Ver Demo")
  intro → countdown (user clicks "Comenzar Práctica")
  demo → post_demo (demo finished)
  post_demo → demo (user clicks "Repetir Demo")
  post_demo → countdown (user clicks "Comenzar Práctica")
  countdown → active (countdown reaches 0)
  active → summary (lesson completed or time expired)
  summary → demo (user clicks "Siguiente Lección" → starts new lesson at intro)
  """

  defstruct [
    :current_state,
    :lesson_id,
    :lesson,
    :step_index,
    :stats,
    :feedback,
    :step_analysis,
    :countdown,
    :metronome_active
  ]

  @type state :: %__MODULE__{}
  @type lesson_phase :: :intro | :demo | :post_demo | :countdown | :active | :summary

  @doc """
  Create new FSM instance for a lesson.
  """
  def new(lesson_id) do
    case MusicIan.Practice.Manager.LessonManager.get_lesson(lesson_id) do
      nil ->
        {:error, :not_found}

      lesson_schema ->
        lesson = MusicIan.Practice.Helper.LessonHelperConvert.schema_to_map(lesson_schema)

        {:ok,
         %__MODULE__{
           current_state: :intro,
           lesson_id: lesson_id,
           lesson: lesson,
           step_index: 0,
           stats: %{correct: 0, errors: 0},
           feedback: nil,
           step_analysis: [],
           countdown: nil,
           metronome_active: false
         }}
    end
  end

  @doc """
  Transition to demo phase.
  """
  def transition_to_demo(%__MODULE__{current_state: :intro} = fsm) do
    {:ok, %{fsm | current_state: :demo}}
  end

  def transition_to_demo(%__MODULE__{current_state: :post_demo} = fsm) do
    {:ok, %{fsm | current_state: :demo}}
  end

  def transition_to_demo(_fsm), do: {:error, :invalid_transition}

  @doc """
  Demo finished, go to post_demo.
  """
  def transition_to_post_demo(%__MODULE__{current_state: :demo} = fsm) do
    {:ok, %{fsm | current_state: :post_demo}}
  end

  def transition_to_post_demo(_fsm), do: {:error, :invalid_transition}

  @doc """
  Start practice countdown. Metronome will activate at countdown=10.
  Can be called from :intro or :post_demo.
  """
  def transition_to_countdown(%__MODULE__{current_state: state} = fsm)
      when state in [:intro, :post_demo] do
    {:ok,
     %{
       fsm
       | current_state: :countdown,
         step_index: 0,
         stats: %{correct: 0, errors: 0},
         feedback: nil,
         step_analysis: [],
         countdown: 10,
         metronome_active: false
     }}
  end

  def transition_to_countdown(_fsm), do: {:error, :invalid_transition}

  @doc """
  Countdown tick. At countdown=10, activate metronome.
  At countdown=0, transition to active.
  """
  def handle_countdown_tick(%__MODULE__{current_state: :countdown, countdown: 10} = fsm) do
    # COUNTDOWN TICK 10: Activate metronome
    {:countdown_tick_10,
     %{fsm | countdown: 9, metronome_active: Map.get(fsm.lesson, :metronome, false)}}
  end

  def handle_countdown_tick(%__MODULE__{current_state: :countdown, countdown: cd} = fsm)
      when cd > 0 do
    # Regular countdown tick
    {:countdown_tick, %{fsm | countdown: cd - 1}}
  end

  def handle_countdown_tick(%__MODULE__{current_state: :countdown, countdown: 0} = fsm) do
    # Countdown finished, start active practice
    {:transition_to_active, %{fsm | current_state: :active, metronome_active: true}}
  end

  def handle_countdown_tick(_fsm), do: {:error, :invalid_transition}

  @doc """
  Finish practice and show summary.
  """
  def transition_to_summary(%__MODULE__{current_state: :active} = fsm) do
    {:ok, %{fsm | current_state: :summary}}
  end

  def transition_to_summary(_fsm), do: {:error, :invalid_transition}

  @doc """
  Get current phase for template rendering.
  """
  def current_phase(%__MODULE__{current_state: state}), do: state

  @doc """
  Check if metronome should be active.
  """
  def metronome_enabled?(%__MODULE__{metronome_active: active}), do: active
end
