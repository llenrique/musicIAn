# Seed: Módulo 6 - Repertorio y Piezas Musicales (Repertoire & Pieces)
# Lecciones: Piezas clásicas completas, Oda a la Alegría en diferentes versiones

alias MusicIan.Repo
alias MusicIan.Curriculum.Lesson

IO.puts("\n" <> String.duplicate("=", 60))
IO.puts("📚 SEEDING MODULE 6: Repertorio y Piezas Musicales")
IO.puts(String.duplicate("=", 60))

lessons_module_06 = [
  %{
    id: "14a_ode_to_joy_simple",
    title: "14A. Oda a la Alegría: Versión Simple",
    description: "Versión de 16 pasos con notas enteras, mitades y negras.",
    intro:
      "La versión simplificada de Ode to Joy usando solo valores largos (redonda, blanca, negra). 16 pasos.",
    metronome: true,
    module_id: "mod_006_repertoire",
    steps: [
      %{text: "Mi (E4)", note: 64, hint: "Dedo 3", finger: 3, duration: 1},
      %{text: "Mi (E4)", note: 64, hint: "Repite", finger: 3, duration: 1},
      %{text: "Fa (F4)", note: 65, hint: "Sube", finger: 4, duration: 1},
      %{text: "Sol (G4)", note: 67, hint: "Sube", finger: 5, duration: 2},
      %{text: "Sol (G4)", note: 67, hint: "Repite", finger: 5, duration: 1},
      %{text: "Fa (F4)", note: 65, hint: "Baja", finger: 4, duration: 1},
      %{text: "Mi (E4)", note: 64, hint: "Baja", finger: 3, duration: 1},
      %{text: "Re (D4)", note: 62, hint: "Baja", finger: 2, duration: 2},
      %{text: "Do (C4)", note: 60, hint: "Bajada", finger: 1, duration: 1},
      %{text: "Re (D4)", note: 62, hint: "Sube", finger: 2, duration: 1},
      %{text: "Mi (E4)", note: 64, hint: "Sube", finger: 3, duration: 1},
      %{text: "Fa (F4)", note: 65, hint: "Sube", finger: 4, duration: 2},
      %{text: "Mi (E4)", note: 64, hint: "Baja", finger: 3, duration: 1.5},
      %{text: "Re (D4)", note: 62, hint: "Más", finger: 2, duration: 0.5},
      %{text: "Re (D4)", note: 62, hint: "Repite", finger: 2, duration: 2},
      %{text: "Do (C4)", note: 60, hint: "Final", finger: 1, duration: 4}
    ]
  },
  %{
    id: "14b_ode_to_joy_intermediate",
    title: "14B. Oda a la Alegría: Versión Intermedia",
    description: "Versión con corcheas incluidas (24 pasos).",
    intro: "Con corcheas incluidas. Ahora la melodía suena más naturalmente con subdivisiones. 24 pasos.",
    metronome: true,
    module_id: "mod_006_repertoire",
    steps: [
      %{text: "Mi (E4)", notes: [64], hint: "Dedo 3", fingers: [3], duration: 1},
      %{text: "Mi (E4)", notes: [64], hint: "Repite", fingers: [3], duration: 1},
      %{text: "Fa-Sol", notes: [65, 67], hint: "2 corcheas", fingers: [4, 5], duration: 1},
      %{text: "Sol (G4)", note: 67, hint: "Negra", finger: 5, duration: 1},
      %{text: "Sol (G4)", note: 67, hint: "Negra", finger: 5, duration: 1},
      %{text: "Fa-Mi", notes: [65, 64], hint: "2 corcheas", fingers: [4, 3], duration: 1},
      %{text: "Re (D4)", note: 62, hint: "Negra", finger: 2, duration: 1},
      %{text: "Do (C4)", note: 60, hint: "Negra", finger: 1, duration: 1},
      %{text: "Do-Re-Mi", notes: [60, 62, 64], hint: "3 notas rápidas", fingers: [1, 2, 3], duration: 1},
      %{text: "Fa (F4)", note: 65, hint: "Negra", finger: 4, duration: 1},
      %{text: "Mi-Fa", notes: [64, 65], hint: "2 corcheas", fingers: [3, 4], duration: 1},
      %{text: "Sol (G4)", note: 67, hint: "Negra", finger: 5, duration: 1},
      %{text: "Fa-Mi-Re", notes: [65, 64, 62], hint: "3 notas", fingers: [4, 3, 2], duration: 1},
      %{text: "Do (C4)", note: 60, hint: "Negra", finger: 1, duration: 1},
      %{text: "Re-Mi-Fa-Sol", notes: [62, 64, 65, 67], hint: "4 semicorcheas", fingers: [2, 3, 4, 5],
        duration: 1},
      %{text: "Sol (G4)", note: 67, hint: "Negra", finger: 5, duration: 1},
      %{text: "Fa (F4)", note: 65, hint: "Negra", finger: 4, duration: 1},
      %{text: "Mi-Re", notes: [64, 62], hint: "2 corcheas", fingers: [3, 2], duration: 1},
      %{text: "Do (C4)", note: 60, hint: "Negra", finger: 1, duration: 1},
      %{text: "Do (C4)", note: 60, hint: "Blanca", finger: 1, duration: 2},
      %{text: "Do (C4)", note: 60, hint: "Blanca", finger: 1, duration: 2},
      %{text: "Do (C4)", note: 60, hint: "Final largo", finger: 1, duration: 4}
    ]
  },
  %{
    id: "14c_ode_to_joy_advanced",
    title: "14C. Oda a la Alegría: Versión Avanzada",
    description: "Versión completa con semicorcheas (36 pasos).",
    intro:
      "Versión completa con semicorcheas y variaciones. La versión más cercana a la partitura original. 36 pasos.",
    metronome: true,
    module_id: "mod_006_repertoire",
    steps: [
      %{text: "Mi (E4)", note: 64, hint: "Dedo 3", finger: 3, duration: 1},
      %{text: "Mi (E4)", note: 64, hint: "Repite", finger: 3, duration: 1},
      %{text: "Fa (F4)", note: 65, hint: "Sube", finger: 4, duration: 0.5},
      %{text: "Sol (G4)", note: 67, hint: "Sube", finger: 5, duration: 0.5},
      %{text: "Sol (G4)", note: 67, hint: "Largo", finger: 5, duration: 1},
      %{text: "Sol (G4)", note: 67, hint: "Repite", finger: 5, duration: 0.5},
      %{text: "Fa (F4)", note: 65, hint: "Baja", finger: 4, duration: 0.5},
      %{text: "Mi (E4)", note: 64, hint: "Baja", finger: 3, duration: 0.5},
      %{text: "Re (D4)", note: 62, hint: "Baja", finger: 2, duration: 0.5},
      %{text: "Do (C4)", note: 60, hint: "Llegada", finger: 1, duration: 1},
      %{text: "Do (C4)", note: 60, hint: "Base", finger: 1, duration: 0.5},
      %{text: "Re (D4)", note: 62, hint: "Paso", finger: 2, duration: 0.5},
      %{text: "Mi (E4)", note: 64, hint: "Sube", finger: 3, duration: 0.5},
      %{text: "Fa (F4)", note: 65, hint: "Sube", finger: 4, duration: 0.5},
      %{text: "Sol (G4)", note: 67, hint: "Pico", finger: 5, duration: 1},
      %{text: "Fa (F4)", note: 65, hint: "Baja", finger: 4, duration: 0.5},
      %{text: "Mi (E4)", note: 64, hint: "Baja", finger: 3, duration: 0.5},
      %{text: "Re (D4)", note: 62, hint: "Baja", finger: 2, duration: 0.5},
      %{text: "Do (C4)", note: 60, hint: "Tónica", finger: 1, duration: 0.5},
      %{text: "Do (C4)", note: 60, hint: "Repite", finger: 1, duration: 1},
      %{text: "Mi (E4)", note: 64, hint: "Salto", finger: 3, duration: 0.5},
      %{text: "Fa (F4)", note: 65, hint: "Paso", finger: 4, duration: 0.5},
      %{text: "Sol (G4)", note: 67, hint: "Salto", finger: 5, duration: 1},
      %{text: "Fa (F4)", note: 65, hint: "Baja", finger: 4, duration: 0.5},
      %{text: "Mi (E4)", note: 64, hint: "Baja", finger: 3, duration: 0.5},
      %{text: "Re (D4)", note: 62, hint: "Baja", finger: 2, duration: 0.5},
      %{text: "Do (C4)", note: 60, hint: "Casa", finger: 1, duration: 0.5},
      %{text: "Do-Re-Mi-Fa", notes: [60, 62, 64, 65], hint: "Escala rápida (4 semicor)",
        fingers: [1, 2, 3, 4], duration: 1},
      %{text: "Sol (G4)", note: 67, hint: "Pico", finger: 5, duration: 1},
      %{text: "Sol (G4)", note: 67, hint: "Sostenido", finger: 5, duration: 1},
      %{text: "Fa-Mi", notes: [65, 64], hint: "2 corcheas", fingers: [4, 3], duration: 1},
      %{text: "Re (D4)", note: 62, hint: "Nota larga", finger: 2, duration: 2},
      %{text: "Do (C4)", note: 60, hint: "Resolución", finger: 1, duration: 2},
      %{text: "Do (C4)", note: 60, hint: "Final", finger: 1, duration: 4}
    ]
  },
  %{
    id: "15_final_performance",
    title: "15. RECITAL: Oda a la Alegría Completa",
    description: "Tu primera pieza completa con acompañamiento.",
    intro:
      "¡EL GRAN FINAL! La versión COMPLETA de Ode to Joy con ambas manos y todo el acompañamiento. 38 pasos de música clásica. ¡Lo lograste!",
    metronome: true,
    module_id: "mod_006_repertoire",
    steps: []
  },
  %{
    id: "23_g_piece",
    title: "23. Pieza en Sol: Minueto (Tema)",
    description: "Aplicando la nueva tonalidad a música clásica.",
    intro:
      "Un fragmento del famoso Minueto en Sol de Bach. Fíjate en el ritmo: TA, TA, TA, TA-AA (Negra, Negra, Negra, Blanca).",
    metronome: true,
    module_id: "mod_006_repertoire",
    steps: []
  }
]

IO.puts("🎵 Inserting #{Enum.count(lessons_module_06)} lessons...")

Enum.each(lessons_module_06, fn lesson ->
  MusicIan.Repo.insert!(MusicIan.Curriculum.Lesson.changeset(%MusicIan.Curriculum.Lesson{}, lesson))
end)

IO.puts("✅ Module 6 lessons inserted!")
IO.puts(String.duplicate("=", 60) <> "\n")
