defmodule MusicIan.Curriculum.Module do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}
  @foreign_key_type :string
  
  schema "modules" do
    field :title, :string
    field :description, :string
    field :order, :integer
    field :category, :string
    field :learning_objectives, :map, default: %{}
    field :icon, :string
    
    # Enriched pedagogical metadata
    field :pedagogical_intent, :string
    field :emotional_goal, :string
    field :duration_progression_rule, :string
    field :skill_scope, {:array, :string}, default: []
    field :completion_criteria, :string
    field :cognitive_load_growth, :string, default: "gradual"
    field :motor_complexity_growth, :string, default: "gradual"
    field :theory_complexity_growth, :string, default: "gradual"
    field :lesson_duration_progression, {:array, :integer}, default: []
    field :final_student_capabilities, {:array, :string}, default: []
    field :perceived_confidence_level_target, :string

    has_many :lessons, MusicIan.Curriculum.Lesson, foreign_key: :module_id

    timestamps(type: :utc_datetime_usec)
  end

  def changeset(module, attrs) do
    module
    |> cast(attrs, [
      :id, :title, :description, :order, :category, :learning_objectives, :icon,
      :pedagogical_intent, :emotional_goal, :duration_progression_rule, :skill_scope,
      :completion_criteria, :cognitive_load_growth, :motor_complexity_growth,
      :theory_complexity_growth, :lesson_duration_progression, :final_student_capabilities,
      :perceived_confidence_level_target
    ])
    |> validate_required([:id, :title, :order])
    |> unique_constraint(:id, name: :modules_pkey)
  end
end
