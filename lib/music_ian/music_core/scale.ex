defmodule MusicIan.MusicCore.Scale do
  @moduledoc """
  Handles the generation and manipulation of musical scales.
  """

  alias MusicIan.MusicCore.{Chord, Note}

  @type scale_type ::
          :major
          | :natural_minor
          | :harmonic_minor
          | :melodic_minor
          | :pentatonic_major
          | :pentatonic_minor
          | :blues
          | :dorian
          | :phrygian
          | :lydian
          | :mixolydian
          | :locrian

  @type t :: %__MODULE__{
          root: Note.t(),
          type: scale_type(),
          notes: [Note.t()],
          note_explanations: [map()],
          description: String.t(),
          mood: String.t(),
          suggested_keys: [integer()],
          suggestion_reason: String.t()
        }

  defstruct [
    :root,
    :type,
    :notes,
    :note_explanations,
    :description,
    :mood,
    :suggested_keys,
    :suggestion_reason
  ]

  # Intervals in semitones from the root
  @intervals %{
    major: [0, 2, 4, 5, 7, 9, 11],
    natural_minor: [0, 2, 3, 5, 7, 8, 10],
    harmonic_minor: [0, 2, 3, 5, 7, 8, 11],
    melodic_minor: [0, 2, 3, 5, 7, 9, 11],
    pentatonic_major: [0, 2, 4, 7, 9],
    pentatonic_minor: [0, 3, 5, 7, 10],
    blues: [0, 3, 5, 6, 7, 10],
    # Modes
    dorian: [0, 2, 3, 5, 7, 9, 10],
    phrygian: [0, 1, 3, 5, 7, 8, 10],
    lydian: [0, 2, 4, 6, 7, 9, 11],
    mixolydian: [0, 2, 4, 5, 7, 9, 10],
    locrian: [0, 1, 3, 5, 6, 8, 10]
  }

  @metadata %{
    major: %{
      description: "La escala fundamental de la música occidental. Base de la tonalidad mayor.",
      mood: "Alegre, Brillante, Estable",
      # C, G, F
      suggested_keys: [0, 7, 5],
      suggestion_reason:
        "Son las tonalidades más comunes y fáciles de leer en partitura (pocas alteraciones)."
    },
    natural_minor: %{
      description: "La escala menor estándar (Eólica). Misma armadura que su relativa mayor.",
      mood: "Triste, Serio, Melancólico",
      # A, E, D
      suggested_keys: [9, 4, 2],
      suggestion_reason:
        "Tonalidades menores naturales con pocas alteraciones, muy usadas en pop y baladas."
    },
    harmonic_minor: %{
      description:
        "Variación de la menor con la 7ma elevada para crear un acorde dominante fuerte.",
      mood: "Exótico, Clásico, Tensión dramática",
      # A, E
      suggested_keys: [9, 4],
      suggestion_reason:
        "Comunes en música clásica y guitarra española por la facilidad de digitación."
    },
    melodic_minor: %{
      description: "Suaviza el salto de la armónica elevando también la 6ta al subir.",
      mood: "Jazz, Sofisticado, Fluido",
      # C, G (Jazz standard keys)
      suggested_keys: [0, 7],
      suggestion_reason:
        "Estándares de Jazz (como 'Autumn Leaves') suelen modular a estas tonalidades."
    },
    pentatonic_major: %{
      description: "Escala de 5 notas. Omite los semitonos (4ta y 7ma) para evitar disonancias.",
      mood: "Folk, Simple, Pacífico",
      # C, G, F
      suggested_keys: [0, 7, 5],
      suggestion_reason: "Ideales para melodías vocales sencillas y música folk/country."
    },
    pentatonic_minor: %{
      description: "La base del Rock y el Blues. Omite 2da y 6ta.",
      mood: "Rock, Blues, Potente",
      # E, A, G (Guitar friendly)
      suggested_keys: [4, 9, 7],
      suggestion_reason:
        "Favoritas de los guitarristas por el uso de cuerdas al aire (Mi, La, Sol)."
    },
    blues: %{
      description: "Pentatónica menor con la 'Blue Note' (b5) añadida.",
      mood: "Bluesy, Soulful, Tensión expresiva",
      # E, A, G (Guitar friendly)
      suggested_keys: [4, 9, 7],
      suggestion_reason: "La 'Santísima Trinidad' del Blues en guitarra: Mi, La y Sol."
    },
    dorian: %{
      description: "Modo menor con la 6ta mayor. Característico del Funk y Jazz Modal.",
      mood: "Groovy, Sofisticado, Menor pero brillante",
      # D, A, G (So What, etc)
      suggested_keys: [2, 9, 7],
      suggestion_reason:
        "Clásicos como 'So What' (Miles Davis) o 'Oye Como Va' usan estas tonalidades."
    },
    phrygian: %{
      description: "Modo menor con la 2da menor. Sonido español o metalero.",
      mood: "Oscuro, Flamenco, Tenso",
      # E, B (Flamenco guitar)
      suggested_keys: [4, 11],
      suggestion_reason:
        "La cadencia andaluza y el metal suenan poderosos en Mi (cuerda más grave de guitarra)."
    },
    lydian: %{
      description: "Modo mayor con la 4ta aumentada (#4). Sonido de ensueño.",
      mood: "Mágico, Espacial, Flotante",
      # F, C
      suggested_keys: [5, 0],
      suggestion_reason: "Fa Lidio es natural (todas teclas blancas) y muy brillante."
    },
    mixolydian: %{
      description: "Modo mayor con la 7ma menor (b7). Base del Rock clásico.",
      mood: "Rock, Bluesy, Mayor pero relajado",
      # G, D, A
      suggested_keys: [7, 2, 9],
      suggestion_reason: "El sonido de AC/DC y el Rock clásico. Sol y La son muy potentes."
    },
    locrian: %{
      description: "Modo disminuido. Muy inestable debido a la 5ta disminuida.",
      mood: "Disonante, Inestable, Terror",
      # B
      suggested_keys: [11],
      suggestion_reason: "Si Locrio es el único modo 'natural' (teclas blancas) de este tipo."
    }
  }

  @doc """
  Generates a scale given a root MIDI note and a scale type.
  Automatically determines correct note names (sharps/flats) based on the root note.
  """
  @spec new(integer() | Note.t(), scale_type(), keyword()) :: t()
  def new(root, type, opts \\ [])

  def new(root_midi, type, opts) when is_integer(root_midi) do
    root_note = Note.new(root_midi, opts)
    new(root_note, type, opts)
  end

  def new(%Note{} = root, type, opts) do
    intervals = Map.get(@intervals, type, Map.get(@intervals, :major))

    meta =
      Map.get(@metadata, type, %{
        description: "",
        mood: "",
        suggested_keys: [],
        suggestion_reason: ""
      })

    # Generate notes with proper enharmonic spelling based on scale degree
    notes = generate_scale_notes(root, intervals, type, opts)

    # Generate explanations for each note
    note_explanations = generate_note_explanations(root, intervals, type, notes)

    %__MODULE__{
      root: root,
      type: type,
      notes: notes,
      note_explanations: note_explanations,
      description: meta.description,
      mood: meta.mood,
      suggested_keys: meta.suggested_keys,
      suggestion_reason: meta.suggestion_reason
    }
  end

  @doc false
  defp generate_scale_notes(root, intervals, _scale_type, opts) do
    # Respect explicit use_flats opt; otherwise auto-detect from root
    use_flats =
      case Keyword.fetch(opts, :use_flats) do
        {:ok, val} -> val
        :error -> should_use_flats(root.midi)
      end

    # Map of scale degrees to note names (1-7 corresponding to root, 2nd, 3rd, etc)
    # This ensures proper spelling for each degree
    natural_order = ~w(C D E F G A B)
    root_pitch = rem(root.midi, 12)
    root_index = get_natural_note_index(root_pitch, use_flats)

    intervals
    |> Enum.with_index()
    |> Enum.map(fn {interval, degree} ->
      midi = root.midi + interval
      # Calculate which natural note this should be named
      natural_note_index = rem(root_index + degree, 7)
      natural_note_name = Enum.at(natural_order, natural_note_index)

      # Now determine if it needs an accidental
      note_with_accidental = add_accidental_for_degree(midi, natural_note_name, use_flats)

      # Create note with calculated name
      Note.new(midi, use_flats: false)
      |> Map.put(:name, note_with_accidental)
    end)
  end

  @doc false
  defp should_use_flats(root_midi) do
    pitch_class = rem(root_midi, 12)
    # Flats: Db(1), Eb(3), F(5), Ab(8), Bb(10)
    # Pitch class 6 is ambiguous (F#/Gb) — default to sharps (F# major)
    pitch_class in [1, 3, 5, 8, 10]
  end

  # Natural note index by pitch class.
  # For accidentals (black keys), the index depends on whether we use sharps or flats:
  #   sharps: C#=C(0), D#=D(1), F#=F(3), G#=G(4), A#=A(5)
  #   flats:  Db=D(1), Eb=E(2), Gb=G(4), Ab=A(5), Bb=B(6)
  defp get_natural_note_index(pc, use_flats \\ false)
  # C
  defp get_natural_note_index(0, _), do: 0
  # C#
  defp get_natural_note_index(1, false), do: 0
  # Db
  defp get_natural_note_index(1, true), do: 1
  # D
  defp get_natural_note_index(2, _), do: 1
  # D# (but rarely used)
  defp get_natural_note_index(3, false), do: 2
  # Eb
  defp get_natural_note_index(3, true), do: 2
  # E
  defp get_natural_note_index(4, _), do: 2
  # F
  defp get_natural_note_index(5, _), do: 3
  # F#
  defp get_natural_note_index(6, false), do: 3
  # Gb
  defp get_natural_note_index(6, true), do: 4
  # G
  defp get_natural_note_index(7, _), do: 4
  # G#
  defp get_natural_note_index(8, false), do: 4
  # Ab
  defp get_natural_note_index(8, true), do: 5
  # A
  defp get_natural_note_index(9, _), do: 5
  # A#
  defp get_natural_note_index(10, false), do: 5
  # Bb
  defp get_natural_note_index(10, true), do: 6
  # B
  defp get_natural_note_index(11, _), do: 6
  defp get_natural_note_index(_, _), do: 0

  @doc false
  defp add_accidental_for_degree(midi, natural_note_name, _use_flats) do
    pitch_class = rem(midi, 12)

    # Pitch class of the natural (unaltered) version of the target letter
    natural_pitch = %{
      "C" => 0,
      "D" => 2,
      "E" => 4,
      "F" => 5,
      "G" => 7,
      "A" => 9,
      "B" => 11
    }

    base_pc = Map.get(natural_pitch, natural_note_name, pitch_class)

    # Difference between actual pitch class and natural pitch class (mod 12, range -1..+1)
    diff = Integer.mod(pitch_class - base_pc, 12)
    # Normalize to range -2..2 (double flat/sharp)
    diff =
      cond do
        diff > 6 -> diff - 12
        diff < -6 -> diff + 12
        true -> diff
      end

    case diff do
      0 -> natural_note_name
      1 -> natural_note_name <> "#"
      -1 -> natural_note_name <> "b"
      2 -> natural_note_name <> "##"
      -2 -> natural_note_name <> "bb"
      _ -> natural_note_name
    end
  end

  @doc false
  defp generate_note_explanations(root, intervals, scale_type, notes) do
    root_pitch = rem(root.midi, 12)
    _use_flats = should_use_flats(root.midi)
    _natural_order = ~w(C D E F G A B)
    _root_index = get_natural_note_index(root_pitch)

    intervals
    |> Enum.with_index()
    |> Enum.map(fn {interval, degree} ->
      midi = root.midi + interval
      note = Enum.at(notes, degree)

      # Get the degree name (1st, 2nd, 3rd, etc)
      degree_name = get_degree_name(degree)

      # Get scale degree in terms of intervals
      interval_semitones = interval
      interval_explanation = get_interval_explanation(interval_semitones)

      # Check if this note has an accidental
      has_accidental = String.contains?(note.name, "#") or String.contains?(note.name, "b")

      accidental_reason =
        if has_accidental do
          get_accidental_reason(scale_type, degree)
        else
          ""
        end

      %{
        midi: midi,
        name: note.name,
        degree: degree_name,
        interval: interval_explanation,
        has_accidental: has_accidental,
        accidental_reason: accidental_reason,
        scale_type: scale_type
      }
    end)
  end

  @doc false
  defp get_degree_name(degree) do
    case degree do
      0 -> "Raíz (1ª)"
      1 -> "2ª"
      2 -> "3ª"
      3 -> "4ª"
      4 -> "5ª"
      5 -> "6ª"
      6 -> "7ª"
      _ -> "#{degree + 1}ª"
    end
  end

  defp get_interval_explanation(0), do: "Unísono (0 semitonos)"
  defp get_interval_explanation(2), do: "Tono (2 semitonos) - Intervalo mayor"
  defp get_interval_explanation(3), do: "Tono y medio (3 semitonos) - Intervalo menor"
  defp get_interval_explanation(4), do: "Dos tonos (4 semitonos) - Tercera mayor"
  defp get_interval_explanation(5), do: "Dos tonos y medio (5 semitonos) - Cuarta perfecta"
  defp get_interval_explanation(6), do: "Tres tonos (6 semitonos) - Tritono"
  defp get_interval_explanation(7), do: "Tres tonos y medio (7 semitonos) - Quinta perfecta"
  defp get_interval_explanation(9), do: "Cuatro tonos y medio (9 semitonos) - Sexta mayor"
  defp get_interval_explanation(10), do: "Cinco tonos (10 semitonos) - Sexta menor"
  defp get_interval_explanation(11), do: "Cinco tonos y medio (11 semitonos) - Séptima mayor"
  defp get_interval_explanation(n), do: "#{n} semitonos"

  defp get_accidental_reason(:major, 3),
    do: "4ª: Elevada para crear intervalo de Tritono en Lidio"

  defp get_accidental_reason(:major, _), do: "Alterada según la tonalidad"
  defp get_accidental_reason(:natural_minor, 2), do: "3ª menor: Característica de la escala menor"
  defp get_accidental_reason(:natural_minor, 5), do: "6ª menor: Característica de la escala menor"
  defp get_accidental_reason(:natural_minor, 6), do: "7ª menor: Característica de la escala menor"

  defp get_accidental_reason(:harmonic_minor, 6),
    do: "7ª mayor: Elevada para crear el acorde dominante en menor"

  defp get_accidental_reason(:melodic_minor, 5),
    do: "6ª mayor: Elevada al subir para suavizar la conducción de voces"

  defp get_accidental_reason(:melodic_minor, 6),
    do: "7ª mayor: Elevada al subir para suavizar la conducción de voces"

  defp get_accidental_reason(:dorian, 5), do: "6ª mayor: Define el modo Dorio (menor con 6ª alta)"

  defp get_accidental_reason(:phrygian, 1),
    do: "2ª menor: Define el modo Frigio (sonido oscuro español)"

  defp get_accidental_reason(:lydian, 3), do: "4ª aumentada: Característica del modo Lidio"

  defp get_accidental_reason(:mixolydian, 6),
    do: "7ª menor: Define el modo Mixolidio (mayor con 7ª baja)"

  defp get_accidental_reason(:locrian, 1), do: "2ª menor: Característica del modo Locrio"

  defp get_accidental_reason(:locrian, 4),
    do: "5ª disminuida: Define el modo Locrio (muy inestable)"

  defp get_accidental_reason(:pentatonic_major, _),
    do: "Escala pentatónica: Omite semitonos para evitar disonancias"

  defp get_accidental_reason(:pentatonic_minor, _),
    do: "Escala pentatónica: La base del Blues y Rock"

  defp get_accidental_reason(:blues, 3), do: "b5 (Blue Note): La 'nota de paso' del Blues"
  defp get_accidental_reason(:blues, _), do: "Nota de la escala pentatónica"
  defp get_accidental_reason(_, _), do: "Alterada según la tonalidad"

  @doc """
  Returns the list of supported scale types.
  """
  def types, do: Map.keys(@intervals)

  @doc """
  Generates diatonic triads for the scale.
  Stacks thirds (every other note) for each degree of the scale.
  """
  @spec diatonic_triads(t()) :: [Chord.t()]
  def diatonic_triads(%__MODULE__{notes: notes} = _scale) do
    extended_notes = extend_notes(notes)

    0..(length(notes) - 1)
    |> Enum.map(fn i ->
      root = Enum.at(extended_notes, i)
      third = Enum.at(extended_notes, i + 2)
      fifth = Enum.at(extended_notes, i + 4)

      chord_notes = [root, third, fifth]
      quality = identify_triad_quality(chord_notes)

      %Chord{
        root: root,
        quality: quality,
        notes: chord_notes,
        inversion: 0
      }
    end)
  end

  @doc """
  Generates diatonic seventh chords for the scale.
  Stacks thirds (root, 3rd, 5th, 7th) for each degree.
  """
  @spec diatonic_sevenths(t()) :: [Chord.t()]
  def diatonic_sevenths(%__MODULE__{notes: notes} = _scale) do
    extended_notes = extend_notes(notes)

    0..(length(notes) - 1)
    |> Enum.map(fn i ->
      root = Enum.at(extended_notes, i)
      third = Enum.at(extended_notes, i + 2)
      fifth = Enum.at(extended_notes, i + 4)
      seventh = Enum.at(extended_notes, i + 6)

      chord_notes = [root, third, fifth, seventh]
      quality = identify_seventh_quality(chord_notes)

      %Chord{
        root: root,
        quality: quality,
        notes: chord_notes,
        inversion: 0
      }
    end)
  end

  defp extend_notes(notes) do
    # Extend enough to cover 7th chords (need up to index + 6)
    # Doubling the scale is usually enough for heptatonic (7 notes -> 14 notes)
    # When extending, we should respect the original note's flat/sharp preference
    # But Note.new creates a new note from MIDI, so we might lose the preference if not careful.
    # However, for extension we just need MIDI values usually, but here we return Note structs.
    # A simple way is to just add 12 to midi and recreate.
    # Ideally we should copy the name logic or pass options.
    # For now, let's assume standard sharp naming for extensions unless we pass opts,
    # but diatonic_triads doesn't take opts.
    # Let's just use Note.new(midi) which defaults to sharp.
    # This might cause inconsistency in naming (e.g. Ab scale having G# in upper octave).
    # Mejora futura: almacenar la preferencia (sharps/flats) en el struct Scale para pasarla aquí.

    notes ++ Enum.map(notes, fn n -> Note.new(n.midi + 12) end)
  end

  defp identify_triad_quality([root, third, fifth]) do
    i1 = third.midi - root.midi
    i2 = fifth.midi - root.midi

    case {i1, i2} do
      {4, 7} -> :major
      {3, 7} -> :minor
      {3, 6} -> :diminished
      {4, 8} -> :augmented
      _ -> :unknown
    end
  end

  defp identify_seventh_quality([root, third, fifth, seventh]) do
    i1 = third.midi - root.midi
    i2 = fifth.midi - root.midi
    i3 = seventh.midi - root.midi

    case {i1, i2, i3} do
      {4, 7, 11} -> :major7
      {4, 7, 10} -> :dominant7
      {3, 7, 10} -> :minor7
      {3, 6, 10} -> :minor7b5
      {3, 6, 9} -> :diminished7
      # Rare but possible in melodic minor
      {3, 7, 11} -> :minor_major7
      _ -> :unknown
    end
  end
end
