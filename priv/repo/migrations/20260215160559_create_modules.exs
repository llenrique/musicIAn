defmodule MusicIan.Repo.Migrations.CreateModules do
  use Ecto.Migration

  def change do
    # Create modules table
    create table(:modules, primary_key: false) do
      add :id, :string, primary_key: true
      add :title, :string, null: false
      add :description, :text
      add :order, :integer, null: false

      add :category, :string,
        comment: "Type of module: fundamentals, theory, technique, repertoire"

      add :learning_objectives, :map, default: %{}, comment: "JSON map of learning goals"
      add :icon, :string, comment: "Icon identifier for UI display"

      timestamps(type: :utc_datetime_usec)
    end

    create index(:modules, [:order])

    # Add module_id foreign key to lessons table (nullable initially for migration)
    alter table(:lessons) do
      add :module_id, references(:modules, type: :string, column: :id)
    end

    create index(:lessons, [:module_id])
  end
end
