defmodule MusicIan.MusicCore do
  @moduledoc """
  The MusicCore context.
  Contains pure music theory logic, independent of database or web layer.
  """

  alias MusicIan.MusicCore.{Note, Scale, Chord}

  @doc """
  Converts a MIDI note number to frequency (Hz).
  """
  @spec frequency_from_midi(integer()) :: float()
  def frequency_from_midi(midi_number) do
    Note.frequency(midi_number)
  end

  @doc """
  Generates a scale.
  """
  @spec get_scale(integer() | Note.t(), Scale.scale_type(), keyword()) :: Scale.t()
  def get_scale(root, type, opts \\ []) do
    Scale.new(root, type, opts)
  end

  @doc """
  Generates a chord.
  """
  @spec get_chord(integer() | Note.t(), Chord.quality()) :: Chord.t()
  def get_chord(root, quality) do
    Chord.new(root, quality)
  end
end
