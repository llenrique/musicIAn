defmodule MusicIan.Repo.Migrations.AddLoopToLessons do
  @moduledoc """
  Adds loop field to lessons table.

  loop = true: repetitive practice (scales, solfege, arpeggios, ear training)
  loop = false: single-pass (melodies, songs, theory explanations, evaluations)
  """

  use Ecto.Migration

  def change do
    alter table(:lessons) do
      add :loop, :boolean, default: false, null: false
    end
  end
end
