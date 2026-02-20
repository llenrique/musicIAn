defmodule MusicIan.Practice.FSM.LessonFSM do
  @moduledoc """
  Finite State Machine para control de flujo de lecciones.
  Combina gestión de estado FSM CON lógica de validación de notas/steps.
  Fuente única de verdad para todo el estado de ejecución de una lección.

  States:
  - :intro      - Lección cargada, esperando elección del usuario (demo o práctica)
  - :demo       - Reproduciendo demo automático
  - :post_demo  - Demo terminado, usuario puede repetir o practicar
  - :countdown  - Cuenta atrás de 10 segundos antes de práctica
  - :active     - Fase de práctica, usuario toca, sistema valida
  - :paused     - Práctica pausada (puede reanudar o detener)
  - :stopped    - Práctica detenida
  - :summary    - Práctica finalizada, mostrando resultados

  Step types (campo :type en cada step):
  - "practice"    - Nota individual a validar. step[:note] debe coincidir.
  - "chord"       - Múltiples notas simultáneas. step[:notes] debe coincidir.
  - "generated"   - Ejercicio generado dinámicamente por ExerciseGenerator.

  Motor temporal:
  - Cada lección define un BPM sugerido y timing_strictness (0-5).
  - Al transicionar a :active se pre-calcula un beat_map con la posición
    temporal esperada de cada step.
  - timing_strictness 0 = standby (sin penalización por timing).
  - Valores mayores penalizan progresivamente el destiempo.
  """

  alias MusicIan.MusicCore.Note
  alias MusicIan.Practice.ExerciseGenerator
  alias MusicIan.Practice.Helper.LessonHelperConvert
  alias MusicIan.Practice.Manager.LessonManager

  # Mapa de penalización por timing: strictness level → porcentaje máximo de penalización
  @timing_penalties %{0 => 0, 1 => 1, 2 => 3, 3 => 5, 4 => 10, 5 => 20}

  defstruct [
    :current_state,
    :lesson_id,
    :lesson,
    :step_index,
    :stats,
    :feedback,
    :step_analysis,
    :countdown,
    :metronome_active,
    # For :generated steps: holds the dynamically generated exercise
    :current_exercise,
    # Motor temporal
    :bpm,
    :time_signature,
    :timing_strictness,
    :practice_start_time,
    :beat_map
  ]

  @type state :: %__MODULE__{}
  @type lesson_phase ::
          :intro | :demo | :post_demo | :countdown | :active | :paused | :stopped | :summary

  # -------------------------------------------------------------------------
  # Initialization
  # -------------------------------------------------------------------------

  @doc """
  Crea nueva instancia FSM para una lección. Carga desde DB via LessonManager.
  """
  def new(lesson_id) do
    case LessonManager.get_lesson(lesson_id) do
      nil ->
        {:error, :not_found}

      lesson_schema ->
        lesson = LessonHelperConvert.schema_to_map(lesson_schema)

        {:ok,
         %__MODULE__{
           current_state: :intro,
           lesson_id: lesson_id,
           lesson: lesson,
           step_index: 0,
           stats: %{correct: 0, errors: 0, timing_penalty_total: 0},
           feedback: nil,
           step_analysis: [],
           countdown: nil,
           metronome_active: false,
           current_exercise: nil,
           bpm: lesson[:bpm] || 60,
           time_signature: lesson[:time_signature] || "4/4",
           timing_strictness: lesson[:timing_strictness] || 0,
           practice_start_time: nil,
           beat_map: nil
         }}
    end
  end

  # -------------------------------------------------------------------------
  # FSM Transitions
  # -------------------------------------------------------------------------

  @doc "Transición a fase demo."
  def transition_to_demo(%__MODULE__{current_state: state} = fsm)
      when state in [:intro, :post_demo, :stopped] do
    {:ok, %{fsm | current_state: :demo, step_index: 0, countdown: nil}}
  end

  def transition_to_demo(_fsm), do: {:error, :invalid_transition}

  @doc "Demo terminado, ir a post_demo."
  def transition_to_post_demo(%__MODULE__{current_state: :demo} = fsm) do
    {:ok, %{fsm | current_state: :post_demo}}
  end

  def transition_to_post_demo(_fsm), do: {:error, :invalid_transition}

  @doc """
  Iniciar cuenta atrás de práctica.
  Acepta BPM opcional (el usuario puede haberlo cambiado antes de iniciar).
  """
  def transition_to_countdown(fsm, bpm \\ nil)

  def transition_to_countdown(%__MODULE__{current_state: state} = fsm, bpm)
      when state in [:intro, :post_demo, :countdown, :paused, :stopped] do
    active_bpm = bpm || fsm.bpm

    {:ok,
     %{
       fsm
       | current_state: :countdown,
         step_index: 0,
         stats: %{correct: 0, errors: 0, timing_penalty_total: 0},
         feedback: nil,
         step_analysis: [],
         countdown: 10,
         metronome_active: false,
         current_exercise: nil,
         bpm: active_bpm,
         beat_map: nil,
         practice_start_time: nil
     }}
  end

  def transition_to_countdown(_fsm, _bpm), do: {:error, :invalid_transition}

  @doc "Handler de tick de cuenta atrás."
  def handle_countdown_tick(%__MODULE__{current_state: :countdown, countdown: 10} = fsm) do
    metronome_enabled = Map.get(fsm.lesson, :metronome, false)
    {:countdown_tick_10, %{fsm | countdown: 9, metronome_active: metronome_enabled}}
  end

  def handle_countdown_tick(%__MODULE__{current_state: :countdown, countdown: cd} = fsm)
      when cd > 0 do
    {:countdown_tick, %{fsm | countdown: cd - 1}}
  end

  def handle_countdown_tick(%__MODULE__{current_state: :countdown, countdown: 0} = fsm) do
    metronome_enabled = Map.get(fsm.lesson, :metronome, false)

    # Pre-calcular beat_map y generar ejercicio si el primer step es :generated
    fsm_with_exercise = maybe_generate_exercise(fsm)
    beat_map = calculate_beat_map(fsm_with_exercise)

    active_fsm =
      %{
        fsm_with_exercise
        | current_state: :active,
          metronome_active: metronome_enabled,
          practice_start_time: NaiveDateTime.utc_now(),
          beat_map: beat_map
      }
      |> skip_to_next_playable()

    {:transition_to_active, active_fsm}
  end

  def handle_countdown_tick(_fsm), do: {:error, :invalid_transition}

  @doc "Finalizar práctica y mostrar resumen."
  def transition_to_summary(%__MODULE__{current_state: state} = fsm)
      when state in [:active, :paused] do
    {:ok, %{fsm | current_state: :summary}}
  end

  def transition_to_summary(_fsm), do: {:error, :invalid_transition}

  @doc "Pausar práctica activa."
  def pause_practice(%__MODULE__{current_state: :active} = fsm) do
    {:ok, %{fsm | current_state: :paused, metronome_active: false}}
  end

  def pause_practice(_fsm), do: {:error, :invalid_transition}

  @doc "Reanudar práctica pausada."
  def resume_practice(%__MODULE__{current_state: :paused} = fsm) do
    metronome_enabled = Map.get(fsm.lesson, :metronome, false)
    {:ok, %{fsm | current_state: :active, metronome_active: metronome_enabled}}
  end

  def resume_practice(_fsm), do: {:error, :invalid_transition}

  @doc "Detener práctica."
  def stop_practice(%__MODULE__{current_state: state} = fsm)
      when state in [:countdown, :active, :paused] do
    {:ok, %{fsm | current_state: :stopped, metronome_active: false}}
  end

  def stop_practice(_fsm), do: {:error, :invalid_transition}

  @doc "Reiniciar lección a estado intro."
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
         metronome_active: false,
         current_exercise: nil,
         beat_map: nil,
         practice_start_time: nil
     }}
  end

  # -------------------------------------------------------------------------
  # Beat Map & Practice Duration
  # -------------------------------------------------------------------------

  @doc """
  Pre-calcula en qué beat cae cada step basándose en las duraciones acumuladas.
  """
  def calculate_beat_map(%__MODULE__{} = fsm) do
    beat_duration_ms = 60_000 / fsm.bpm

    fsm.lesson.steps
    |> Enum.reduce({0, []}, fn step, {acc_beat, entries} ->
      duration = step[:duration] || 1

      entry = %{
        step: length(entries),
        beat: acc_beat,
        duration: duration,
        expected_ms: trunc(acc_beat * beat_duration_ms)
      }

      {acc_beat + duration, entries ++ [entry]}
    end)
    |> elem(1)
  end

  @doc """
  Calcula la duración total de la práctica en milisegundos basada en el beat_map.
  """
  def calculate_practice_duration(%__MODULE__{} = fsm) do
    total_beats =
      Enum.reduce(fsm.lesson.steps, 0, fn step, acc ->
        acc + (step[:duration] || 1)
      end)

    beat_duration_ms = 60_000 / fsm.bpm
    trunc(total_beats * beat_duration_ms)
  end

  # -------------------------------------------------------------------------
  # Note Validation
  # -------------------------------------------------------------------------

  @doc """
  Punto de entrada principal para validación de notas durante fase :active.

  Tipos de step soportados:
  - "practice"  → valida coincidencia de nota individual
  - "chord"     → valida todas las notas sostenidas simultáneamente
  - "generated" → valida contra current_exercise.target_note

  Retorna:
  - {:continue, new_fsm}   — step correcto, quedan más steps
  - {:completed, new_fsm}  — step correcto, lección terminada
  - {:error, new_fsm}      — nota incorrecta
  - {:ignore, new_fsm}     — información insuficiente (acorde incompleto)
  """
  def validate_note(fsm, held_notes, latest_midi, timing_info \\ nil)

  def validate_note(
        %__MODULE__{current_state: :active} = fsm,
        held_notes,
        latest_midi,
        timing_info
      ) do
    current_step = Enum.at(fsm.lesson.steps, fsm.step_index)

    cond do
      is_nil(current_step) ->
        {:ignore, fsm}

      observation_step?(current_step) ->
        # Paso sin nota (note: 0 / nil): no penalizar, simplemente ignorar
        {:ignore, fsm}

      true ->
        resolved_type = step_type(current_step)
        do_validate(fsm, current_step, resolved_type, held_notes, latest_midi, timing_info)
    end
  end

  # Catch-all: ignorar validación cuando no está en fase :active
  def validate_note(fsm, _held, _midi, _timing), do: {:ignore, fsm}

  # -------------------------------------------------------------------------
  # Private: step type resolution
  # -------------------------------------------------------------------------

  defp step_type(step) do
    case step[:type] do
      t when t in ["practice", "chord", "generated"] -> t
      _ -> infer_step_type(step)
    end
  end

  defp infer_step_type(step) do
    cond do
      is_list(step[:notes]) and length(step[:notes]) > 1 -> "chord"
      not is_nil(step[:generator]) -> "generated"
      true -> "practice"
    end
  end

  # -------------------------------------------------------------------------
  # Private: validation dispatch
  # -------------------------------------------------------------------------

  defp do_validate(fsm, step, "practice", _held, latest_midi, timing_info) do
    target = step[:note]

    if latest_midi == target do
      do_success(fsm, timing_info)
    else
      do_error(fsm, latest_midi, target, timing_info)
    end
  end

  defp do_validate(fsm, step, "chord", held_notes, latest_midi, timing_info) do
    target_notes = step[:notes] || [step[:note]]
    target_set = MapSet.new(target_notes)
    held_set = MapSet.new(held_notes)

    all_held = MapSet.subset?(target_set, held_set)
    no_extras = MapSet.equal?(target_set, held_set)

    cond do
      all_held and no_extras ->
        do_success(fsm, timing_info)

      not MapSet.member?(target_set, latest_midi) ->
        do_error(fsm, latest_midi, target_notes, timing_info)

      not all_held ->
        {:ignore, fsm}

      true ->
        do_error(fsm, latest_midi, target_notes, timing_info)
    end
  end

  defp do_validate(fsm, _step, "generated", _held, latest_midi, timing_info) do
    case fsm.current_exercise do
      nil ->
        {:ignore, fsm}

      %{target_note: target} ->
        if latest_midi == target do
          do_success(fsm, timing_info)
        else
          do_error(fsm, latest_midi, target, timing_info)
        end
    end
  end

  # -------------------------------------------------------------------------
  # Private: success/error handlers
  # -------------------------------------------------------------------------

  defp do_success(fsm, timing_info) do
    current_step = Enum.at(fsm.lesson.steps, fsm.step_index)
    step_text = current_step[:text] || "Step #{fsm.step_index + 1}"

    next_index = fsm.step_index + 1
    total_steps = length(fsm.lesson.steps)

    {timing_status, timing_message} = evaluate_timing(timing_info)
    timing_penalty = calculate_timing_penalty(fsm.timing_strictness, timing_status)

    new_stats =
      fsm.stats
      |> Map.update!(:correct, &(&1 + 1))
      |> Map.update!(:timing_penalty_total, &(&1 + timing_penalty))

    message = build_success_message(timing_message, timing_penalty)

    step_record = %{
      step_index: fsm.step_index,
      step_text: step_text,
      notes: current_step[:notes] || [current_step[:note]],
      timing_status: timing_status,
      timing_deviation: (timing_info && timing_info["timingDeviation"]) || 0,
      timing_penalty: timing_penalty,
      status: :success,
      timestamp: NaiveDateTime.utc_now()
    }

    new_analysis = fsm.step_analysis ++ [step_record]

    next_fsm =
      %{
        fsm
        | stats: new_stats,
          step_index: next_index,
          step_analysis: new_analysis,
          feedback: %{status: :success, message: message},
          current_exercise: nil
      }
      |> maybe_generate_exercise()
      |> skip_to_next_playable()

    if next_fsm.step_index < total_steps do
      {:continue, next_fsm}
    else
      {:completed,
       %{
         next_fsm
         | current_state: :summary,
           metronome_active: false,
           feedback: %{status: :success, message: "¡Lección Completada!"}
       }}
    end
  end

  defp do_error(fsm, played_midi, target, timing_info) do
    current_step = Enum.at(fsm.lesson.steps, fsm.step_index)
    step_text = current_step[:text] || "Step #{fsm.step_index + 1}"

    new_stats = Map.update!(fsm.stats, :errors, &(&1 + 1))

    {_target_name, message} = build_error_message(played_midi, target)

    step_record = %{
      step_index: fsm.step_index,
      step_text: step_text,
      notes: current_step[:notes] || [current_step[:note]],
      played_note: played_midi,
      timing_status: :error,
      timing_deviation: (timing_info && timing_info["timingDeviation"]) || 0,
      timing_penalty: 0,
      status: :error,
      timestamp: NaiveDateTime.utc_now()
    }

    new_analysis = fsm.step_analysis ++ [step_record]

    {:error,
     %{
       fsm
       | stats: new_stats,
         step_analysis: new_analysis,
         feedback: %{status: :error, message: message}
     }}
  end

  # -------------------------------------------------------------------------
  # Private: timing evaluation & penalty
  # -------------------------------------------------------------------------

  defp evaluate_timing(nil), do: {:unknown, ""}

  defp evaluate_timing(timing_info) do
    note_relative = Map.get(timing_info, "noteRelativeTime", 0)
    expected_beat = Map.get(timing_info, "expectedBeat")
    beat_duration = Map.get(timing_info, "beatDurationMs", 500)
    tolerance = Map.get(timing_info, "toleranceMs", 150)

    case expected_beat do
      nil -> evaluate_timing_fallback(timing_info)
      _ -> classify_deviation(note_relative - expected_beat * beat_duration, tolerance)
    end
  end

  defp classify_deviation(deviation, tolerance) do
    cond do
      abs(deviation) <= tolerance -> {:on_time, ""}
      deviation < -tolerance -> {:early, early_message(abs(trunc(deviation)))}
      deviation > tolerance -> {:late, late_message(trunc(deviation))}
      true -> {:unknown, ""}
    end
  end

  # Mensajes de timing: mostrar desde 100ms de desviación (un beat lento/rápido es muy perceptible)
  defp early_message(abs_dev) when abs_dev > 100, do: "Un poco rápido (#{abs_dev}ms)"
  defp early_message(_), do: ""

  defp late_message(dev) when dev > 100, do: "Un poco lento (#{dev}ms)"
  defp late_message(_), do: ""

  defp evaluate_timing_fallback(%{"timingStatus" => "on-time"}), do: {:on_time, ""}

  # Manejar tanto "error" como "warning" del cliente
  defp evaluate_timing_fallback(%{"timingSeverity" => sev, "timingStatus" => status})
       when sev in ["error", "warning"] do
    case status do
      "between-beats" -> {:late, "Fuera de tiempo"}
      "early" -> {:early, "Demasiado rápido"}
      "late" -> {:late, "Demasiado lento"}
      _ -> {:unknown, ""}
    end
  end

  defp evaluate_timing_fallback(_), do: {:unknown, ""}

  defp calculate_timing_penalty(strictness, timing_status) do
    max_penalty = Map.get(@timing_penalties, strictness, 0)

    if max_penalty == 0 or timing_status not in [:early, :late] do
      0
    else
      max_penalty
    end
  end

  defp build_success_message("", 0), do: "¡Correcto!"
  defp build_success_message(msg, 0), do: "¡Correcto! #{msg}"

  defp build_success_message("", penalty),
    do: "¡Correcto! (timing: -#{penalty}%)"

  defp build_success_message(msg, penalty),
    do: "¡Correcto! #{msg} (timing: -#{penalty}%)"

  # -------------------------------------------------------------------------
  # Private: error message generation
  # -------------------------------------------------------------------------

  defp build_error_message(played_midi, target) when is_list(target) do
    played_name = Note.new(played_midi).name
    target_names = Enum.map_join(target, " + ", fn n -> Note.new(n).name end)
    {target_names, "Has tocado #{played_name}. Busca: #{target_names}."}
  end

  defp build_error_message(played_midi, target) when is_integer(target) do
    played_name = Note.new(played_midi).name
    target_name = Note.new(target).name

    message =
      cond do
        played_name == target_name ->
          "Es la nota correcta (#{played_name}), pero en la octava equivocada."

        abs(played_midi - target) <= 2 ->
          diff = abs(played_midi - target)
          "¡Casi! Estás a #{diff} semitono(s) de #{target_name}."

        true ->
          "Has tocado #{played_name}. Busca la nota #{target_name}."
      end

    {target_name, message}
  end

  # -------------------------------------------------------------------------
  # Private: observation step detection & skip
  # -------------------------------------------------------------------------

  # Un paso de observación no tiene nota tocable (note: 0 o nil).
  # Se usan para instrucciones de conteo/pausa en el demo, pero en práctica
  # se saltan automáticamente para no confundir ni penalizar al estudiante.
  defp observation_step?(nil), do: true
  defp observation_step?(step), do: is_nil(step[:note]) or step[:note] == 0

  # Avanza step_index hasta el primer paso que requiere tocar una nota.
  defp skip_to_next_playable(%__MODULE__{} = fsm) do
    total = length(fsm.lesson.steps)
    do_skip_playable(fsm, total)
  end

  defp do_skip_playable(%__MODULE__{step_index: idx} = fsm, total) when idx >= total, do: fsm

  defp do_skip_playable(%__MODULE__{step_index: idx} = fsm, total) do
    step = Enum.at(fsm.lesson.steps, idx)

    if observation_step?(step) do
      do_skip_playable(%{fsm | step_index: idx + 1}, total)
    else
      fsm
    end
  end

  # -------------------------------------------------------------------------
  # Private: exercise generation for :generated steps
  # -------------------------------------------------------------------------

  defp maybe_generate_exercise(%__MODULE__{} = fsm) do
    current_step = Enum.at(fsm.lesson.steps, fsm.step_index)

    if current_step && step_type(current_step) == "generated" do
      generator = current_step[:generator]
      params = current_step[:params] || %{}
      exercise = ExerciseGenerator.generate(generator, params)
      %{fsm | current_exercise: exercise}
    else
      %{fsm | current_exercise: nil}
    end
  end

  # -------------------------------------------------------------------------
  # Utility / Query
  # -------------------------------------------------------------------------

  @doc "Obtiene el step actual."
  def current_step(%__MODULE__{} = fsm) do
    Enum.at(fsm.lesson.steps, fsm.step_index)
  end

  @doc "Obtiene la fase actual."
  def current_phase(%__MODULE__{current_state: state}), do: state

  @doc "¿Metrónomo activo?"
  def metronome_enabled?(%__MODULE__{metronome_active: active}), do: active

  @doc "¿En práctica?"
  def practicing?(%__MODULE__{current_state: state}), do: state in [:countdown, :active]

  @doc "¿Pausado?"
  def paused?(%__MODULE__{current_state: state}), do: state == :paused

  @doc "Calcula porcentaje de precisión."
  def calculate_accuracy(%__MODULE__{stats: stats}) do
    total = stats.correct + stats.errors

    if total > 0 do
      base = stats.correct / total * 100
      penalty = Map.get(stats, :timing_penalty_total, 0)
      max(0.0, base - penalty)
    else
      0.0
    end
  end

  @doc "¿Aprobó la lección? (>= 80%)"
  def passed?(%__MODULE__{} = fsm), do: calculate_accuracy(fsm) >= 80.0
end
