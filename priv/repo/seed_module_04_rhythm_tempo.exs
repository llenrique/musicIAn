# Seed: Módulo 4 - Ritmo y Tempo
# Cada step = una nota MIDI con duración válida (4=redonda, 2=blanca, 1=negra, 0.5=corchea)
# La suma de duraciones por lección es múltiplo de 4 (compás 4/4)

alias MusicIan.Repo
alias MusicIan.Curriculum.Lesson

IO.puts("\n" <> String.duplicate("=", 70))
IO.puts("📚 SEEDING MODULE 4: Ritmo y Tempo")
IO.puts(String.duplicate("=", 70))

lessons_module_04 = [
  %{id: "4_01_understanding_tempo",
    title: "4.1 Qué es el Tempo",
    description: "El tempo es la velocidad de la música. Se mide en BPM (beats por minuto).",
    intro: "Tempo = velocidad. El metrónomo marca cada beat. 60 BPM = 1 beat por segundo. 120 BPM = 2 beats por segundo. Escucha el metrónomo y toca Do en cada click.",
    metronome: true, timing_strictness: 0, time_signature: "4/4", module_id: "mod_004_rhythm_tempo", order: 1,
    steps: [
      %{text: "Escucha el metrónomo — cuenta 1-2-3-4", note: 0, hint: "Solo escucha", finger: 0, duration: 1},
      %{text: "Escucha otro compás — siente el pulso", note: 0, hint: "El click es regular", finger: 0, duration: 1},
      %{text: "Toca Do en el primer click", note: 60, hint: "Al ritmo del metrónomo", finger: 1, duration: 1},
      %{text: "Toca Do en el segundo click", note: 60, hint: "Sigue el pulso", finger: 1, duration: 1},
      %{text: "Toca Do en el tercer click", note: 60, hint: "Regular", finger: 1, duration: 1},
      %{text: "Toca Do en el cuarto click", note: 60, hint: "Fin del compás", finger: 1, duration: 1},
      %{text: "Toca Do en el primer click del compás 2", note: 60, hint: "Nuevo compás", finger: 1, duration: 1},
      %{text: "Toca Do en el cuarto click del compás 2", note: 60, hint: "¡Tempo constante!", finger: 1, duration: 1}
    ],
    focus: "Understanding tempo and BPM with metronome guidance",
    new_concepts: ["tempo", "bpm", "metronome", "pulse", "beat"],
    confidence_level_target: "Understands tempo as steady pulse",
    cognitive_complexity: "basic", motor_complexity: "basic", duration_minutes: 26
  },

  %{id: "4_02_steady_pulse_whole",
    title: "4.2 Pulso Constante — Redondas",
    description: "Practica redondas (4 tiempos) manteniendo un pulso constante.",
    intro: "Una redonda dura 4 clicks. Toca la nota y SOSTENLA durante 4 clicks antes de soltarla. No aprietes otra tecla hasta que el cuarto click suene.",
    metronome: true, timing_strictness: 2, time_signature: "4/4", module_id: "mod_004_rhythm_tempo", order: 2,
    steps: [
      %{text: "Do — redonda (sostén 4 clicks)", note: 60, hint: "Cuenta 1-2-3-4 en silencio", finger: 1, duration: 4},
      %{text: "Re — redonda (sostén 4 clicks)", note: 62, hint: "No apures el siguiente", finger: 2, duration: 4},
      %{text: "Mi — redonda (sostén 4 clicks)", note: 64, hint: "4 clicks exactos", finger: 3, duration: 4},
      %{text: "Fa — redonda (sostén 4 clicks)", note: 65, hint: "Sin apurarse", finger: 4, duration: 4},
      %{text: "Sol — redonda (sostén 4 clicks)", note: 67, hint: "Pulso constante", finger: 5, duration: 4},
      %{text: "La — redonda (sostén 4 clicks)", note: 69, hint: "Sigue el metrónomo", finger: 4, duration: 4},
      %{text: "Si — redonda (sostén 4 clicks)", note: 71, hint: "Casi terminamos", finger: 3, duration: 4},
      %{text: "Do alta — redonda (sostén 4 clicks)", note: 72, hint: "¡Escala completa de redondas!", finger: 5, duration: 4}
    ],
    focus: "Master whole note timing and consistent pulse control",
    new_concepts: ["whole_note_timing", "four_beat_sustain", "pulse_consistency", "note_release"],
    confidence_level_target: "Can sustain whole notes with steady pulse",
    cognitive_complexity: "basic", motor_complexity: "intermediate", duration_minutes: 27
  },

  %{id: "4_03_steady_pulse_half",
    title: "4.3 Pulso Constante — Blancas",
    description: "Practica blancas (2 tiempos) manteniendo el pulso. Son el doble de rápido que las redondas.",
    intro: "Una blanca dura 2 clicks. Toca, sostén 2 clicks, luego toca la siguiente. El metrónomo te guía. Dos blancas caben exactamente en un compás.",
    metronome: true, timing_strictness: 2, time_signature: "4/4", module_id: "mod_004_rhythm_tempo", order: 3,
    steps: [
      %{text: "Do — blanca (sostén 2 clicks)", note: 60, hint: "Cuenta 1-2", finger: 1, duration: 2},
      %{text: "Re — blanca (sostén 2 clicks)", note: 62, hint: "Segundo tiempo del compás", finger: 2, duration: 2},
      %{text: "Mi — blanca (sostén 2 clicks)", note: 64, hint: "Primer tiempo del nuevo compás", finger: 3, duration: 2},
      %{text: "Fa — blanca (sostén 2 clicks)", note: 65, hint: "Segundo tiempo", finger: 4, duration: 2},
      %{text: "Sol — blanca (sostén 2 clicks)", note: 67, hint: "Primer tiempo", finger: 5, duration: 2},
      %{text: "La — blanca (sostén 2 clicks)", note: 69, hint: "Segundo tiempo", finger: 4, duration: 2},
      %{text: "Si — blanca (sostén 2 clicks)", note: 71, hint: "Primer tiempo", finger: 3, duration: 2},
      %{text: "Do alta — blanca (sostén 2 clicks)", note: 72, hint: "¡Escala completa de blancas!", finger: 5, duration: 2}
    ],
    focus: "Play half notes with accurate timing at moderate tempo",
    new_concepts: ["half_note_timing", "two_beat_sustain", "rhythm_subdivision", "note_transitions"],
    confidence_level_target: "Can play half notes with steady pulse",
    cognitive_complexity: "basic", motor_complexity: "intermediate", duration_minutes: 29
  },

  %{id: "4_04_steady_pulse_quarter",
    title: "4.4 Pulso Constante — Negras",
    description: "Practica negras (1 tiempo). Son el pulso básico de la música.",
    intro: "Una negra dura 1 click — toca y suelta inmediatamente. Hay 4 negras por compás. No apures, no te retrases. Deja que el metrónomo sea tu guía.",
    metronome: true, timing_strictness: 2, time_signature: "4/4", module_id: "mod_004_rhythm_tempo", order: 4,
    steps: [
      %{text: "Do — negra (toca y suelta)", note: 60, hint: "1 click exacto", finger: 1, duration: 1},
      %{text: "Re — negra", note: 62, hint: "En el siguiente click", finger: 2, duration: 1},
      %{text: "Mi — negra", note: 64, hint: "Sigue el ritmo", finger: 3, duration: 1},
      %{text: "Fa — negra", note: 65, hint: "Cuatro negras = 1 compás", finger: 4, duration: 1},
      %{text: "Sol — negra", note: 67, hint: "Nuevo compás", finger: 5, duration: 1},
      %{text: "La — negra", note: 69, hint: "Constante", finger: 4, duration: 1},
      %{text: "Si — negra", note: 71, hint: "Sin apurarse", finger: 3, duration: 1},
      %{text: "Do alta — negra (¡escala completa!)", note: 72, hint: "8 negras = 2 compases", finger: 5, duration: 1}
    ],
    focus: "Execute quarter notes with precision and tempo control",
    new_concepts: ["quarter_note_timing", "one_beat_articulation", "pulse_coordination", "tempo_control"],
    confidence_level_target: "Can play quarter notes with steady pulse",
    cognitive_complexity: "intermediate", motor_complexity: "intermediate", duration_minutes: 32
  },

  %{id: "4_05_mixed_rhythms",
    title: "4.5 Ritmos Mixtos en un Compás",
    description: "Combina redondas, blancas y negras. La suma siempre debe ser 4 tiempos por compás.",
    intro: "Ahora mezclamos. Ejemplo: blanca(2) + negra(1) + negra(1) = 4. O: negra(1) + negra(1) + blanca(2) = 4. La suma siempre es 4 en 4/4.",
    metronome: true, timing_strictness: 2, time_signature: "4/4", module_id: "mod_004_rhythm_tempo", order: 5,
    steps: [
      %{text: "Do — blanca", note: 60, hint: "2 tiempos", finger: 1, duration: 2},
      %{text: "Re — negra", note: 62, hint: "1 tiempo", finger: 2, duration: 1},
      %{text: "Mi — negra (2+1+1=4 ✓)", note: 64, hint: "Cierra el compás", finger: 3, duration: 1},
      %{text: "Fa — negra", note: 65, hint: "1 tiempo", finger: 4, duration: 1},
      %{text: "Sol — negra", note: 67, hint: "1 tiempo", finger: 5, duration: 1},
      %{text: "La — blanca (1+1+2=4 ✓)", note: 69, hint: "Cierra el compás", finger: 4, duration: 2},
      %{text: "Do — negra", note: 60, hint: "1 tiempo", finger: 1, duration: 1},
      %{text: "Re — negra", note: 62, hint: "1 tiempo", finger: 2, duration: 1},
      %{text: "Mi — negra", note: 64, hint: "1 tiempo", finger: 3, duration: 1},
      %{text: "Fa — negra (1+1+1+1=4 ✓)", note: 65, hint: "Cuatro negras", finger: 4, duration: 1},
      %{text: "Sol — redonda (4=4 ✓)", note: 67, hint: "Un compás entero", finger: 5, duration: 4}
    ],
    focus: "Combine multiple note durations within a single measure",
    new_concepts: ["mixed_rhythms", "measure_arithmetic", "duration_combinations", "rhythmic_variety"],
    confidence_level_target: "Can execute mixed duration patterns",
    cognitive_complexity: "intermediate", motor_complexity: "intermediate", duration_minutes: 36
  },

  %{id: "4_06_rhythm_patterns",
    title: "4.6 Patrones de Ritmo Comunes",
    description: "Practica los patrones rítmicos que más se repiten en música.",
    intro: "Dos patrones clásicos: (A) negra-negra-blanca (corta-corta-larga). (B) blanca-negra-negra (larga-corta-corta). Los practicaremos en secuencia.",
    metronome: true, timing_strictness: 2, time_signature: "4/4", module_id: "mod_004_rhythm_tempo", order: 6,
    steps: [
      %{text: "Do — negra (patrón A: inicio)", note: 60, hint: "Corta", finger: 1, duration: 1},
      %{text: "Re — negra (patrón A: medio)", note: 62, hint: "Corta", finger: 2, duration: 1},
      %{text: "Mi — blanca (patrón A: cierre 1+1+2=4 ✓)", note: 64, hint: "Larga — cierra el compás", finger: 3, duration: 2},
      %{text: "Fa — negra (patrón A: segundo compás)", note: 65, hint: "Corta", finger: 4, duration: 1},
      %{text: "Sol — negra", note: 67, hint: "Corta", finger: 5, duration: 1},
      %{text: "La — blanca (1+1+2=4 ✓)", note: 69, hint: "Larga", finger: 4, duration: 2},
      %{text: "Si — blanca (patrón B: inicio)", note: 71, hint: "Larga", finger: 3, duration: 2},
      %{text: "Do alta — negra (patrón B: medio)", note: 72, hint: "Corta", finger: 5, duration: 1},
      %{text: "Si — negra (patrón B: cierre 2+1+1=4 ✓)", note: 71, hint: "Corta — cierra el compás", finger: 4, duration: 1},
      %{text: "La — blanca (patrón B: repite)", note: 69, hint: "Larga", finger: 3, duration: 2},
      %{text: "Sol — negra", note: 67, hint: "Corta", finger: 5, duration: 1},
      %{text: "Fa — negra (2+1+1=4 ✓)", note: 65, hint: "Corta — cierra", finger: 4, duration: 1}
    ],
    focus: "Recognize and execute common rhythmic patterns with fluency",
    new_concepts: ["rhythm_patterns", "long_short_patterns", "pattern_repetition", "rhythmic_identity"],
    confidence_level_target: "Can execute common rhythmic patterns",
    cognitive_complexity: "intermediate", motor_complexity: "intermediate", duration_minutes: 41
  },

  %{id: "4_07_tempo_control",
    title: "4.7 Control de Tempo — No Aceleres, No Desacelers",
    description: "La disciplina más importante: mantener tempo absolutamente constante.",
    intro: "Es natural acelerar cuando tocas rápido o desacelerar cuando te cansas. El metrónomo es tu árbitro. Cada click = una negra. Sigue el metrónomo exactamente.",
    metronome: true, timing_strictness: 3, time_signature: "4/4", module_id: "mod_004_rhythm_tempo", order: 7,
    steps: [
      %{text: "Do — negra (¡no te adelantes!)", note: 60, hint: "Exactamente en el click", finger: 1, duration: 1},
      %{text: "Re — negra", note: 62, hint: "Ni antes ni después", finger: 2, duration: 1},
      %{text: "Mi — negra", note: 64, hint: "Constante", finger: 3, duration: 1},
      %{text: "Fa — negra", note: 65, hint: "Con el metrónomo", finger: 4, duration: 1},
      %{text: "Sol — negra", note: 67, hint: "Sin acelerar", finger: 5, duration: 1},
      %{text: "La — negra", note: 69, hint: "Sin desacelerar", finger: 4, duration: 1},
      %{text: "Si — negra", note: 71, hint: "Disciplina rítmica", finger: 3, duration: 1},
      %{text: "Do alta — negra", note: 72, hint: "¡Escala en tempo perfecto!", finger: 5, duration: 1}
    ],
    focus: "Maintain unwavering tempo control and rhythmic consistency",
    new_concepts: ["tempo_consistency", "no_rushing", "no_dragging", "metronome_discipline"],
    confidence_level_target: "Maintains steady tempo throughout",
    cognitive_complexity: "intermediate", motor_complexity: "intermediate", duration_minutes: 46
  },

  %{id: "4_08_complete_rhythm_exercise",
    title: "4.8 Ejercicio Rítmico Completo",
    description: "Combina redondas, blancas y negras en una secuencia musical completa.",
    intro: "Ejercicio final del módulo. Mezclarás los tres valores de nota en una pieza de 4 compases. Mantén tempo constante en todo momento.",
    metronome: true, timing_strictness: 2, time_signature: "4/4", module_id: "mod_004_rhythm_tempo", order: 8,
    steps: [
      %{text: "Do — redonda (compás 1)", note: 60, hint: "4 tiempos completos", finger: 1, duration: 4},
      %{text: "Re — blanca (compás 2)", note: 62, hint: "2 tiempos", finger: 2, duration: 2},
      %{text: "Mi — blanca (compás 2 completo: 2+2=4)", note: 64, hint: "2 tiempos", finger: 3, duration: 2},
      %{text: "Fa — negra (compás 3)", note: 65, hint: "1 tiempo", finger: 4, duration: 1},
      %{text: "Sol — negra", note: 67, hint: "1 tiempo", finger: 5, duration: 1},
      %{text: "La — negra", note: 69, hint: "1 tiempo", finger: 4, duration: 1},
      %{text: "Si — negra (compás 3 completo: 1+1+1+1=4)", note: 71, hint: "1 tiempo", finger: 3, duration: 1},
      %{text: "Do alta — blanca (compás 4)", note: 72, hint: "2 tiempos", finger: 5, duration: 2},
      %{text: "Si — negra (compás 4)", note: 71, hint: "1 tiempo", finger: 4, duration: 1},
      %{text: "La — negra (compás 4 completo: 2+1+1=4)", note: 69, hint: "1 tiempo — ¡pieza completa!", finger: 3, duration: 1}
    ],
    focus: "Execute complete rhythmic composition combining all learned skills",
    new_concepts: ["rhythmic_synthesis", "complete_piece", "all_durations_combined", "performance"],
    confidence_level_target: "Can perform a complete multi-measure piece with varied durations",
    cognitive_complexity: "intermediate", motor_complexity: "intermediate", duration_minutes: 46
  }
]

IO.puts("🎵 Inserting #{Enum.count(lessons_module_04)} lessons...")

Enum.each(lessons_module_04, fn lesson ->
  MusicIan.Repo.insert!(
    MusicIan.Curriculum.Lesson.changeset(%MusicIan.Curriculum.Lesson{}, lesson),
    on_conflict: :replace_all,
    conflict_target: :id
  )
end)

IO.puts("✅ Module 4 (Ritmo y Tempo) lessons inserted!")
IO.puts(String.duplicate("=", 70) <> "\n")
