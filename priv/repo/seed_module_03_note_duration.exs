# Seed: Módulo 3 - El Tiempo de las Notas (Note Duration - ENRICHED PEDAGOGY)
# Focus: Understanding whole, half, quarter notes in 4/4 time
# Duration progression: [24, 25, 27, 30, 34, 39, 44] minutes
# Emotional arc: movimiento → coordinación
# Cognitive load: Moderate - bridges visual/auditory to time perception

alias MusicIan.Repo
alias MusicIan.Curriculum.Lesson

IO.puts("\n" <> String.duplicate("=", 70))
IO.puts("📚 SEEDING MODULE 3: El Tiempo de las Notas (with Rich Pedagogy)")
IO.puts(String.duplicate("=", 70))

lessons_module_03 = [
  %{id: "3_01_measure_intro", title: "3.1 El Compás - 4 Tiempos (4/4)", description: "Practica tocando Do en cada tiempo del compás. El metrónomo marca cada beat.",
    intro: "Un compás de 4/4 tiene 4 tiempos. El metrónomo te marca cada uno. Tu tarea: toca Do (tecla blanca central) en cada tiempo. Escucha el click, toca al ritmo. 1-toca, 2-toca, 3-toca, 4-toca.",
    metronome: true, timing_strictness: 2, time_signature: "4/4", module_id: "mod_003_note_duration", order: 1,
    steps: [
      %{text: "Compás 1 — Tiempo 1: toca Do", note: 60, hint: "Toca al primer click del metrónomo", finger: 1, duration: 1},
      %{text: "Compás 1 — Tiempo 2: toca Do", note: 60, hint: "Segundo click", finger: 1, duration: 1},
      %{text: "Compás 1 — Tiempo 3: toca Do", note: 60, hint: "Tercer click", finger: 1, duration: 1},
      %{text: "Compás 1 — Tiempo 4: toca Do", note: 60, hint: "Cuarto click — fin del primer compás", finger: 1, duration: 1},
      %{text: "Compás 2 — Tiempo 1: toca Do", note: 60, hint: "Empieza el segundo compás", finger: 1, duration: 1},
      %{text: "Compás 2 — Tiempo 2: toca Do", note: 60, hint: "Sigue el ritmo", finger: 1, duration: 1},
      %{text: "Compás 2 — Tiempo 3: toca Do", note: 60, hint: "¡Ya casi!", finger: 1, duration: 1},
      %{text: "Compás 2 — Tiempo 4: toca Do", note: 60, hint: "¡Dos compases completos de 4/4!", finger: 1, duration: 1}
    ],
    focus: "Introducing 4/4 time structure by playing on each beat", new_concepts: ["four_four_time", "measure_structure", "beat_counting", "metronome_beats", "tempo_basics"],
    confidence_level_target: "Understands beat structure; ready for note durations", cognitive_complexity: "intermediate", motor_complexity: "basic", duration_minutes: 24
  },

  %{id: "3_02_whole_note", title: "3.2 La Redonda - 4 Tiempos Completos", description: "Una redonda (nota blanca vacía sin tallo) dura un compás entero: 4 tiempos.",
    intro: "La redonda se ve como un óvalo blanco sin tallo. Dura 4 tiempos. Tocas la nota y la sostienes contando 1-2-3-4. Cada redonda ocupa un compás completo.",
    metronome: true, timing_strictness: 2, time_signature: "4/4", module_id: "mod_003_note_duration", order: 2,
    steps: [
      %{text: "Toca Do y SOSTÉN — cuenta 1-2-3-4", note: 60, hint: "Mantén el dedo presionado todo el compás", finger: 1, duration: 4},
      %{text: "Do otra vez — siente los 4 tiempos", note: 60, hint: "Redonda = 1 compás entero", finger: 1, duration: 4},
      %{text: "Redonda en Re — sostén 4 tiempos", note: 62, hint: "Mismo concepto, nota diferente", finger: 2, duration: 4},
      %{text: "Redonda en Mi — sostén 4 tiempos", note: 64, hint: "Tercer dedo, cuenta en silencio", finger: 3, duration: 4},
      %{text: "Redonda en Sol — sostén 4 tiempos", note: 67, hint: "Nota más aguda, misma duración", finger: 5, duration: 4},
      %{text: "Vuelve a Do — redonda final", note: 60, hint: "¡Un compás completo de redonda!", finger: 1, duration: 4}
    ],
    focus: "Understanding whole note duration and sustain technique", new_concepts: ["whole_note_symbol", "four_beat_duration", "note_sustain", "entire_measure", "long_note_holding"],
    confidence_level_target: "Can hold notes for correct duration", cognitive_complexity: "intermediate", motor_complexity: "intermediate", duration_minutes: 25
  },

  %{id: "3_03_half_note", title: "3.3 La Blanca - 2 Tiempos", description: "Una blanca (nota blanca con tallo) dura la mitad de una redonda: 2 tiempos.",
    intro: "La blanca se ve como un óvalo blanco CON un tallo. Dura 2 tiempos. Tocas la nota y la sostienes contando 1-2 antes de soltarla.",
    metronome: true, timing_strictness: 2, time_signature: "4/4", module_id: "mod_003_note_duration", order: 3,
    steps: [
      %{text: "Do — blanca (sostén 1-2)", note: 60, hint: "Dedo 1 — cuenta 2 tiempos", finger: 1, duration: 2},
      %{text: "Re — blanca (sostén 1-2)", note: 62, hint: "Dedo 2 — cuenta 2 tiempos", finger: 2, duration: 2},
      %{text: "Mi — blanca (sostén 1-2)", note: 64, hint: "Dedo 3 — cuenta 2 tiempos", finger: 3, duration: 2},
      %{text: "Fa — blanca (sostén 1-2)", note: 65, hint: "Dedo 4 — cuenta 2 tiempos", finger: 4, duration: 2},
      %{text: "Sol — blanca (sostén 1-2)", note: 67, hint: "Dedo 5 — cuenta 2 tiempos", finger: 5, duration: 2},
      %{text: "La — blanca (sostén 1-2)", note: 69, hint: "Dedo 4 — cuenta 2 tiempos", finger: 4, duration: 2},
      %{text: "Si — blanca (sostén 1-2)", note: 71, hint: "Dedo 3 — cuenta 2 tiempos", finger: 3, duration: 2},
      %{text: "Do alta — blanca (sostén 1-2)", note: 72, hint: "Dedo 5 — ¡escala completa de blancas!", finger: 5, duration: 2}
    ],
    focus: "Learning half note duration relative to whole note", new_concepts: ["half_note_symbol", "two_beat_duration", "proportional_duration", "half_measure", "note_comparison"],
    confidence_level_target: "Understands half note as half of whole", cognitive_complexity: "intermediate", motor_complexity: "intermediate", duration_minutes: 27
  },

  %{id: "3_04_quarter_note", title: "3.4 La Negra - 1 Tiempo", description: "Una negra (nota negra llena con tallo) dura 1 tiempo.",
    intro: "La negra se ve como un punto negro CON un tallo. Dura solo 1 tiempo — tocas y sueltas rápido. Hay 4 negras en un compás de 4/4.",
    metronome: true, timing_strictness: 2, time_signature: "4/4", module_id: "mod_003_note_duration", order: 4,
    steps: [
      %{text: "Do — negra (toca y suelta)", note: 60, hint: "Dedo 1 — 1 solo tiempo", finger: 1, duration: 1},
      %{text: "Re — negra", note: 62, hint: "Dedo 2", finger: 2, duration: 1},
      %{text: "Mi — negra", note: 64, hint: "Dedo 3", finger: 3, duration: 1},
      %{text: "Fa — negra", note: 65, hint: "Dedo 4", finger: 4, duration: 1},
      %{text: "Sol — negra", note: 67, hint: "Dedo 5", finger: 5, duration: 1},
      %{text: "La — negra", note: 69, hint: "Dedo 4", finger: 4, duration: 1},
      %{text: "Si — negra", note: 71, hint: "Dedo 3", finger: 3, duration: 1},
      %{text: "Do alta — negra (¡escala completa!)", note: 72, hint: "Dedo 5 — 8 negras = 2 compases", finger: 5, duration: 1}
    ],
    focus: "Learning quarter note as fastest duration studied", new_concepts: ["quarter_note_symbol", "one_beat_duration", "fast_notes", "four_notes_per_measure", "note_speed_variation"],
    confidence_level_target: "Can play quarter notes fluidly", cognitive_complexity: "intermediate", motor_complexity: "intermediate", duration_minutes: 30
  },

  %{id: "3_05_compare_durations", title: "3.5 Comparar Duraciones: Redonda, Blanca, Negra", description: "Entiende la relación entre los tres valores de nota.",
    intro: "Compás 1: una redonda (4 tiempos). Compás 2: dos blancas (2+2). Compás 3: cuatro negras (1+1+1+1). Todos suman 4 tiempos.",
    metronome: true, timing_strictness: 2, time_signature: "4/4", module_id: "mod_003_note_duration", order: 5,
    steps: [
      %{text: "Do — REDONDA (sostén 4 tiempos)", note: 60, hint: "Un compás entero", finger: 1, duration: 4},
      %{text: "Do — BLANCA (sostén 2 tiempos)", note: 60, hint: "Primera mitad del compás", finger: 1, duration: 2},
      %{text: "Do — BLANCA (sostén 2 tiempos)", note: 60, hint: "Segunda mitad — 2+2=4", finger: 1, duration: 2},
      %{text: "Do — NEGRA (1 tiempo)", note: 60, hint: "1ª negra del compás", finger: 1, duration: 1},
      %{text: "Do — NEGRA (1 tiempo)", note: 60, hint: "2ª negra", finger: 1, duration: 1},
      %{text: "Do — NEGRA (1 tiempo)", note: 60, hint: "3ª negra", finger: 1, duration: 1},
      %{text: "Do — NEGRA (1 tiempo)", note: 60, hint: "4ª negra — 1+1+1+1=4", finger: 1, duration: 1}
    ],
    focus: "Understanding proportional relationships between note durations", new_concepts: ["duration_ratios", "whole_vs_half_vs_quarter", "note_value_proportions", "measure_equivalence", "duration_comparison"],
    confidence_level_target: "Understands duration relationships", cognitive_complexity: "moderate", motor_complexity: "intermediate", duration_minutes: 34
  },

  %{id: "3_06_mixed_durations", title: "3.6 Mezclar Duraciones en un Compás", description: "Un compás puede tener una mezcla de redondas, blancas y negras.",
    intro: "Un compás NO tiene que ser solo negras. Puede ser: blanca (2) + negra (1) + negra (1) = 4 tiempos.",
    metronome: true, time_signature: "4/4", module_id: "mod_003_note_duration", order: 6,
    steps: [
      %{text: "Do — blanca (2 tiempos)", note: 60, hint: "Primera mitad del compás", finger: 1, duration: 2},
      %{text: "Re — negra (1 tiempo)", note: 62, hint: "Tercer tiempo", finger: 2, duration: 1},
      %{text: "Mi — negra (1 tiempo)", note: 64, hint: "Cuarto tiempo — 2+1+1=4 ✓", finger: 3, duration: 1},
      %{text: "Fa — negra (1 tiempo)", note: 65, hint: "Primer tiempo", finger: 4, duration: 1},
      %{text: "Sol — negra (1 tiempo)", note: 67, hint: "Segundo tiempo", finger: 5, duration: 1},
      %{text: "La — blanca (2 tiempos)", note: 69, hint: "Tercer y cuarto tiempo — 1+1+2=4 ✓", finger: 4, duration: 2},
      %{text: "Do — negra", note: 60, hint: "Primer tiempo", finger: 1, duration: 1},
      %{text: "Re — negra", note: 62, hint: "Segundo tiempo", finger: 2, duration: 1},
      %{text: "Mi — negra", note: 64, hint: "Tercer tiempo", finger: 3, duration: 1},
      %{text: "Fa — negra (1+1+1+1=4 ✓)", note: 65, hint: "Cuarto tiempo — cuatro negras", finger: 4, duration: 1},
      %{text: "Sol — redonda (4 tiempos)", note: 67, hint: "Un compás entero — 4=4 ✓", finger: 5, duration: 4}
    ],
    focus: "Combining different durations within measure constraints", new_concepts: ["mixed_note_durations", "measure_arithmetic", "rhythm_pattern_combinations", "duration_flexibility", "rhythmic_variety"],
    confidence_level_target: "Can execute various duration combinations", cognitive_complexity: "moderate", motor_complexity: "intermediate", duration_minutes: 39
  },

  %{id: "3_07_duration_symbols", title: "3.7 Los Símbolos de Duración", description: "Visualiza cómo se ven los símbolos para redonda, blanca, y negra.",
    intro: "Las notas se escriben diferente según su duración. Redonda: óvalo blanco sin tallo. Blanca: óvalo blanco con tallo. Negra: círculo negro con tallo.",
    metronome: false, time_signature: "4/4", module_id: "mod_003_note_duration", order: 7,
    steps: [
      %{text: "Ves una redonda — Toca la nota y sostén 4 tiempos", note: 60, hint: "Símbolo: óvalo blanco sin tallo", finger: 1, duration: 4},
      %{text: "Ves una blanca — Toca la nota y sostén 2 tiempos", note: 62, hint: "Símbolo: óvalo blanco con tallo", finger: 2, duration: 2},
      %{text: "Ves una negra — Toca rápido, 1 tiempo", note: 64, hint: "Símbolo: negro lleno con tallo", finger: 3, duration: 1},
      %{text: "Identifica: Redonda vs Blanca — ¿Cuál es cuál?", note: 0, hint: "Mira el tallo", finger: 0, duration: 1},
      %{text: "Identifica: Blanca vs Negra — ¿Cuál es cuál?", note: 0, hint: "Mira si está relleno", finger: 0, duration: 1},
      %{text: "Identifica todas las duraciones en una fila", note: 0, hint: "Redonda, Blanca, Negra", finger: 0, duration: 1}
    ],
    focus: "Reading written duration notation and symbol recognition", new_concepts: ["notation_symbols", "visual_duration_identification", "stem_visual_cues", "fill_visual_cues", "symbol_to_duration_mapping"],
    confidence_level_target: "Can identify durations from notation", cognitive_complexity: "moderate", motor_complexity: "basic", duration_minutes: 44
  },

  %{id: "3_08_duration_metronome_exercise", title: "3.8 Ejercicio de Duración con Metrónomo", description: "Practica tocando diferentes duraciones mientras el metrónomo marca el tiempo.",
    intro: "El metrónomo te ayuda a mantener el tempo. Cada click del metrónomo = 1 tiempo. Toca notas según su duración.",
    metronome: true, time_signature: "4/4", module_id: "mod_003_note_duration", order: 8,
    steps: [
      %{text: "Do — redonda (4 clicks)", note: 60, hint: "Sostén 4 tiempos", finger: 1, duration: 4},
      %{text: "Re — blanca (2 clicks)", note: 62, hint: "Sostén 2 tiempos", finger: 2, duration: 2},
      %{text: "Mi — blanca (2 clicks)", note: 64, hint: "Sostén 2 tiempos — 2+2=4 ✓", finger: 3, duration: 2},
      %{text: "Fa — negra (1 click)", note: 65, hint: "Un tiempo", finger: 4, duration: 1},
      %{text: "Sol — negra (1 click)", note: 67, hint: "Un tiempo", finger: 5, duration: 1},
      %{text: "La — negra (1 click)", note: 69, hint: "Un tiempo", finger: 4, duration: 1},
      %{text: "Si — negra (1 click — 1+1+1+1=4 ✓)", note: 71, hint: "Un tiempo", finger: 3, duration: 1},
      %{text: "Do — blanca (2 clicks)", note: 72, hint: "Sostén 2 tiempos", finger: 5, duration: 2},
      %{text: "Si — negra (1 click)", note: 71, hint: "Un tiempo", finger: 4, duration: 1},
      %{text: "La — negra (1 click)", note: 69, hint: "Un tiempo — 2+1+1=4 ✓", finger: 3, duration: 1},
      %{text: "Sol — redonda (4 clicks)", note: 67, hint: "Cierre con redonda", finger: 5, duration: 4}
    ],
    focus: "Applying durations with external tempo reference", new_concepts: ["metronome_integration", "external_tempo_following", "duration_accuracy_with_timing", "rhythm_execution", "tempo_stability"],
    confidence_level_target: "Can play durations accurately with metronome", cognitive_complexity: "intermediate", motor_complexity: "intermediate", duration_minutes: 44
  }
]

IO.puts("🎵 Inserting #{Enum.count(lessons_module_03)} lessons with enriched metadata...")

Enum.each(lessons_module_03, fn lesson ->
  MusicIan.Repo.insert!(
    MusicIan.Curriculum.Lesson.changeset(%MusicIan.Curriculum.Lesson{}, lesson),
    on_conflict: :replace_all,
    conflict_target: :id
  )
end)

IO.puts("✅ Module 3 (El Tiempo de las Notas) lessons inserted with rich pedagogy!")
IO.puts(String.duplicate("=", 70) <> "\n")
