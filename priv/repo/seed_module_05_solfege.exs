# Seed: Módulo 5 - Solfeo (Staff Reading and Note Identification)
# BABY STEPS: Aprender a leer notas en el pentagrama
# Conectar notación con sonido

alias MusicIan.Repo
alias MusicIan.Curriculum.Lesson

IO.puts("\n" <> String.duplicate("=", 70))
IO.puts("📚 SEEDING MODULE 5: Solfeo - Leer Partituras")
IO.puts(String.duplicate("=", 70))

lessons_module_05 = [
  # Lesson 5.1 - The Staff (Pentagrama)
  %{
    id: "5_01_intro_staff",
    title: "5.1 El Pentagrama - Las Líneas y Espacios",
    description: "Entiende la estructura del pentagrama: 5 líneas y 4 espacios donde escribimos las notas.",
    intro:
      "La música se escribe en un pentagrama. Hay 5 líneas horizontales. Entre las líneas hay espacios. Las notas se escriben en las líneas O en los espacios.",
    metronome: false,
    module_id: "mod_005_solfege",
    focus: "Understand the staff structure and note positioning fundamentals",
    new_concepts: ["pentagrama", "staff lines", "spaces", "note placement"],
    confidence_level_target: "estructura",
    cognitive_complexity: "basic",
    motor_complexity: "basic",
    duration_minutes: 28,
    order: 1,
    steps: [
      %{text: "Ve el pentagrama: 5 líneas", note: 0, hint: "De abajo hacia arriba", finger: 0, duration: 0},
      %{text: "Entre las líneas hay 4 espacios", note: 0, hint: "Los espacios vacíos", finger: 0, duration: 0},
      %{text: "Una nota puede estar EN una línea", note: 0, hint: "En la línea misma", finger: 0, duration: 0},
      %{text: "O una nota puede estar EN un espacio", note: 0, hint: "Entre dos líneas", finger: 0, duration: 0},
      %{text: "Cuenta las líneas: 1-2-3-4-5 de abajo a arriba", note: 0, hint: "Número de cada línea", finger: 0, duration: 0},
      %{text: "Señala cada línea y cada espacio", note: 0, hint: "Familiaridad", finger: 0, duration: 0}
    ]
  },

  # Lesson 5.2 - Treble Clef (Clave de Sol)
  %{
    id: "5_02_treble_clef",
    title: "5.2 La Clave de Sol (Treble Clef)",
    description: "La clave de Sol se usa para notas agudas. Identifica dónde están los Do-Re-Mi-Fa-Sol en el pentagrama.",
    intro:
      "La clave de Sol es un símbolo al inicio del pentagrama. Se ve como una espiral. La espiral rodea la segunda línea. Eso nos dice dónde está cada nota.",
    metronome: false,
    module_id: "mod_005_solfege",
    focus: "Master treble clef recognition and spatial reference points",
    new_concepts: ["treble clef", "clef symbol", "reference notes", "G position"],
    confidence_level_target: "estructura",
    cognitive_complexity: "basic",
    motor_complexity: "basic",
    duration_minutes: 29,
    order: 2,
    steps: [
      %{text: "Mira la clave de Sol: una espiral", note: 0, hint: "Símbolo bonito", finger: 0, duration: 0},
      %{text: "La espiral rodea la 2da línea", note: 0, hint: "Eso es Sol (G)", finger: 0, duration: 0},
      %{text: "Por eso se llama 'Clave de Sol'", note: 0, hint: "La nota Sol en la 2da línea", finger: 0, duration: 0},
      %{text: "Si Sol está en la 2da línea, donde está Do?", note: 0, hint: "Abajo", finger: 0, duration: 0},
      %{text: "Do Central está EN un espacio (línea 1)", note: 0, hint: "El espacio más bajo", finger: 0, duration: 0},
      %{text: "Identifica: Línea 2 = Sol, Espacio 1 = Do", note: 0, hint: "Puntos de referencia", finger: 0, duration: 0}
    ]
  },

  # Lesson 5.3 - Notes on the Lines (Las Líneas)
  %{
    id: "5_03_notes_on_lines",
    title: "5.3 Las Notas en las Líneas",
    description: "Memoriza las notas que están en las 5 líneas del pentagrama en clave de Sol.",
    intro:
      "En la clave de Sol, las líneas (de abajo a arriba) son: Mi-Sol-Si-Re-Fa. Es fácil recordar: 'Mi-Sol-Si-Re-Fa'. Practica identificar cada una.",
    metronome: false,
    module_id: "mod_005_solfege",
    focus: "Memorize line notes and build rapid note identification skills",
    new_concepts: ["line notes", "E-G-B-D-F", "mnemonic recall", "staff positions"],
    confidence_level_target: "estructura",
    cognitive_complexity: "intermediate",
    motor_complexity: "basic",
    duration_minutes: 31,
    order: 3,
    steps: [
      %{text: "Línea 1 (abajo) = Mi", note: 64, hint: "Primera línea desde abajo", finger: 3, duration: 0},
      %{text: "Línea 2 = Sol", note: 67, hint: "Segunda línea", finger: 5, duration: 0},
      %{text: "Línea 3 (centro) = Si", note: 71, hint: "Línea central", finger: 0, duration: 0},
      %{text: "Línea 4 = Re", note: 74, hint: "Cuarta línea", finger: 0, duration: 0},
      %{text: "Línea 5 (arriba) = Fa", note: 77, hint: "Línea superior", finger: 0, duration: 0},
      %{text: "Mnemónico: Mi-Sol-Si-Re-Fa", note: 0, hint: "Recuerda esto", finger: 0, duration: 0}
    ]
  },

  # Lesson 5.4 - Notes in the Spaces (Los Espacios)
  %{
    id: "5_04_notes_in_spaces",
    title: "5.4 Las Notas en los Espacios",
    description: "Memoriza las notas que están en los 4 espacios del pentagrama en clave de Sol.",
    intro:
      "Los espacios (de abajo a arriba) entre las líneas son: Fa-La-Do-Mi. Lee la primera letra de cada palabra: 'F-A-C-E' que forma la palabra 'FACE'. Fácil de recordar.",
    metronome: false,
    module_id: "mod_005_solfege",
    focus: "Memorize space notes and integrate with line note knowledge",
    new_concepts: ["space notes", "F-A-C-E", "interval mapping", "staff fluency"],
    confidence_level_target: "ejecución",
    cognitive_complexity: "intermediate",
    motor_complexity: "basic",
    duration_minutes: 34,
    order: 4,
    steps: [
      %{text: "Espacio 1 (entre líneas 1-2) = Fa", note: 65, hint: "Primer espacio", finger: 4, duration: 0},
      %{text: "Espacio 2 (entre líneas 2-3) = La", note: 69, hint: "Segundo espacio", finger: 0, duration: 0},
      %{text: "Espacio 3 (entre líneas 3-4) = Do", note: 72, hint: "Tercer espacio", finger: 1, duration: 0},
      %{text: "Espacio 4 (entre líneas 4-5) = Mi", note: 76, hint: "Cuarto espacio", finger: 3, duration: 0},
      %{text: "Mnemónico: FACE", note: 0, hint: "Fa-La-Do-Mi", finger: 0, duration: 0},
      %{text: "O: Fa-La-Do-Mi en orden", note: 0, hint: "Memorizalo", finger: 0, duration: 0}
    ]
  },

  # Lesson 5.5 - Reading Notes Individually
  %{
    id: "5_05_read_notes_individual",
    title: "5.5 Leer Notas Individuales",
    description: "Se te muestra una nota en el pentagrama. Debes identificarla y tocarla en el teclado.",
    intro:
      "Una nota se ve como un punto (cabeza) que puede estar en una línea o espacio. Ahora que sabes Mi-Sol-Si-Re-Fa (líneas) y Fa-La-Do-Mi (espacios), identifica cada nota que ves.",
    metronome: false,
    module_id: "mod_005_solfege",
    focus: "Identify individual notes instantly and execute keyboard positioning",
    new_concepts: ["note recognition", "staff reading", "keyboard mapping", "visual fluency"],
    confidence_level_target: "ejecución",
    cognitive_complexity: "intermediate",
    motor_complexity: "intermediate",
    duration_minutes: 38,
    order: 5,
    steps: [
      %{text: "Nota en línea 1: ¿Cuál es? (Respuesta: Mi)", note: 64, hint: "¿Dónde está en el teclado?", finger: 3, duration: 0},
      %{text: "Nota en espacio 1: ¿Cuál es? (Respuesta: Fa)", note: 65, hint: "Identifica y toca", finger: 4, duration: 0},
      %{text: "Nota en línea 2: ¿Cuál es? (Respuesta: Sol)", note: 67, hint: "Toca en el teclado", finger: 5, duration: 0},
      %{text: "Nota en espacio 2: ¿Cuál es? (Respuesta: La)", note: 69, hint: "¿Dónde en el teclado?", finger: 0, duration: 0},
      %{text: "Nota en línea 3: ¿Cuál es? (Respuesta: Si)", note: 71, hint: "Centro del pentagrama", finger: 0, duration: 0},
      %{text: "Practica leyendo 5 notas aleatorias", note: 64, hint: "Identifica cada una", finger: 3, duration: 0}
    ]
  },

  # Lesson 5.6 - Simple Melodies on the Staff
  %{
    id: "5_06_simple_melodies_staff",
    title: "5.6 Melodías Simples en el Pentagrama",
    description: "Lee y toca pequeñas melodías escritas en el pentagrama.",
    intro:
      "Ahora que puedes leer notas individuales, vamos a leer secuencias. Lee cada nota de izquierda a derecha y tócalas. Recuerda contar también los valores de duración.",
    metronome: false,
    module_id: "mod_005_solfege",
    focus: "Read and perform simple melodies with smooth transitions",
    new_concepts: ["melodic reading", "note sequences", "fluent execution", "left-to-right parsing"],
    confidence_level_target: "ejecución",
    cognitive_complexity: "advanced",
    motor_complexity: "intermediate",
    duration_minutes: 43,
    order: 6,
    steps: [
      %{text: "Melodía 1: Do-Re-Mi (notas que suben)", note: 60, hint: "Escala simple", finger: 1, duration: 0},
      %{text: "Lee en el pentagrama: nota 1 = Do", note: 60, hint: "¿Dónde está en el teclado?", finger: 1, duration: 0},
      %{text: "Lee nota 2 = Re", note: 62, hint: "Siguiente", finger: 2, duration: 0},
      %{text: "Lee nota 3 = Mi", note: 64, hint: "Siguiente", finger: 3, duration: 0},
      %{text: "Toca la melodía: Do-Re-Mi en orden", note: 60, hint: "Fluida", finger: 1, duration: 0},
      %{text: "Melodía 2: Sol-La-Si-Do (más notas)", note: 67, hint: "Lee y toca", finger: 5, duration: 0}
    ]
  },

  # Lesson 5.7 - Reading with Durations
  %{
    id: "5_07_reading_with_durations",
    title: "5.7 Leer con Duración de Notas",
    description: "Lee notas Y sus duraciones (redonda, blanca, negra) en el pentagrama.",
    intro:
      "Hasta ahora leíste solo qué nota es. Ahora suma el símbolo de duración. Una nota rellena = negra (1 tiempo). Una nota blanca = blanca (2 tiempos). Etc.",
    metronome: true,
    module_id: "mod_005_solfege",
    focus: "Integrate note reading with rhythmic duration interpretation",
    new_concepts: ["note duration", "rhythmic notation", "tempo application", "metronome coordination"],
    confidence_level_target: "confianza",
    cognitive_complexity: "advanced",
    motor_complexity: "intermediate",
    duration_minutes: 48,
    order: 7,
    steps: [
      %{text: "Lee: Do redonda (óvalo blanco sin tallo)", note: 60, hint: "Sostén 4 tiempos", finger: 1, duration: 4},
      %{text: "Lee: Re blanca (óvalo blanco con tallo)", note: 62, hint: "Sostén 2 tiempos", finger: 2, duration: 2},
      %{text: "Lee: Mi negra (punto negro con tallo)", note: 64, hint: "1 tiempo", finger: 3, duration: 1},
      %{text: "Lee: Fa negra", note: 65, hint: "1 tiempo", finger: 4, duration: 1},
      %{text: "Lee una fila: Do redonda + Re blanca + Mi blanca", note: 60, hint: "4+2+2=8 tiempos", finger: 1, duration: 8},
      %{text: "Lee otra fila: Sol negra-La negra-Si blanca", note: 67, hint: "1+1+2=4 tiempos", finger: 5, duration: 4}
    ]
  },

  # Lesson 5.8 - Complete Reading Exercise
  %{
    id: "5_08_complete_reading_exercise",
    title: "5.8 Ejercicio Completo de Lectura",
    description: "Combina todo lo aprendido: lee notas en el pentagrama, identifica duraciones, toca en el teclado.",
    intro:
      "Este es el examen final del módulo. Te mostramos un fragmento de música con notas en el pentagrama. Debes leer cada nota, ver su duración, e interpretarla en el teclado.",
    metronome: true,
    module_id: "mod_005_solfege",
    focus: "Master comprehensive solfege reading with flawless execution",
    new_concepts: ["solfege synthesis", "comprehensive reading", "musical performance", "module mastery"],
    confidence_level_target: "confianza",
    cognitive_complexity: "advanced",
    motor_complexity: "intermediate",
    duration_minutes: 48,
    order: 8,
    steps: [
      %{text: "Compás 1: Lee Do redonda", note: 60, hint: "Óvalo blanco", finger: 1, duration: 4},
      %{text: "Compás 2: Lee Re blanca + Mi blanca", note: 62, hint: "Dos óvalos blancos", finger: 2, duration: 4},
      %{text: "Compás 3: Lee escala de negras: Fa-Sol-La-Si", note: 65, hint: "Cuatro puntos negros", finger: 4, duration: 4},
      %{text: "Compás 4: Lee Do-Si-La-Sol (negras bajando)", note: 72, hint: "Bajada", finger: 5, duration: 4},
      %{text: "Toca los 4 compases sin parar", note: 60, hint: "Pieza pequeña", finger: 1, duration: 16},
      %{text: "¡Acabas de leer y tocar música! ¡Felicidades!", note: 60, hint: "Solfeo dominado", finger: 1, duration: 0}
    ]
  }
]

IO.puts("🎵 Inserting #{Enum.count(lessons_module_05)} lessons...")

Enum.each(lessons_module_05, fn lesson ->
  MusicIan.Repo.insert!(MusicIan.Curriculum.Lesson.changeset(%MusicIan.Curriculum.Lesson{}, lesson))
end)

IO.puts("✅ Module 5 (Solfège - Staff Reading) lessons inserted!")
IO.puts(String.duplicate("=", 70) <> "\n")
