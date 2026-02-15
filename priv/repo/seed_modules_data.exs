# Seed data for modules with ENRICHED PEDAGOGICAL METADATA
# Baby steps piano curriculum - from absolute beginner to first note reading
# Progressive structure: each module builds on the previous one
# 
# PEDAGOGICAL FRAMEWORK:
# - Duration: Each module scales 20-40 minutes to build confidence gradually
# - Emotional Arc: Disorientation → Orientation → Movement → Coordination → Structure → Execution → Confidence
# - Cognitive Load: Grows gradually within each module, no sudden jumps
# - Motor Complexity: Starts with visual/cognitive (Module 1), progresses to physical execution
# - Baby Steps: Each lesson connects explicitly to previous, building incrementally

alias MusicIan.Curriculum.Module

modules = [
  %{
    id: "mod_001_piano_fundamentals",
    title: "Módulo 1: Fundamentos del Teclado",
    description: "Empieza desde cero. Conoce el piano, el Do central, las octavas y los patrones de las teclas. Sin requisitos previos de música.",
    order: 1,
    category: "fundamentals",
    learning_objectives: %{
      "objectives" => [
        "Identificar las partes del piano",
        "Entender el patrón de teclas blancas y negras",
        "Localizar el Do central (Middle C)",
        "Comprender qué es una octava",
        "Reconocer que el patrón se repite en todo el teclado",
        "Situar tu cuerpo correctamente frente al piano"
      ],
      "duration_weeks" => 1,
      "prerequisite" => nil
    },
    icon: "piano",
    # ENRICHED PEDAGOGICAL METADATA
    pedagogical_intent: "Remove initial disorientation and build confidence through visual pattern recognition. Student moves from 'I don't know anything' to 'I understand how the keyboard is organized.' Focus is 100% on cognitive/visual skills with ZERO motor requirements. Each lesson progressively builds spatial awareness.",
    emotional_goal: "desorientación → ubicación",
    duration_progression_rule: "Lesson durations scale from 20 to 40 minutes: [20, 21, 23, 26, 30, 35, 40]. Each incremental increase allows deeper exploration without overwhelming.",
    skill_scope: [
      "visual_pattern_recognition",
      "spatial_orientation_keyboard",
      "octave_concept",
      "middle_c_location",
      "keyboard_navigation"
    ],
    completion_criteria: "Student can locate Middle C without hesitation, explain the 2-3 black key pattern, find any note name on the keyboard by pattern, and understand octave repetition visually.",
    cognitive_load_growth: "gradual",
    motor_complexity_growth: "none",
    theory_complexity_growth: "gradual",
    lesson_duration_progression: [20, 21, 23, 26, 30, 35, 40],
    final_student_capabilities: [
      "Locate Middle C on any part of keyboard instantly",
      "Identify white and black key patterns without counting",
      "Explain octave concept in own words",
      "Navigate keyboard spatially with eyes closed (muscle memory for Middle C)",
      "Understand keyboard organization conceptually"
    ],
    perceived_confidence_level_target: "Confident in understanding piano layout; ready to learn note names"
  },

  %{
    id: "mod_002_first_octave",
    title: "Módulo 2: Tu Primera Octava - Las Notas",
    description: "Aprende los nombres de las 7 notas blancas: Do, Re, Mi, Fa, Sol, La, Si. Empieza tocando cada nota y reconociéndola.",
    order: 2,
    category: "notes",
    learning_objectives: %{
      "objectives" => [
        "Memorizar los nombres de las 7 notas (C, D, E, F, G, A, B)",
        "Tocar cada nota de forma individual",
        "Reconocer visualmente cada nota en el teclado",
        "Entender el patrón de repetición de notas",
        "Practicar transiciones suaves entre notas",
        "Introducción a los dedos: 1 = Pulgar, 5 = Meñique"
      ],
      "duration_weeks" => 1.5,
      "prerequisite" => "mod_001_piano_fundamentals"
    },
    icon: "note",
    pedagogical_intent: "Bridge from keyboard understanding to note naming. Student moves from 'I know the pattern' to 'I can name and play any white key.' Introduces basic motor skills (pressing keys with intention). Focus on memory formation through repetition with multi-sensory reinforcement (visual name, auditory sound, kinesthetic touch).",
    emotional_goal: "ubicación → movimiento",
    duration_progression_rule: "Lesson durations scale from 22 to 42 minutes: [22, 23, 25, 28, 32, 37, 42]. Increases allow for name repetition and muscle memory consolidation.",
    skill_scope: [
      "note_naming_white_keys",
      "visual_note_recognition",
      "basic_key_pressing",
      "auditory_note_identification",
      "finger_numbering",
      "note_sequence_memorization"
    ],
    completion_criteria: "Student can name all 7 white keys instantly from any octave, play each note with deliberate finger placement, recognize notes by sound, and understand sequence (Do-Re-Mi-Fa-Sol-La-Si) in any starting position.",
    cognitive_load_growth: "gradual",
    motor_complexity_growth: "gradual",
    theory_complexity_growth: "moderate",
    lesson_duration_progression: [22, 23, 25, 28, 32, 37, 42],
    final_student_capabilities: [
      "Name any white key instantly without counting",
      "Play each note with proper finger alignment",
      "Recognize notes by ear (auditory mapping)",
      "Sing note names while playing",
      "Understand ascending/descending note sequences",
      "Recall note names in backward order"
    ],
    perceived_confidence_level_target: "Confident naming and playing individual notes; ready for rhythm and timing"
  },

  %{
    id: "mod_003_note_duration",
    title: "Módulo 3: El Tiempo de las Notas - Duraciones",
    description: "Aprende que cada nota tiene una duración diferente. Redonda (4 tiempos), Blanca (2 tiempos), Negra (1 tiempo). Compás 4/4.",
    order: 3,
    category: "rhythm",
    learning_objectives: %{
      "objectives" => [
        "Entender el compás 4/4 como base (4 tiempos en total)",
        "Reconocer la redonda: 4 tiempos (nota entera)",
        "Reconocer la blanca: 2 tiempos (media nota)",
        "Reconocer la negra: 1 tiempo (cuarto de nota)",
        "Visualizar cómo se escriben estas notas",
        "Practicar contando tiempos mientras tocas"
      ],
      "duration_weeks" => 1.5,
      "prerequisite" => "mod_002_first_octave"
    },
    icon: "duration",
    pedagogical_intent: "Introduce temporal/rhythmic dimension. Student moves from 'I can play notes' to 'I understand how long notes last.' Focus on bridging visual notation with auditory/kinesthetic experience. Introduces counting and time awareness without metronome yet. Creates foundation for rhythm coordination.",
    emotional_goal: "movimiento → coordinación",
    duration_progression_rule: "Lesson durations scale from 24 to 44 minutes: [24, 25, 27, 30, 34, 39, 44]. Allows for counting practice and duration differentiation exercises.",
    skill_scope: [
      "time_signature_4_4",
      "whole_note_duration",
      "half_note_duration",
      "quarter_note_duration",
      "note_value_comparison",
      "counting_rhythms",
      "visual_notation_reading"
    ],
    completion_criteria: "Student can visually identify whole/half/quarter notes, count beats correctly for each duration, sustain notes for proper lengths, and understand how multiple notes fit in a 4/4 measure.",
    cognitive_load_growth: "moderate",
    motor_complexity_growth: "moderate",
    theory_complexity_growth: "moderate",
    lesson_duration_progression: [24, 25, 27, 30, 34, 39, 44],
    final_student_capabilities: [
      "Identify note durations from written notation",
      "Count beats while holding notes correctly",
      "Understand measure structure (4/4 timing)",
      "Play sequences with mixed durations accurately by counting",
      "Relate written symbols to auditory duration",
      "Sustain notes for exact beat counts"
    ],
    perceived_confidence_level_target: "Confident with rhythm basics; ready for metronome and tempo control"
  },

  %{
    id: "mod_004_rhythm_tempo",
    title: "Módulo 4: Ritmo y Tempo - Ejercicios Prácticos",
    description: "Toca ejercicios de ritmo con metrónomo. Practica mantener tempo constante con diferentes duraciones de notas.",
    order: 4,
    category: "rhythm",
    learning_objectives: %{
      "objectives" => [
        "Usar el metrónomo como guía de tempo",
        "Practicar notas redondas con pulso constante",
        "Practicar notas blancas con control",
        "Practicar notas negras con fluidez",
        "Combinar diferentes duraciones en un compás",
        "Mantener el ritmo sin acelerar ni desacelerar"
      ],
      "duration_weeks" => 2,
      "prerequisite" => "mod_003_note_duration"
    },
    icon: "tempo",
    pedagogical_intent: "Develop temporal coordination and rhythm stability. Student moves from 'I understand duration theoretically' to 'I can play in time with external pulse.' Introduces metronome as practice partner, not just tool. Focus on building rhythm internalization and eliminating rushing/dragging.",
    emotional_goal: "coordinación → estructura",
    duration_progression_rule: "Lesson durations scale from 26 to 46 minutes: [26, 27, 29, 32, 36, 41, 46]. Extended durations allow for multiple metronome tempos and progressive challenges.",
    skill_scope: [
      "metronome_integration",
      "tempo_stability",
      "whole_note_rhythm_control",
      "half_note_rhythm_control",
      "quarter_note_rhythm_control",
      "mixed_duration_sequences",
      "pulse_synchronization",
      "rhythm_internalization"
    ],
    completion_criteria: "Student can play any duration sequence in tempo with metronome without rushing or dragging, maintain steady beat internally, and execute rhythm changes smoothly within 4/4 measures.",
    cognitive_load_growth: "moderate",
    motor_complexity_growth: "moderate",
    theory_complexity_growth: "mild",
    lesson_duration_progression: [26, 27, 29, 32, 36, 41, 46],
    final_student_capabilities: [
      "Play in time with metronome at various tempos (60-100 BPM)",
      "Maintain steady tempo throughout 4-measure sequences",
      "Execute note duration changes smoothly in tempo",
      "Identify and correct rushing/dragging in own playing",
      "Internalize beat (play without metronome briefly)",
      "Handle tempo changes without losing coordination"
    ],
    perceived_confidence_level_target: "Confident with rhythm execution; ready for staff notation and reading"
  },

  %{
    id: "mod_005_solfege",
    title: "Módulo 5: Solfeo - Leer Partituras",
    description: "Aprende a leer notas en el pentagrama. Identifica dónde está cada nota en la clave de Sol y cómo tocarla en el teclado.",
    order: 5,
    category: "theory",
    learning_objectives: %{
      "objectives" => [
        "Entender la clave de Sol (treble clef)",
        "Leer las líneas del pentagrama (E-G-B-D-F)",
        "Leer los espacios del pentagrama (F-A-C-E)",
        "Conectar notas en el pentagrama con teclas del piano",
        "Practicar lectura lenta pero segura",
        "Comprender la relación entre notación y sonido"
      ],
      "duration_weeks" => 2,
      "prerequisite" => "mod_004_rhythm_tempo"
    },
    icon: "staff",
    pedagogical_intent: "Complete the bridge from keyboard to written music. Student moves from 'I can play notes in time' to 'I can read basic sheet music and play it.' Integrates all previous skills: pattern recognition → naming → rhythm. Focus on decoding written symbols and translating to keyboard action.",
    emotional_goal: "estructura → ejecución → confianza",
    duration_progression_rule: "Lesson durations scale from 28 to 48 minutes: [28, 29, 31, 34, 38, 43, 48]. Maximum durations for reading practice and integration of all learned skills.",
    skill_scope: [
      "treble_clef_recognition",
      "staff_line_identification",
      "staff_space_identification",
      "note_position_reading",
      "staff_to_keyboard_mapping",
      "sight_reading_fundamentals",
      "notation_comprehension",
      "integrated_playing_from_notation"
    ],
    completion_criteria: "Student can read single-note sequences in treble clef at comfortable pace, translate written notes to keyboard instantly, play simple 4-8 measure pieces from notation at moderate tempo.",
    cognitive_load_growth: "steep",
    motor_complexity_growth: "moderate",
    theory_complexity_growth: "steep",
    lesson_duration_progression: [28, 29, 31, 34, 38, 43, 48],
    final_student_capabilities: [
      "Read treble clef notes without hesitation",
      "Identify notes on staff lines and spaces instantly",
      "Translate written notation to keyboard action",
      "Play simple melodies from notation at sight",
      "Understand relationship between staff position and keyboard location",
      "Read and execute rhythm notation simultaneously",
      "Play 8-16 measure pieces from written music"
    ],
    perceived_confidence_level_target: "Confident reading and playing from sheet music; ready for music study journey"
  }
]

# Insert modules with enriched pedagogical metadata
modules
|> Enum.each(fn module_data ->
  MusicIan.Repo.insert!(
    MusicIan.Curriculum.Module.changeset(%MusicIan.Curriculum.Module{}, module_data),
    on_conflict: :replace_all,
    conflict_target: :id
  )
end)

IO.puts("✅ Inserted #{length(modules)} modules with enriched pedagogical metadata")
