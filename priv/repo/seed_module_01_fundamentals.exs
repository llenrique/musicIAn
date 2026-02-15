# Seed: Módulo 1 - Fundamentos Musicales (Fundamentals)
# Lecciones: Valores de nota (redonda, blanca, negra, corchea, semicorchea)
# Estas lecciones establecen la base rítmica antes de técnica de mano derecha

alias MusicIan.Repo
alias MusicIan.Curriculum.Lesson
alias MusicIan.Curriculum.LessonMetadata

IO.puts("\n" <> String.duplicate("=", 60))
IO.puts("📚 SEEDING MODULE 1: Fundamentos Musicales")
IO.puts(String.duplicate("=", 60))

lessons_module_01 = [
  %{
    id: "4a_note_values_basics",
    title: "4A. Valores de Nota: Redonda y Blanca",
    description: "Aprendiendo notas largas (4 y 2 tiempos).",
    intro:
      "Cada nota tiene una duración. La redonda (⚫) dura 4 tiempos. La blanca (⚪) dura 2 tiempos. Practica sosteniendo las notas.",
    metronome: true,
    module_id: "mod_001_fundamentals",
    steps: [
      %{text: "Do (C4) - Redonda", note: 60, hint: "Sostén 4 tiempos", finger: 1, duration: 4},
      %{text: "Re (D4) - Blanca", note: 62, hint: "Sostén 2 tiempos", finger: 2, duration: 2},
      %{text: "Mi (E4) - Blanca", note: 64, hint: "Sostén 2 tiempos", finger: 3, duration: 2},
      %{text: "Fa (F4) - Redonda", note: 65, hint: "Sostén 4 tiempos", finger: 4, duration: 4},
      %{text: "Sol (G4) - Blanca", note: 67, hint: "Sostén 2 tiempos", finger: 5, duration: 2},
      %{text: "Fa (F4) - Redonda", note: 65, hint: "Sostén 4 tiempos", finger: 4, duration: 4},
      %{text: "Mi (E4) - Blanca", note: 64, hint: "Sostén 2 tiempos", finger: 3, duration: 2},
      %{text: "Re (D4) - Blanca", note: 62, hint: "Sostén 2 tiempos", finger: 2, duration: 2}
    ]
  },
  %{
    id: "4b_note_values_quarter",
    title: "4B. Valores de Nota: Negra",
    description: "La negra (1 tiempo) es tu base.",
    intro:
      "La negra (♩) dura 1 tiempo. Es la nota más común en la música. La usamos como nuestro 'pulso base'.",
    metronome: true,
    module_id: "mod_001_fundamentals",
    steps: [
      %{text: "Do (C4) - Negra", note: 60, hint: "1 tiempo", finger: 1, duration: 1},
      %{text: "Re (D4) - Negra", note: 62, hint: "1 tiempo", finger: 2, duration: 1},
      %{text: "Mi (E4) - Negra", note: 64, hint: "1 tiempo", finger: 3, duration: 1},
      %{text: "Fa (F4) - Negra", note: 65, hint: "1 tiempo", finger: 4, duration: 1},
      %{text: "Sol (G4) - Negra", note: 67, hint: "1 tiempo", finger: 5, duration: 1},
      %{text: "Fa (F4) - Negra", note: 65, hint: "1 tiempo", finger: 4, duration: 1},
      %{text: "Mi (E4) - Negra", note: 64, hint: "1 tiempo", finger: 3, duration: 1},
      %{text: "Re (D4) - Negra", note: 62, hint: "1 tiempo", finger: 2, duration: 1},
      %{text: "Do (C4) - Negra", note: 60, hint: "1 tiempo", finger: 1, duration: 1},
      %{text: "Do (C4) - Blanca", note: 60, hint: "2 tiempos", finger: 1, duration: 2}
    ]
  },
  %{
    id: "4c_note_values_eighths",
    title: "4C. Valores de Nota: Corcheas",
    description: "Notas rápidas (0.5 tiempos cada una).",
    intro:
      "La corchea (♪) dura 0.5 tiempos. Dos corcheas = una negra. Suena más rápido. ♪♪ = ♩",
    metronome: true,
    module_id: "mod_001_fundamentals",
    steps: [
      %{text: "Do-Re (C4-D4)", notes: [60, 62], hint: "2 corcheas = 1 tiempo", fingers: [1, 2],
        duration: 1},
      %{text: "Mi-Fa (E4-F4)", notes: [64, 65], hint: "2 corcheas = 1 tiempo", fingers: [3, 4],
        duration: 1},
      %{text: "Sol (G4)", note: 67, hint: "1 negra = 1 tiempo", finger: 5, duration: 1},
      %{text: "Fa-Mi-Re-Do (F4-E4-D4-C4)", notes: [65, 64, 62, 60],
        hint: "4 corcheas = 2 tiempos", fingers: [4, 3, 2, 1], duration: 2},
      %{text: "Do (C4)", note: 60, hint: "1 blanca = 2 tiempos", finger: 1, duration: 2},
      %{text: "Re-Mi (D4-E4)", notes: [62, 64], hint: "2 corcheas", fingers: [2, 3], duration: 1},
      %{text: "Fa-Sol (F4-G4)", notes: [65, 67], hint: "2 corcheas", fingers: [4, 5], duration: 1},
      %{text: "Sol (G4)", note: 67, hint: "1 negra", finger: 5, duration: 1},
      %{text: "Fa (F4)", note: 65, hint: "1 negra", finger: 4, duration: 1}
    ]
  },
  %{
    id: "4d_note_values_sixteenths",
    title: "4D. Valores de Nota: Semicorcheas",
    description: "Notas muy rápidas (0.25 tiempos).",
    intro:
      "La semicorchea (𝅘𝅥𝅯) dura 0.25 tiempos. Cuatro semicorcheas = una negra. Muy rápido: 𝅘𝅥𝅯𝅘𝅥𝅯𝅘𝅥𝅯𝅘𝅥𝅯 = ♩",
    metronome: true,
    module_id: "mod_001_fundamentals",
    steps: [
      %{text: "Do-Re-Mi-Fa (C4-D4-E4-F4)", notes: [60, 62, 64, 65],
        hint: "4 semicorcheas = 1 tiempo", fingers: [1, 2, 3, 4], duration: 1},
      %{text: "Sol (G4)", note: 67, hint: "1 negra", finger: 5, duration: 1},
      %{text: "Sol-Fa-Mi-Re (G4-F4-E4-D4)", notes: [67, 65, 64, 62],
        hint: "4 semicorcheas = 1 tiempo", fingers: [5, 4, 3, 2], duration: 1},
      %{text: "Do (C4)", note: 60, hint: "1 negra", finger: 1, duration: 1},
      %{text: "Do-Re-Mi-Fa-Sol-La-Si-Do (C4-D4-E4-F4-G4-A4-B4-C5)", notes: [60, 62, 64, 65, 67, 69, 71, 72],
        hint: "Escala rápida en semicorcheas", fingers: [1, 2, 3, 4, 5, 5, 5, 5], duration: 2},
      %{text: "Do (C4) - Final", note: 60, hint: "1 blanca para descansar", finger: 1, duration: 2}
    ]
  }
]

IO.puts("🎵 Inserting #{Enum.count(lessons_module_01)} lessons...")

Enum.each(lessons_module_01, fn lesson ->
  MusicIan.Repo.insert!(MusicIan.Curriculum.Lesson.changeset(%MusicIan.Curriculum.Lesson{}, lesson))
end)

IO.puts("✅ Module 1 lessons inserted!")
IO.puts(String.duplicate("=", 60) <> "\n")
