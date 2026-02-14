# Script to clear all lesson results
alias MusicIan.Repo
alias MusicIan.Practice.Schema.LessonResult

IO.puts "🗑️ Clearing database..."
Repo.delete_all(LessonResult)
IO.puts "✅ Database cleared!"
