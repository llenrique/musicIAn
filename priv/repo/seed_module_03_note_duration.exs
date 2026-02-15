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
  %{id: "3_01_measure_intro", title: "3.1 El Compás - La Estructura Base (4/4)", description: "Entiende qué es un compás. En 4/4, caben 4 tiempos (beats) en total.",
    intro: "Un compás es una sección de tiempo. Imagina que marcas un ritmo con los pies: 1-2-3-4, 1-2-3-4. Eso es un compás de 4/4.",
    metronome: true, module_id: "mod_003_note_duration", order: 1,
    steps: [
      %{text: "Cuenta 1-2-3-4", note: 0, hint: "Sin tocar, solo contar", finger: 0, duration: 0},
      %{text: "Cuenta 1-2-3-4 de nuevo", note: 0, hint: "Más rápido", finger: 0, duration: 0},
      %{text: "Cuenta mientras el metrónomo marca", note: 60, hint: "Uno = Un tick del metrónomo", finger: 1, duration: 4},
      %{text: "Toca Do en cada número", note: 60, hint: "1 (toca), 2 (toca), 3 (toca), 4 (toca)", finger: 1, duration: 4},
      %{text: "Entendiste: 4 tiempos = 1 compás", note: 0, hint: "Todo cabe en esto", finger: 0, duration: 0}
    ],
    focus: "Introducing 4/4 time structure and beat counting", new_concepts: ["four_four_time", "measure_structure", "beat_counting", "metronome_beats", "tempo_basics"],
    confidence_level_target: "Understands beat structure; ready for note durations", cognitive_complexity: "intermediate", motor_complexity: "basic", duration_minutes: 24
  },

  %{id: "3_02_whole_note", title: "3.2 La Redonda - 4 Tiempos Completos", description: "Una redonda (nota blanca vacía sin tallo) dura un compás entero: 4 tiempos.",
    intro: "La redonda se ve como un óvalo blanco sin tallo. Dura 4 tiempos. Tocas una nota y la sostienes mientras cuentas 1-2-3-4.",
    metronome: true, module_id: "mod_003_note_duration", order: 2,
    steps: [
      %{text: "Toca Do y SOSTÉN", note: 60, hint: "Mantén el dedo presionado", finger: 1, duration: 4},
      %{text: "Mientras sostienes, cuenta: 1-2-3-4", note: 60, hint: "Sigue contando", finger: 1, duration: 4},
      %{text: "Redonda = 4 tiempos = 1 compás", note: 60, hint: "La duración entera", finger: 1, duration: 4},
      %{text: "Practica redondas en diferentes notas", note: 62, hint: "Redonda en Re", finger: 2, duration: 4},
      %{text: "Do redonda, Re redonda, Mi redonda", note: 60, hint: "Una tras otra", finger: 1, duration: 8},
      %{text: "Escucha cómo suena la redonda sostenida", note: 67, hint: "Sol redonda", finger: 5, duration: 4}
    ],
    focus: "Understanding whole note duration and sustain technique", new_concepts: ["whole_note_symbol", "four_beat_duration", "note_sustain", "entire_measure", "long_note_holding"],
    confidence_level_target: "Can hold notes for correct duration", cognitive_complexity: "intermediate", motor_complexity: "intermediate", duration_minutes: 25
  },

  %{id: "3_03_half_note", title: "3.3 La Blanca - 2 Tiempos", description: "Una blanca (nota blanca con tallo) dura la mitad de una redonda: 2 tiempos.",
    intro: "La blanca se ve como un óvalo blanco CON un tallo. Dura 2 tiempos. Tocas una nota y la sostienes mientras cuentas 1-2.",
    metronome: true, module_id: "mod_003_note_duration", order: 3,
    steps: [
      %{text: "Toca Do y SOSTÉN por 2 tiempos", note: 60, hint: "1-2 (y levanta)", finger: 1, duration: 2},
      %{text: "Toca Re y SOSTÉN por 2 tiempos", note: 62, hint: "1-2 (y levanta)", finger: 2, duration: 2},
      %{text: "Dos blancas caben en un compás", note: 60, hint: "2 + 2 = 4", finger: 1, duration: 4},
      %{text: "Do-blanca, Re-blanca, Do-blanca", note: 60, hint: "Tres blancas", finger: 1, duration: 6},
      %{text: "Blanca = 2 tiempos = Media nota", note: 67, hint: "La mitad de la redonda", finger: 5, duration: 2},
      %{text: "Practica alternando blancas", note: 60, hint: "Do, Re, Mi, Fa", finger: 1, duration: 8}
    ],
    focus: "Learning half note duration relative to whole note", new_concepts: ["half_note_symbol", "two_beat_duration", "proportional_duration", "half_measure", "note_comparison"],
    confidence_level_target: "Understands half note as half of whole", cognitive_complexity: "intermediate", motor_complexity: "intermediate", duration_minutes: 27
  },

  %{id: "3_04_quarter_note", title: "3.4 La Negra - 1 Tiempo", description: "Una negra (nota negra llena con tallo) dura 1 tiempo.",
    intro: "La negra se ve como un punto negro CON un tallo. Dura solo 1 tiempo. Hay 4 negras en un compás.",
    metronome: true, module_id: "mod_003_note_duration", order: 4,
    steps: [
      %{text: "Toca Do - 1 tiempo (rápido)", note: 60, hint: "Toca y levanta", finger: 1, duration: 1},
      %{text: "Toca Re - 1 tiempo", note: 62, hint: "Rápido", finger: 2, duration: 1},
      %{text: "Cuatro negras en un compás", note: 60, hint: "Do-Re-Mi-Fa", finger: 1, duration: 4},
      %{text: "Negra = 1 tiempo = Rápido", note: 67, hint: "Un cuarto de la redonda", finger: 5, duration: 1},
      %{text: "Escala de negras: Do-Re-Mi-Fa-Sol-La-Si-Do", note: 60, hint: "Rápida", finger: 1, duration: 8},
      %{text: "Do-Do-Do-Do (4 negras iguales)", note: 60, hint: "Repetición de una nota", finger: 1, duration: 4}
    ],
    focus: "Learning quarter note as fastest duration studied", new_concepts: ["quarter_note_symbol", "one_beat_duration", "fast_notes", "four_notes_per_measure", "note_speed_variation"],
    confidence_level_target: "Can play quarter notes fluidly", cognitive_complexity: "intermediate", motor_complexity: "intermediate", duration_minutes: 30
  },

  %{id: "3_05_compare_durations", title: "3.5 Comparar Duraciones: Redonda, Blanca, Negra", description: "Entiende la relación entre los tres valores de nota.",
    intro: "Redonda = 4 tiempos. Blanca = 2 tiempos (la mitad de redonda). Negra = 1 tiempo (la mitad de blanca).",
    metronome: true, module_id: "mod_003_note_duration", order: 5,
    steps: [
      %{text: "Redonda Do - cuenta 4 tiempos", note: 60, hint: "LARGA", finger: 1, duration: 4},
      %{text: "Blanca Do - cuenta 2 tiempos", note: 60, hint: "MEDIA", finger: 1, duration: 2},
      %{text: "Negra Do - solo 1 tiempo", note: 60, hint: "CORTA", finger: 1, duration: 1},
      %{text: "Redonda cabe 2 blancas", note: 60, hint: "4 = 2+2", finger: 1, duration: 4},
      %{text: "Blanca cabe 2 negras", note: 60, hint: "2 = 1+1", finger: 1, duration: 2},
      %{text: "En un compás: 1 redonda O 2 blancas O 4 negras", note: 60, hint: "Todas son 4 tiempos", finger: 1, duration: 4}
    ],
    focus: "Understanding proportional relationships between note durations", new_concepts: ["duration_ratios", "whole_vs_half_vs_quarter", "note_value_proportions", "measure_equivalence", "duration_comparison"],
    confidence_level_target: "Understands duration relationships", cognitive_complexity: "moderate", motor_complexity: "intermediate", duration_minutes: 34
  },

  %{id: "3_06_mixed_durations", title: "3.6 Mezclar Duraciones en un Compás", description: "Un compás puede tener una mezcla de redondas, blancas y negras.",
    intro: "Un compás NO tiene que ser solo negras. Puede ser: blanca (2) + negra (1) + negra (1) = 4 tiempos.",
    metronome: true, module_id: "mod_003_note_duration", order: 6,
    steps: [
      %{text: "Blanca Do + Blanca Re = 1 compás", note: 60, hint: "2+2=4", finger: 1, duration: 4},
      %{text: "Blanca Do + Negra Re + Negra Mi = 1 compás", note: 60, hint: "2+1+1=4", finger: 1, duration: 4},
      %{text: "Negra Do + Negra Re + Negra Mi + Negra Fa = 1 compás", note: 60, hint: "1+1+1+1=4", finger: 1, duration: 4},
      %{text: "Redonda Do = 1 compás (nota única larga)", note: 60, hint: "4=4", finger: 1, duration: 4},
      %{text: "Practica: Blanca + Negra + Negra, con diferentes notas", note: 60, hint: "Do-Re-Mi", finger: 1, duration: 4},
      %{text: "Escucha los patrones diferentes de duración", note: 60, hint: "Ritmo varía", finger: 1, duration: 8}
    ],
    focus: "Combining different durations within measure constraints", new_concepts: ["mixed_note_durations", "measure_arithmetic", "rhythm_pattern_combinations", "duration_flexibility", "rhythmic_variety"],
    confidence_level_target: "Can execute various duration combinations", cognitive_complexity: "moderate", motor_complexity: "intermediate", duration_minutes: 39
  },

  %{id: "3_07_duration_symbols", title: "3.7 Los Símbolos de Duración", description: "Visualiza cómo se ven los símbolos para redonda, blanca, y negra.",
    intro: "Las notas se escriben diferente según su duración. Redonda: óvalo blanco sin tallo. Blanca: óvalo blanco con tallo. Negra: círculo negro con tallo.",
    metronome: false, module_id: "mod_003_note_duration", order: 7,
    steps: [
      %{text: "Ves una redonda - Toca la nota y sostén 4 tiempos", note: 60, hint: "Símbolo: óvalo blanco", finger: 1, duration: 0},
      %{text: "Ves una blanca - Toca la nota y sostén 2 tiempos", note: 62, hint: "Símbolo: óvalo blanco + tallo", finger: 2, duration: 0},
      %{text: "Ves una negra - Toca rápido, 1 tiempo", note: 64, hint: "Símbolo: negro lleno + tallo", finger: 3, duration: 0},
      %{text: "Identifica: Redonda vs Blanca - ¿Cuál es cuál?", note: 0, hint: "Mira el tallo", finger: 0, duration: 0},
      %{text: "Identifica: Blanca vs Negra - ¿Cuál es cuál?", note: 0, hint: "Mira si está relleno", finger: 0, duration: 0},
      %{text: "Identifica todas las duraciones en una fila", note: 0, hint: "Redonda, Blanca, Blanca, Negra, Negra", finger: 0, duration: 0}
    ],
    focus: "Reading written duration notation and symbol recognition", new_concepts: ["notation_symbols", "visual_duration_identification", "stem_visual_cues", "fill_visual_cues", "symbol_to_duration_mapping"],
    confidence_level_target: "Can identify durations from notation", cognitive_complexity: "moderate", motor_complexity: "basic", duration_minutes: 44
  },

  %{id: "3_08_duration_metronome_exercise", title: "3.8 Ejercicio de Duración con Metrónomo", description: "Practica tocando diferentes duraciones mientras el metrónomo marca el tiempo.",
    intro: "El metrónomo te ayuda a mantener el tempo. Cada click del metrónomo = 1 tiempo. Toca notas según su duración.",
    metronome: true, module_id: "mod_003_note_duration", order: 8,
    steps: [
      %{text: "Metrónomo: Toca Do redonda (4 clicks)", note: 60, hint: "Escucha 4 clicks", finger: 1, duration: 4},
      %{text: "Metrónomo: Toca Re blanca (2 clicks)", note: 62, hint: "Escucha 2 clicks", finger: 2, duration: 2},
      %{text: "Metrónomo: Toca Mi blanca (2 clicks)", note: 64, hint: "Escucha 2 clicks", finger: 3, duration: 2},
      %{text: "Metrónomo: Toca escala de negras (8 notas)", note: 60, hint: "1 click por nota", finger: 1, duration: 8},
      %{text: "Metrónomo: Blanca Do + 2 negras Re", note: 60, hint: "2 + 1 + 1 = 4", finger: 1, duration: 4},
      %{text: "Metrónomo: Practica patrón de tu elección", note: 60, hint: "Experimenta", finger: 1, duration: 4}
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
