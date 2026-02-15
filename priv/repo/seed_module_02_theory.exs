# Seed: Módulo 2 - Solfeo (Music Theory - Solfège)
# Lecciones: Intervalos, escalas, tonalidades
# PLACEHOLDER: Estas lecciones serán agregadas en futuras versiones

alias MusicIan.Repo
alias MusicIan.Curriculum.Lesson

IO.puts("\n" <> String.duplicate("=", 60))
IO.puts("📚 SEEDING MODULE 2: Solfeo")
IO.puts(String.duplicate("=", 60))

lessons_module_02 = [
  # Placeholder: Aquí se agregarán lecciones de solfeo
  # - Intervalos básicos
  # - Escalas mayores y menores
  # - Tonalidades y armaduras
  # - Solfeo de las notas en pentagrama
]

if Enum.count(lessons_module_02) > 0 do
  IO.puts("🎵 Inserting #{Enum.count(lessons_module_02)} lessons...")

  Enum.each(lessons_module_02, fn lesson ->
    MusicIan.Repo.insert!(MusicIan.Curriculum.Lesson.changeset(%MusicIan.Curriculum.Lesson{}, lesson))
  end)

  IO.puts("✅ Module 2 lessons inserted!")
else
  IO.puts("⏳ Module 2 is empty - ready for future lessons")
  IO.puts("   Próximas lecciones a agregar:")
  IO.puts("   - 25_intervals_basic")
  IO.puts("   - 26_major_scale_theory")
  IO.puts("   - 27_minor_scale_theory")
  IO.puts("   - 28_tonality_c_major")
  IO.puts("   - 29_tonality_g_major")
  IO.puts("   - 30_tonality_f_major")
end

IO.puts(String.duplicate("=", 60) <> "\n")
