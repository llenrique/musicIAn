defmodule MusicIan.Repo.Migrations.AddTemporalFieldsToLessons do
  @moduledoc "Agrega campos temporales (bpm, time_signature, timing_strictness) a lessons."
  use Ecto.Migration

  def change do
    alter table(:lessons) do
      add :bpm, :integer, default: 60
      add :time_signature, :string, default: "4/4"
      add :timing_strictness, :integer, default: 0
    end
  end
end
