# Seed: Módulo 2 - Tu Primera Octava: Las Notas (First Octave: Note Names)
# ENRICHED PEDAGOGY: Learn to name and play all 7 white keys
# Target: Note naming, auditory recognition, multi-sensory reinforcement
#
# Duration progression: [22, 23, 25, 28, 32, 37, 42] minutes
# Emotional arc: ubicación → movimiento
# Cognitive load: Gradual - memory formation with repetition
# Motor complexity: Gradual - intentional key pressing and transitions

alias MusicIan.Repo
alias MusicIan.Curriculum.Lesson

IO.puts("\n" <> String.duplicate("=", 70))
IO.puts("📚 SEEDING MODULE 2: Tu Primera Octava - Las Notas (with Rich Pedagogy)")
IO.puts(String.duplicate("=", 70))

lessons_module_02 = [
  # Lesson 2.1 - The 7 Notes Introduction
  %{
    id: "2_01_seven_notes_intro",
    title: "2.1 Las 7 Notas Blancas",
    description: "Conoce los nombres de las 7 notas que se repiten en todo el piano.",
    intro:
      "Todas las teclas blancas tienen nombres. Solo hay 7 nombres diferentes, y luego se repiten. Los nombres son: Do, Re, Mi, Fa, Sol, La, Si. Después vuelve a Do.",
    metronome: false,
    time_signature: "4/4",
    module_id: "mod_002_first_octave",
    order: 1,
    steps: [
      %{text: "Do (C) - Aquí está", note: 60, hint: "A la izquierda de 2 negras", finger: 1, duration: 1},
      %{text: "Re (D) - Una blanca a la derecha", note: 62, hint: "Después de Do", finger: 2, duration: 1},
      %{text: "Mi (E) - Una blanca a la derecha", note: 64, hint: "Después de Re", finger: 3, duration: 1},
      %{text: "Fa (F) - Una blanca a la derecha", note: 65, hint: "A la izquierda de 3 negras", finger: 4, duration: 1},
      %{text: "Sol (G) - Una blanca a la derecha", note: 67, hint: "En el medio de 3 negras", finger: 5, duration: 1},
      %{text: "La (A) - Una blanca a la derecha", note: 69, hint: "Entre dos negras", finger: 5, duration: 1},
      %{text: "Si (B) - Una blanca a la derecha", note: 71, hint: "A la derecha de 3 negras", finger: 5, duration: 1},
      %{text: "Do (C) nuevamente - ¡Se repite!", note: 72, hint: "Una octava más arriba", finger: 5, duration: 1}
    ],
    focus: "Introducing all 7 note names and establishing sequence in memory",
    new_concepts: [
      "note_names_c_d_e_f_g_a_b",
      "seven_note_cycle",
      "chromatic_navigation",
      "note_sequence_ascending",
      "octave_note_repetition"
    ],
    confidence_level_target: "Heard all names once; sequence structure starting to form",
    cognitive_complexity: "intermediate",
    motor_complexity: "basic",
    duration_minutes: 22
  },

  # Lesson 2.2 - Individual Notes: Do
  %{
    id: "2_02_note_do",
    title: "2.2 La Nota Do (C)",
    description: "Practica tocar solo la nota Do. La encontramos a la izquierda del grupo de 2 teclas negras.",
    intro:
      "Do es la nota con la que empezamos. Está siempre a la izquierda del grupo de 2 teclas negras. Busca todos los Do que puedas en el teclado.",
    metronome: false,
    time_signature: "4/4",
    module_id: "mod_002_first_octave",
    order: 2,
    steps: [
      %{text: "Encuentra Do Central (Do en el centro)", note: 60, hint: "Punto de referencia", finger: 1, duration: 1},
      %{text: "Toca Do varias veces", note: 60, hint: "Recuerda el sonido", finger: 1, duration: 2},
      %{text: "Encuentra Do a la IZQUIERDA", note: 48, hint: "Una octava más grave", finger: 1, duration: 1},
      %{text: "Toca ese Do", note: 48, hint: "Suena más bajo", finger: 1, duration: 1},
      %{text: "Encuentra Do a la DERECHA", note: 72, hint: "Una octava más aguda", finger: 1, duration: 1},
      %{text: "Toca ese Do", note: 72, hint: "Suena más alto", finger: 1, duration: 1},
      %{text: "Alterna entre los tres Do", note: 60, hint: "Izquierda - Centro - Derecha", finger: 1, duration: 2}
    ],
    focus: "Isolating single note name, multi-octave recognition, auditory anchoring",
    new_concepts: [
      "note_name_do_c",
      "do_in_multiple_octaves",
      "note_location_patterns",
      "auditory_tone_recognition",
      "hand_transition_between_octaves"
    ],
    confidence_level_target: "Can find and name Do reliably across keyboard",
    cognitive_complexity: "intermediate",
    motor_complexity: "intermediate",
    duration_minutes: 23
  },

  # Lesson 2.3 - Individual Notes: Re
  %{
    id: "2_03_note_re",
    title: "2.3 La Nota Re (D)",
    description: "Practica tocar Re. Viene siempre después de Do.",
    intro:
      "Re viene después de Do. Si empiezas en Do Central y mueves un dedo a la derecha, ese es Re. Es la segunda nota blanca del patrón.",
    metronome: false,
    time_signature: "4/4",
    module_id: "mod_002_first_octave",
    order: 3,
    steps: [
      %{text: "Toca Do Central", note: 60, hint: "Punto de inicio", finger: 1, duration: 0.5},
      %{text: "Toca Re (la blanca al lado a la derecha)", note: 62, hint: "Dedo 2", finger: 2, duration: 1},
      %{text: "Vuelve a Do", note: 60, hint: "Atrás hacia la izquierda", finger: 1, duration: 0.5},
      %{text: "Do-Re-Do, Do-Re-Do", note: 60, hint: "Alterna entre Do y Re", finger: 1, duration: 2},
      %{text: "Ahora toca solo Re varias veces", note: 62, hint: "Sin Do", finger: 2, duration: 2},
      %{text: "Encuentra Re en diferentes octavas", note: 62, hint: "Arriba y abajo", finger: 2, duration: 2}
    ],
    focus: "Learning second note through adjacent-key relationship to Do",
    new_concepts: [
      "note_name_re_d",
      "note_adjacency_relationship",
      "do_re_sequence",
      "transition_between_adjacent_keys",
      "note_identity_isolation"
    ],
    confidence_level_target: "Can identify Re as 'the note next to Do'",
    cognitive_complexity: "intermediate",
    motor_complexity: "intermediate",
    duration_minutes: 25
  },

  # Lesson 2.4 - Individual Notes: Mi
  %{
    id: "2_04_note_mi",
    title: "2.4 La Nota Mi (E)",
    description: "Practica tocar Mi. Es la tercera nota después de Do.",
    intro:
      "Mi viene después de Re. Do-Re-Mi. Es la tercera nota blanca. Buscamos a Mi mirando a la izquierda del grupo de 3 teclas negras.",
    metronome: false,
    time_signature: "4/4",
    module_id: "mod_002_first_octave",
    order: 4,
    steps: [
      %{text: "Toca Do", note: 60, hint: "Inicio", finger: 1, duration: 0.5},
      %{text: "Toca Re", note: 62, hint: "Siguiente", finger: 2, duration: 0.5},
      %{text: "Toca Mi (la blanca al lado a la derecha)", note: 64, hint: "Dedo 3", finger: 3, duration: 1},
      %{text: "Do-Re-Mi juntas", note: 60, hint: "La secuencia", finger: 1, duration: 2},
      %{text: "Ahora toca solo Mi varias veces", note: 64, hint: "Una nota", finger: 3, duration: 2},
      %{text: "Mi en diferentes posiciones del teclado", note: 64, hint: "Arriba y abajo", finger: 3, duration: 2}
    ],
    focus: "Adding third note to sequence, pattern extension practice",
    new_concepts: [
      "note_name_mi_e",
      "do_re_mi_sequence",
      "three_note_pattern",
      "black_key_landmark_mi_position",
      "sequential_note_building"
    ],
    confidence_level_target: "Can identify Mi in context of Do-Re-Mi sequence",
    cognitive_complexity: "intermediate",
    motor_complexity: "intermediate",
    duration_minutes: 28
  },

  # Lesson 2.5 - Individual Notes: Fa, Sol, La, Si
  %{
    id: "2_05_notes_fa_sol_la_si",
    title: "2.5 Las Notas Fa, Sol, La, Si",
    description: "Continúa con Fa, Sol, La, Si. Las últimas notas antes de Do nuevamente.",
    intro:
      "Después de Mi vienen Fa, Sol, La, Si. Luego vuelve a Do. Vamos a aprender estas cuatro notas.",
    metronome: false,
    time_signature: "4/4",
    module_id: "mod_002_first_octave",
    order: 5,
    steps: [
      %{text: "Toca Fa (a la izquierda de 3 negras)", note: 65, hint: "Dedo 4", finger: 4, duration: 1},
      %{text: "Toca Sol (en el medio de 3 negras)", note: 67, hint: "Dedo 5", finger: 5, duration: 1},
      %{text: "Toca La (entre dos negras)", note: 69, hint: "Después de Sol", finger: 5, duration: 1},
      %{text: "Toca Si (a la derecha de 3 negras)", note: 71, hint: "Penúltima", finger: 5, duration: 1},
      %{text: "Y Do nuevamente", note: 72, hint: "¡Se repite!", finger: 5, duration: 1},
      %{text: "Canta: Do-Re-Mi-Fa-Sol-La-Si-Do", note: 60, hint: "Con el nombre", finger: 1, duration: 4}
    ],
    focus: "Completing seven-note set, integrating full scale sequence",
    new_concepts: [
      "note_names_fa_sol_la_si",
      "complete_seven_note_sequence",
      "black_key_landmarks_for_fa_sol_la_si",
      "singing_note_names",
      "auditory_memory_formation"
    ],
    confidence_level_target: "Knows all 7 names in sequence; can sing and play",
    cognitive_complexity: "intermediate",
    motor_complexity: "intermediate",
    duration_minutes: 32
  },

  # Lesson 2.6 - All Notes Together
  %{
    id: "2_06_all_notes_sequence",
    title: "2.6 Las 7 Notas - Secuencia Completa",
    description: "Toca todas las 7 notas en orden, lentamente y con confianza.",
    intro:
      "Ahora que conoces los 7 nombres, vamos a tocar la escala completa lentamente. Do-Re-Mi-Fa-Sol-La-Si-Do. Recuerda los patrones de teclas negras para orientarte.",
    metronome: false,
    time_signature: "4/4",
    module_id: "mod_002_first_octave",
    order: 6,
    steps: [
      %{text: "Do", note: 60, hint: "Izquierda de 2 negras", finger: 1, duration: 1},
      %{text: "Re", note: 62, hint: "Siguiente blanca", finger: 2, duration: 1},
      %{text: "Mi", note: 64, hint: "Izquierda de 3 negras", finger: 3, duration: 1},
      %{text: "Fa", note: 65, hint: "Izquierda de 3 negras", finger: 4, duration: 1},
      %{text: "Sol", note: 67, hint: "Centro de 3 negras", finger: 5, duration: 1},
      %{text: "La", note: 69, hint: "Entre negras", finger: 5, duration: 1},
      %{text: "Si", note: 71, hint: "Derecha de 3 negras", finger: 5, duration: 1},
      %{text: "Do", note: 72, hint: "Una octava más arriba", finger: 5, duration: 1}
    ],
    focus: "Sequential execution of entire scale, fluency building",
    new_concepts: [
      "major_scale_structure",
      "eight_note_octave_cycle",
      "scale_fluency_ascending",
      "continuous_finger_movement",
      "note_naming_while_playing"
    ],
    confidence_level_target: "Can play full scale smoothly; sequence is secure",
    cognitive_complexity: "intermediate",
    motor_complexity: "intermediate",
    duration_minutes: 37
  },

  # Lesson 2.7 - Scale Up and Down
  %{
    id: "2_07_scale_up_down",
    title: "2.7 Escala Arriba y Abajo",
    description: "Toca la escala hacia arriba, luego hacia abajo. Regresa por donde viniste.",
    intro:
      "Toca la escala hacia arriba: Do-Re-Mi-Fa-Sol-La-Si-Do. Ahora hacia abajo: Do-Si-La-Sol-Fa-Mi-Re-Do. Es como subir una escalera y bajar.",
    metronome: false,
    time_signature: "4/4",
    module_id: "mod_002_first_octave",
    order: 7,
    steps: [
      %{text: "Escala ARRIBA: Do-Re-Mi-Fa-Sol-La-Si-Do", note: 60, hint: "Sube suavemente", finger: 1, duration: 2},
      %{text: "Pausa en Do arriba", note: 72, hint: "Momento de descanso", finger: 5, duration: 1},
      %{text: "Escala ABAJO: Do-Si-La-Sol-Fa-Mi-Re-Do", note: 72, hint: "Baja suavemente", finger: 5, duration: 2},
      %{text: "Pausa en Do abajo", note: 60, hint: "Volviste a casa", finger: 1, duration: 1},
      %{text: "Arriba-Abajo completo", note: 60, hint: "Fluida", finger: 1, duration: 4}
    ],
    focus: "Bidirectional scale execution, reversing sequence, smooth transitions",
    new_concepts: [
      "descending_scale_sequence",
      "scale_reversal_symmetry",
      "bidirectional_navigation",
      "fluent_multi_directional_playing",
      "scale_completion_cycle"
    ],
    confidence_level_target: "Fluid in both directions; scale mastery emerging",
    cognitive_complexity: "intermediate",
    motor_complexity: "intermediate",
    duration_minutes: 42
  },

  # Lesson 2.8 - Random Notes Recognition
  %{
    id: "2_08_random_notes",
    title: "2.8 Reconocer Notas Aleatoriamente",
    description: "Se te dirá el nombre de una nota. Tócala en el teclado.",
    intro:
      "Ahora vamos a practicar el reconocimiento rápido. Te decimos una nota (como 'Sol'), y tú la buscas en el teclado lo más rápido posible.",
    metronome: false,
    time_signature: "4/4",
    module_id: "mod_002_first_octave",
    order: 8,
    steps: [
      %{text: "Toca Sol", note: 67, hint: "Centro de 3 negras", finger: 5, duration: 0.5},
      %{text: "Toca Mi", note: 64, hint: "Izquierda de 3 negras", finger: 3, duration: 0.5},
      %{text: "Toca Do", note: 60, hint: "Izquierda de 2 negras", finger: 1, duration: 0.5},
      %{text: "Toca La", note: 69, hint: "Entre dos negras", finger: 5, duration: 0.5},
      %{text: "Toca Si", note: 71, hint: "Derecha de 3 negras", finger: 5, duration: 0.5},
      %{text: "Toca Fa", note: 65, hint: "Izquierda de 3 negras", finger: 4, duration: 0.5},
      %{text: "Toca Re", note: 62, hint: "Segunda blanca", finger: 2, duration: 0.5},
      %{text: "Toca cualquier nota sin mirar", note: 60, hint: "Memoria del teclado", finger: 1, duration: 1}
    ],
    focus: "Rapid note identification and kinesthetic response, breaking sequence dependency",
    new_concepts: [
      "random_note_recognition",
      "fast_name_to_key_mapping",
      "landmark_based_navigation",
      "kinesthetic_memory_independence",
      "auditory_note_naming"
    ],
    confidence_level_target: "Can instantly name and play any note; identity secure",
    cognitive_complexity: "intermediate",
    motor_complexity: "intermediate",
    duration_minutes: 40
  }
]

IO.puts("🎵 Inserting #{Enum.count(lessons_module_02)} lessons with enriched metadata...")

Enum.each(lessons_module_02, fn lesson ->
  MusicIan.Repo.insert!(
    MusicIan.Curriculum.Lesson.changeset(%MusicIan.Curriculum.Lesson{}, lesson),
    on_conflict: :replace_all,
    conflict_target: :id
  )
end)

IO.puts("✅ Module 2 (Tu Primera Octava - Las Notas) lessons inserted with rich pedagogy!")
IO.puts(String.duplicate("=", 70) <> "\n")
