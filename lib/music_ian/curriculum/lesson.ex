defmodule MusicIan.Curriculum.Lesson do
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

    timestamps(type: :utc_datetime_usec)
  end

  def changeset(lesson, attrs) do
    lesson
    |> cast(attrs, [:id, :title, :description, :intro, :steps, :metronome, :order])
    |> validate_required([:id, :title, :steps])
  end
end
