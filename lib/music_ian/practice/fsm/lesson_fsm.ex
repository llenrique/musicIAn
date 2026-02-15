defmodule MusicIan.Practice.FSM.LessonFSM do
  @moduledoc """
  Finite State Machine for lesson flow control.
  
  States:
  - :intro - Lesson loaded, waiting for user choice (demo or practice)
  - :demo - Playing automated demo
  - :post_demo - Demo finished, user can retry or go to practice
  - :countdown - 10 second countdown before practice (metronome activates at tick 10)
  - :active - Practice phase, user plays, system validates
  - :paused - Practice paused (can resume or stop)
  - :stopped - Practice stopped (can retry from intro or summary)
  - :summary - Practice finished, showing results and options
  
  Main Flow (Happy Path):
  intro → demo → post_demo → countdown → active → summary
  
  Alternative Flows:
  intro → countdown (skip demo, go straight to practice)
  post_demo → demo (repeat demo)
  active → paused (pause practice)
  paused → active (resume practice)
  paused → stopped (stop practice, go back to intro)
  active → stopped (stop practice, go back to intro)
  active → summary (complete practice)
  summary → intro (next lesson or retry)
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
  @type lesson_phase :: :intro | :demo | :post_demo | :countdown | :active | :paused | :stopped | :summary

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
   Transition to demo phase. Can be called from intro, post_demo, or stopped.
   Resets stats but preserves lesson_id.
   """
   def transition_to_demo(%__MODULE__{current_state: state} = fsm)
       when state in [:intro, :post_demo, :stopped] do
     {:ok, %{fsm | 
       current_state: :demo,
       step_index: 0,
       countdown: nil
     }}
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
   Can be called from :intro, :post_demo, :countdown, :paused, or :stopped.
   Resets stats and countdown to 10.
   """
   def transition_to_countdown(%__MODULE__{current_state: state} = fsm)
       when state in [:intro, :post_demo, :countdown, :paused, :stopped] do
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
   Can be called from :active or :paused.
   """
   def transition_to_summary(%__MODULE__{current_state: state} = fsm)
       when state in [:active, :paused] do
     {:ok, %{fsm | current_state: :summary}}
   end

   def transition_to_summary(_fsm), do: {:error, :invalid_transition}

   @doc """
   Pause active practice. Can only pause from :active.
   """
   def pause_practice(%__MODULE__{current_state: :active} = fsm) do
     {:ok, %{fsm | current_state: :paused, metronome_active: false}}
   end

   def pause_practice(_fsm), do: {:error, :invalid_transition}

   @doc """
   Resume paused practice. Can only resume from :paused.
   """
   def resume_practice(%__MODULE__{current_state: :paused} = fsm) do
     {:ok, %{fsm | current_state: :active, metronome_active: true}}
   end

   def resume_practice(_fsm), do: {:error, :invalid_transition}

   @doc """
   Stop practice and return to intro. Can be called from :countdown, :active, or :paused.
   Preserves current stats and step_analysis but goes back to intro state.
   """
   def stop_practice(%__MODULE__{current_state: state} = fsm)
       when state in [:countdown, :active, :paused] do
     {:ok, %{fsm | current_state: :stopped, metronome_active: false}}
   end

   def stop_practice(_fsm), do: {:error, :invalid_transition}

   @doc """
   Reset lesson to intro state. Used after completing or failing a lesson.
   """
   def reset_to_intro(%__MODULE__{} = fsm) do
     {:ok,
      %{
        fsm
        | current_state: :intro,
          step_index: 0,
          stats: %{correct: 0, errors: 0},
          feedback: nil,
          step_analysis: [],
          countdown: nil,
          metronome_active: false
      }}
   end

   @doc """
   Get current phase for template rendering.
   """
   def current_phase(%__MODULE__{current_state: state}), do: state

   @doc """
   Check if metronome should be active.
   """
   def metronome_enabled?(%__MODULE__{metronome_active: active}), do: active

   @doc """
   Check if practice is currently in an active playing state.
   """
   def is_practicing?(%__MODULE__{current_state: state}), do: state in [:countdown, :active]

   @doc """
   Check if practice is paused.
   """
   def is_paused?(%__MODULE__{current_state: state}), do: state == :paused
 end
