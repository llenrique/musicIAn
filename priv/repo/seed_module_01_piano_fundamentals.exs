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
    description: "Observa las partes principales del piano: teclas blancas, teclas negras y patrones básicos.",
    intro:
      "¡Bienvenido al piano! Este instrumento tiene muchas teclas blancas y negras. Las teclas son lo que tocas con los dedos. Observemos cómo están organizadas.",
    metronome: false,
    module_id: "mod_001_piano_fundamentals",
    order: 1,
    steps: [
      %{text: "Observa las teclas blancas", note: 0, hint: "Hay muchas teclas blancas", finger: 0, duration: 0},
      %{text: "Observa las teclas negras", note: 0, hint: "Están agrupadas en patrones", finger: 0, duration: 0},
      %{text: "Toca una tecla blanca", note: 60, hint: "¡Escuchas un sonido!", finger: 1, duration: 1},
      %{text: "Toca otra tecla blanca", note: 62, hint: "Sonido diferente", finger: 2, duration: 1},
      %{text: "Toca una tecla negra", note: 61, hint: "También suena", finger: 2, duration: 1}
    ],
    # ENRICHED METADATA
    focus: "Visual orientation to piano keyboard structure and basic touch",
    new_concepts: [
      "piano_keyboard_layout",
      "white_keys",
      "black_keys",
      "key_group_patterns"
    ],
    confidence_level_target: "Curious and comfortable exploring the keyboard visually",
    cognitive_complexity: "basic",
    motor_complexity: "basic",
    duration_minutes: 5
  },

  # Lesson 1.2 - White and Black Keys Pattern
  %{
    id: "1_02_white_black_pattern",
    title: "1.2 El Patrón de Teclas: Blancas y Negras",
    description: "Aprende el patrón que se repite: 2 negras, 3 negras, 2 negras, 3 negras... Este patrón te ayudará a orientarte en el piano.",
    intro:
      "Observa bien: Las teclas negras están agrupadas en un patrón que se repite. Hay grupos de 2 teclas negras, luego un grupo de 3. Este mismo patrón se repite en todo el piano. Este patrón es tu brújula.",
    metronome: false,
    module_id: "mod_001_piano_fundamentals",
    order: 2,
    steps: [
      %{text: "Encuentra un grupo de 2 negras", note: 0, hint: "¿Ves dónde está?", finger: 0, duration: 0},
      %{text: "Encuentra un grupo de 3 negras", note: 0, hint: "Viene después del grupo de 2", finger: 0, duration: 0},
      %{text: "Toca la blanca entre las 2 negras", note: 62, hint: "La blanca en el medio", finger: 2, duration: 1},
      %{text: "Toca la blanca en el grupo de 3", note: 65, hint: "La blanca en el centro del grupo", finger: 0, duration: 1},
      %{text: "Busca el patrón más a la derecha", note: 0, hint: "¿Ves cómo se repite?", finger: 0, duration: 0}
    ],
    focus: "Recognizing and using the fundamental 2-3 black key pattern for keyboard orientation",
    new_concepts: [
      "two_black_keys_group",
      "three_black_keys_group",
      "pattern_repetition_across_keyboard",
      "spatial_landmarks",
      "white_keys_relative_to_black_groups"
    ],
    confidence_level_target: "Pattern recognition clear; using pattern as navigation aid",
    cognitive_complexity: "basic",
    motor_complexity: "basic",
    duration_minutes: 8
  },

  # Lesson 1.3 - Middle C Introduction
  %{
    id: "1_03_middle_c_intro",
    title: "1.3 El Do Central (Middle C)",
    description: "El Do Central es el punto de referencia más importante. Es el centro del piano.",
    intro:
      "En el medio del piano, hay una nota especial llamada Do Central. Es como el 'hogar' de tu mano. La encontramos mirando el patrón de teclas negras.",
    metronome: false,
    module_id: "mod_001_piano_fundamentals",
    order: 3,
    steps: [
      %{text: "Mira el grupo de 2 negras en el centro", note: 0, hint: "En el medio del piano", finger: 0, duration: 0},
      %{text: "La blanca a la IZQUIERDA de las 2 negras es Do Central", note: 60, hint: "Aquí está", finger: 1, duration: 1},
      %{text: "Toca Do Central varias veces", note: 60, hint: "Recuerda este sonido", finger: 1, duration: 1},
      %{text: "Cierra los ojos y toca Do Central", note: 60, hint: "Desarrolla la memoria muscular", finger: 1, duration: 1},
      %{text: "Ahora abre los ojos, ¿dónde está Do Central?", note: 60, hint: "Intenta encontrarlo sin mirar", finger: 1, duration: 0}
    ],
    focus: "Identifying Middle C as reference point using pattern landmarks",
    new_concepts: [
      "middle_c_location",
      "center_keyboard_position",
      "white_key_position_relative_to_black_groups",
      "auditory_middle_c_tone",
      "muscle_memory_for_location"
    ],
    confidence_level_target: "Found home position; gaining spatial security",
    cognitive_complexity: "basic",
    motor_complexity: "basic",
    duration_minutes: 23
  },

  # Lesson 1.4 - Finding Middle C on the Keyboard
  %{
    id: "1_04_locate_middle_c",
    title: "1.4 Localiza el Do Central",
    description: "Practica encontrar el Do Central en diferentes partes del piano.",
    intro:
      "El Do Central siempre está en el mismo lugar: a la izquierda del grupo de 2 teclas negras en el CENTRO del piano. Vamos a practicar encontrarlo desde diferentes posiciones.",
    metronome: false,
    module_id: "mod_001_piano_fundamentals",
    order: 4,
    steps: [
      %{text: "Toca Do Central (en el centro)", note: 60, hint: "Pulgar en C", finger: 1, duration: 1},
      %{text: "Mueve la mano a la DERECHA, ¿dónde está Do Central?", note: 60, hint: "Más a la izquierda ahora", finger: 1, duration: 1},
      %{text: "Mueve la mano a la IZQUIERDA, ¿dónde está Do Central?", note: 60, hint: "Más a la derecha ahora", finger: 1, duration: 1},
      %{text: "Cierra los ojos, mueve la mano, abre los ojos y toca Do Central", note: 60, hint: "Habilidad tacto", finger: 1, duration: 1},
      %{text: "Practica alternando: izquierda, centro, derecha", note: 60, hint: "Familiaridad con la posición", finger: 1, duration: 2}
    ],
    focus: "Developing spatial navigation and kinesthetic memory for Middle C position",
    new_concepts: [
      "kinesthetic_keyboard_navigation",
      "hand_displacement_and_return",
      "tactile_note_finding",
      "eye_closed_spatial_awareness",
      "consistency_of_position"
    ],
    confidence_level_target: "Can find home position reliably; spatial understanding secured",
    cognitive_complexity: "basic",
    motor_complexity: "intermediate",
    duration_minutes: 26
  },

  # Lesson 1.5 - Introduction to Octaves
  %{
    id: "1_05_octave_concept",
    title: "1.5 Las Octavas - El Patrón se Repite",
    description: "Una octava es cuando el patrón se repite. La siguiente Do está una octava más arriba.",
    intro:
      "Si tocas Do Central y luego cuentas 8 notas blancas hacia la derecha, vuelves a tocar Do. Pero suena más alto. Eso es una octava.",
    metronome: false,
    module_id: "mod_001_piano_fundamentals",
    order: 5,
    steps: [
      %{text: "Toca Do Central (C4)", note: 60, hint: "Punto de partida", finger: 1, duration: 1},
      %{text: "Toca la siguiente blanca (D)", note: 62, hint: "Es Re", finger: 2, duration: 0.5},
      %{text: "Sigue con Mi (E)", note: 64, hint: "Es Mi", finger: 3, duration: 0.5},
      %{text: "Continúa: Fa, Sol, La, Si", note: 65, hint: "Subiendo", finger: 0, duration: 2},
      %{text: "¡Volvemos a Do (C5)! Una octava más arriba", note: 72, hint: "¿Ves? Se repite", finger: 5, duration: 1}
    ],
    focus: "Understanding octave as pattern repetition and pitch relationship",
    new_concepts: [
      "octave_concept",
      "eight_white_keys_sequence",
      "note_sequence_ascending",
      "pitch_height_variation",
      "pattern_repetition_principle",
      "higher_lower_pitch_relationship"
    ],
    confidence_level_target: "Understands why piano is organized; pattern clarity",
    cognitive_complexity: "intermediate",
    motor_complexity: "intermediate",
    duration_minutes: 30
  },

  # Lesson 1.6 - Hand Position and Posture
  %{
    id: "1_06_hand_position",
    title: "1.6 Posición de la Mano",
    description: "Cómo sentar correctamente frente al piano y posicionar la mano.",
    intro:
      "Siéntate derecho. Los codos deben estar relajados. Los dedos deben verse curvos, como si sostuvieras una pelota pequeña. La muñeca debe estar relajada y recta.",
    metronome: false,
    module_id: "mod_001_piano_fundamentals",
    order: 6,
    steps: [
      %{text: "Siéntate frente al piano", note: 0, hint: "Derecho, cómodo", finger: 0, duration: 0},
      %{text: "Relaja los codos", note: 0, hint: "No tenses", finger: 0, duration: 0},
      %{text: "Coloca los dedos en Do Central", note: 60, hint: "Mano reposada", finger: 1, duration: 1},
      %{text: "Imagina una pelota en tu mano", note: 0, hint: "Dedos curvos", finger: 0, duration: 0},
      %{text: "Toca Do Central con postura correcta", note: 60, hint: "Escucha el sonido", finger: 1, duration: 1}
    ],
    focus: "Establishing proper ergonomic foundation for playing",
    new_concepts: [
      "body_posture_at_piano",
      "seated_positioning",
      "elbow_relaxation",
      "finger_curvature",
      "wrist_alignment",
      "hand_shape_technique",
      "physical_comfort_for_practice"
    ],
    confidence_level_target: "Comfortable physical setup; ready for intentional playing",
    cognitive_complexity: "basic",
    motor_complexity: "intermediate",
    duration_minutes: 35
  },

  # Lesson 1.7 - Keyboard Layout Overview
  %{
    id: "1_07_keyboard_overview",
    title: "1.7 Panorama General del Teclado",
    description: "Entiende que el patrón de teclas se repite en todo el teclado.",
    intro:
      "El piano es grande porque el patrón se repite muchas veces. A la izquierda de Do Central, las notas suenan más graves (bajas). A la derecha, más agudas (altas). Pero el patrón es siempre el mismo.",
    metronome: false,
    module_id: "mod_001_piano_fundamentals",
    order: 7,
    steps: [
      %{text: "Toca Do Central", note: 60, hint: "El centro", finger: 1, duration: 1},
      %{text: "Toca Do a la izquierda (más grave)", note: 48, hint: "Suena más bajo", finger: 5, duration: 1},
      %{text: "Toca Do a la derecha (más agudo)", note: 72, hint: "Suena más alto", finger: 1, duration: 1},
      %{text: "¿Ves el patrón blanco-negro igual?", note: 0, hint: "Es idéntico en cada octava", finger: 0, duration: 0},
      %{text: "Todo el piano es Do Central repetido", note: 60, hint: "Solo que más alto o más bajo", finger: 1, duration: 2}
    ],
    focus: "Synthesizing full keyboard understanding: pattern repetition across all octaves",
    new_concepts: [
      "full_keyboard_organization",
      "multiple_octaves_concept",
      "pitch_register_low_middle_high",
      "consistent_pattern_throughout",
      "piano_geography_overview",
      "reference_points_across_registers",
      "foundational_model_of_keyboard"
    ],
    confidence_level_target: "Complete understanding of keyboard; ready for note naming",
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
