# Seed: Módulo 1 - Fundamentos del Piano (Piano Fundamentals)
# BABY STEPS: Conoce el piano, el Do central, octavas y patrones
# Target: Absolute beginner with ZERO music knowledge
# 
# ENRICHED PEDAGOGICAL STRUCTURE:
# - 7 lessons with duration progression: 20, 21, 23, 26, 30, 35, 40 minutes
# - Emotional arc: Disorientation (observing) → Orientation (understanding patterns)
# - Cognitive load: Visual pattern recognition only (ZERO theory required)
# - Motor complexity: Minimal (pointing, touching, basic finger work)
# - Each lesson explicitly builds on previous with reinforcement

alias MusicIan.Repo
alias MusicIan.Curriculum.Lesson

IO.puts("\n" <> String.duplicate("=", 70))
IO.puts("📚 SEEDING MODULE 1: Fundamentos del Teclado (with Rich Pedagogy)")
IO.puts(String.duplicate("=", 70))

lessons_module_01 = [
  # Lesson 1.1 - Know Your Piano
  %{
    id: "1_01_meet_the_piano",
    title: "1.1 Conoce el Piano",
    description: "Aprende las partes principales del piano: teclas blancas, teclas negras, el patrón que se repite (2-3), y cómo el sonido cambia a medida que te mueves.",
    intro:
      "¡Bienvenido al piano! Este es uno de los instrumentos más hermosos. Tiene 88 teclas que producen sonidos diferentes. Hoy vamos a explorar cómo está organizado y entenderlo completamente.",
    metronome: false,
    module_id: "mod_001_piano_fundamentals",
    order: 1,
    steps: [
      %{text: "Mira el piano completo. ¿Cuántas teclas ves?", note: 0, hint: "Son muchas, pero están organizadas", finger: 0, duration: 0},
      %{text: "Observa: hay teclas BLANCAS", note: 0, hint: "Son la mayoría", finger: 0, duration: 0},
      %{text: "Observa: hay teclas NEGRAS", note: 0, hint: "Están levantadas y agrupadas", finger: 0, duration: 0},
      %{text: "Toca una tecla blanca (izquierda)", note: 36, hint: "Escucha el sonido grave", finger: 1, duration: 1},
      %{text: "Toca una tecla blanca (centro)", note: 60, hint: "Escucha el sonido medio", finger: 1, duration: 1},
      %{text: "Toca una tecla blanca (derecha)", note: 84, hint: "Escucha el sonido agudo", finger: 1, duration: 1},
      %{text: "¿Notas la diferencia? Izquierda = grave, Derecha = agudo", note: 0, hint: "El sonido SUBE de izquierda a derecha", finger: 0, duration: 0},
      %{text: "Ahora toca una tecla NEGRA (izquierda)", note: 37, hint: "¿Suena diferente?", finger: 1, duration: 1},
      %{text: "Toca una tecla NEGRA (centro)", note: 61, hint: "Compara con la blanca", finger: 1, duration: 1},
      %{text: "Toca una tecla NEGRA (derecha)", note: 85, hint: "También es agudo", finger: 1, duration: 1},
      %{text: "Observa el PATRÓN: mira cómo las negras se agrupan", note: 0, hint: "¿Ves 2 negras, luego 3, luego 2, luego 3?", finger: 0, duration: 0},
      %{text: "Señala el primer grupo de 2 negras", note: 0, hint: "A la izquierda", finger: 0, duration: 0},
      %{text: "Señala el primer grupo de 3 negras", note: 0, hint: "Viene después", finger: 0, duration: 0},
      %{text: "Este patrón se REPITE en todo el piano", note: 0, hint: "Es tu brújula para navegarlo", finger: 0, duration: 0},
      %{text: "Toca una blanca ENTRE las 2 negras", note: 37, hint: "En la izquierda primero", finger: 1, duration: 1},
      %{text: "Toca una blanca EN EL CENTRO del grupo de 3", note: 61, hint: "La del medio de las 3", finger: 1, duration: 1},
      %{text: "Estos dos puntos de referencia te ayudarán a navegar", note: 0, hint: "Son tus puntos de anclaje", finger: 0, duration: 0},
      %{text: "Ahora mueve tu mano hacia la DERECHA", note: 0, hint: "Sin dejar el teclado", finger: 0, duration: 0},
      %{text: "¿Ves cómo el patrón se REPITE?", note: 0, hint: "2 negras, 3 negras, 2 negras, 3...", finger: 0, duration: 0},
      %{text: "Mueve tu mano hacia la IZQUIERDA", note: 0, hint: "Observa que sigue el mismo patrón", finger: 0, duration: 0}
    ],
    # ENRICHED METADATA
    focus: "Complete understanding of piano structure, key types, pitch direction, and the fundamental 2-3 pattern",
    new_concepts: [
      "piano_keyboard_88_keys",
      "white_keys_structure",
      "black_keys_structure",
      "pitch_direction_left_to_right",
      "pitch_high_and_low",
      "black_key_2_3_pattern",
      "pattern_repetition",
      "keyboard_organization"
    ],
    confidence_level_target: "Comprehensive understanding of piano layout; confident with key types and pattern",
    cognitive_complexity: "basic",
    motor_complexity: "basic",
    duration_minutes: 20
  },

  # Lesson 1.2 - White and Black Keys Pattern
  %{
    id: "1_02_white_black_pattern",
    title: "1.2 El Patrón de Teclas: Blancas y Negras",
    description: "Domina el patrón fundamental del piano: 2 negras, 3 negras, 2 negras, 3 negras. Aprende a identificarlo, navegarlo y usarlo como referencia en todo el teclado.",
    intro:
      "El patrón de las teclas negras es la clave para entender el piano. Las teclas negras siempre se agrupan así: 2 negras, luego 3 negras, luego 2 de nuevo, luego 3... Este patrón se repite 7 veces en todo el piano. Hoy lo dominarás completamente.",
    metronome: false,
    module_id: "mod_001_piano_fundamentals",
    order: 2,
    steps: [
      %{text: "Mira el PRIMER grupo: 2 negras juntas", note: 0, hint: "A la izquierda del piano", finger: 0, duration: 0},
      %{text: "Después de las 2 negras, ¿qué ves?", note: 0, hint: "Un grupo MAYOR de negras", finger: 0, duration: 0},
      %{text: "Mira el SEGUNDO grupo: 3 negras juntas", note: 0, hint: "Más grandes, cercanas entre sí", finger: 0, duration: 0},
      %{text: "Toca una blanca ANTES de las 2 negras", note: 36, hint: "A la izquierda", finger: 1, duration: 1},
      %{text: "Toca una blanca ENTRE las 2 negras", note: 37, hint: "En el espacio del medio", finger: 1, duration: 1},
      %{text: "Toca una blanca DESPUÉS de las 2 negras (antes de las 3)", note: 38, hint: "A la derecha", finger: 1, duration: 1},
      %{text: "Ahora toca una blanca ANTES del grupo de 3", note: 39, hint: "La primera de la derecha", finger: 1, duration: 1},
      %{text: "Toca una blanca EN EL CENTRO del grupo de 3", note: 61, hint: "La del medio exacto", finger: 1, duration: 1},
      %{text: "Toca una blanca DESPUÉS del grupo de 3", note: 62, hint: "La última antes que se repita", finger: 1, duration: 1},
      %{text: "¿Ves? Acabas de tocar un CICLO completo", note: 0, hint: "2 negras, 3 negras, y luego se repite", finger: 0, duration: 0},
      %{text: "Mueve a la DERECHA. ¿Ves el MISMO patrón?", note: 0, hint: "2 negras, 3 negras, 2, 3...", finger: 0, duration: 0},
      %{text: "Toca las blancas de este nuevo ciclo", note: 48, hint: "Entre y alrededor de las negras", finger: 1, duration: 2},
      %{text: "Mueve a la IZQUIERDA desde donde empezamos", note: 0, hint: "¿Se repite el patrón hacia atrás?", finger: 0, duration: 0},
      %{text: "Toca las blancas de este ciclo hacia la izquierda", note: 24, hint: "Patrón idéntico", finger: 1, duration: 2},
      %{text: "El patrón es IDÉNTICO en todo el piano", note: 0, hint: "7 repeticiones exactas", finger: 0, duration: 0},
      %{text: "Practica: encuentra 2 negras en cualquier parte", note: 0, hint: "Sin mirar demasiado", finger: 0, duration: 0},
      %{text: "Practica: toca la blanca ENTRE esas 2 negras", note: 0, hint: "Usa el patrón como guía", finger: 0, duration: 0},
      %{text: "Practica: encuentra 3 negras en cualquier parte", note: 0, hint: "Busca grupos más grandes", finger: 0, duration: 0},
      %{text: "Practica: toca la blanca EN EL CENTRO de esas 3", note: 0, hint: "Precisión es importante", finger: 0, duration: 0},
      %{text: "Repite en diferentes partes del piano", note: 0, hint: "Izquierda, centro, derecha", finger: 0, duration: 1},
      %{text: "El patrón 2-3 es tu MAPA del piano. Lo usarás siempre.", note: 0, hint: "Este es el fundamento del piano", finger: 0, duration: 0}
    ],
    focus: "Deep mastery of the 2-3 black key pattern; using it as the fundamental navigation system for the entire keyboard",
    new_concepts: [
      "two_black_keys_group",
      "three_black_keys_group",
      "pattern_cycle_structure",
      "pattern_repetition_across_keyboard",
      "white_keys_in_pattern_context",
      "keyboard_navigation_system",
      "spatial_landmarks_2_3_pattern",
      "pattern_mastery"
    ],
    confidence_level_target: "Pattern fully internalized; can navigate keyboard reliably using 2-3 pattern",
    cognitive_complexity: "basic",
    motor_complexity: "intermediate",
    duration_minutes: 21
  },

  # Lesson 1.3 - Middle C Introduction
  %{
    id: "1_03_middle_c_intro",
    title: "1.3 El Do Central (Middle C)",
    description: "Descubre el Do Central: el punto de referencia más importante del piano. Aprende a identificarlo, localizarlo y desarrollar memoria muscular para encontrarlo incluso con los ojos cerrados.",
    intro:
      "En el medio del piano, hay una nota especial llamada Do Central (Middle C). Es como el 'hogar' de tu mano. La encontramos usando el patrón de teclas negras. Hoy aprenderás a encontrarlo y a recordar su sonido para siempre.",
    metronome: false,
    module_id: "mod_001_piano_fundamentals",
    order: 3,
    steps: [
      %{text: "Recuerda: ¿Dónde está el grupo de 2 negras EN EL CENTRO del piano?", note: 0, hint: "Busca el punto medio", finger: 0, duration: 0},
      %{text: "La blanca a la IZQUIERDA de ese grupo de 2 negras", note: 0, hint: "Está entre dos grupos", finger: 0, duration: 0},
      %{text: "ESA es el Do Central. Este es tu HOGAR en el piano", note: 60, hint: "Recuerda esta posición", finger: 1, duration: 1},
      %{text: "Toca Do Central varias veces. Escucha su sonido.", note: 60, hint: "Es un sonido cálido, central", finger: 1, duration: 1},
      %{text: "Toca Do Central lentamente: DO... DO... DO...", note: 60, hint: "Siente el ritmo", finger: 1, duration: 2},
      %{text: "Ahora toca MÁS rápido: Do Do Do Do", note: 60, hint: "Manteniendo la precisión", finger: 1, duration: 1},
      %{text: "Detente. MEMORIZA el sonido de Do Central", note: 0, hint: "Este sonido es tu referencia", finger: 0, duration: 0},
      %{text: "Toca Do Central con los ojos ABIERTOS", note: 60, hint: "Observa dónde está", finger: 1, duration: 1},
      %{text: "Ahora CIERRA los ojos", note: 0, hint: "Vamos a usar la memoria muscular", finger: 0, duration: 0},
      %{text: "Con los ojos cerrados: ¿dónde está Do Central?", note: 60, hint: "Usa el patrón de negras como guía", finger: 1, duration: 1},
      %{text: "Toca Do Central sin ver. ¿Lo encontraste?", note: 60, hint: "Abre los ojos para verificar", finger: 1, duration: 1},
      %{text: "Abre los ojos. ¿Acertaste? Si no, intenta de nuevo.", note: 0, hint: "La práctica desarrolla la memoria", finger: 0, duration: 0},
      %{text: "Cierra los ojos NUEVAMENTE", note: 0, hint: "Segunda ronda de práctica", finger: 0, duration: 0},
      %{text: "Encuentra Do Central sin mirar", note: 60, hint: "Usa tu tacto", finger: 1, duration: 1},
      %{text: "Tócalo. Abre los ojos. ¿Correcto?", note: 0, hint: "Mejorando cada vez", finger: 0, duration: 0},
      %{text: "Una tercera vez: ojos cerrados", note: 0, hint: "La memoria se refuerza", finger: 0, duration: 0},
      %{text: "Encuentra Do Central", note: 60, hint: "Confianza creciente", finger: 1, duration: 1},
      %{text: "Tócalo 3 veces lentamente", note: 60, hint: "Celebra tu logro", finger: 1, duration: 2},
      %{text: "Abre los ojos. Has aprendido el HOGAR del piano", note: 0, hint: "Do Central es tu referencia", finger: 0, duration: 0},
      %{text: "Practica una última vez: ojos abiertos, toca Do Central", note: 60, hint: "Refuerzo final", finger: 1, duration: 1},
      %{text: "DO CENTRAL: Tu punto de partida, tu hogar, tu referencia", note: 60, hint: "Lo usarás siempre", finger: 1, duration: 1},
      %{text: "El Do Central es el corazón del piano. Lo has dominado.", note: 0, hint: "¡Felicitaciones!", finger: 0, duration: 0},
      %{text: "Ahora estás listo para explorar el resto del teclado desde aquí", note: 0, hint: "Todo empieza en Do Central", finger: 0, duration: 0}
    ],
    focus: "Complete mastery of Middle C: visual identification, auditory recognition, kinesthetic memory, and muscle memory development",
    new_concepts: [
      "middle_c_precise_location",
      "center_keyboard_position",
      "white_key_between_2_black_keys",
      "auditory_middle_c_tone_recognition",
      "muscle_memory_for_location",
      "eyes_closed_spatial_awareness",
      "home_position_concept",
      "reference_point_for_navigation"
    ],
    confidence_level_target: "Complete comfort with Middle C; can find it with eyes closed; confident home position",
    cognitive_complexity: "basic",
    motor_complexity: "intermediate",
    duration_minutes: 23
  },

  # Lesson 1.4 - Finding Middle C on the Keyboard
  %{
    id: "1_04_locate_middle_c",
    title: "1.4 Localiza el Do Central",
    description: "Practica encontrar el Do Central desde cualquier posición del piano. Desarrolla la capacidad de navegar hacia el hogar desde cualquier lugar.",
    intro:
      "El Do Central siempre está en el mismo lugar: a la izquierda del grupo de 2 teclas negras en el CENTRO del piano. Ahora vamos a practicar encontrarlo desde diferentes posiciones. Esta es una habilidad crítica: siempre poder regresar al hogar.",
    metronome: false,
    module_id: "mod_001_piano_fundamentals",
    order: 4,
    steps: [
      %{text: "Comencemos en Do Central (posición neutral)", note: 60, hint: "El hogar", finger: 1, duration: 0},
      %{text: "Toca Do Central una vez", note: 60, hint: "Punto de partida claro", finger: 1, duration: 1},
      %{text: "Ahora MUEVE tu mano hacia la DERECHA (hacia notas agudas)", note: 0, hint: "Desliza sin perder contacto", finger: 0, duration: 0},
      %{text: "Tu mano está 5 teclas a la derecha. ¿DÓNDE está Do Central ahora?", note: 0, hint: "Está a tu izquierda", finger: 0, duration: 0},
      %{text: "Sin mirar, toca Do Central desde aquí", note: 60, hint: "Usa el patrón de negras", finger: 1, duration: 1},
      %{text: "Abre los ojos. ¿Lo encontraste? Verifica.", note: 0, hint: "¿Acertaste?", finger: 0, duration: 0},
      %{text: "Regresa a Do Central. Tócalo.", note: 60, hint: "De vuelta al hogar", finger: 1, duration: 1},
      %{text: "Ahora MUEVE tu mano hacia la IZQUIERDA (hacia notas graves)", note: 0, hint: "Alejándote más", finger: 0, duration: 0},
      %{text: "Tu mano está 8 teclas a la izquierda. ¿DÓNDE está Do Central?", note: 0, hint: "Está a tu derecha", finger: 0, duration: 0},
      %{text: "Sin mirar, toca Do Central desde aquí", note: 60, hint: "Más difícil esta vez", finger: 1, duration: 1},
      %{text: "Abre los ojos. ¿Lo encontraste?", note: 0, hint: "Verifica tu precisión", finger: 0, duration: 0},
      %{text: "De vuelta a Do Central. Descansa un momento.", note: 60, hint: "Refuerzo del hogar", finger: 1, duration: 1},
      %{text: "Muévete HACIA LA DERECHA nuevamente (3 teclas)", note: 0, hint: "Posición intermedia", finger: 0, duration: 0},
      %{text: "Toca Do Central sin mirar", note: 60, hint: "Segunda ronda", finger: 1, duration: 1},
      %{text: "Verifica. Regresa a Do Central.", note: 60, hint: "Refuerzo constante", finger: 1, duration: 1},
      %{text: "Muévete HACIA LA IZQUIERDA (5 teclas)", note: 0, hint: "Otra posición", finger: 0, duration: 0},
      %{text: "Toca Do Central sin mirar", note: 60, hint: "Tercera ronda", finger: 1, duration: 1},
      %{text: "Verifica. Regresa a Do Central.", note: 60, hint: "El patrón se refuerza", finger: 1, duration: 1},
      %{text: "Posición EXTREMA: muévete MUY a la derecha (12 teclas)", note: 0, hint: "Desafío mayor", finger: 0, duration: 0},
      %{text: "¿DÓNDE está Do Central? Tócalo sin mirar.", note: 60, hint: "Usa toda tu memoria", finger: 1, duration: 2},
      %{text: "¿Acertaste? Regresa y verifica.", note: 60, hint: "Validación importante", finger: 1, duration: 1},
      %{text: "Posición EXTREMA: muévete MUY a la izquierda (12 teclas)", note: 0, hint: "Extremo opuesto", finger: 0, duration: 0},
      %{text: "¿DÓNDE está Do Central? Tócalo sin mirar.", note: 60, hint: "Máximo desafío", finger: 1, duration: 2},
      %{text: "¿Acertaste? Regresa y verifica.", note: 60, hint: "Celebra tu precisión", finger: 1, duration: 1},
      %{text: "Finalmente: desde el CENTRO nuevamente", note: 0, hint: "Cierre positivo", finger: 0, duration: 0},
      %{text: "Toca Do Central una última vez. Estás en casa.", note: 60, hint: "Dominio completo", finger: 1, duration: 1},
      %{text: "Has aprendido a navegar hacia el hogar desde CUALQUIER posición", note: 0, hint: "Esta es una habilidad fundamental", finger: 0, duration: 0}
    ],
    focus: "Complete kinesthetic mastery: navigating to Middle C from any keyboard position with eyes closed",
    new_concepts: [
      "kinesthetic_keyboard_navigation",
      "hand_displacement_and_return",
      "tactile_note_finding",
      "eyes_closed_spatial_awareness",
      "navigation_from_multiple_positions",
      "consistency_of_position_finding",
      "keyboard_compass_concept",
      "home_position_navigation"
    ],
    confidence_level_target: "Can reliably navigate to Middle C from any position; eyes-closed accuracy mastered",
    cognitive_complexity: "intermediate",
    motor_complexity: "intermediate",
    duration_minutes: 26
  },

  # Lesson 1.5 - Introduction to Octaves
  %{
    id: "1_05_octave_concept",
    title: "1.5 Las Octavas - El Patrón se Repite",
    description: "Descubre qué son las octavas: el concepto fundamental que explica por qué el piano se repite. Aprende que Do suena igual en todas partes, solo más alto o más bajo.",
    intro:
      "El piano es grande porque el patrón se repite. Si tocas Do Central y luego cuentas 8 notas blancas hacia la derecha, vuelves a tocar Do. Pero suena más alto. Eso es una octava. Es el concepto más importante para entender el piano.",
    metronome: false,
    module_id: "mod_001_piano_fundamentals",
    order: 5,
    steps: [
      %{text: "Comenzamos en Do Central (C4)", note: 60, hint: "Nuestro punto de partida", finger: 1, duration: 1},
      %{text: "Recuerda: ¿cuántas TECLAS BLANCAS hay entre Do y el siguiente Do?", note: 0, hint: "Cuéntalas: Do, Re, Mi, Fa, Sol, La, Si, Do", finger: 0, duration: 0},
      %{text: "Toca Do Central lentamente", note: 60, hint: "Punto A", finger: 1, duration: 1},
      %{text: "Ahora toca la siguiente blanca: Re", note: 62, hint: "Es la segunda blanca desde Do", finger: 2, duration: 0.5},
      %{text: "Siguiente: Mi", note: 64, hint: "Tercera blanca", finger: 3, duration: 0.5},
      %{text: "Siguiente: Fa", note: 65, hint: "Cuarta blanca", finger: 4, duration: 0.5},
      %{text: "Siguiente: Sol", note: 67, hint: "Quinta blanca", finger: 5, duration: 0.5},
      %{text: "Siguiente: La", note: 69, hint: "Sexta blanca", finger: 1, duration: 0.5},
      %{text: "Siguiente: Si", note: 71, hint: "Séptima blanca", finger: 2, duration: 0.5},
      %{text: "¡Siguiente: Do! ¿Ves que volvió?", note: 72, hint: "Octava blanca - volvemos al Do", finger: 3, duration: 1},
      %{text: "Escucha la diferencia: Do Central vs este Do", note: 0, hint: "Suena igual, pero MÁS ALTO", finger: 0, duration: 0},
      %{text: "Toca AMBOS Do juntos para comparar", note: 60, hint: "Primero Do Central", finger: 1, duration: 1},
      %{text: "Ahora toca el Do una octava más arriba", note: 72, hint: "El mismo nombre, sonido más alto", finger: 3, duration: 1},
      %{text: "¿Notas que suena IDÉNTICO pero MÁS ALTO?", note: 0, hint: "Eso es una octava", finger: 0, duration: 0},
      %{text: "Eso se llama una OCTAVA: 8 notas blancas, mismo patrón, diferente altura", note: 0, hint: "Octa = ocho", finger: 0, duration: 0},
      %{text: "Ahora vamos HACIA ATRÁS (izquierda) desde Do Central", note: 0, hint: "Hacia las notas graves", finger: 0, duration: 0},
      %{text: "Toca Si (la blanca antes de Do Central)", note: 59, hint: "Una blanca atrás", finger: 1, duration: 0.5},
      %{text: "Toca La", note: 57, hint: "Dos blancas atrás", finger: 1, duration: 0.5},
      %{text: "Toca Sol", note: 55, hint: "Tres blancas atrás", finger: 1, duration: 0.5},
      %{text: "Toca Fa", note: 53, hint: "Cuatro blancas atrás", finger: 1, duration: 0.5},
      %{text: "Toca Mi", note: 52, hint: "Cinco blancas atrás", finger: 1, duration: 0.5},
      %{text: "Toca Re", note: 50, hint: "Seis blancas atrás", finger: 1, duration: 0.5},
      %{text: "Toca Do (una octava DEBAJO de Do Central)", note: 48, hint: "Séptima blanca atrás", finger: 1, duration: 1},
      %{text: "Escucha: este Do suena IDÉNTICO a Do Central, solo MÁS BAJO", note: 0, hint: "Otra octava", finger: 0, duration: 0},
      %{text: "Toca los TRES Do que conoces: grave, central, agudo", note: 48, hint: "En orden: grave, medio, agudo", finger: 1, duration: 2},
      %{text: "¿Ves el patrón? Do es Do es Do. Solo la altura cambia.", note: 0, hint: "Todas las notas funcionan así", finger: 0, duration: 0},
      %{text: "CONCLUSIÓN: Las octavas explican por qué el piano se repite", note: 0, hint: "El patrón se repite infinitamente", finger: 0, duration: 0},
      %{text: "Cada nota blanca se repite en octavas: Do, Re, Mi, Fa, Sol, La, Si, Do, Re, Mi...", note: 0, hint: "Patrones anidados", finger: 0, duration: 0},
      %{text: "El piano tiene 88 teclas porque el patrón se repite aproximadamente 7 veces", note: 0, hint: "7 octavas completas más algunas notas", finger: 0, duration: 0},
      %{text: "Felicitaciones: has descubierto la estructura fundamental del piano", note: 60, hint: "Domina octavas, dominas el piano", finger: 1, duration: 1}
    ],
    focus: "Deep understanding of octaves as the fundamental organizing principle of keyboard structure",
    new_concepts: [
      "octave_definition_eight_white_keys",
      "octave_as_pattern_repetition",
      "pitch_higher_lower_concept",
      "note_names_across_octaves",
      "octave_equivalence_same_note_different_height",
      "seven_notes_repeating_pattern",
      "keyboard_organization_by_octaves",
      "piano_88_keys_seven_octaves"
    ],
    confidence_level_target: "Complete octave comprehension; understands fundamental piano organization",
    cognitive_complexity: "intermediate",
    motor_complexity: "intermediate",
    duration_minutes: 30
  },

  # Lesson 1.6 - Hand Position and Posture
  %{
    id: "1_06_hand_position",
    title: "1.6 Posición de la Mano",
    description: "Aprende la postura correcta al piano: cómo sentarte, posicionar la mano, los dedos y la muñeca. Una buena postura es la base para tocar con libertad y sin lesiones.",
    intro:
      "La postura es fundamental. Una mala postura te cansará, causará dolor y limitará tu técnica. Hoy aprenderás a sentarte correctamente, posicionar la mano como los pianistas profesionales, y desarrollar buenos hábitos desde el inicio.",
    metronome: false,
    module_id: "mod_001_piano_fundamentals",
    order: 6,
    steps: [
      %{text: "POSTURA DEL CUERPO: Siéntate frente al piano", note: 0, hint: "Centro del teclado, frente a ti", finger: 0, duration: 0},
      %{text: "La banqueta debe tener la altura CORRECTA", note: 0, hint: "Los codos al mismo nivel que el teclado", finger: 0, duration: 0},
      %{text: "¿Tus codos están al nivel del teclado? Ajusta si es necesario", note: 0, hint: "Altura crítica para la técnica", finger: 0, duration: 0},
      %{text: "Tu espalda debe estar DERECHA pero RELAJADA", note: 0, hint: "No rígida, pero no hundida", finger: 0, duration: 0},
      %{text: "Siéntate hacia el BORDE de la banqueta (no atrás)", note: 0, hint: "Te da libertad de movimiento", finger: 0, duration: 0},
      %{text: "POSTURA DE LOS PIES: Coloca los pies en el piso", note: 0, hint: "Naturalmente, sin forzar", finger: 0, duration: 0},
      %{text: "Los pies deben estar SEPARADOS al ancho de los hombros", note: 0, hint: "Base estable", finger: 0, duration: 0},
      %{text: "RELAJ ACIÓN DE LOS HOMBROS: Levanta los hombros hacia las orejas", note: 0, hint: "Ahora déjalos caer naturalmente", finger: 0, duration: 0},
      %{text: "Tus hombros deben estar RELAJADOS, no tensos", note: 0, hint: "Esto evita dolor a largo plazo", finger: 0, duration: 0},
      %{text: "POSICIÓN DE LOS CODOS: Los codos deben estar RELAJADOS a tu lado", note: 0, hint: "No pegados al cuerpo, pero naturales", finger: 0, duration: 0},
      %{text: "Los codos deben estar en línea con el teclado", note: 0, hint: "Esto facilita el movimiento libre", finger: 0, duration: 0},
      %{text: "POSICIÓN DE LA MUÑECA: Coloca tus manos sobre el teclado (Do Central)", note: 60, hint: "Pulgar en Do", finger: 1, duration: 0},
      %{text: "La muñeca debe estar RECTA, no doblada hacia arriba ni hacia abajo", note: 0, hint: "Alineación perfecta", finger: 0, duration: 0},
      %{text: "Verifica: ¿tu muñeca está en línea recta con tu antebrazo?", note: 0, hint: "No debe estar arqueada", finger: 0, duration: 0},
      %{text: "La muñeca debe tener cierta FLEXIBILIDAD pero sin estar tensa", note: 0, hint: "Flexibilidad activa", finger: 0, duration: 0},
      %{text: "POSICIÓN DE LOS DEDOS: Tus dedos deben estar CURVOS", note: 0, hint: "Como si sostuvieras una pelota pequeña", finger: 0, duration: 0},
      %{text: "Imagina una pelota de ping-pong en tu mano", note: 0, hint: "Esa es la forma perfecta", finger: 0, duration: 0},
      %{text: "Los dedos deben golpear el teclado, no tocar plano", note: 0, hint: "Técnica correcta desde el inicio", finger: 0, duration: 0},
      %{text: "Practica tocando Do Central con los DEDOS CURVOS", note: 60, hint: "Siente la diferencia", finger: 1, duration: 1},
      %{text: "El sonido debe ser CLARO y DEFINIDO", note: 0, hint: "Con dedos curvos suena mejor", finger: 0, duration: 0},
      %{text: "POSICIÓN COMPLETA: Revisa TODO", note: 0, hint: "Espalda recta, hombros relajados, codos naturales", finger: 0, duration: 0},
      %{text: "Muñeca recta, dedos curvos, sentado correctamente", note: 0, hint: "¿Todo está bien?", finger: 0, duration: 0},
      %{text: "PRÁCTICA: Toca Do Central con postura correcta", note: 60, hint: "Siente la diferencia", finger: 1, duration: 1},
      %{text: "Ahora toca Re, Mi, Fa, Sol con la misma postura", note: 62, hint: "Mantén los dedos curvos", finger: 2, duration: 2},
      %{text: "La postura correcta te permitirá tocar más tiempo sin cansarte", note: 0, hint: "Es una inversión en tu futuro", finger: 0, duration: 0},
      %{text: "La postura correcta también PROTEGE tus manos de lesiones", note: 0, hint: "La lesión más pequeña puede causar problemas grandes", finger: 0, duration: 0},
      %{text: "Practica: siéntate correctamente CADA VEZ que tocas el piano", note: 0, hint: "Los buenos hábitos son automáticos después", finger: 0, duration: 0},
      %{text: "Recuerda: ESPALDA recta, HOMBROS relajados, CODOS naturales", note: 0, hint: "La tríada de la postura correcta", finger: 0, duration: 0},
      %{text: "MUÑECA recta, DEDOS curvos, SENTADO hacia el borde", note: 0, hint: "Los detalles importan", finger: 0, duration: 0},
      %{text: "Felicitaciones: has establecido los cimientos de una técnica sólida", note: 60, hint: "La postura correcta desde el inicio", finger: 1, duration: 1}
    ],
    focus: "Complete mastery of correct hand position, posture, and ergonomic setup for injury-free, efficient piano playing",
    new_concepts: [
      "body_posture_at_piano",
      "seated_positioning_bench_height",
      "shoulder_relaxation",
      "elbow_positioning_and_freedom",
      "wrist_alignment_straight",
      "finger_curvature_technique",
      "hand_shape_optimal",
      "physical_comfort_and_endurance",
      "injury_prevention",
      "ergonomic_foundation"
    ],
    confidence_level_target: "Perfect posture mastered; muscle memory for correct position; injury prevention understood",
    cognitive_complexity: "basic",
    motor_complexity: "intermediate",
    duration_minutes: 35
  },

  # Lesson 1.7 - Keyboard Layout Overview
  %{
    id: "1_07_keyboard_overview",
    title: "1.7 Panorama General del Teclado",
    description: "Comprende el TECLADO COMPLETO: cómo el patrón se repite 7 veces, cómo las notas se hacen más graves a la izquierda y más agudas a la derecha, y cómo TODA la estructura tiene sentido.",
    intro:
      "Hasta ahora hemos aprendido sobre Do Central. Pero el piano tiene 88 teclas. Hoy comprenderemos el piano COMPLETO: por qué es tan grande, cómo se organiza, y cómo TODA la estructura es lógica y consistente. Este es el mapa completo del territorio que dominarás.",
    metronome: false,
    module_id: "mod_001_piano_fundamentals",
    order: 7,
    steps: [
      %{text: "Siéntate en Do Central. Este es nuestro HOGAR.", note: 60, hint: "El punto de referencia", finger: 1, duration: 1},
      %{text: "Ahora nos vamos a explorar hacia la IZQUIERDA (GRAVES)", note: 0, hint: "Hacia las notas bajas", finger: 0, duration: 0},
      %{text: "Muévete a la izquierda: ¿qué ves? ¿El patrón 2-3 sigue igual?", note: 0, hint: "Sí, se repite", finger: 0, duration: 0},
      %{text: "Toca Do una octava debajo de Central", note: 48, hint: "Suena más GRAVE", finger: 1, duration: 1},
      %{text: "Toca Do dos octavas debajo", note: 36, hint: "Mucho más grave", finger: 1, duration: 1},
      %{text: "Toca Do tres octavas debajo", note: 24, hint: "MUCHO más grave", finger: 1, duration: 1},
      %{text: "¿Notas el patrón? Do, una octava más grave, otra más, otra más...", note: 0, hint: "El patrón PERFECTO de octavas", finger: 0, duration: 0},
      %{text: "Hacia el EXTREMO IZQUIERDO del piano", note: 0, hint: "Las notas más graves", finger: 0, duration: 0},
      %{text: "Toca la nota MÁS GRAVE del piano (la tecla del extremo izquierdo)", note: 21, hint: "¡Qué sonido tan profundo!", finger: 1, duration: 2},
      %{text: "Ese es La (A0). El piano empieza aquí en La, no en Do.", note: 0, hint: "Dato interesante", finger: 0, duration: 0},
      %{text: "Regresa a Do Central. Ahora exploramos hacia la DERECHA (AGUDOS)", note: 60, hint: "Hacia las notas altas", finger: 1, duration: 1},
      %{text: "Muévete a la derecha: ¿el patrón 2-3 sigue igual?", note: 0, hint: "Siempre el mismo", finger: 0, duration: 0},
      %{text: "Toca Do una octava ARRIBA de Central", note: 72, hint: "Suena más AGUDO", finger: 1, duration: 1},
      %{text: "Toca Do dos octavas arriba", note: 84, hint: "Mucho más agudo", finger: 1, duration: 1},
      %{text: "¿Notas cómo sube el sonido? Cada Do es más alto.", note: 0, hint: "El patrón sigue siendo perfecto", finger: 0, duration: 0},
      %{text: "Hacia el EXTREMO DERECHO del piano", note: 0, hint: "Las notas más agudas", finger: 0, duration: 0},
      %{text: "Toca la nota MÁS AGUDA del piano (la tecla del extremo derecho)", note: 108, hint: "¡Qué sonido tan brillante!", finger: 5, duration: 2},
      %{text: "Ese es Do (C8). El piano termina aquí.", note: 0, hint: "El rango completo", finger: 0, duration: 0},
      %{text: "CONCLUSIÓN: El piano va desde La (A0) hasta Do (C8)", note: 0, hint: "88 teclas exactas", finger: 0, duration: 0},
      %{text: "ORGANIZACIÓN: El patrón 2-3 se repite en TODAS partes", note: 0, hint: "7 octavas completas + algunas notas", finger: 0, duration: 0},
      %{text: "DIRECCIÓN: Izquierda = GRAVE, Derecha = AGUDO", note: 0, hint: "Siempre en la misma dirección", finger: 0, duration: 0},
      %{text: "Regresa a Do Central: el HOGAR del piano", note: 60, hint: "Desde aquí puedes ir a cualquier lado", finger: 1, duration: 1},
      %{text: "Ahora vamos a mapear TODO el teclado", note: 0, hint: "Comprensión completa", finger: 0, duration: 0},
      %{text: "Toca Do en el extremo izquierdo", note: 24, hint: "La nota más grave de Do", finger: 1, duration: 1},
      %{text: "Ahora salta a Do Central", note: 60, hint: "Salto de 3 octavas", finger: 1, duration: 1},
      %{text: "Ahora salta al Do más agudo", note: 84, hint: "Otro salto de 2 octavas", finger: 1, duration: 1},
      %{text: "Ahora toca TODAS las notas Do del piano (de izquierda a derecha)", note: 0, hint: "Estarás subiendo constantemente", finger: 1, duration: 3},
      %{text: "¿Lo ves? Do es Do es Do. Mismo patrón, diferente altura.", note: 0, hint: "La claridad emerge", finger: 0, duration: 0},
      %{text: "COMPRENDISTE: El piano es LÓGICO, ORGANIZADO, PREDECIBLE", note: 0, hint: "No es caótico", finger: 0, duration: 0},
      %{text: "88 teclas. 7 octavas. 1 patrón. Infinitamente bello.", note: 0, hint: "La elegancia de la música", finger: 0, duration: 0},
      %{text: "Felicitaciones: has completado la exploración fundamental del piano", note: 60, hint: "Dominas la geografía del teclado", finger: 1, duration: 1},
      %{text: "Ahora estás listo para lo que viene: NOMBRES DE NOTAS Y MELODÍAS", note: 0, hint: "El siguiente módulo", finger: 0, duration: 0}
    ],
    focus: "Complete synthesis of keyboard understanding: full 88-key organization, pattern consistency, pitch direction, and readiness for advanced learning",
    new_concepts: [
      "full_keyboard_88_keys",
      "piano_range_A0_to_C8",
      "octave_repetition_throughout",
      "grave_to_acute_pitch_direction",
      "keyboard_geography_mapping",
      "pattern_consistency_all_registers",
      "reference_points_multiple_octaves",
      "foundational_keyboard_mastery",
      "readiness_for_next_learning_stage"
    ],
    confidence_level_target: "Complete keyboard comprehension; ready for note naming and advanced concepts",
    cognitive_complexity: "intermediate",
    motor_complexity: "intermediate",
    duration_minutes: 40
  }
]

IO.puts("🎵 Inserting #{Enum.count(lessons_module_01)} lessons with enriched metadata...")

Enum.each(lessons_module_01, fn lesson ->
  MusicIan.Repo.insert!(
    MusicIan.Curriculum.Lesson.changeset(%MusicIan.Curriculum.Lesson{}, lesson),
    on_conflict: :replace_all,
    conflict_target: :id
  )
end)

IO.puts("✅ Module 1 (Fundamentos del Teclado) lessons inserted with rich pedagogy!")
IO.puts(String.duplicate("=", 70) <> "\n")
