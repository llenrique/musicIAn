defmodule MusicIan.MCPClientHelper do
  @moduledoc """
  Helper module for TheoryLive to interact with MCP-exposed functions
  via the WebSocket API (MusicApiChannel).

  These functions mirror what musicIAn-mcp exposes but use local channel calls
  for server-side integration in LiveView.

  Usage:
    MCPClientHelper.chord_from_midi_notes([60, 64, 67])
    MCPClientHelper.scale_notes(60, :major)
  """

  alias MusicIan.MusicCore.{Note, Scale, Chord}

  @doc """
  Detect chord from a list of MIDI note numbers.

  Returns: %{name: string, notes: list, description: string}
  """
  def chord_from_midi_notes(midi_notes) when is_list(midi_notes) do
    midi_notes
    |> Enum.map(&Note.new/1)
    |> Chord.from_midi_notes()
    |> case do
      {:ok, chord} ->
        {:ok,
         %{
           name: chord.name,
           notes: Enum.map(chord.notes, &%{midi: &1.midi, name: &1.name}),
           description: Map.get(chord, :description, ""),
           inversion: Map.get(chord, :inversion, 0)
         }}

      error ->
        error
    end
  rescue
    _e -> {:error, "Could not detect chord"}
  end

  @doc """
  Get scale notes for a given root and scale type.

  Returns: %{
    notes: [int],
    names: [string],
    description: string,
    mood: string
  }
  """
  def scale_notes(root_midi, scale_type) do
    scale = Scale.new(root_midi, scale_type)

    {:ok,
     %{
       notes: Enum.map(scale.notes, & &1.midi),
       names: Enum.map(scale.notes, & &1.name),
       description: scale.description,
       mood: scale.mood,
       scale_type: Atom.to_string(scale_type)
     }}
  rescue
    _e -> {:error, "Could not create scale"}
  end

  @doc """
  Get all modes for a given root note.

  Returns: %{ionian: [...], dorian: [...], ...}
  """
  def scale_modes(root_midi) do
    mode_types = [
      :major,
      :minor_natural,
      :minor_harmonic,
      :minor_melodic,
      :dorian,
      :phrygian,
      :lydian,
      :mixolydian,
      :locrian
    ]

    modes =
      Enum.reduce(mode_types, %{}, fn mode_type, acc ->
        case scale_notes(root_midi, mode_type) do
          {:ok, scale_info} -> Map.put(acc, mode_type, scale_info.notes)
          _error -> acc
        end
      end)

    {:ok, modes}
  rescue
    _e -> {:error, "Could not generate modes"}
  end

  @doc """
  Validate if a list of MIDI notes belong to a scale.

  Returns: %{
    contained: bool,
    in_scale: [int],
    out_of_scale: [int],
    coverage: float
  }
  """
  def validate_scale_membership(note_midis, scale_type, root_midi) do
    scale = Scale.new(root_midi, scale_type)
    scale_midi_notes = Enum.map(scale.notes, & &1.midi)

    in_scale = Enum.filter(note_midis, &Enum.member?(scale_midi_notes, &1))
    out_of_scale = Enum.filter(note_midis, &(!Enum.member?(scale_midi_notes, &1)))

    coverage =
      if Enum.empty?(note_midis) do
        0.0
      else
        Enum.count(in_scale) / Enum.count(note_midis)
      end

    {:ok,
     %{
       contained: Enum.empty?(out_of_scale),
       in_scale: in_scale,
       out_of_scale: out_of_scale,
       coverage: coverage
     }}
  rescue
    _e -> {:error, "Could not validate scale membership"}
  end

  @doc """
  Get note frequency from MIDI number.

  Returns: %{name: string, octave: int, frequency: float, midi: int}
  """
  def note_frequency(midi) do
    note = Note.new(midi)

    {:ok,
     %{
       name: note.name,
       octave: note.octave,
       frequency: note.frequency,
       midi: note.midi
     }}
  rescue
    _e -> {:error, "Could not get note frequency"}
  end

  @doc """
  Get key signature information for a chord or set of notes.
  """
  def theory_key_signature(midi_notes) do
    # Count occurrences of each pitch class to infer key
    pitch_classes = Enum.map(midi_notes, &rem(&1, 12))

    # This is a simplified version - in reality you'd use scale detection
    major_scale_root = List.first(pitch_classes) || 0

    {:ok,
     %{
       root_midi: major_scale_root,
       scale_type: "major",
       confidence: 0.5
     }}
  rescue
    _e -> {:error, "Could not detect key signature"}
  end
end
