defmodule MusicIan.Repo.Migrations.AddLessonMetadata do
  use Ecto.Migration

  def change do
    # Add metadata JSONB column to lessons table
    alter table(:lessons) do
      add :metadata, :map, default: %{}
    end

    # Create lesson_metadata table for more complex queries if needed later
    create table(:lesson_metadata) do
      add :lesson_id, references(:lessons, type: :string, column: :id), null: false
      
      # Musical context
      add :key_signature, :string, comment: "e.g., 'C Major', 'G Major', 'D minor'"
      add :scale_type, :string, comment: "e.g., 'major', 'minor', 'pentatonic'"
      add :root_note, :integer, comment: "MIDI note number of the root"
      
      # Rhythm and tempo
      add :tempo_bpm, :integer, default: 120, comment: "Beats per minute"
      add :time_signature_numerator, :integer, default: 4, comment: "e.g., 4 in 4/4"
      add :time_signature_denominator, :integer, default: 4, comment: "e.g., 4 in 4/4"
      add :rhythm_pattern, :string, comment: "e.g., 'quarter notes', 'straight eighths', 'swing'"
      
      # Hand position
      add :starting_position, :string, comment: "e.g., 'C4 - Middle C', 'Position 1'"
      add :hand_position_description, :string, comment: "Detailed position info"
      add :hand_spans, :string, comment: "e.g., 'C4-G4' for hand span"
      
      # Difficulty and focus
      add :technical_focus, :string, comment: "What skill is being practiced"
      add :difficulty_level, :integer, default: 1, comment: "1-10 scale"
      add :recommended_practice_bpm_range, :string, comment: "e.g., '60-90'"
      
      # Performance requirements
      add :accuracy_required, :float, default: 0.8, comment: "Min accuracy (0.0-1.0)"
      add :timing_tolerance_ms, :integer, default: 150, comment: "Milliseconds tolerance"
      add :min_tempo_bpm, :integer, comment: "Minimum tempo to pass"
      add :max_tempo_bpm, :integer, comment: "Maximum tempo (for fast pieces)"
      
      # Learning goals
      add :learning_objectives, :string, comment: "JSON array of learning goals"
      add :common_mistakes, :string, comment: "JSON array of common mistakes to avoid"
      add :practice_tips, :string, comment: "JSON array of tips for practice"
      
      # Metadata
      add :created_at_lesson, :utc_datetime
      add :updated_at_lesson, :utc_datetime
      
      timestamps()
    end

    create index(:lesson_metadata, [:lesson_id])
    create unique_index(:lesson_metadata, [:lesson_id], name: :unique_lesson_metadata)
  end
end
