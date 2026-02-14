defmodule MusicIan.MusicCore.Chord do
  @moduledoc """
  Handles the generation and manipulation of musical chords.
  """

  alias MusicIan.MusicCore.Note

  @type quality ::
          :major
          | :minor
          | :diminished
          | :augmented
          | :sus2
          | :sus4
          | :major7
          | :dominant7
          | :minor7
          | :minor7b5
          | :diminished7

  @type t :: %__MODULE__{
          root: Note.t(),
          quality: quality(),
          notes: [Note.t()],
          inversion: integer()
        }

  defstruct [:root, :quality, :notes, inversion: 0]

  # Intervals in semitones from the root
  @intervals %{
    # Triads
    major: [0, 4, 7],
    minor: [0, 3, 7],
    diminished: [0, 3, 6],
    augmented: [0, 4, 8],
    sus2: [0, 2, 7],
    sus4: [0, 5, 7],
    # Sevenths
    major7: [0, 4, 7, 11],
    dominant7: [0, 4, 7, 10],
    minor7: [0, 3, 7, 10],
    minor7b5: [0, 3, 6, 10],
    diminished7: [0, 3, 6, 9]
  }

  @doc """
  Generates a chord given a root MIDI note and a quality.
  """
  @spec new(integer() | Note.t(), quality()) :: t()
  def new(root_midi, quality) when is_integer(root_midi) do
    root_note = Note.new(root_midi)
    new(root_note, quality)
  end

  def new(%Note{} = root, quality) do
    intervals = Map.get(@intervals, quality, Map.get(@intervals, :major))

    notes =
      intervals
      |> Enum.map(fn interval ->
        Note.new(root.midi + interval)
      end)

    %__MODULE__{
      root: root,
      quality: quality,
      notes: notes,
      inversion: 0
    }
  end

  @doc """
  Inverts a chord.
  0: Root position
  1: First inversion (Root moves up an octave)
  2: Second inversion (Root and 3rd move up an octave)
  ...
  """
  @spec invert(t(), integer()) :: t()
  def invert(%__MODULE__{notes: notes} = chord, inversion) when inversion >= 0 do
    # Calculate effective inversion based on number of notes
    # e.g. 1st inversion of a triad is same as 4th inversion? No, 3rd inversion returns to root position but octave higher?
    # Usually inversion 1 means the lowest note is the 3rd.
    # We will implement it by rotating the notes and adding 12 semitones to the notes that wrap around.

    count = length(notes)
    effective_inv = rem(inversion, count)

    # Split notes into those that stay and those that move up
    {to_move, to_stay} = Enum.split(notes, effective_inv)

    shifted_moved_notes =
      Enum.map(to_move, fn note ->
        Note.new(note.midi + 12)
      end)

    new_notes = to_stay ++ shifted_moved_notes

    %__MODULE__{chord | notes: new_notes, inversion: inversion}
  end

  @doc """
  Detecta qué acorde forman un conjunto de notas MIDI.
  Retorna el acorde más probable basado en los intervalos detectados.

  Ejemplo:
    iex> Chord.from_midi_notes([60, 64, 67])
    %Chord{root: %Note{name: "C", ...}, quality: :major, ...}
  """
  @spec from_midi_notes([integer()]) :: t()
  def from_midi_notes(midi_notes) when is_list(midi_notes) and length(midi_notes) > 0 do
    # Normaliza notas a octava 0 para identificar intervalos
    normalized =
      midi_notes
      |> Enum.map(&rem(&1, 12))
      |> Enum.sort()
      |> Enum.uniq()

    # La nota raíz es la más grave (primer MIDI)
    root_midi = Enum.min(midi_notes)
    root = Note.new(root_midi)

    # Identifica la calidad del acorde basado en los intervalos
    quality = identify_chord_quality(normalized)

    new(root, quality)
  end

  @doc false
  defp identify_chord_quality(normalized_intervals) do
    # Mapea patrones de intervalos a cualidades de acordes
    case normalized_intervals do
      # Triadas
      [0, 4, 7] -> :major
      [0, 3, 7] -> :minor
      [0, 3, 6] -> :diminished
      [0, 4, 8] -> :augmented
      [0, 2, 7] -> :sus2
      [0, 5, 7] -> :sus4
      # Séptimas
      [0, 4, 7, 11] -> :major7
      [0, 4, 7, 10] -> :dominant7
      [0, 3, 7, 10] -> :minor7
      [0, 3, 6, 10] -> :minor7b5
      [0, 3, 6, 9] -> :diminished7
      # Default: major
      _ -> :major
    end
  end
end
