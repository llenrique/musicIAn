defmodule MusicIan.Repo.Migrations.CreateLessons do
  use Ecto.Migration

  def change do
    create table(:lessons, primary_key: false) do
      add :id, :string, primary_key: true
      add :title, :string, null: false
      add :description, :text
      add :intro, :text
      add :steps, :jsonb, null: false, default: "[]"
      add :metronome, :boolean, null: false, default: true
      add :order, :integer
      
      timestamps(type: :utc_datetime_usec)
    end

    create index(:lessons, [:order])
  end
end
