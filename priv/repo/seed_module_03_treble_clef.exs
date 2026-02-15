# Seed: Módulo 3 - Clave de Sol (Treble Clef - Right Hand)
# Lecciones: Técnica de mano derecha, posición, pasos y saltos, melodías

alias MusicIan.Repo
alias MusicIan.Curriculum.Lesson

IO.puts("\n" <> String.duplicate("=", 60))
IO.puts("📚 SEEDING MODULE 3: Clave de Sol (Mano Derecha)")
IO.puts(String.duplicate("=", 60))

lessons_module_03 = [
  %{
    id: "01_rh_five_fingers",
    title: "1. MD: Los 5 Dedos",
    description: "Estableciendo la posición de mano derecha.",
    intro:
      "Coloca tu mano derecha en el Do Central (C4). Cada dedo tiene su tecla: Pulgar(1) en Do, hasta Meñique(5) en Sol. Mantén la mano curva como si sostuvieras una pelota.",
    metronome: true,
    module_id: "mod_003_treble_clef",
    steps: [
      %{text: "Do (C4)", note: 60, hint: "Pulgar (1)", finger: 1, duration: 1},
      %{text: "Re (D4)", note: 62, hint: "Índice (2)", finger: 2, duration: 1},
      %{text: "Mi (E4)", note: 64, hint: "Medio (3)", finger: 3, duration: 1},
      %{text: "Fa (F4)", note: 65, hint: "Anular (4)", finger: 4, duration: 1},
      %{text: "Sol (G4)", note: 67, hint: "Meñique (5)", finger: 5, duration: 1},
      %{text: "Fa (F4)", note: 65, hint: "Bajando...", finger: 4, duration: 1},
      %{text: "Mi (E4)", note: 64, hint: "Bajando...", finger: 3, duration: 1},
      %{text: "Re (D4)", note: 62, hint: "Bajando...", finger: 2, duration: 1},
      %{text: "Do (C4)", note: 60, hint: "Final", finger: 1, duration: 2}
    ]
  },
  %{
    id: "02_rh_skips",
    title: "2. MD: Pasos y Saltos",
    description: "Diferencia entre segundas y terceras.",
    intro:
      "La música se mueve por pasos (nota vecina) o saltos (saltarse una nota). Practiquemos saltar del 1 al 3 y del 3 al 5.",
    metronome: true,
    module_id: "mod_003_treble_clef",
    steps: [
      %{text: "Do (C4)", note: 60, hint: "Dedo 1", finger: 1, duration: 1},
      %{text: "Mi (E4)", note: 64, hint: "Salto al 3", finger: 3, duration: 1},
      %{text: "Sol (G4)", note: 67, hint: "Salto al 5", finger: 5, duration: 1},
      %{text: "Mi (E4)", note: 64, hint: "Salto al 3", finger: 3, duration: 1},
      %{text: "Do (C4)", note: 60, hint: "Salto al 1", finger: 1, duration: 1},
      %{text: "Re (D4)", note: 62, hint: "Paso", finger: 2, duration: 1},
      %{text: "Fa (F4)", note: 65, hint: "Salto de tercera", finger: 4, duration: 1},
      %{text: "Re (D4)", note: 62, hint: "Regreso", finger: 2, duration: 2}
    ]
  },
  %{
    id: "03_rh_melody",
    title: "3. MD: Primera Melodía (Oda a la Alegría)",
    description: "Aplicando la técnica a música real.",
    intro:
      "Usando solo los 5 dedos de la mano derecha, podemos tocar melodías famosas. Intenta mantener un ritmo constante.",
    metronome: true,
    module_id: "mod_003_treble_clef",
    steps: [
      %{text: "Mi (E4)", note: 64, hint: "Dedo 3", finger: 3, duration: 1},
      %{text: "Mi (E4)", note: 64, hint: "Repite", finger: 3, duration: 1},
      %{text: "Fa (F4)", note: 65, hint: "Sube", finger: 4, duration: 1},
      %{text: "Sol (G4)", note: 67, hint: "Sube", finger: 5, duration: 1},
      %{text: "Sol (G4)", note: 67, hint: "Repite", finger: 5, duration: 1},
      %{text: "Fa (F4)", note: 65, hint: "Baja", finger: 4, duration: 1},
      %{text: "Mi (E4)", note: 64, hint: "Baja", finger: 3, duration: 1},
      %{text: "Re (D4)", note: 62, hint: "Baja", finger: 2, duration: 1},
      %{text: "Do (C4)", note: 60, hint: "Llegada", finger: 1, duration: 2}
    ]
  },
  %{
    id: "04_rh_rhythm",
    title: "4. MD: Ritmo y Repetición (Jingle Bells)",
    description: "Control de notas repetidas.",
    intro: "El control de las notas repetidas es crucial. Usa un rebote suave de muñeca.",
    metronome: true,
    module_id: "mod_003_treble_clef",
    steps: [
      %{text: "Mi (E4)", note: 64, hint: "Jingle...", finger: 3, duration: 1},
      %{text: "Mi (E4)", note: 64, hint: "...Bells", finger: 3, duration: 1},
      %{text: "Mi (E4)", note: 64, hint: "Jingle...", finger: 3, duration: 2},
      %{text: "Mi (E4)", note: 64, hint: "...Bells", finger: 3, duration: 1},
      %{text: "Mi (E4)", note: 64, hint: "Jin-", finger: 3, duration: 1},
      %{text: "Sol (G4)", note: 67, hint: "-gle", finger: 5, duration: 1},
      %{text: "Do (C4)", note: 60, hint: "All", finger: 1, duration: 1},
      %{text: "Re (D4)", note: 62, hint: "The", finger: 2, duration: 1},
      %{text: "Mi (E4)", note: 64, hint: "Way!", finger: 3, duration: 2}
    ]
  },
  %{
    id: "16_rh_thumb_under",
    title: "16. MD: El Cruce de Pulgar",
    description: "Técnica esencial para extender la mano más allá de 5 notas.",
    intro:
      "Para tocar más de 5 notas, necesitamos 'cruzar'. Toca Do-Re-Mi (1-2-3) y luego pasa el Pulgar (1) POR DEBAJO del dedo 3 para llegar a Fa.",
    metronome: true,
    module_id: "mod_003_treble_clef",
    steps: []
  },
  %{
    id: "17_rh_c_scale",
    title: "17. MD: Escala de Do Mayor (1 Octava)",
    description: "Tu primera escala completa de 8 notas.",
    intro:
      "Completemos la octava. Mantén un pulso constante, como un reloj: Tic, Tac, Tic, Tac. ¡Intenta que suene fluido!",
    metronome: true,
    module_id: "mod_003_treble_clef",
    steps: []
  },
  %{
    id: "20_g_position",
    title: "20. Posición de Sol (G Major)",
    description: "Nueva posición: Mueve tus manos a Sol.",
    intro:
      "Mueve tu mano derecha. Ahora el Pulgar (1) va en Sol (G4). Tus 5 dedos cubrirán: Sol, La, Si, Do, Re.",
    metronome: true,
    module_id: "mod_003_treble_clef",
    steps: []
  }
]

IO.puts("🎵 Inserting #{Enum.count(lessons_module_03)} lessons...")

Enum.each(lessons_module_03, fn lesson ->
  MusicIan.Repo.insert!(MusicIan.Curriculum.Lesson.changeset(%MusicIan.Curriculum.Lesson{}, lesson))
end)

IO.puts("✅ Module 3 lessons inserted!")
IO.puts(String.duplicate("=", 60) <> "\n")
