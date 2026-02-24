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
          | :unknown

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
    # Inversion 1: lowest note is the 3rd. Notes that wrap around get +12 semitones.
    # We rotate the notes array and adjust octaves accordingly.

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
  Prueba todas las rotaciones de pitch classes para encontrar el acorde correcto,
  incluyendo inversiones. Si no hay coincidencia, devuelve quality: :unknown.

  ## Ejemplo

      iex> Chord.from_midi_notes([60, 64, 67])
      %Chord{root: %Note{name: "C"}, quality: :major, inversion: 0}

      iex> Chord.from_midi_notes([64, 67, 72])   # C Mayor primera inversión
      %Chord{root: %Note{name: "C"}, quality: :major, inversion: 1}
  """
  @spec from_midi_notes([integer()]) :: t()
  def from_midi_notes([_ | _] = midi_notes) do
    pitch_classes =
      midi_notes
      |> Enum.map(&rem(&1, 12))
      |> Enum.sort()
      |> Enum.uniq()

    case find_chord_root_and_quality(pitch_classes) do
      {root_pc, quality} ->
        root_midi = find_root_midi(midi_notes, root_pc)
        inv = compute_inversion(Enum.sort(midi_notes), root_pc)
        chord = new(Note.new(root_midi), quality)
        %{chord | inversion: inv}

      nil ->
        root_midi = Enum.min(midi_notes)

        %__MODULE__{
          root: Note.new(root_midi),
          quality: :unknown,
          notes: midi_notes |> Enum.sort() |> Enum.map(&Note.new/1),
          inversion: 0
        }
    end
  end

  # Prueba cada pitch class como raíz potencial y verifica si los intervalos coinciden
  defp find_chord_root_and_quality(pitch_classes) do
    Enum.find_value(pitch_classes, fn potential_root ->
      intervals =
        pitch_classes
        |> Enum.map(&rem(&1 - potential_root + 12, 12))
        |> Enum.sort()

      case identify_chord_quality(intervals) do
        :unknown -> nil
        quality -> {potential_root, quality}
      end
    end)
  end

  # Encuentra el MIDI más grave con el pitch class del acorde detectado
  defp find_root_midi(midi_notes, root_pc) do
    midi_notes
    |> Enum.filter(&(rem(&1, 12) == root_pc))
    |> Enum.min()
  end

  # Calcula la inversión: cuántas notas del acorde suenan antes de la raíz (en orden)
  defp compute_inversion(sorted_midi_notes, root_pc) do
    Enum.find_index(sorted_midi_notes, &(rem(&1, 12) == root_pc)) || 0
  end

  # Tríadas
  defp identify_chord_quality([0, 4, 7]), do: :major
  defp identify_chord_quality([0, 3, 7]), do: :minor
  defp identify_chord_quality([0, 3, 6]), do: :diminished
  defp identify_chord_quality([0, 4, 8]), do: :augmented
  defp identify_chord_quality([0, 2, 7]), do: :sus2
  defp identify_chord_quality([0, 5, 7]), do: :sus4
  # Séptimas
  defp identify_chord_quality([0, 4, 7, 11]), do: :major7
  defp identify_chord_quality([0, 4, 7, 10]), do: :dominant7
  defp identify_chord_quality([0, 3, 7, 10]), do: :minor7
  defp identify_chord_quality([0, 3, 6, 10]), do: :minor7b5
  defp identify_chord_quality([0, 3, 6, 9]), do: :diminished7
  defp identify_chord_quality(_), do: :unknown
end
