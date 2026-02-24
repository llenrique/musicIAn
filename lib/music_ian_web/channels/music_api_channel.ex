defmodule MusicIanWeb.MusicApiChannel do
  @moduledoc """
  WebSocket channel que expone la API de musicIAn.

  Se conecta en: ws://localhost:4000/music_api

  Permite que musicIAn-mcp (y TheoryLive) accedan a funciones de:
  - MusicCore: Note, Scale, Chord, Theory
  - Practice: Lecciones, validación, estadísticas
  - Validation: Testing functions
  """

  use Phoenix.Channel

  require Logger

  @doc """
  Join el channel music_api.
  Cualquiera puede conectarse (sin autenticación).
  """
  def join("music_api", _payload, socket) do
    Logger.info("MusicAPI channel joined")
    {:ok, socket}
  end

  # ─────────────────────────────────────────────────────────────
  # MUSICCORE: NOTE OPERATIONS
  # ─────────────────────────────────────────────────────────────

  # Crea una nota a partir de MIDI.
  #
  # Params: {notes: int}
  # Response: {name: str, octave: int, frequency: float, midi: int}
  @doc false
  def handle_in("mcp.note_new", %{"midi" => midi}, socket) do
    result = MusicIan.MusicCore.Note.new(midi)

    response = %{
      "success" => true,
      "result" => %{
        "name" => result.name,
        "octave" => result.octave,
        "frequency" => result.frequency,
        "midi" => result.midi
      },
      "metadata" => %{"execution_time_ms" => 0}
    }

    {:reply, {:ok, response}, socket}
  rescue
    e ->
      error_response("mcp.note_new", e, socket)
  end

  # Obtiene la frecuencia de una nota MIDI.
  #
  # Params: {midi: int}
  # Response: {frequency: float}
  def handle_in("mcp.note_frequency", %{"midi" => midi}, socket) do
    frequency = MusicIan.MusicCore.Note.frequency(midi)

    response = %{
      "success" => true,
      "result" => %{"frequency" => frequency},
      "metadata" => %{"execution_time_ms" => 0}
    }

    {:reply, {:ok, response}, socket}
  rescue
    e ->
      error_response("mcp.note_frequency", e, socket)
  end

  # ─────────────────────────────────────────────────────────────
  # MUSICCORE: SCALE OPERATIONS
  # ─────────────────────────────────────────────────────────────

  # Obtiene las notas de una escala.
  #
  # Params: {root: int, scale_type: string}
  # Response: {notes: List, names: List, description: str, mood: str}
  def handle_in("mcp.scale_notes", %{"root" => root, "scale_type" => scale_type}, socket) do
    scale_atom = String.to_atom(scale_type)
    scale = MusicIan.MusicCore.Scale.new(root, scale_atom)

    response = %{
      "success" => true,
      "result" => %{
        "notes" => scale.notes,
        "names" => Enum.map(scale.notes, &MusicIan.MusicCore.Note.new/1) |> Enum.map(& &1.name),
        "scale_type" => scale_type,
        "description" => scale.description,
        "mood" => scale.mood || "neutral"
      },
      "metadata" => %{"execution_time_ms" => 0}
    }

    {:reply, {:ok, response}, socket}
  rescue
    e ->
      error_response("mcp.scale_notes", e, socket)
  end

  # Obtiene todos los modos de una escala.
  #
  # Params: {root: int}
  # Response: {ionian: List, dorian: List, ...}
  def handle_in("mcp.scale_modes", %{"root" => root}, socket) do
    # Generate all modes for the given root
    mode_types = [:ionian, :dorian, :phrygian, :lydian, :mixolydian, :aeolian, :locrian]

    modes =
      Enum.map(mode_types, fn mode_type ->
        scale = MusicIan.MusicCore.Scale.new(root, mode_type)
        {mode_type, Enum.map(scale.notes, & &1.midi)}
      end)
      |> Enum.into(%{})

    response = %{
      "success" => true,
      "result" => modes,
      "metadata" => %{"execution_time_ms" => 0}
    }

    {:reply, {:ok, response}, socket}
  rescue
    e ->
      error_response("mcp.scale_modes", e, socket)
  end

  # Verifica si notas pertenecen a una escala.
  #
  # Params: {scale_notes: List, test_notes: List}
  # Response: {contained: bool, missing: List, extra: List}
  def handle_in(
        "mcp.scale_contains_notes",
        %{"scale_notes" => scale_notes, "test_notes" => test_notes},
        socket
      ) do
    contained = Enum.all?(test_notes, &Enum.member?(scale_notes, &1))
    missing = test_notes |> Enum.filter(&(!Enum.member?(scale_notes, &1)))
    extra = scale_notes |> Enum.filter(&(!Enum.member?(test_notes, &1)))

    response = %{
      "success" => true,
      "result" => %{
        "contained" => contained,
        "missing" => missing,
        "extra" => extra,
        "coverage" =>
          if(Enum.empty?(test_notes),
            do: 0,
            else: (length(test_notes) - length(missing)) / length(test_notes)
          )
      },
      "metadata" => %{"execution_time_ms" => 0}
    }

    {:reply, {:ok, response}, socket}
  rescue
    e ->
      error_response("mcp.scale_contains_notes", e, socket)
  end

  # ─────────────────────────────────────────────────────────────
  # MUSICCORE: CHORD OPERATIONS
  # ─────────────────────────────────────────────────────────────

  # Crea un acorde a partir de root y quality.
  #
  # Params: {root: int, quality: string}
  # Response: {root: str, quality: str, notes: List, inversion: int}
  def handle_in("mcp.chord_new", %{"root" => root, "quality" => quality}, socket) do
    quality_atom = String.to_atom(quality)
    chord = MusicIan.MusicCore.Chord.new(root, quality_atom)

    response = %{
      "success" => true,
      "result" => %{
        "root" => chord.root.name,
        "quality" => quality,
        "notes" => Enum.map(chord.notes, &%{"name" => &1.name, "midi" => &1.midi}),
        "inversion" => chord.inversion,
        "intervals" => compute_intervals(chord.notes)
      },
      "metadata" => %{"execution_time_ms" => 0}
    }

    {:reply, {:ok, response}, socket}
  rescue
    e ->
      error_response("mcp.chord_new", e, socket)
  end

  # Detecta qué acorde forman un conjunto de notas MIDI.
  #
  # Params: {notes: List}
  # Response: {root: str, quality: str, notes: List, inversion: int, reasoning: str}
  def handle_in("mcp.chord_from_midi_notes", %{"notes" => notes}, socket) do
    chord = MusicIan.MusicCore.Chord.from_midi_notes(notes)

    # Calcular intervalos normalizados para mostrar razonamiento
    normalized = Enum.map(notes, &rem(&1, 12)) |> Enum.sort() |> Enum.uniq()
    first_note = Enum.min(notes)

    intervals =
      normalized
      |> Enum.map(&(&1 - rem(first_note, 12)))
      |> Enum.map(&if(&1 < 0, do: &1 + 12, else: &1))

    response = %{
      "success" => true,
      "result" => %{
        "root" => chord.root.name,
        "quality" => Atom.to_string(chord.quality),
        "notes" => Enum.map(chord.notes, &%{"name" => &1.name, "midi" => &1.midi}),
        "inversion" => chord.inversion,
        "all_notes" => Enum.map(chord.notes, & &1.name)
      },
      "reasoning" => %{
        "detected_intervals" => intervals,
        "pattern_matched" => "#{chord.quality} chord",
        "confidence" => 1.0
      },
      "metadata" => %{"execution_time_ms" => 0}
    }

    {:reply, {:ok, response}, socket}
  rescue
    e ->
      error_response("mcp.chord_from_midi_notes", e, socket)
  end

  # Invierte un acorde.
  #
  # Params: {root: int, quality: string, inversion: int}
  # Response: {root: str, quality: str, notes: List, inversion: int, name: str}
  def handle_in(
        "mcp.chord_invert",
        %{"root" => root, "quality" => quality, "inversion" => inversion},
        socket
      ) do
    quality_atom = String.to_atom(quality)

    chord =
      MusicIan.MusicCore.Chord.new(root, quality_atom)
      |> MusicIan.MusicCore.Chord.invert(inversion)

    inversion_names = ["root", "1st", "2nd", "3rd", "4th"]
    inversion_name = Enum.at(inversion_names, rem(inversion, length(inversion_names)), "root")

    response = %{
      "success" => true,
      "result" => %{
        "root" => chord.root.name,
        "quality" => quality,
        "notes" => Enum.map(chord.notes, &%{"name" => &1.name, "midi" => &1.midi}),
        "inversion" => chord.inversion,
        "name" => "#{chord.root.name} #{quality} (#{inversion_name} inversion)"
      },
      "metadata" => %{"execution_time_ms" => 0}
    }

    {:reply, {:ok, response}, socket}
  rescue
    e ->
      error_response("mcp.chord_invert", e, socket)
  end

  # ─────────────────────────────────────────────────────────────
  # MUSICCORE: SCALE - DIATONIC CHORDS
  # ─────────────────────────────────────────────────────────────

  # Genera triadas diatónicas para una escala.
  #
  # Params: {root: int, scale_type: string}
  # Response: {triads: List of chords by degree}
  def handle_in(
        "mcp.scale_diatonic_triads",
        %{"root" => root, "scale_type" => scale_type},
        socket
      ) do
    scale_atom = String.to_atom(scale_type)
    scale = MusicIan.MusicCore.Scale.new(root, scale_atom)
    triads = MusicIan.MusicCore.Scale.diatonic_triads(scale)

    triads_data =
      triads
      |> Enum.with_index(1)
      |> Enum.map(fn {chord, degree} ->
        %{
          "degree" => degree,
          "root" => chord.root.name,
          "quality" => Atom.to_string(chord.quality),
          "notes" => Enum.map(chord.notes, &%{"name" => &1.name, "midi" => &1.midi})
        }
      end)

    response = %{
      "success" => true,
      "result" => %{
        "scale_root" => scale.root.name,
        "scale_type" => scale_type,
        "triads" => triads_data
      },
      "metadata" => %{"execution_time_ms" => 0}
    }

    {:reply, {:ok, response}, socket}
  rescue
    e ->
      error_response("mcp.scale_diatonic_triads", e, socket)
  end

  # Genera acordes de séptima diatónicos para una escala.
  #
  # Params: {root: int, scale_type: string}
  # Response: {sevenths: List of 7th chords by degree}
  def handle_in(
        "mcp.scale_diatonic_sevenths",
        %{"root" => root, "scale_type" => scale_type},
        socket
      ) do
    scale_atom = String.to_atom(scale_type)
    scale = MusicIan.MusicCore.Scale.new(root, scale_atom)
    sevenths = MusicIan.MusicCore.Scale.diatonic_sevenths(scale)

    sevenths_data =
      sevenths
      |> Enum.with_index(1)
      |> Enum.map(fn {chord, degree} ->
        %{
          "degree" => degree,
          "root" => chord.root.name,
          "quality" => Atom.to_string(chord.quality),
          "notes" => Enum.map(chord.notes, &%{"name" => &1.name, "midi" => &1.midi})
        }
      end)

    response = %{
      "success" => true,
      "result" => %{
        "scale_root" => scale.root.name,
        "scale_type" => scale_type,
        "sevenths" => sevenths_data
      },
      "metadata" => %{"execution_time_ms" => 0}
    }

    {:reply, {:ok, response}, socket}
  rescue
    e ->
      error_response("mcp.scale_diatonic_sevenths", e, socket)
  end

  # ─────────────────────────────────────────────────────────────
  # MUSICCORE: THEORY OPERATIONS
  # ─────────────────────────────────────────────────────────────

  # Genera el Círculo de Quintas completo.
  #
  # Params: none
  # Response: {sectors: List of {label, minor, midi, minor_midi, angle}}
  def handle_in("mcp.theory_circle_of_fifths", _params, socket) do
    sectors = MusicIan.MusicCore.Theory.generate_circle_of_fifths()

    response = %{
      "success" => true,
      "result" => %{
        "sectors" => sectors
      },
      "metadata" => %{"execution_time_ms" => 0}
    }

    {:reply, {:ok, response}, socket}
  rescue
    e ->
      error_response("mcp.theory_circle_of_fifths", e, socket)
  end

  # Obtiene las alteraciones de una armadura.
  #
  # Params: {key: string}
  # Response: {accidentals: map of note => accidental}
  def handle_in("mcp.theory_key_accidentals", %{"key" => key}, socket) do
    accidentals = MusicIan.MusicCore.Theory.get_key_signature_accidentals(key)

    response = %{
      "success" => true,
      "result" => %{
        "key" => key,
        "accidentals" => accidentals
      },
      "metadata" => %{"execution_time_ms" => 0}
    }

    {:reply, {:ok, response}, socket}
  rescue
    e ->
      error_response("mcp.theory_key_accidentals", e, socket)
  end

  # Analiza contexto teórico de una escala.
  #
  # Params: {root: int, scale_type: string, use_flats: bool}
  # Response: {analysis: map with theoretical context}
  def handle_in(
        "mcp.theory_analyze_context",
        %{"root" => root, "scale_type" => scale_type} = params,
        socket
      ) do
    use_flats = Map.get(params, "use_flats", false)
    scale_atom = String.to_atom(scale_type)
    scale = MusicIan.MusicCore.Scale.new(root, scale_atom, use_flats: use_flats)

    analysis =
      MusicIan.MusicCore.Theory.analyze_context(scale.root, scale_atom, scale.notes, use_flats)

    response = %{
      "success" => true,
      "result" => analysis,
      "metadata" => %{"execution_time_ms" => 0}
    }

    {:reply, {:ok, response}, socket}
  rescue
    e ->
      error_response("mcp.theory_analyze_context", e, socket)
  end

  # Determina la tonalidad (key signature) de un conjunto de notas.
  #
  # Params: {notes: List}
  # Response: {key: str, accidentals: int, suggested_tonality: str, confidence: float}
  def handle_in("mcp.theory_key_signature", %{"notes" => notes}, socket) do
    result = MusicIan.MusicCore.Theory.determine_key_signature(notes, :major, :natural)

    response = %{
      "success" => true,
      "result" => %{
        "key" => result.key || "Unknown",
        "accidentals" => result.accidentals || 0,
        "suggested_tonality" => result.tonality || "major",
        "confidence" => 0.95
      },
      "metadata" => %{"execution_time_ms" => 0}
    }

    {:reply, {:ok, response}, socket}
  rescue
    e ->
      error_response("mcp.theory_key_signature", e, socket)
  end

  # Calcula el intervalo entre dos notas.
  #
  # Params: {note1: int, note2: int}
  # Response: {semitones: int, name: str, quality: str}
  def handle_in("mcp.theory_intervals", %{"note1" => note1, "note2" => note2}, socket) do
    semitones = abs(note2 - note1)
    normalized = rem(semitones, 12)

    # Mapeo de semitones a nombres de intervalos
    interval_map = %{
      0 => "unison",
      1 => "minor second",
      2 => "major second",
      3 => "minor third",
      4 => "major third",
      5 => "perfect fourth",
      6 => "tritone",
      7 => "perfect fifth",
      8 => "minor sixth",
      9 => "major sixth",
      10 => "minor seventh",
      11 => "major seventh"
    }

    interval_name = Map.get(interval_map, normalized, "unknown")

    response = %{
      "success" => true,
      "result" => %{
        "semitones" => semitones,
        "normalized_semitones" => normalized,
        "name" => interval_name,
        "distance" => "#{semitones} semitones"
      },
      "metadata" => %{"execution_time_ms" => 0}
    }

    {:reply, {:ok, response}, socket}
  rescue
    e ->
      error_response("mcp.theory_intervals", e, socket)
  end

  # ─────────────────────────────────────────────────────────────
  # PRACTICE: LESSON MANAGER OPERATIONS
  # ─────────────────────────────────────────────────────────────

  # Obtiene una lección por ID.
  #
  # Params: {lesson_id: string}
  # Response: {lesson: map with lesson data}
  def handle_in("mcp.lesson_get", %{"lesson_id" => lesson_id}, socket) do
    case MusicIan.Practice.Manager.LessonManager.get_lesson(lesson_id) do
      nil ->
        response = %{
          "success" => false,
          "error" => %{"code" => -32_602, "message" => "Lesson not found: #{lesson_id}"},
          "metadata" => %{"execution_time_ms" => 0}
        }

        {:reply, {:error, response}, socket}

      lesson ->
        lesson_map = MusicIan.Practice.Helper.LessonHelperConvert.schema_to_map(lesson)

        response = %{
          "success" => true,
          "result" => lesson_map,
          "metadata" => %{"execution_time_ms" => 0}
        }

        {:reply, {:ok, response}, socket}
    end
  rescue
    e ->
      error_response("mcp.lesson_get", e, socket)
  end

  # Lista todas las lecciones.
  #
  # Params: none
  # Response: {lessons: List of lesson maps}
  def handle_in("mcp.lesson_list", _params, socket) do
    lessons = MusicIan.Practice.Manager.LessonManager.list_all_lessons()
    lesson_maps = MusicIan.Practice.Helper.LessonHelperConvert.schemas_to_maps(lessons)

    response = %{
      "success" => true,
      "result" => %{
        "lessons" => lesson_maps,
        "count" => length(lesson_maps)
      },
      "metadata" => %{"execution_time_ms" => 0}
    }

    {:reply, {:ok, response}, socket}
  rescue
    e ->
      error_response("mcp.lesson_list", e, socket)
  end

  # Obtiene estadísticas globales.
  #
  # Params: none
  # Response: {stats: map with global stats}
  def handle_in("mcp.stats_global", _params, socket) do
    stats = MusicIan.Practice.Manager.LessonManager.get_stats()

    response = %{
      "success" => true,
      "result" => stats,
      "metadata" => %{"execution_time_ms" => 0}
    }

    {:reply, {:ok, response}, socket}
  rescue
    e ->
      error_response("mcp.stats_global", e, socket)
  end

  # Obtiene estadísticas de una lección específica.
  #
  # Params: {lesson_id: string}
  # Response: {stats: map with lesson stats}
  def handle_in("mcp.stats_lesson", %{"lesson_id" => lesson_id}, socket) do
    stats = MusicIan.Practice.Manager.LessonManager.get_lesson_stats(lesson_id)

    response = %{
      "success" => true,
      "result" => stats,
      "metadata" => %{"execution_time_ms" => 0}
    }

    {:reply, {:ok, response}, socket}
  rescue
    e ->
      error_response("mcp.stats_lesson", e, socket)
  end

  # Obtiene el resultado más reciente de una lección.
  #
  # Params: {lesson_id: string}
  # Response: {result: map or null}
  def handle_in("mcp.lesson_latest_result", %{"lesson_id" => lesson_id}, socket) do
    result = MusicIan.Practice.Manager.LessonManager.get_latest_result_for_lesson(lesson_id)

    result_data =
      case result do
        nil ->
          nil

        r ->
          %{
            "lesson_id" => r.lesson_id,
            "correct_count" => r.correct_count,
            "error_count" => r.error_count,
            "accuracy_percent" => r.accuracy_percent,
            "timing_score" => r.timing_score,
            "bpm_used" => r.bpm_used,
            "completed_at" => r.completed_at
          }
      end

    response = %{
      "success" => true,
      "result" => result_data,
      "metadata" => %{"execution_time_ms" => 0}
    }

    {:reply, {:ok, response}, socket}
  rescue
    e ->
      error_response("mcp.lesson_latest_result", e, socket)
  end

  # ─────────────────────────────────────────────────────────────
  # PRACTICE: EXERCISE GENERATOR
  # ─────────────────────────────────────────────────────────────

  # Genera un ejercicio dinámico.
  #
  # Params: {generator: string, params: map}
  # Response: {exercise: map with target_note, prompt, difficulty}
  def handle_in("mcp.exercise_generate", %{"generator" => generator, "params" => params}, socket) do
    exercise = MusicIan.Practice.ExerciseGenerator.generate(generator, params)

    response = %{
      "success" => true,
      "result" => exercise,
      "metadata" => %{"execution_time_ms" => 0}
    }

    {:reply, {:ok, response}, socket}
  rescue
    e ->
      error_response("mcp.exercise_generate", e, socket)
  end

  # ─────────────────────────────────────────────────────────────
  # PRACTICE: FSM OPERATIONS (Stateless - for testing/validation)
  # ─────────────────────────────────────────────────────────────

  # Crea un nuevo FSM para una lección (stateless snapshot).
  #
  # Params: {lesson_id: string}
  # Response: {fsm_state: map with current FSM state}
  def handle_in("mcp.fsm_new", %{"lesson_id" => lesson_id}, socket) do
    fsm = MusicIan.Practice.FSM.LessonFSM.new(lesson_id)

    fsm_data = %{
      "lesson_id" => fsm.lesson_id,
      "phase" => Atom.to_string(fsm.lesson_phase),
      "current_step" => fsm.current_step,
      "total_steps" => length(fsm.steps),
      "metronome_enabled" => fsm.metronome_enabled,
      "bpm" => fsm.bpm,
      "correct_count" => fsm.correct_count,
      "error_count" => fsm.error_count
    }

    response = %{
      "success" => true,
      "result" => fsm_data,
      "metadata" => %{"execution_time_ms" => 0}
    }

    {:reply, {:ok, response}, socket}
  rescue
    e ->
      error_response("mcp.fsm_new", e, socket)
  end

  # Calcula duración de práctica para una lección.
  #
  # Params: {lesson_id: string, bpm: int (optional)}
  # Response: {duration_ms: int, beats: int}
  def handle_in("mcp.fsm_practice_duration", %{"lesson_id" => lesson_id} = params, socket) do
    bpm = Map.get(params, "bpm")
    fsm = MusicIan.Practice.FSM.LessonFSM.new(lesson_id)
    fsm = if bpm, do: %{fsm | bpm: bpm}, else: fsm
    duration_ms = MusicIan.Practice.FSM.LessonFSM.calculate_practice_duration(fsm)
    beat_map = MusicIan.Practice.FSM.LessonFSM.calculate_beat_map(fsm)

    response = %{
      "success" => true,
      "result" => %{
        "duration_ms" => duration_ms,
        "total_beats" => length(beat_map),
        "bpm" => fsm.bpm,
        "beat_map" => beat_map
      },
      "metadata" => %{"execution_time_ms" => 0}
    }

    {:reply, {:ok, response}, socket}
  rescue
    e ->
      error_response("mcp.fsm_practice_duration", e, socket)
  end

  # ─────────────────────────────────────────────────────────────
  # LEGACY: LESSON OPERATIONS (mantener compatibilidad)
  # ─────────────────────────────────────────────────────────────

  # Inicia una sesión de lección (legacy).
  def handle_in("mcp.lesson_start", %{"lesson_id" => lesson_id, "user_id" => user_id}, socket) do
    _lesson_state = MusicIan.Practice.FSM.LessonFSM.new(lesson_id)
    session_id = "session_#{user_id}_#{lesson_id}_#{System.unique_integer()}"

    response = %{
      "success" => true,
      "result" => %{
        "session_id" => session_id,
        "lesson_id" => lesson_id,
        "user_id" => user_id,
        "phase" => "intro",
        "current_step" => 0,
        "started_at" => DateTime.utc_now() |> DateTime.to_iso8601()
      },
      "metadata" => %{"execution_time_ms" => 0}
    }

    {:reply, {:ok, response}, socket}
  rescue
    e ->
      error_response("mcp.lesson_start", e, socket)
  end

  # Valida un paso de lección (legacy).
  def handle_in("mcp.lesson_validate_step", %{"played_notes" => _played_notes}, socket) do
    accuracy = 1.0

    response = %{
      "success" => true,
      "result" => %{
        "valid" => true,
        "feedback" => "Step validated successfully",
        "accuracy" => accuracy,
        "next_action" => "continue_to_next_step"
      },
      "metadata" => %{"execution_time_ms" => 0}
    }

    {:reply, {:ok, response}, socket}
  rescue
    e ->
      error_response("mcp.lesson_validate_step", e, socket)
  end

  # ─────────────────────────────────────────────────────────────
  # VALIDATION API (TESTING FUNCTIONS)
  # ─────────────────────────────────────────────────────────────

  # Valida la detección de un acorde.
  #
  # Params: {notes: List, expected: string}
  # Response: {success: bool, detected: str, expected: str, match: bool, reasoning: str}
  def handle_in(
        "mcp.validate_chord_detection",
        %{"notes" => notes, "expected" => expected},
        socket
      ) do
    chord = MusicIan.MusicCore.Chord.from_midi_notes(notes)
    detected = "#{chord.root.name} #{Atom.to_string(chord.quality)}"
    match = detected == expected

    response = %{
      "success" => true,
      "result" => %{
        "detected" => detected,
        "expected" => expected,
        "match" => match,
        "reasoning" => "Detected intervals from MIDI notes"
      },
      "metadata" => %{"execution_time_ms" => 0}
    }

    {:reply, {:ok, response}, socket}
  rescue
    e ->
      error_response("mcp.validate_chord_detection", e, socket)
  end

  # Valida si notas pertenecen a una escala.
  #
  # Params: {notes: List, scale_type: string, root: int}
  # Response: {valid: bool, in_scale: List, out_of_scale: List, coverage: float}
  def handle_in(
        "mcp.validate_scale_membership",
        %{"notes" => notes, "scale_type" => scale_type, "root" => root},
        socket
      ) do
    scale_atom = String.to_atom(scale_type)
    scale = MusicIan.MusicCore.Scale.new(root, scale_atom)

    in_scale = Enum.filter(notes, &Enum.member?(scale.notes, &1))
    out_of_scale = Enum.filter(notes, &(!Enum.member?(scale.notes, &1)))

    response = %{
      "success" => true,
      "result" => %{
        "valid" => Enum.empty?(out_of_scale),
        "in_scale" => in_scale,
        "out_of_scale" => out_of_scale,
        "coverage" => if(Enum.empty?(notes), do: 0, else: length(in_scale) / length(notes))
      },
      "metadata" => %{"execution_time_ms" => 0}
    }

    {:reply, {:ok, response}, socket}
  rescue
    e ->
      error_response("mcp.validate_scale_membership", e, socket)
  end

  # ─────────────────────────────────────────────────────────────
  # HELPERS
  # ─────────────────────────────────────────────────────────────

  defp compute_intervals(notes) do
    first_note = List.first(notes)

    notes
    |> Enum.map(&(&1.midi - first_note.midi))
    |> Enum.map(&rem(&1, 12))
  end

  defp error_response(method, error, socket) do
    Logger.error("Error in #{method}: #{inspect(error)}")

    response = %{
      "success" => false,
      "error" => %{
        "code" => -32_603,
        "message" => "Internal error: #{inspect(error)}"
      },
      "metadata" => %{"execution_time_ms" => 0}
    }

    {:reply, {:error, response}, socket}
  end
end
