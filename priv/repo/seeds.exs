# Main seed script - Orchestrator
# Este archivo coordina la carga de módulos y lecciones de forma ordenada
# Permite agregar lecciones a módulos específicos de forma independiente

alias MusicIan.Repo
alias MusicIan.Curriculum.Lesson
alias MusicIan.Curriculum.LessonMetadata
alias MusicIan.Curriculum.Module

IO.puts("\n" <> String.duplicate("=", 70))
IO.puts("🌱 MUSICÍAN - SEED DATABASE")
IO.puts(String.duplicate("=", 70))

IO.puts("🗑️ Clearing database...")
Repo.delete_all(LessonMetadata)
Repo.delete_all(Lesson)
Repo.delete_all(Module)
IO.puts("✅ Database cleared!\n")

# Load modules and lesson-to-module mapping
IO.puts("📚 Loading modules...")
_lesson_to_module_mapping = Code.eval_file("priv/repo/seed_modules_data.exs") |> elem(0)
IO.puts("✅ Modules loaded!\n")

# Load lessons from individual module seed files
# They are loaded in order, so prerequisites are met sequentially
# New baby-steps curriculum for absolute beginners

Code.eval_file("priv/repo/seed_module_01_piano_fundamentals.exs")
Code.eval_file("priv/repo/seed_module_02_first_octave.exs")
Code.eval_file("priv/repo/seed_module_03_note_duration.exs")
Code.eval_file("priv/repo/seed_module_04_rhythm_tempo.exs")
Code.eval_file("priv/repo/seed_module_05_solfege.exs")

# Insert lesson metadata (temporarily disabled - old data references old lessons)
IO.puts("🎼 Skipping old lesson metadata (pending update for new curriculum)...")

IO.puts("\n")

# Final summary
IO.puts(String.duplicate("=", 70))
IO.puts("✨ DATABASE SEEDING COMPLETE ✨")
IO.puts(String.duplicate("=", 70))

# Count totals
total_modules = Repo.aggregate(Module, :count)
total_lessons = Repo.aggregate(Lesson, :count)
total_metadata = Repo.aggregate(LessonMetadata, :count)

IO.puts("\n📊 Summary:")
IO.puts("   • Modules: #{total_modules}")
IO.puts("   • Lessons: #{total_lessons}")
IO.puts("   • Metadata: #{total_metadata}")
IO.puts("\n")
