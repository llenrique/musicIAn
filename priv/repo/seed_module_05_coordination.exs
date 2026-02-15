# Seed: Módulo 5 - Coordinación de Manos (Hand Coordination)
# Lecciones: Alternancia, movimiento contrario, movimiento paralelo, escalas en diferentes posiciones

alias MusicIan.Repo
alias MusicIan.Curriculum.Lesson

IO.puts("\n" <> String.duplicate("=", 60))
IO.puts("📚 SEEDING MODULE 5: Coordinación de Manos")
IO.puts(String.duplicate("=", 60))

lessons_module_05 = [
  %{
    id: "09_ht_alternating",
    title: "9. Coordinación: Pregunta y Respuesta",
    description: "Alternando manos sin superponerlas.",
    intro:
      "Antes de tocar juntos, aprendamos a pasarnos la pelota. Mano Izquierda pregunta, Mano Derecha responde.",
    metronome: true,
    module_id: "mod_005_coordination",
    steps: [
      %{text: "Do (C3) - Izq", note: 48, hint: "Pregunta (5)", finger: 5, duration: 1},
      %{text: "Mi (E3) - Izq", note: 52, hint: "Pregunta (3)", finger: 3, duration: 1},
      %{text: "Sol (G3) - Izq", note: 55, hint: "Pregunta (1)", finger: 1, duration: 1},
      %{text: "Do (C4) - Der", note: 60, hint: "Respuesta (1)", finger: 1, duration: 1},
      %{text: "Mi (E4) - Der", note: 64, hint: "Respuesta (3)", finger: 3, duration: 1},
      %{text: "Sol (G4) - Der", note: 67, hint: "Respuesta (5)", finger: 5, duration: 2}
    ]
  },
  %{
    id: "10_ht_contrary",
    title: "10. Coordinación: Movimiento Contrario",
    description: "Espejo: Separarse y juntarse.",
    intro:
      "Tocar con dos manos es más fácil si se mueven en espejo (alejándose del centro). Ambos pulgares empiezan en Do.",
    metronome: true,
    module_id: "mod_005_coordination",
    steps: [
      %{text: "Centro: Do (C4)", notes: [60], hint: "Pulgares Juntos", finger: 1, duration: 1},
      %{text: "Re (D4) / Si (B3)", notes: [62, 59], hint: "Índices (2)", finger: 2, duration: 1},
      %{text: "Mi (E4) / La (A3)", notes: [64, 57], hint: "Medios (3)", finger: 3, duration: 1},
      %{text: "Fa (F4) / Sol (G3)", notes: [65, 55], hint: "Anulares (4)", finger: 4, duration: 1},
      %{text: "Sol (G4) / Fa (F3)", notes: [67, 53], hint: "Meñiques (5)", finger: 5, duration: 2}
    ]
  },
  %{
    id: "11_ht_parallel",
    title: "11. Coordinación: Movimiento Paralelo",
    description: "El reto: Ambas manos en la misma dirección.",
    intro:
      "El gran desafío: Ambas manos suben. La derecha usa dedos 1-2-3-4-5, pero la izquierda usa 5-4-3-2-1. ¡Concéntrate!",
    metronome: true,
    module_id: "mod_005_coordination",
    steps: [
      %{text: "Do (C3 + C4)", notes: [60, 48], hint: "Der: 1 / Izq: 5", finger: 1, duration: 1},
      %{text: "Re (D3 + D4)", notes: [62, 50], hint: "Der: 2 / Izq: 4", finger: 2, duration: 1},
      %{text: "Mi (E3 + E4)", notes: [64, 52], hint: "Der: 3 / Izq: 3", finger: 3, duration: 1},
      %{text: "Fa (F3 + F4)", notes: [65, 53], hint: "Der: 4 / Izq: 2", finger: 4, duration: 1},
      %{text: "Sol (G3 + G4)", notes: [67, 55], hint: "Der: 5 / Izq: 1", finger: 5, duration: 2}
    ]
  },
  %{
    id: "21_f_sharp",
    title: "21. La Tecla Negra: Fa Sostenido (F#)",
    description: "Introduciendo las alteraciones (teclas negras).",
    intro:
      "En Sol Mayor, todos los Fa son Sostenidos (Tecla Negra). Está justo a la derecha del Fa natural. Tócalo con el anular (4) si estás en posición Re, o ajusta.",
    metronome: true,
    module_id: "mod_005_coordination",
    steps: []
  },
  %{
    id: "22_g_scale",
    title: "22. Escala de Sol Mayor",
    description: "Escala con una alteración fija.",
    intro: "La escala completa de Sol tiene un Fa#. Recuerda: G A B C D E F# G.",
    metronome: true,
    module_id: "mod_005_coordination",
    steps: []
  }
]

IO.puts("🎵 Inserting #{Enum.count(lessons_module_05)} lessons...")

Enum.each(lessons_module_05, fn lesson ->
  MusicIan.Repo.insert!(MusicIan.Curriculum.Lesson.changeset(%MusicIan.Curriculum.Lesson{}, lesson))
end)

IO.puts("✅ Module 5 lessons inserted!")
IO.puts(String.duplicate("=", 60) <> "\n")
