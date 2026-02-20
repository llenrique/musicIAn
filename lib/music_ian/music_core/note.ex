defmodule MusicIan.MusicCore.Note do
  @moduledoc """
  Represents a musical note and provides basic operations.
  """

  @type t :: %__MODULE__{
          midi: integer(),
          name: String.t(),
          octave: integer(),
          frequency: float()
        }

  defstruct [:midi, :name, :octave, :frequency]

  @notes_sharp ~w(C C# D D# E F F# G G# A A# B)
  @notes_flat ~w(C Db D Eb E F Gb G Ab A Bb B)

  @doc """
  Creates a new Note struct from a MIDI number.
  Options:
    - use_flats: boolean (default false)
  """
  @spec new(integer(), keyword()) :: t()
  def new(midi, opts \\ []) when is_integer(midi) and midi >= 0 and midi <= 127 do
    use_flats = Keyword.get(opts, :use_flats, false)

    %__MODULE__{
      midi: midi,
      name: name_from_midi(midi, use_flats),
      octave: octave_from_midi(midi),
      frequency: frequency(midi)
    }
  end

  @doc """
  Calculates frequency from MIDI number.
  Formula: f = 440 * 2^((d - 69) / 12)
  """
  @spec frequency(integer()) :: float()
  def frequency(midi) do
    440.0 * :math.pow(2, (midi - 69) / 12)
  end

  defp name_from_midi(midi, use_flats) do
    notes = if use_flats, do: @notes_flat, else: @notes_sharp
    Enum.at(notes, rem(midi, 12))
  end

  defp octave_from_midi(midi) do
    div(midi, 12) - 1
  end
end
