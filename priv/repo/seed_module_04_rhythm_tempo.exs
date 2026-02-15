# Seed: Módulo 4 - Ritmo y Tempo (Rhythm and Tempo Exercises)
# BABY STEPS: Ejercicios prácticos de ritmo con metrónomo
# Domina mantener tempo constante

alias MusicIan.Repo
alias MusicIan.Curriculum.Lesson

IO.puts("\n" <> String.duplicate("=", 70))
IO.puts("📚 SEEDING MODULE 4: Ritmo y Tempo - Ejercicios Prácticos")
IO.puts(String.duplicate("=", 70))

lessons_module_04 = [
  # Lesson 4.1 - Understanding Tempo
  %{
    id: "4_01_understanding_tempo",
    title: "4.1 Qué es el Tempo",
    description: "El tempo es la velocidad a la que tocas. Se mide en BPM (beats por minuto).",
    intro:
      "Tempo = velocidad. Lento es como 60 BPM. Normal es como 120 BPM. Rápido es como 160 BPM. El metrónomo marca el tempo.",
    metronome: true,
    module_id: "mod_004_rhythm_tempo",
    focus: "Understand tempo and BPM with metronome guidance",
    new_concepts: ["tempo", "BPM", "metronome", "pulse"],
    confidence_level_target: "coordinación",
    cognitive_complexity: "basic",
    motor_complexity: "basic",
    duration_minutes: 26,
    order: 1,
    steps: [
      %{text: "Metrónomo LENTO (60 BPM): Cuenta 1-2-3-4 con cada click", note: 0, hint: "Un click cada 1 tiempo", finger: 0, duration: 4},
      %{text: "Metrónomo NORMAL (120 BPM): Cuenta 1-2-3-4", note: 0, hint: "El doble de rápido", finger: 0, duration: 4},
      %{text: "Toca Do en cada click del metrónomo lento", note: 60, hint: "1 nota por click", finger: 1, duration: 4},
      %{text: "Toca Do en cada click del metrónomo normal", note: 60, hint: "El doble de rápido", finger: 1, duration: 4},
      %{text: "¿Cuál es más rápido? Tempo rápido vs lento", note: 0, hint: "Mismo ritmo, diferente velocidad", finger: 0, duration: 0}
    ]
  },

  # Lesson 4.2 - Steady Pulse with Whole Notes
  %{
    id: "4_02_steady_pulse_whole",
    title: "4.2 Pulso Constante - Redondas",
    description: "Practica tocar redondas (4 tiempos) manteniendo un pulso constante con el metrónomo.",
    intro:
      "Una redonda dura exactamente 4 clicks del metrónomo. Toca una nota, sostén por 4 clicks sin acelerar ni desacelerar. Eso es pulso constante.",
    metronome: true,
    module_id: "mod_004_rhythm_tempo",
    focus: "Master whole note timing and consistent pulse control",
    new_concepts: ["whole notes", "four beats", "sustained tone", "pulse consistency"],
    confidence_level_target: "coordinación",
    cognitive_complexity: "basic",
    motor_complexity: "intermediate",
    duration_minutes: 27,
    order: 2,
    steps: [
      %{text: "Toca Do redonda (escucha 4 clicks)", note: 60, hint: "No te apures", finger: 1, duration: 4},
      %{text: "Levanta el dedo exactamente al 4to click", note: 60, hint: "Timing preciso", finger: 1, duration: 4},
      %{text: "Toca Re redonda", note: 62, hint: "Otros 4 clicks", finger: 2, duration: 4},
      %{text: "Toca Mi redonda", note: 64, hint: "4 clicks más", finger: 3, duration: 4},
      %{text: "Secuencia: Do-Re-Mi redondas", note: 60, hint: "Sin cambiar tempo", finger: 1, duration: 12},
      %{text: "Practica: Escala completa de redondas", note: 60, hint: "Do-Re-Mi-Fa-Sol-La-Si-Do", finger: 1, duration: 32}
    ]
  },

  # Lesson 4.3 - Steady Pulse with Half Notes
  %{
    id: "4_03_steady_pulse_half",
    title: "4.3 Pulso Constante - Blancas",
    description: "Practica tocar blancas (2 tiempos) manteniendo el pulso. Son el doble de rápido que las redondas.",
    intro:
      "Una blanca dura 2 clicks. Toca una nota, sostén por 2 clicks, luego toca la siguiente. Mantén el mismo tempo del metrónomo.",
    metronome: true,
    module_id: "mod_004_rhythm_tempo",
    focus: "Play half notes with accurate timing at moderate tempo",
    new_concepts: ["half notes", "two beats", "note transitions", "rhythm subdivision"],
    confidence_level_target: "coordinación",
    cognitive_complexity: "basic",
    motor_complexity: "intermediate",
    duration_minutes: 29,
    order: 3,
    steps: [
      %{text: "Toca Do blanca (2 clicks)", note: 60, hint: "Cuenta 1-2", finger: 1, duration: 2},
      %{text: "Toca Re blanca (2 clicks)", note: 62, hint: "Cuenta 1-2 nuevamente", finger: 2, duration: 2},
      %{text: "Mi-Fa blancas", note: 64, hint: "2 clicks cada una", finger: 3, duration: 4},
      %{text: "Dos blancas por compás", note: 60, hint: "Do-Re (completa un compás)", finger: 1, duration: 4},
      %{text: "Escala de blancas arriba", note: 60, hint: "Do-Re-Mi-Fa-Sol-La-Si-Do", finger: 1, duration: 16},
      %{text: "Escala de blancas abajo", note: 72, hint: "Do-Si-La-Sol-Fa-Mi-Re-Do", finger: 5, duration: 16}
    ]
  },

  # Lesson 4.4 - Steady Pulse with Quarter Notes
  %{
    id: "4_04_steady_pulse_quarter",
    title: "4.4 Pulso Constante - Negras",
    description: "Practica tocar negras (1 tiempo) rápidamente. Mantén el pulso sin acelerarte.",
    intro:
      "Una negra dura 1 click. Es rápido. Toca 4 negras en un compás. No aceleres - deja que el metrónomo te guíe.",
    metronome: true,
    module_id: "mod_004_rhythm_tempo",
    focus: "Execute quarter notes with precision and tempo control",
    new_concepts: ["quarter notes", "one beat", "rapid articulation", "pulse coordination"],
    confidence_level_target: "coordinación",
    cognitive_complexity: "intermediate",
    motor_complexity: "intermediate",
    duration_minutes: 32,
    order: 4,
    steps: [
      %{text: "Toca Do negra en cada click", note: 60, hint: "Click = una nota", finger: 1, duration: 1},
      %{text: "Cuatro Do negras = 1 compás", note: 60, hint: "Do-Do-Do-Do", finger: 1, duration: 4},
      %{text: "Escala de negras: Do-Re-Mi-Fa-Sol-La-Si-Do", note: 60, hint: "Rápida, fluida", finger: 1, duration: 8},
      %{text: "Escala reversa de negras", note: 72, hint: "Abajo", finger: 5, duration: 8},
      %{text: "Arriba-abajo-arriba de negras", note: 60, hint: "Tres veces", finger: 1, duration: 24},
      %{text: "Mantén tempo: no aceleres ni desacelers", note: 60, hint: "Confianza", finger: 1, duration: 8}
    ]
  },

  # Lesson 4.5 - Mixed Rhythms in One Measure
  %{
    id: "4_05_mixed_rhythms",
    title: "4.5 Ritmos Mixtos en un Compás",
    description: "Combina redondas, blancas y negras en el mismo compás.",
    intro:
      "Ahora vamos a mezclar duraciones. Ejemplo: Blanca Do + Negra Re + Negra Mi = 1 compás. El metrónomo te mantiene en tiempo.",
    metronome: true,
    module_id: "mod_004_rhythm_tempo",
    focus: "Combine multiple note durations within a single measure",
    new_concepts: ["mixed rhythms", "rhythmic integration", "measure subdivision", "beat allocation"],
    confidence_level_target: "estructura",
    cognitive_complexity: "intermediate",
    motor_complexity: "intermediate",
    duration_minutes: 36,
    order: 5,
    steps: [
      %{text: "Blanca Do (2 clicks) + Blanca Re (2 clicks)", note: 60, hint: "2+2=4", finger: 1, duration: 4},
      %{text: "Blanca Do (2) + Negra Re (1) + Negra Mi (1)", note: 60, hint: "2+1+1=4", finger: 1, duration: 4},
      %{text: "Negra Do (1) + Negra Re (1) + Blanca Mi (2)", note: 60, hint: "1+1+2=4", finger: 1, duration: 4},
      %{text: "Negra Do-Re-Mi-Fa", note: 60, hint: "1+1+1+1=4", finger: 1, duration: 4},
      %{text: "Patrón: Blanca-Negra-Negra, Blanca-Negra-Negra", note: 60, hint: "Dos compases", finger: 1, duration: 8},
      %{text: "Tu propio patrón rítmico", note: 60, hint: "Experimenta combinaciones", finger: 1, duration: 8}
    ]
  },

  # Lesson 4.6 - Rhythm Pattern Recognition
  %{
    id: "4_06_rhythm_patterns",
    title: "4.6 Patrones de Ritmo Comunes",
    description: "Aprende patrones de ritmo que se repiten frecuentemente en música.",
    intro:
      "Existen patrones rítmicos comunes que escucharás una y otra vez. Vamos a practicar algunos básicos.",
    metronome: true,
    module_id: "mod_004_rhythm_tempo",
    focus: "Recognize and execute common rhythmic patterns with fluency",
    new_concepts: ["rhythm patterns", "motif recognition", "pattern repetition", "rhythmic identity"],
    confidence_level_target: "estructura",
    cognitive_complexity: "intermediate",
    motor_complexity: "intermediate",
    duration_minutes: 41,
    order: 6,
    steps: [
      %{text: "Patrón 1: Negra-Negra-Negra-Negra (constante)", note: 60, hint: "Pulso básico", finger: 1, duration: 4},
      %{text: "Patrón 2: Blanca-Blanca (lento, relajado)", note: 60, hint: "Dos notas largas", finger: 1, duration: 4},
      %{text: "Patrón 3: Blanca-Negra-Negra (variado)", note: 60, hint: "Larga-corta-corta", finger: 1, duration: 4},
      %{text: "Patrón 4: Negra-Negra-Blanca (variado inverso)", note: 60, hint: "Corta-corta-larga", finger: 1, duration: 4},
      %{text: "Repite Patrón 3 cuatro veces", note: 60, hint: "Blanca-Negra-Negra x 4", finger: 1, duration: 16},
      %{text: "Alterna: Patrón 3, Patrón 4, Patrón 3, Patrón 4", note: 60, hint: "Variedad", finger: 1, duration: 16}
    ]
  },

  # Lesson 4.7 - Tempo Control: Don't Rush, Don't Drag
  %{
    id: "4_07_tempo_control",
    title: "4.7 Control de Tempo - No Aceleres, No Desacelers",
    description: "La lección más importante: mantén el tempo consistente todo el tiempo.",
    intro:
      "Es natural acelerar cuando tocas rápido, o desacelerar cuando cansas. Pero eso no es profesional. El metrónomo es tu amigo. Déjate guiar por él.",
    metronome: true,
    module_id: "mod_004_rhythm_tempo",
    focus: "Maintain unwavering tempo control and rhythmic consistency",
    new_concepts: ["tempo consistency", "rushing", "dragging", "metronome mastery"],
    confidence_level_target: "estructura",
    cognitive_complexity: "intermediate",
    motor_complexity: "intermediate",
    duration_minutes: 46,
    order: 7,
    steps: [
      %{text: "Escala de negras con metrónomo - Ve LENTAMENTE", note: 60, hint: "Resiste la tentación de acelerar", finger: 1, duration: 8},
      %{text: "Si aceleraste, vuelve a empezar LENTAMENTE", note: 60, hint: "Otra vez, con paciencia", finger: 1, duration: 8},
      %{text: "Ahora práctica 'dragging' - Ve MÁS LENTAMENTE", note: 60, hint: "Demasiado lento deliberadamente", finger: 1, duration: 8},
      %{text: "Encuentra el tempo JUSTO - ni rápido ni lento", note: 60, hint: "Con el metrónomo exactamente", finger: 1, duration: 8},
      %{text: "Practica: 4 compases sin acelerar", note: 60, hint: "Ritmo perfecto", finger: 1, duration: 16},
      %{text: "¡Éxito! Mantuviste el tempo consistente", note: 60, hint: "Profesionalismo", finger: 1, duration: 0}
    ]
  },

  # Lesson 4.8 - Complete Rhythm Exercise
  %{
    id: "4_08_complete_rhythm_exercise",
    title: "4.8 Ejercicio Rítmico Completo",
    description: "Toca una secuencia que combina lo aprendido: escalas, duraciones, patrones y tempo.",
    intro:
      "Ahora que dominas redondas, blancas, negras y tempo, vamos a hacer un ejercicio donde lo combinas todo.",
    metronome: true,
    module_id: "mod_004_rhythm_tempo",
    focus: "Execute complete rhythmic composition combining all learned skills",
    new_concepts: ["rhythmic synthesis", "tempo application", "note integration", "performance"],
    confidence_level_target: "estructura",
    cognitive_complexity: "intermediate",
    motor_complexity: "intermediate",
    duration_minutes: 46,
    order: 8,
    steps: [
      %{text: "Compás 1: Do redonda (toda la duración)", note: 60, hint: "Relajado", finger: 1, duration: 4},
      %{text: "Compás 2: Do blanca + Re blanca", note: 60, hint: "Dos notas", finger: 1, duration: 4},
      %{text: "Compás 3: Escala de negras: Do-Re-Mi-Fa", note: 60, hint: "Rápido pero controlado", finger: 1, duration: 4},
      %{text: "Compás 4: Sol blanca + La negra + Si negra", note: 67, hint: "Mezcla", finger: 5, duration: 4},
      %{text: "Repite 4 compases completos", note: 60, hint: "Patrón entero", finger: 1, duration: 16},
      %{text: "¡Acabas de tocar una pequeña pieza!", note: 60, hint: "Con ritmo y tempo", finger: 1, duration: 0}
    ]
  }
]

IO.puts("🎵 Inserting #{Enum.count(lessons_module_04)} lessons...")

Enum.each(lessons_module_04, fn lesson ->
  MusicIan.Repo.insert!(MusicIan.Curriculum.Lesson.changeset(%MusicIan.Curriculum.Lesson{}, lesson))
end)

IO.puts("✅ Module 4 (Rhythm and Tempo) lessons inserted!")
IO.puts(String.duplicate("=", 70) <> "\n")
