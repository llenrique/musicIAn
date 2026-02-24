# Seed: Módulo 1 - Fundamentos del Piano (Piano Fundamentals)
#
# ARQUITECTURA DE LECCIONES (v3 - Motor Temporal):
# Cada lección tiene:
#   - intro: Texto explicativo/conceptual completo
#   - steps: Solo steps con notas (practice, chord, generated)
#   - bpm: BPM sugerido para la práctica
#   - timing_strictness: 0=standby (sin penalización), 1-5 = progresivo
#   - loop: true = práctica repetitiva, false = secuencia única
#
# El campo :type en cada step determina cómo el motor lo valida:
#   "practice"    → debe coincidir con step[:note]
#   "chord"       → debe coincidir con step[:notes]
#   "generated"   → el motor genera el ejercicio con ExerciseGenerator
#
# Los steps de "observation" fueron eliminados. Su texto va en :intro.
#
# LOOP CONFIGURATION:
#   loop: true  → Lecciones de práctica repetitiva (escalas, ejercicios técnicos)
#   loop: false → Lecciones explicativas, melodías, evaluaciones
#
# Progresión pedagógica del Módulo 1:
#   1.1 El mapa visual del teclado          → loop: false (exploración guiada)
#   1.2 El patrón 2-3 de teclas negras      → loop: false (aprendizaje de concepto)
#   1.3 El Do central (C4) como hogar       → loop: true (memoria muscular)
#   1.4 Octavas: el patrón se repite        → loop: true (práctica de octavas)
#   1.5 Encuentra cualquier Do (generado)   → loop: true (ejercicios aleatorios)
#   1.6 Posición de la mano                 → loop: false (técnica inicial)
#   1.7 Panorama completo del teclado       → loop: true (integración práctica)

alias MusicIan.Repo
alias MusicIan.Curriculum.Lesson

IO.puts("\n" <> String.duplicate("=", 70))
IO.puts("SEEDING MODULE 1: Fundamentos del Teclado (v3 - Motor Temporal)")
IO.puts(String.duplicate("=", 70))

lessons_module_01 = [
  # ===========================================================================
  # Lesson 1.1 — El mapa visual del teclado
  # ===========================================================================
  %{
    id: "1_01_meet_the_piano",
    title: "1.1 El mapa visual del teclado",
    description:
      "Explora la estructura del piano. Aprende a reconocer el patrón de teclas negras y úsalo para encontrar todos los Do's del teclado.",
    intro:
      "El piano parece complicado con tantas teclas, pero en realidad sigue un patrón muy simple que se repite. " <>
        "Observa el teclado completo: hay teclas BLANCAS y teclas NEGRAS. Las negras NUNCA van solas — siempre están en grupos de 2 o de 3. " <>
        "Este patrón (2 negras, 3 negras) se repite a lo largo de TODO el piano. " <>
        "Aquí está el secreto: la tecla blanca a la IZQUIERDA del grupo de 2 negras siempre es un DO. " <>
        "Como el patrón se repite, hay VARIOS Do's en el piano — uno por cada repetición del patrón. " <>
        "En esta lección vas a encontrar todos los Do's del piano de izquierda a derecha.",
    metronome: false,
    bpm: 60,
    timing_strictness: 0,
    time_signature: "4/4",
    loop: false,
    module_id: "mod_001_piano_fundamentals",
    order: 1,
    steps: [
      %{
        type: "practice",
        text: "Toca el Do más grave del piano (C2 — el Do más a la izquierda del teclado).",
        note: 36,
        hint:
          "Busca el primer grupo de 2 negras desde la izquierda. La blanca antes de ellas es C2.",
        finger: 1,
        duration: 1
      },
      %{
        type: "practice",
        text: "Siguiente Do. Sube una octava: C3.",
        note: 48,
        hint: "Busca el siguiente grupo de 2 negras. La blanca a su izquierda.",
        finger: 1,
        duration: 1
      },
      %{
        type: "practice",
        text: "Siguiente Do: C4 — el Do Central. El corazón del piano.",
        note: 60,
        hint: "Está aproximadamente en el centro del teclado.",
        finger: 1,
        duration: 1
      },
      %{
        type: "practice",
        text: "Siguiente Do: C5. Una octava arriba del central.",
        note: 72,
        hint: "El mismo patrón, más a la derecha.",
        finger: 1,
        duration: 1
      },
      %{
        type: "practice",
        text: "Siguiente Do: C6.",
        note: 84,
        hint: "Suena más agudo cada vez.",
        finger: 1,
        duration: 1
      },
      %{
        type: "practice",
        text: "Último Do del recorrido: C7.",
        note: 96,
        hint: "Casi en el extremo derecho del piano.",
        finger: 1,
        duration: 1
      }
    ],
    focus:
      "Visual recognition of keyboard layout and finding all C notes using the 2-3 black key pattern",
    new_concepts: [
      "black_key_2_3_pattern",
      "c_note_location",
      "keyboard_left_to_right",
      "octave_repetition"
    ],
    confidence_level_target:
      "Can find any C note on the full keyboard using the 2-3 pattern as a visual guide",
    cognitive_complexity: "basic",
    motor_complexity: "basic",
    duration_minutes: 20
  },

  # ===========================================================================
  # Lesson 1.2 — El patrón 2-3 como mapa de navegación
  # ===========================================================================
  %{
    id: "1_02_white_black_pattern",
    title: "1.2 El patrón 2-3: tu mapa del piano",
    description:
      "Domina el patrón de teclas negras como sistema de navegación. Aprende a leer el teclado usando los grupos de 2 y 3 negras como referencia.",
    intro:
      "Ya sabes que las negras forman el patrón 2-3. Ahora vamos a usar ese patrón como un mapa. " <>
        "Un 'ciclo' del piano es: grupo de 2 negras + grupo de 3 negras. Ese ciclo se repite 7 veces. " <>
        "Alrededor del grupo de 2 negras hay 3 teclas blancas: Do (izquierda), Re (medio), Mi (derecha). " <>
        "Alrededor del grupo de 3 negras hay 4 teclas blancas: Fa, Sol, La, Si. " <>
        "Las 7 notas (Do Re Mi Fa Sol La Si) caben exactamente en un ciclo. Luego se repite.",
    metronome: false,
    bpm: 60,
    timing_strictness: 0,
    time_signature: "4/4",
    loop: false,
    module_id: "mod_001_piano_fundamentals",
    order: 2,
    steps: [
      %{
        type: "practice",
        text: "Toca Do (C4) — la blanca a la izquierda del grupo de 2 negras en el centro.",
        note: 60,
        hint: "La blanca antes de las 2 negras.",
        finger: 1,
        duration: 1
      },
      %{
        type: "practice",
        text: "Toca Re (D4) — la blanca entre las 2 negras.",
        note: 62,
        hint: "En el espacio del medio.",
        finger: 2,
        duration: 1
      },
      %{
        type: "practice",
        text: "Toca Mi (E4) — la blanca después de las 2 negras.",
        note: 64,
        hint: "A la derecha del grupo de 2.",
        finger: 3,
        duration: 1
      },
      %{
        type: "practice",
        text: "Toca Fa (F4) — la primera blanca a la izquierda del grupo de 3 negras.",
        note: 65,
        hint: "Justo antes de las 3 negras.",
        finger: 4,
        duration: 1
      },
      %{
        type: "practice",
        text: "Toca Sol (G4) — entre la 1a y 2a negra del grupo de 3.",
        note: 67,
        hint: "Primer espacio entre las 3 negras.",
        finger: 5,
        duration: 1
      },
      %{
        type: "practice",
        text: "Toca La (A4) — entre la 2a y 3a negra del grupo de 3.",
        note: 69,
        hint: "Segundo espacio entre las 3 negras.",
        finger: 1,
        duration: 1
      },
      %{
        type: "practice",
        text: "Toca Si (B4) — la blanca después del grupo de 3 negras.",
        note: 71,
        hint: "La última antes de que empiece el siguiente Do.",
        finger: 2,
        duration: 1
      },
      %{
        type: "practice",
        text: "Y volvemos al Do (C5) — el ciclo se completó.",
        note: 72,
        hint: "El mismo Do pero una octava más arriba.",
        finger: 1,
        duration: 1
      }
    ],
    focus: "Using the 2-3 black key pattern to navigate all 7 white notes in one octave cycle",
    new_concepts: [
      "do_re_mi_fa_sol_la_si",
      "note_positions_relative_to_black_groups",
      "one_octave_cycle"
    ],
    confidence_level_target:
      "Can name and locate all 7 white notes in any octave using the 2-3 pattern",
    cognitive_complexity: "basic",
    motor_complexity: "intermediate",
    duration_minutes: 21
  },

  # ===========================================================================
  # Lesson 1.3 — El Do Central (C4): tu hogar en el piano
  # ===========================================================================
  %{
    id: "1_03_middle_c_intro",
    title: "1.3 El Do Central (C4): tu hogar",
    description:
      "Aprende a encontrar el Do Central (C4) como punto de referencia absoluto del piano. Desarrolla memoria muscular para encontrarlo incluso sin mirar.",
    intro:
      "En el piano hay un punto de referencia que todos los músicos usan: el Do Central (C4). " <>
        "Está aproximadamente en el centro del teclado, a la izquierda del grupo de 2 negras más cercano al centro físico. " <>
        "En un piano de 88 teclas, C4 es la tecla número 40 desde la izquierda. En MIDI su número es 60. " <>
        "El Do Central divide el piano en dos zonas: izquierda (mano izquierda) y derecha (mano derecha). " <>
        "Hoy lo vas a memorizar completamente — incluso sin mirar.",
    metronome: false,
    bpm: 60,
    timing_strictness: 0,
    time_signature: "4/4",
    loop: true,
    module_id: "mod_001_piano_fundamentals",
    order: 3,
    steps: [
      %{
        type: "practice",
        text: "Toca el Do Central (C4) con los ojos abiertos. Observa exactamente dónde está.",
        note: 60,
        hint: "Usa el grupo de 2 negras del centro. La blanca a su izquierda.",
        finger: 1,
        duration: 1
      },
      %{
        type: "practice",
        text: "Toca C4 de nuevo. Escucha bien su sonido — cálido, ni muy grave ni muy agudo.",
        note: 60,
        hint: "Memoriza este sonido. Es tu referencia auditiva.",
        finger: 1,
        duration: 1
      },
      %{
        type: "practice",
        text: "Mueve la mano al extremo derecho del piano. Ahora, sin mirar, vuelve a tocar C4.",
        note: 60,
        hint: "Usa el patrón de negras como guía táctil.",
        finger: 1,
        duration: 1
      },
      %{
        type: "practice",
        text: "Mueve la mano al extremo izquierdo. Vuelve a tocar C4 sin mirar.",
        note: 60,
        hint: "¿Encontraste el grupo de 2 negras en el centro?",
        finger: 1,
        duration: 1
      },
      %{
        type: "practice",
        text: "Una vez más: desde cualquier posición, encuentra C4.",
        note: 60,
        hint: "La práctica hace permanente la memoria muscular.",
        finger: 1,
        duration: 1
      }
    ],
    focus:
      "Kinesthetic and auditory memorization of Middle C (C4) as the absolute reference point",
    new_concepts: ["middle_c_c4", "piano_center_reference", "muscle_memory", "midi_60"],
    confidence_level_target:
      "Can find C4 with eyes closed from any position; recognizes its sound immediately",
    cognitive_complexity: "basic",
    motor_complexity: "intermediate",
    duration_minutes: 23
  },

  # ===========================================================================
  # Lesson 1.4 — Octavas: el patrón que se repite
  # ===========================================================================
  %{
    id: "1_04_locate_middle_c",
    title: "1.4 Octavas: el mismo Do, diferente altura",
    description:
      "Descubre el concepto de octava. Aprende que Do suena igual en todas partes del piano, solo cambia si es más grave o más agudo.",
    intro:
      "Ya sabes que hay varios Do's en el piano. ¿Pero por qué se llaman igual? " <>
        "Porque son la MISMA nota en distintas octavas. Una octava es la distancia de 7 notas blancas entre un Do y el siguiente. " <>
        "'Octa' significa 8 en latín (Do Re Mi Fa Sol La Si Do = 8 notas contando ambos extremos). " <>
        "El mismo Do suena parecido en cualquier octava — la diferencia es la ALTURA: más grave (izquierda) o más agudo (derecha). " <>
        "Hoy recorrerás todas las octavas de C, de grave a agudo y viceversa.",
    metronome: false,
    bpm: 60,
    timing_strictness: 0,
    time_signature: "4/4",
    loop: true,
    module_id: "mod_001_piano_fundamentals",
    order: 4,
    steps: [
      %{
        type: "practice",
        text: "Toca C1 — el Do más grave que usaremos. Muy grave, profundo.",
        note: 24,
        hint: "El segundo Do desde la izquierda del piano.",
        finger: 1,
        duration: 1
      },
      %{
        type: "practice",
        text: "Sube una octava: C2.",
        note: 36,
        hint: "7 teclas blancas a la derecha de C1.",
        finger: 1,
        duration: 1
      },
      %{
        type: "practice",
        text: "Sube otra octava: C3.",
        note: 48,
        hint: "Sigue subiendo. El sonido se hace más agudo.",
        finger: 1,
        duration: 1
      },
      %{
        type: "practice",
        text: "C4 — el Do Central. Tu hogar.",
        note: 60,
        hint: "Ya lo conoces bien.",
        finger: 1,
        duration: 1
      },
      %{
        type: "practice",
        text: "C5 — una octava arriba del central.",
        note: 72,
        hint: "El sonido sube pero sigue siendo 'Do'.",
        finger: 1,
        duration: 1
      },
      %{
        type: "practice",
        text: "C6.",
        note: 84,
        hint: "Cada vez más agudo.",
        finger: 1,
        duration: 1
      },
      %{
        type: "practice",
        text: "C7 — el Do más agudo que usaremos.",
        note: 96,
        hint: "Brillante y agudo.",
        finger: 1,
        duration: 1
      },
      # Ahora al revés
      %{
        type: "practice",
        text: "Ahora baja: C7 de nuevo.",
        note: 96,
        hint: "Empezamos desde arriba.",
        finger: 1,
        duration: 1
      },
      %{type: "practice", text: "C6.", note: 84, hint: "Bajando...", finger: 1, duration: 1},
      %{
        type: "practice",
        text: "C5.",
        note: 72,
        hint: "Cada vez más grave.",
        finger: 1,
        duration: 1
      },
      %{
        type: "practice",
        text: "C4 — volvemos al hogar.",
        note: 60,
        hint: "Siempre vuelves aquí.",
        finger: 1,
        duration: 1
      }
    ],
    focus:
      "Understanding octaves as the repeating pattern; traversing all C notes ascending and descending",
    new_concepts: [
      "octave_definition",
      "c1_to_c7",
      "ascending_descending",
      "same_note_different_register"
    ],
    confidence_level_target:
      "Can play all C notes in order (ascending and descending) without hesitation",
    cognitive_complexity: "intermediate",
    motor_complexity: "intermediate",
    duration_minutes: 26
  },

  # ===========================================================================
  # Lesson 1.5 — Encuentra el Do (ejercicios generados)
  # ===========================================================================
  %{
    id: "1_05_octave_concept",
    title: "1.5 Encuentra el Do: práctica libre de octavas",
    description:
      "Practica encontrar Do's saltando octavas de forma dinámica. El motor te pedirá saltos de diferente dificultad.",
    intro:
      "Es hora de poner a prueba lo que aprendiste. Esta lección usa ejercicios generados: " <>
        "el piano te pedirá que encuentres un Do a X octavas de distancia. No es siempre el mismo ejercicio. " <>
        "Recuerda: para encontrar el siguiente Do arriba, busca el siguiente grupo de 2 negras. Confía en el patrón 2-3.",
    metronome: false,
    bpm: 60,
    timing_strictness: 0,
    time_signature: "4/4",
    loop: true,
    module_id: "mod_001_piano_fundamentals",
    order: 5,
    steps: [
      %{
        type: "practice",
        text: "Comienza en C4 (Do Central). Tócalo para orientarte.",
        note: 60,
        hint: "Tu punto de partida.",
        finger: 1,
        duration: 1
      },
      %{
        type: "generated",
        text: "Ejercicio 1: encontrar el Do a 1 octava de distancia.",
        note: 0,
        generator: "octave_finder",
        params: %{from_octave: 4, delta_octaves: 1, direction: "up", difficulty: 1},
        hint: "Sube una octava desde C4.",
        finger: 1,
        duration: 1
      },
      %{
        type: "generated",
        text: "Ejercicio 2: bajar una octava.",
        note: 0,
        generator: "octave_finder",
        params: %{from_octave: 4, delta_octaves: 1, direction: "down", difficulty: 1},
        hint: "Baja una octava desde C4.",
        finger: 1,
        duration: 1
      },
      %{
        type: "generated",
        text: "Ejercicio 3: subir dos octavas.",
        note: 0,
        generator: "octave_finder",
        params: %{from_octave: 3, delta_octaves: 2, direction: "up", difficulty: 2},
        hint: "Desde C3, sube dos octavas.",
        finger: 1,
        duration: 1
      },
      %{
        type: "generated",
        text: "Ejercicio 4: bajar dos octavas.",
        note: 0,
        generator: "octave_finder",
        params: %{from_octave: 6, delta_octaves: 2, direction: "down", difficulty: 2},
        hint: "Desde C6, baja dos octavas.",
        finger: 1,
        duration: 1
      },
      %{
        type: "generated",
        text: "Ejercicio 5: salto aleatorio (dificultad media).",
        note: 0,
        generator: "octave_finder",
        params: %{difficulty: 3, direction: "random"},
        hint: "Lee el prompt generado para saber qué octava encontrar.",
        finger: 1,
        duration: 1
      },
      %{
        type: "generated",
        text: "Ejercicio 6: otro salto aleatorio.",
        note: 0,
        generator: "octave_finder",
        params: %{difficulty: 3, direction: "random"},
        hint: "Usa el patrón 2-3 para orientarte.",
        finger: 1,
        duration: 1
      },
      %{
        type: "generated",
        text: "Ejercicio 7: desafío (dificultad alta).",
        note: 0,
        generator: "octave_finder",
        params: %{difficulty: 4, direction: "random"},
        hint: "Salto largo. Cuenta los grupos de 2 negras.",
        finger: 1,
        duration: 1
      }
    ],
    focus:
      "Dynamic octave-jumping exercises with progressive difficulty using generated exercises",
    new_concepts: ["octave_jumping", "dynamic_navigation", "c_note_in_any_octave"],
    confidence_level_target:
      "Can find any C note on demand after hearing the octave target; uses 2-3 pattern automatically",
    cognitive_complexity: "intermediate",
    motor_complexity: "intermediate",
    duration_minutes: 30
  },

  # ===========================================================================
  # Lesson 1.6 — Posición de la mano
  # ===========================================================================
  %{
    id: "1_06_hand_position",
    title: "1.6 Posición de la mano: la base de todo",
    description:
      "Aprende la postura correcta al piano: cómo sentarte, posicionar la mano y los dedos. Practica las primeras 5 notas (C-D-E-F-G) con técnica correcta.",
    intro:
      "Una buena postura permite tocar más tiempo sin cansarte, con más velocidad y sin lesiones. " <>
        "POSTURA: Siéntate en el borde de la banqueta. Codos al nivel de las teclas. Espalda recta pero relajada. " <>
        "MANO: Imagina que sostienes una naranja en la palma. Dedos curvos, golpea con la punta. Muñeca recta. " <>
        "Los dedos se numeran: pulgar=1, índice=2, medio=3, anular=4, meñique=5. " <>
        "Coloca la mano derecha: pulgar (1) en C4, y cada dedo en la siguiente tecla blanca: 1=C4, 2=D4, 3=E4, 4=F4, 5=G4.",
    metronome: false,
    bpm: 60,
    timing_strictness: 0,
    time_signature: "4/4",
    loop: false,
    module_id: "mod_001_piano_fundamentals",
    order: 6,
    steps: [
      %{
        type: "practice",
        text: "Toca C4 con el pulgar (dedo 1). Dedo curvo, muñeca recta.",
        note: 60,
        hint: "Pulgar en Do. Lento y controlado.",
        finger: 1,
        duration: 1
      },
      %{
        type: "practice",
        text: "Toca D4 con el índice (dedo 2).",
        note: 62,
        hint: "Mantén los otros dedos cerca del teclado.",
        finger: 2,
        duration: 1
      },
      %{
        type: "practice",
        text: "Toca E4 con el dedo medio (dedo 3).",
        note: 64,
        hint: "El dedo más largo toca la nota del medio.",
        finger: 3,
        duration: 1
      },
      %{
        type: "practice",
        text: "Toca F4 con el anular (dedo 4).",
        note: 65,
        hint: "El dedo más débil. Dale tiempo para desarrollarse.",
        finger: 4,
        duration: 1
      },
      %{
        type: "practice",
        text: "Toca G4 con el meñique (dedo 5).",
        note: 67,
        hint: "El último dedo. Completa la posición de 5 dedos.",
        finger: 5,
        duration: 1
      }
    ],
    focus:
      "Establishing correct posture, hand position, finger numbering, and basic 5-finger position on C4-G4",
    new_concepts: [
      "finger_numbering_1_to_5",
      "hand_position_curved_fingers",
      "wrist_alignment",
      "five_finger_position_c4_g4"
    ],
    confidence_level_target:
      "Correct posture established; can play C-D-E-F-G with proper finger technique",
    cognitive_complexity: "basic",
    motor_complexity: "intermediate",
    duration_minutes: 35
  },

  # ===========================================================================
  # Lesson 1.7 — Panorama completo del teclado
  # ===========================================================================
  %{
    id: "1_07_keyboard_overview",
    title: "1.7 Panorama completo: domina el teclado",
    description:
      "Integra todo lo aprendido en el Módulo 1. Navega libremente por el teclado usando el patrón 2-3 y encuentra cualquier Do de forma instintiva.",
    intro:
      "Este es el cierre del Módulo 1. Has aprendido el patrón 2-3, los Do's de todo el piano, las octavas y la postura correcta. " <>
        "El piano va de A0 (la grave más extrema) a C8 (la nota más aguda). Son 88 teclas = 7 octavas completas + extra. " <>
        "Ahora vamos a integrar todo con ejercicios más desafiantes: saltos largos, posiciones aleatorias.",
    metronome: false,
    bpm: 60,
    timing_strictness: 0,
    time_signature: "4/4",
    loop: true,
    module_id: "mod_001_piano_fundamentals",
    order: 7,
    steps: [
      %{
        type: "practice",
        text: "Toca la nota más grave de Do en el piano: C1.",
        note: 24,
        hint: "Profundo y oscuro.",
        finger: 1,
        duration: 1
      },
      %{
        type: "practice",
        text: "Toca la nota más aguda de Do en el piano: C8.",
        note: 108,
        hint: "Brillante y agudo.",
        finger: 1,
        duration: 1
      },
      %{
        type: "practice",
        text: "Vuelve al Do Central: C4.",
        note: 60,
        hint: "Siempre puedes volver al hogar.",
        finger: 1,
        duration: 1
      },
      %{
        type: "generated",
        text: "Desafío 1: salto de una octava en dirección aleatoria.",
        note: 0,
        generator: "octave_finder",
        params: %{difficulty: 2, direction: "random"},
        hint: "Usa el patrón 2-3. Busca el grupo de 2 negras.",
        finger: 1,
        duration: 1
      },
      %{
        type: "generated",
        text: "Desafío 2: salto de dos octavas.",
        note: 0,
        generator: "octave_finder",
        params: %{difficulty: 3, direction: "random"},
        hint: "Dos grupos de 2 negras de distancia.",
        finger: 1,
        duration: 1
      },
      %{
        type: "generated",
        text: "Desafío 3: salto largo (3+ octavas).",
        note: 0,
        generator: "octave_finder",
        params: %{difficulty: 4, direction: "random"},
        hint: "Confía en tu instinto. El patrón siempre está.",
        finger: 1,
        duration: 1
      },
      %{
        type: "generated",
        text: "Desafío 4: salto máximo — cualquier Do del piano.",
        note: 0,
        generator: "octave_finder",
        params: %{difficulty: 5, direction: "random"},
        hint: "Este es el reto final. Tómate tu tiempo.",
        finger: 1,
        duration: 1
      },
      %{
        type: "practice",
        text: "Toca C4 una última vez. Vuelves al hogar después de recorrer todo el piano.",
        note: 60,
        hint: "Siempre vuelves aquí.",
        finger: 1,
        duration: 1
      }
    ],
    focus:
      "Integration of all Module 1 concepts; free navigation across the full keyboard with generated challenges",
    new_concepts: [
      "full_keyboard_88_keys",
      "piano_range_a0_c8",
      "keyboard_mastery",
      "dynamic_navigation_advanced"
    ],
    confidence_level_target:
      "Can navigate the full keyboard confidently; finds any C note immediately; ready for Module 2",
    cognitive_complexity: "intermediate",
    motor_complexity: "intermediate",
    duration_minutes: 40
  }
]

IO.puts("Inserting #{Enum.count(lessons_module_01)} lessons for Module 1...")

Enum.each(lessons_module_01, fn lesson ->
  MusicIan.Repo.insert!(
    MusicIan.Curriculum.Lesson.changeset(%MusicIan.Curriculum.Lesson{}, lesson),
    on_conflict: :replace_all,
    conflict_target: :id
  )
end)

IO.puts("Module 1 lessons inserted successfully.")
IO.puts(String.duplicate("=", 70) <> "\n")
