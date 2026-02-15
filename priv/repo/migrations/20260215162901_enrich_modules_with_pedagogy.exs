defmodule MusicIan.Repo.Migrations.EnrichModulesWithPedagogy do
  use Ecto.Migration

  def change do
    # Add enriched pedagogical metadata columns to modules table
    alter table(:modules) do
      add :pedagogical_intent, :text, comment: "Detailed explanation of WHY this module and its progression exists"
      add :emotional_goal, :string, comment: "Emotional/psychological state to achieve (e.g., 'confidence', 'orientation')"
      add :duration_progression_rule, :string, comment: "Description of how lesson durations scale within this module"
      add :skill_scope, {:array, :string}, default: [], comment: "Array of skill identifiers being developed"
      add :completion_criteria, :text, comment: "Definition of what successful module completion looks like"
      add :cognitive_load_growth, :string, default: "gradual", comment: "Pattern of cognitive complexity growth: gradual, moderate, steep"
      add :motor_complexity_growth, :string, default: "gradual", comment: "Pattern of motor skill complexity growth"
      add :theory_complexity_growth, :string, default: "gradual", comment: "Pattern of theoretical knowledge growth"
      add :lesson_duration_progression, {:array, :integer}, default: [], comment: "Array of lesson durations in minutes for each lesson in module"
      add :final_student_capabilities, {:array, :string}, default: [], comment: "Array of concrete skills student should achieve"
      add :perceived_confidence_level_target, :string, comment: "Target confidence/psychological state at module end"
    end

    # Add enriched pedagogical metadata columns to lessons table
    alter table(:lessons) do
      add :focus, :string, comment: "Primary skill being developed in this lesson"
      add :new_concepts, {:array, :string}, default: [], comment: "Array of new concepts introduced in this lesson"
      add :confidence_level_target, :string, comment: "Emotional/confidence state to achieve by lesson end"
      add :cognitive_complexity, :string, default: "basic", comment: "Cognitive load level: basic, intermediate, advanced"
      add :motor_complexity, :string, default: "basic", comment: "Motor skill complexity: basic, intermediate, advanced"
      add :duration_minutes, :integer, comment: "Expected lesson duration in minutes"
    end
  end
end
