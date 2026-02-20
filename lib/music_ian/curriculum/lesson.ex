defmodule MusicIan.Curriculum.Lesson do
  @moduledoc "Ecto schema for a lesson belonging to a curriculum module."

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}
  @foreign_key_type :string

  schema "lessons" do
    field :title, :string
    field :description, :string
    field :intro, :string
    field :steps, {:array, :map}
    field :metronome, :boolean, default: true
    field :order, :integer
    field :bpm, :integer, default: 60
    field :time_signature, :string, default: "4/4"
    field :timing_strictness, :integer, default: 0

    # Enriched pedagogical metadata
    field :focus, :string
    field :new_concepts, {:array, :string}, default: []
    field :confidence_level_target, :string
    field :cognitive_complexity, :string, default: "basic"
    field :motor_complexity, :string, default: "basic"
    field :duration_minutes, :integer

    belongs_to :module, MusicIan.Curriculum.Module, foreign_key: :module_id, type: :string

    timestamps(type: :utc_datetime_usec)
  end

  def changeset(lesson, attrs) do
    lesson
    |> cast(attrs, [
      :id,
      :title,
      :description,
      :intro,
      :steps,
      :metronome,
      :order,
      :module_id,
      :bpm,
      :time_signature,
      :timing_strictness,
      :focus,
      :new_concepts,
      :confidence_level_target,
      :cognitive_complexity,
      :motor_complexity,
      :duration_minutes
    ])
    |> validate_required([:id, :title, :steps, :module_id])
  end
end
