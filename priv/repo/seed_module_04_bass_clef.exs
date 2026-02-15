# Seed: Módulo 4 - Clave de Fa (Bass Clef - Left Hand)
# Lecciones: Técnica de mano izquierda, acordes, arpegios

alias MusicIan.Repo
alias MusicIan.Curriculum.Lesson

IO.puts("\n" <> String.duplicate("=", 60))
IO.puts("📚 SEEDING MODULE 4: Clave de Fa (Mano Izquierda)")
IO.puts(String.duplicate("=", 60))

lessons_module_04 = [
  %{
    id: "05_lh_five_fingers",
    title: "5. MI: El Espejo",
    description: "Despertando la mano izquierda.",
    intro:
      "Ahora la mano izquierda. Coloca el Meñique (5) en el Do grave (C3) y el Pulgar (1) en el Sol (G3).",
    metronome: true,
    module_id: "mod_004_bass_clef",
    steps: [
      %{text: "Do (C3)", note: 48, hint: "Meñique (5)", finger: 5, duration: 1},
      %{text: "Re (D3)", note: 50, hint: "Anular (4)", finger: 4, duration: 1},
      %{text: "Mi (E3)", note: 52, hint: "Medio (3)", finger: 3, duration: 1},
      %{text: "Fa (F3)", note: 53, hint: "Índice (2)", finger: 2, duration: 1},
      %{text: "Sol (G3)", note: 55, hint: "Pulgar (1)", finger: 1, duration: 1},
      %{text: "Fa (F3)", note: 53, hint: "Bajando...", finger: 2, duration: 1},
      %{text: "Mi (E3)", note: 52, hint: "Bajando...", finger: 3, duration: 1},
      %{text: "Re (D3)", note: 50, hint: "Bajando...", finger: 4, duration: 1},
      %{text: "Do (C3)", note: 48, hint: "Final", finger: 5, duration: 2}
    ]
  },
  %{
    id: "06_lh_skips",
    title: "6. MI: Pasos y Saltos",
    description: "Independencia de dedos en la izquierda.",
    intro:
      "Igual que con la derecha, practicamos saltar notas. Esto fortalece los dedos débiles (4 y 5) de la izquierda.",
    metronome: true,
    module_id: "mod_004_bass_clef",
    steps: [
      %{text: "Do (C3)", note: 48, hint: "Dedo 5", finger: 5, duration: 1},
      %{text: "Mi (E3)", note: 52, hint: "Salto al 3", finger: 3, duration: 1},
      %{text: "Sol (G3)", note: 55, hint: "Salto al 1", finger: 1, duration: 1},
      %{text: "Mi (E3)", note: 52, hint: "Salto al 3", finger: 3, duration: 1},
      %{text: "Do (C3)", note: 48, hint: "Salto al 5", finger: 5, duration: 1},
      %{text: "Re (D3)", note: 50, hint: "Dedo 4", finger: 4, duration: 1},
      %{text: "Fa (F3)", note: 53, hint: "Dedo 2", finger: 2, duration: 1},
      %{text: "Sol (G3)", note: 55, hint: "Dedo 1", finger: 1, duration: 2}
    ]
  },
  %{
    id: "07_lh_bass",
    title: "7. MI: Líneas de Bajo",
    description: "El papel de soporte de la izquierda.",
    intro:
      "La mano izquierda suele tocar las notas fundamentales (Bajos). Practica moverte entre Do (Tónica) y Sol (Dominante).",
    metronome: true,
    module_id: "mod_004_bass_clef",
    steps: [
      %{text: "Do (C3)", note: 48, hint: "Tónica (5)", finger: 5, duration: 1},
      %{text: "Sol (G3)", note: 55, hint: "Dominante (1)", finger: 1, duration: 1},
      %{text: "Sol (G3)", note: 55, hint: "Repite", finger: 1, duration: 1},
      %{text: "Do (C3)", note: 48, hint: "Tónica (5)", finger: 5, duration: 1},
      %{text: "Fa (F3)", note: 53, hint: "Subdominante (2)", finger: 2, duration: 1},
      %{text: "Sol (G3)", note: 55, hint: "Dominante (1)", finger: 1, duration: 1},
      %{text: "Do (C3)", note: 48, hint: "Final", finger: 5, duration: 2}
    ]
  },
  %{
    id: "08_lh_melody",
    title: "8. MI: Melodía en el Bajo",
    description: "La izquierda también puede cantar.",
    intro:
      "A veces la izquierda lleva la melodía (como en el violonchelo). Toca 'Oda a la Alegría' con la izquierda.",
    metronome: true,
    module_id: "mod_004_bass_clef",
    steps: [
      %{text: "Mi (E3)", note: 52, hint: "Dedo 3", finger: 3, duration: 1},
      %{text: "Mi (E3)", note: 52, hint: "Dedo 3", finger: 3, duration: 1},
      %{text: "Fa (F3)", note: 53, hint: "Dedo 2", finger: 2, duration: 1},
      %{text: "Sol (G3)", note: 55, hint: "Dedo 1", finger: 1, duration: 1},
      %{text: "Sol (G3)", note: 55, hint: "Dedo 1", finger: 1, duration: 1},
      %{text: "Fa (F3)", note: 53, hint: "Dedo 2", finger: 2, duration: 1},
      %{text: "Mi (E3)", note: 52, hint: "Dedo 3", finger: 3, duration: 1},
      %{text: "Re (D3)", note: 50, hint: "Dedo 4", finger: 4, duration: 2}
    ]
  },
  %{
    id: "12_triad_c",
    title: "12. Acorde de Do Mayor (Arpegio)",
    description: "Construyendo armonía: Raíz, Tercera, Quinta.",
    intro:
      "Un acorde son 3 o más notas. Vamos a tocar las notas del acorde de Do (C Major) una por una (arpegio).",
    metronome: true,
    module_id: "mod_004_bass_clef",
    steps: [
      %{text: "Raíz: Do (C4)", note: 60, hint: "Dedo 1", finger: 1, duration: 1},
      %{text: "Tercera: Mi (E4)", note: 64, hint: "Dedo 3", finger: 3, duration: 1},
      %{text: "Quinta: Sol (G4)", note: 67, hint: "Dedo 5", finger: 5, duration: 1},
      %{text: "Octava: Do (C5)", note: 72, hint: "Estira el 5", finger: 5, duration: 2}
    ]
  },
  %{
    id: "13_triad_g",
    title: "13. Acorde de Sol Mayor (Dominante)",
    description: "Estirando la mano para el cambio de acorde.",
    intro:
      "Para cambiar de acorde, mantenemos la forma de la mano pero la movemos de posición. Mueve el pulgar al Sol.",
    metronome: true,
    module_id: "mod_004_bass_clef",
    steps: [
      %{text: "Raíz: Sol (G4)", note: 67, hint: "Dedo 1", finger: 1, duration: 1},
      %{text: "Tercera: Si (B4)", note: 71, hint: "Dedo 3", finger: 3, duration: 1},
      %{text: "Quinta: Re (D5)", note: 74, hint: "Dedo 5", finger: 5, duration: 1},
      %{text: "Raíz: Sol (G4)", note: 67, hint: "Vuelve al 1", finger: 1, duration: 2}
    ]
  },
  %{
    id: "14_broken_chords",
    title: "14. Acordes Quebrados (Alberti Bass)",
    description: "Patrones de acompañamiento clásico.",
    intro:
      "El 'Bajo Alberti' es un patrón clásico (Do-Sol-Mi-Sol). Practiquémoslo con la mano izquierda.",
    metronome: true,
    module_id: "mod_004_bass_clef",
    steps: [
      %{text: "Do (C3)", note: 48, hint: "Bajo (5)", finger: 5, duration: 1},
      %{text: "Sol (G3)", note: 55, hint: "Alto (1)", finger: 1, duration: 1},
      %{text: "Mi (E3)", note: 52, hint: "Medio (3)", finger: 3, duration: 1},
      %{text: "Sol (G3)", note: 55, hint: "Alto (1)", finger: 1, duration: 1},
      %{text: "Do (C3)", note: 48, hint: "Repite patrón", finger: 5, duration: 2}
    ]
  },
  %{
    id: "18_lh_finger_over",
    title: "18. MI: El Cruce de Dedo",
    description: "Técnica de mano izquierda para bajar en la escala.",
    intro:
      "En la mano izquierda, el cruce ocurre al bajar. Toca Do-Si-La (1-2-3) y pasa el Pulgar (1) por debajo para Sol? ¡NO! La izquierda cruza el 3 POR ENCIMA del 1.",
    metronome: true,
    module_id: "mod_004_bass_clef",
    steps: []
  },
  %{
    id: "19_lh_c_scale",
    title: "19. MI: Escala de Do Mayor (1 Octava)",
    description: "Dominando la escala con la izquierda.",
    intro: "Escala completa izquierda. Sigue el ritmo constante. Subiendo: 5-4-3-2-1 (cruce 3) 3-2-1.",
    metronome: true,
    module_id: "mod_004_bass_clef",
    steps: []
  }
]

IO.puts("🎵 Inserting #{Enum.count(lessons_module_04)} lessons...")

Enum.each(lessons_module_04, fn lesson ->
  MusicIan.Repo.insert!(MusicIan.Curriculum.Lesson.changeset(%MusicIan.Curriculum.Lesson{}, lesson))
end)

IO.puts("✅ Module 4 lessons inserted!")
IO.puts(String.duplicate("=", 60) <> "\n")
