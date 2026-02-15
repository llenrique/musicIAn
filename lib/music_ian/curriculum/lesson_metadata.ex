defmodule MusicIan.Curriculum.LessonMetadata do
  @moduledoc """
  Schema for lesson metadata that describes how a lesson should be performed.
  
  Contains information about:
  - Musical context (key, scale, root note)
  - Rhythm and tempo (BPM, time signature, rhythm pattern)
  - Hand position and technique
  - Performance requirements (accuracy, timing tolerance)
  - Learning goals and practice tips
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "lesson_metadata" do
    field :lesson_id, :string
    
    # Musical context
    field :key_signature, :string
    field :scale_type, :string
    field :root_note, :integer
    
    # Rhythm and tempo
    field :tempo_bpm, :integer, default: 120
    field :time_signature_numerator, :integer, default: 4
    field :time_signature_denominator, :integer, default: 4
    field :rhythm_pattern, :string
    
    # Hand position
    field :starting_position, :string
    field :hand_position_description, :string
    field :hand_spans, :string
    
    # Difficulty and focus
    field :technical_focus, :string
    field :difficulty_level, :integer, default: 1
    field :recommended_practice_bpm_range, :string
    
    # Performance requirements
    field :accuracy_required, :float, default: 0.8
    field :timing_tolerance_ms, :integer, default: 150
    field :min_tempo_bpm, :integer
    field :max_tempo_bpm, :integer
    
    # Learning goals (JSON arrays)
    field :learning_objectives, :string
    field :common_mistakes, :string
    field :practice_tips, :string
    
    field :created_at_lesson, :utc_datetime
    field :updated_at_lesson, :utc_datetime
    
    timestamps()
  end

  @doc false
  def changeset(lesson_metadata, attrs) do
    lesson_metadata
    |> cast(attrs, [
      :lesson_id,
      :key_signature,
      :scale_type,
      :root_note,
      :tempo_bpm,
      :time_signature_numerator,
      :time_signature_denominator,
      :rhythm_pattern,
      :starting_position,
      :hand_position_description,
      :hand_spans,
      :technical_focus,
      :difficulty_level,
      :recommended_practice_bpm_range,
      :accuracy_required,
      :timing_tolerance_ms,
      :min_tempo_bpm,
      :max_tempo_bpm,
      :learning_objectives,
      :common_mistakes,
      :practice_tips,
      :created_at_lesson,
      :updated_at_lesson
    ])
    |> validate_required([:lesson_id])
    |> foreign_key_constraint(:lesson_id, name: :lesson_metadata_lesson_id_fkey)
    |> validate_number(:accuracy_required, greater_than_or_equal_to: 0.0, less_than_or_equal_to: 1.0)
    |> validate_number(:difficulty_level, greater_than_or_equal_to: 1, less_than_or_equal_to: 10)
    |> validate_number(:tempo_bpm, greater_than: 0)
    |> validate_number(:timing_tolerance_ms, greater_than_or_equal_to: 0)
  end
end
