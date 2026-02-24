defmodule MusicIan.MusicCore.Theory do
  @moduledoc """
  Pure domain logic for Music Theory analysis.
  Handles key signatures, accidentals, and contextual analysis of scales/modes.
  Independent of UI or Education logic.
  """

  alias MusicIan.MusicCore.{Note, Scale}

  # ============================================================================
  # MODAL SYSTEM
  # Los 7 modos se derivan de tocar la escala mayor desde diferentes grados.
  # El patrón interválico es fijo para cada modo.
  # ============================================================================

  @modal_info %{
    # Jónico (I) = Escala Mayor Natural
    major: %{
      spanish_name: "Jónico",
      degree: 1,
      degree_roman: "I",
      pattern: "T-T-S-T-T-T-S",
      pattern_list: [:t, :t, :s, :t, :t, :t, :s],
      type: :major,
      brightness: 2,
      characteristic_note: nil,
      characteristic_desc: "Referencia estándar de la escala mayor",
      parent_offset: 0
    },
    # Dórico (II) - Menor con 6ª mayor
    dorian: %{
      spanish_name: "Dórico",
      degree: 2,
      degree_roman: "II",
      pattern: "T-S-T-T-T-S-T",
      pattern_list: [:t, :s, :t, :t, :t, :s, :t],
      type: :minor,
      brightness: 4,
      characteristic_note: "6ª mayor",
      characteristic_desc: "La 6ª mayor le da un brillo especial al modo menor",
      parent_offset: -2
    },
    # Frigio (III) - Menor con 2ª menor
    phrygian: %{
      spanish_name: "Frigio",
      degree: 3,
      degree_roman: "III",
      pattern: "S-T-T-T-S-T-T",
      pattern_list: [:s, :t, :t, :t, :s, :t, :t],
      type: :minor,
      brightness: 6,
      characteristic_note: "2ª menor",
      characteristic_desc: "La 2ª menor crea el sonido flamenco/español",
      parent_offset: -4
    },
    # Lidio (IV) - Mayor con 4ª aumentada
    lydian: %{
      spanish_name: "Lidio",
      degree: 4,
      degree_roman: "IV",
      pattern: "T-T-T-S-T-T-S",
      pattern_list: [:t, :t, :t, :s, :t, :t, :s],
      type: :major,
      brightness: 1,
      characteristic_note: "4ª aumentada",
      characteristic_desc: "La #4 crea el sonido más brillante y etéreo",
      parent_offset: -5
    },
    # Mixolidio (V) - Mayor con 7ª menor
    mixolydian: %{
      spanish_name: "Mixolidio",
      degree: 5,
      degree_roman: "V",
      pattern: "T-T-S-T-T-S-T",
      pattern_list: [:t, :t, :s, :t, :t, :s, :t],
      type: :major,
      brightness: 3,
      characteristic_note: "7ª menor",
      characteristic_desc: "La b7 elimina la tensión de la sensible",
      parent_offset: -7
    },
    # Eólico (VI) = Escala Menor Natural
    natural_minor: %{
      spanish_name: "Eólico",
      degree: 6,
      degree_roman: "VI",
      pattern: "T-S-T-T-S-T-T",
      pattern_list: [:t, :s, :t, :t, :s, :t, :t],
      type: :minor,
      brightness: 5,
      characteristic_note: nil,
      characteristic_desc: "Referencia estándar de la escala menor",
      parent_offset: -9
    },
    # Locrio (VII) - Disminuido con 5ª disminuida
    locrian: %{
      spanish_name: "Locrio",
      degree: 7,
      degree_roman: "VII",
      pattern: "S-T-T-S-T-T-T",
      pattern_list: [:s, :t, :t, :s, :t, :t, :t],
      type: :diminished,
      brightness: 7,
      characteristic_note: "5ª disminuida",
      characteristic_desc: "La b5 crea inestabilidad total",
      parent_offset: -11
    }
  }

  # Orden de brillo (1 = más brillante, 7 = más oscuro)
  @brightness_order [:lydian, :major, :mixolydian, :dorian, :natural_minor, :phrygian, :locrian]

  @doc """
  Obtiene la información del modo para un tipo de escala.
  Retorna nil si no es un modo (ej: blues, pentatonic).
  """
  def get_modal_info(scale_type) do
    Map.get(@modal_info, scale_type)
  end

  @doc """
  Dado un modo y su raíz, calcula de qué escala mayor deriva.
  Ejemplo: D Dorian → C Major (D - 2 semitonos = C)
  """
  def get_parent_major(root_midi, scale_type) do
    case get_modal_info(scale_type) do
      nil ->
        nil

      %{parent_offset: offset} ->
        parent_midi = rem(root_midi + offset + 12, 12) + 60
        parent_note = Note.new(parent_midi)

        %{
          midi: parent_midi,
          name: parent_note.name,
          pitch_class: rem(parent_midi, 12)
        }
    end
  end

  @doc """
  Dado un modo y su raíz, calcula todos los modos relacionados (mismas notas).
  Ejemplo: D Dorian comparte notas con C Jónico, E Frigio, F Lidio, etc.
  """
  def get_related_modes(root_midi, scale_type) do
    case get_parent_major(root_midi, scale_type) do
      nil ->
        []

      %{pitch_class: parent_pc} ->
        # Calcular todas las raíces de los 7 modos desde el padre mayor
        mode_offsets = [
          {:major, 0, "Jónico"},
          {:dorian, 2, "Dórico"},
          {:phrygian, 4, "Frigio"},
          {:lydian, 5, "Lidio"},
          {:mixolydian, 7, "Mixolidio"},
          {:natural_minor, 9, "Eólico"},
          {:locrian, 11, "Locrio"}
        ]

        Enum.map(mode_offsets, fn {mode_type, offset, spanish} ->
          mode_midi = rem(parent_pc + offset, 12) + 60
          mode_note = Note.new(mode_midi)

          %{
            type: mode_type,
            spanish_name: spanish,
            root_midi: mode_midi,
            root_name: mode_note.name,
            is_current: mode_type == scale_type
          }
        end)
    end
  end

  @doc """
  Retorna el nivel de brillo de un modo (1-7, donde 1 es más brillante).
  """
  def get_brightness_level(scale_type) do
    case Enum.find_index(@brightness_order, &(&1 == scale_type)) do
      nil -> nil
      idx -> idx + 1
    end
  end

  @doc """
  Retorna la lista ordenada de modos por brillo.
  """
  def brightness_order, do: @brightness_order

  @doc """
  Generates the Circle of Fifths data mathematically.
  Returns a list of maps with label, relative minor, midi root, and angle.
  """
  def generate_circle_of_fifths do
    # The circle starts at C (0 degrees, top)
    # Clockwise: +1 index = +7 semitones (Perfect 5th)
    # Counter-Clockwise: -1 index = -7 semitones (Perfect 4th)

    for i <- 0..11 do
      # Calculate pitch class (0..11) based on Circle of 5ths logic
      # i=0 -> 0 (C)
      # i=1 -> 7 (G)
      # i=2 -> 14 -> 2 (D)
      pitch_class = rem(i * 7, 12)

      # Determine MIDI root in octave 4 (60-71)
      # We need to map pitch_class to 60+
      midi = 60 + pitch_class
      # Adjust if it went too high (keep close to C4) - optional, but good for consistency
      midi = if midi > 71, do: midi - 12, else: midi

      # Calculate Angle (30 degrees per step)
      angle = i * 30

      # Determine Labels (Major and Relative Minor)
      {label, minor_label, minor_midi} = get_circle_labels(i)

      %{
        index: i,
        label: label,
        minor: minor_label,
        midi: midi,
        minor_midi: minor_midi,
        angle: angle
      }
    end
  end

  # Standard Circle of Fifths labels: {major_key, relative_minor, minor_root_midi}
  # Relative minor root = major root - 3 semitones (kept in octave 3-4 range)
  # A3
  defp get_circle_labels(0), do: {"C", "Am", 57}
  # E4
  defp get_circle_labels(1), do: {"G", "Em", 64}
  # B3
  defp get_circle_labels(2), do: {"D", "Bm", 59}
  # F#4
  defp get_circle_labels(3), do: {"A", "F#m", 66}
  # C#4
  defp get_circle_labels(4), do: {"E", "C#m", 61}
  # G#4
  defp get_circle_labels(5), do: {"B", "G#m", 68}
  # Eb4
  defp get_circle_labels(6), do: {"Gb/F#", "Ebm", 63}
  # Bb3
  defp get_circle_labels(7), do: {"Db", "Bbm", 58}
  # F4
  defp get_circle_labels(8), do: {"Ab", "Fm", 65}
  # C4
  defp get_circle_labels(9), do: {"Eb", "Cm", 60}
  # G4
  defp get_circle_labels(10), do: {"Bb", "Gm", 67}
  # D4
  defp get_circle_labels(11), do: {"F", "Dm", 62}

  @doc """
  Returns the standard VexFlow key signature string for a given root and scale type.
  """
  def determine_key_signature(root_note, scale_type, opts \\ []) do
    root_name = Note.new(root_note, opts).name
    key_signature_suffix(scale_type, root_name)
  end

  # Major-type scales share the major key signature (no suffix)
  defp key_signature_suffix(:major, root), do: root
  defp key_signature_suffix(:lydian, root), do: root
  defp key_signature_suffix(:mixolydian, root), do: root
  defp key_signature_suffix(:pentatonic_major, root), do: root
  # Minor-type scales use the minor key signature ("m" suffix)
  defp key_signature_suffix(:natural_minor, root), do: root <> "m"
  defp key_signature_suffix(:harmonic_minor, root), do: root <> "m"
  defp key_signature_suffix(:melodic_minor, root), do: root <> "m"
  defp key_signature_suffix(:dorian, root), do: root <> "m"
  defp key_signature_suffix(:phrygian, root), do: root <> "m"
  defp key_signature_suffix(:locrian, root), do: root <> "m"
  defp key_signature_suffix(:pentatonic_minor, root), do: root <> "m"
  defp key_signature_suffix(:blues, root), do: root <> "m"
  defp key_signature_suffix(_, _root), do: "C"

  @doc """
  Returns a map of expected accidentals for a given key signature.
  e.g., "G" -> %{"F" => "#"}
  """
  def get_key_signature_accidentals(key) do
    major_sharps = ["G", "D", "A", "E", "B", "F#", "C#"]
    major_flats = ["F", "Bb", "Eb", "Ab", "Db", "Gb", "Cb"]

    minor_sharps = ["Em", "Bm", "F#m", "C#m", "G#m", "D#m", "A#m"]
    minor_flats = ["Dm", "Gm", "Cm", "Fm", "Bbm", "Ebm", "Abm"]

    cond do
      key == "C" or key == "Am" ->
        %{}

      key in major_sharps ->
        count = Enum.find_index(major_sharps, &(&1 == key)) + 1
        sharps_order = ["F", "C", "G", "D", "A", "E", "B"]
        Enum.take(sharps_order, count) |> Map.new(&{&1, "#"})

      key in major_flats ->
        count = Enum.find_index(major_flats, &(&1 == key)) + 1
        flats_order = ["B", "E", "A", "D", "G", "C", "F"]
        Enum.take(flats_order, count) |> Map.new(&{&1, "b"})

      key in minor_sharps ->
        count = Enum.find_index(minor_sharps, &(&1 == key)) + 1
        sharps_order = ["F", "C", "G", "D", "A", "E", "B"]
        Enum.take(sharps_order, count) |> Map.new(&{&1, "#"})

      key in minor_flats ->
        count = Enum.find_index(minor_flats, &(&1 == key)) + 1
        flats_order = ["B", "E", "A", "D", "G", "C", "F"]
        Enum.take(flats_order, count) |> Map.new(&{&1, "b"})

      true ->
        %{}
    end
  end

  @doc """
  Analyzes a note name to separate base and accidental.
  "F#" -> {"F", "#"}
  "Bb" -> {"B", "b"}
  "C" -> {"C", ""}
  """
  def parse_note_name(name) do
    cond do
      String.contains?(name, "#") ->
        [base, _] = String.split(name, "#", parts: 2)
        {base, "#"}

      String.contains?(name, "b") ->
        [base, _] = String.split(name, "b", parts: 2)
        {base, "b"}

      true ->
        {name, ""}
    end
  end

  @doc """
  Generates theoretical context analysis for a scale.
  Returns a map with structural info including modal information.
  """
  def analyze_context(root, scale_type, scale_notes, use_flats) do
    # 1. Circle Context (relative to C)
    circle_text = analyze_circle_position(root)

    # 2. Accidentals Analysis
    altered_notes =
      Enum.filter(scale_notes, fn n ->
        String.contains?(n.name, "#") or String.contains?(n.name, "b")
      end)

    accidentals_count = length(altered_notes)
    altered_names = Enum.map_join(altered_notes, ", ", & &1.name)
    acc_type = if use_flats, do: "bemoles (b)", else: "sostenidos (#)"

    key_sig_text =
      if accidentals_count == 0 do
        "Esta escala es 'natural', no tiene alteraciones (todas teclas blancas)."
      else
        base_text = "Tiene #{accidentals_count} #{acc_type} (#{altered_names})."
        explanation = explain_scale_character(scale_type)
        "#{base_text} #{explanation}"
      end

    # 3. Formula
    formula_text = get_scale_formula(scale_type)

    # 4. Modal Info (si aplica)
    modal_info = get_modal_info(scale_type)
    parent_major = get_parent_major(root, scale_type)
    related_modes = get_related_modes(root, scale_type)
    brightness = get_brightness_level(scale_type)

    %{
      circle: circle_text,
      key_sig: key_sig_text,
      formula: formula_text,
      modal_info: modal_info,
      parent_major: parent_major,
      related_modes: related_modes,
      brightness: brightness
    }
  end

  defp analyze_circle_position(root), do: circle_position_text(rem(root, 12))

  defp circle_position_text(0),
    do: "Centro tonal (Do). El punto de partida puro, sin alteraciones."

  defp circle_position_text(7), do: "Dominante (Sol). Un paso a la derecha. Introduce el Fa#."
  defp circle_position_text(2), do: "Dos pasos a la derecha (Re). Brillo creciente con Fa# y Do#."

  defp circle_position_text(9),
    do: "Tres pasos a la derecha (La). Tonalidad brillante y enérgica."

  defp circle_position_text(4),
    do: "Cuatro pasos a la derecha (Mi). Muy brillante, usada en guitarra."

  defp circle_position_text(11), do: "Cinco pasos a la derecha (Si). Tensión armónica alta."

  defp circle_position_text(6),
    do: "El Tritono (Fa#/Solb). El punto opuesto a Do. Máxima tensión."

  defp circle_position_text(1),
    do: "Cinco pasos a la izquierda (Reb). Oscuro, cálido y romántico."

  defp circle_position_text(8), do: "Cuatro pasos a la izquierda (Lab). Profundo y solemne."
  defp circle_position_text(3), do: "Tres pasos a la izquierda (Mib). Heroico y majestuoso."
  defp circle_position_text(10), do: "Dos pasos a la izquierda (Sib). Suave, común en vientos."
  defp circle_position_text(5), do: "Subdominante (Fa). Un paso a la izquierda. Introduce el Sib."
  defp circle_position_text(_), do: "Una tonalidad intermedia con color propio."

  defp explain_scale_character(:major), do: "Sigue el patrón estándar W-W-H-W-W-W-H."

  defp explain_scale_character(:natural_minor),
    do: "Relativa menor. Comparte armadura con su mayor."

  defp explain_scale_character(:harmonic_minor),
    do: "Se eleva la 7ma nota accidentalmente para crear un acorde dominante."

  defp explain_scale_character(:melodic_minor),
    do: "Se elevan 6ta y 7ma al subir para suavizar la conducción de voces."

  defp explain_scale_character(:blues),
    do: "Añade notas de paso cromáticas (Blue Notes) para expresión."

  defp explain_scale_character(:dorian),
    do: "Menor con la 6ta elevada, lo que le da un brillo especial."

  defp explain_scale_character(:mixolydian),
    do: "Mayor con la 7ma rebajada, eliminando la tensión de la sensible."

  defp explain_scale_character(:lydian),
    do: "Mayor con la 4ta elevada (#4), creando un sonido etéreo."

  defp explain_scale_character(:phrygian),
    do: "Menor con la 2da rebajada (b2), sonido muy oscuro."

  defp explain_scale_character(_), do: "Las alteraciones definen su sonoridad única."

  defp get_scale_formula(:major),
    do: "Patrón: T-T-S-T-T-T-S. La referencia absoluta de la música occidental."

  defp get_scale_formula(:natural_minor),
    do: "Patrón: T-S-T-T-S-T-T. Baja la 3ra, 6ta y 7ma respecto a la Mayor."

  defp get_scale_formula(:harmonic_minor),
    do: "Menor con 7ma elevada. Crea el sonido 'árabe' o 'clásico'."

  defp get_scale_formula(:melodic_minor),
    do: "Sube 6ta y 7ma al subir. Suaviza la melodía para jazz y clásica."

  defp get_scale_formula(:dorian),
    do: "Menor con 6ta mayor. Menos triste, más 'funky' y medieval."

  defp get_scale_formula(:phrygian), do: "Menor con 2da menor. El sonido del Flamenco y Metal."

  defp get_scale_formula(:lydian),
    do: "Mayor con 4ta aumentada (#4). Sonido mágico, de película o sueño."

  defp get_scale_formula(:mixolydian),
    do: "Mayor con 7ma menor (b7). El sonido del Rock y Blues clásico."

  defp get_scale_formula(:locrian), do: "Disminuido. La escala más inestable y tensa de todas."

  defp get_scale_formula(:pentatonic_major),
    do: "Solo 5 notas. Sin semitonos. Imposible sonar mal."

  defp get_scale_formula(:pentatonic_minor),
    do: "Solo 5 notas. La base de la improvisación en Rock y Blues."

  defp get_scale_formula(:blues), do: "Pentatónica menor + Blue Note (b5). El alma del Blues."
  defp get_scale_formula(_), do: "Una estructura interválica única."

  # ============================================================================
  # ANÁLISIS DE NOTAS PRESIONADAS (para análisis MIDI en vivo)
  # ============================================================================

  @doc """
  Calcula los intervalos entre notas MIDI consecutivas (ordenadas de grave a agudo).
  Retorna lista de mapas con semitones, nombre y abreviatura del intervalo.

  ## Ejemplo

      iex> Theory.intervals_between([60, 64, 67])
      [%{semitones: 4, name: "3ª Mayor", abbrev: "M3"},
       %{semitones: 3, name: "3ª Menor", abbrev: "m3"}]
  """
  @spec intervals_between([integer()]) :: [map()]
  def intervals_between(midi_notes) when length(midi_notes) < 2, do: []

  def intervals_between(midi_notes) do
    sorted = Enum.sort(midi_notes)

    sorted
    |> Enum.zip(tl(sorted))
    |> Enum.map(fn {a, b} -> build_interval(b - a) end)
  end

  @doc """
  Encuentra las escalas que contienen todas las notas MIDI dadas.
  Compara pitch classes (rem midi 12) contra los intervalos de cada escala/raíz.
  Retorna lista ordenada por nombre de escala, limitada a 8 resultados.

  ## Ejemplo

      iex> Theory.find_compatible_scales([60, 64, 67])
      [%{root_name: "C", scale_type: :major, label: "C Mayor"}, ...]
  """
  @spec find_compatible_scales([integer()]) :: [map()]
  def find_compatible_scales([]), do: []

  def find_compatible_scales(midi_notes) do
    pitch_classes = midi_notes |> Enum.map(&rem(&1, 12)) |> MapSet.new()

    Scale.intervals_map()
    |> Enum.flat_map(fn {type, intervals} ->
      Enum.map(0..11, fn root_pc ->
        scale_pcs = MapSet.new(Enum.map(intervals, &rem(root_pc + &1, 12)))
        {root_pc, type, scale_pcs}
      end)
    end)
    |> Enum.filter(fn {_root_pc, _type, scale_pcs} ->
      MapSet.subset?(pitch_classes, scale_pcs)
    end)
    |> Enum.map(fn {root_pc, type, _} -> build_scale_match(root_pc, type) end)
    |> Enum.sort_by(& &1.label)
    |> Enum.take(8)
  end

  defp build_scale_match(root_pc, type) do
    root_midi = root_pc + 60
    root_name = Note.new(root_midi).name
    type_label = scale_type_label_es(type)
    %{root_name: root_name, scale_type: type, label: "#{root_name} #{type_label}"}
  end

  defp scale_type_label_es(:major), do: "Mayor"
  defp scale_type_label_es(:natural_minor), do: "Menor"
  defp scale_type_label_es(:harmonic_minor), do: "Menor Armónica"
  defp scale_type_label_es(:melodic_minor), do: "Menor Melódica"
  defp scale_type_label_es(:pentatonic_major), do: "Pentatónica Mayor"
  defp scale_type_label_es(:pentatonic_minor), do: "Pentatónica Menor"
  defp scale_type_label_es(:blues), do: "Blues"
  defp scale_type_label_es(:dorian), do: "Dórico"
  defp scale_type_label_es(:phrygian), do: "Frigio"
  defp scale_type_label_es(:lydian), do: "Lidio"
  defp scale_type_label_es(:mixolydian), do: "Mixolidio"
  defp scale_type_label_es(:locrian), do: "Locrio"
  defp scale_type_label_es(_), do: "Escala"

  # Convierte semitones a nombre de intervalo musical
  defp build_interval(semitones) do
    %{semitones: semitones, name: interval_name(semitones), abbrev: interval_abbrev(semitones)}
  end

  defp interval_name(0), do: "Unísono"
  defp interval_name(1), do: "2ª Menor"
  defp interval_name(2), do: "2ª Mayor"
  defp interval_name(3), do: "3ª Menor"
  defp interval_name(4), do: "3ª Mayor"
  defp interval_name(5), do: "4ª Justa"
  defp interval_name(6), do: "Tritono"
  defp interval_name(7), do: "5ª Justa"
  defp interval_name(8), do: "6ª Menor"
  defp interval_name(9), do: "6ª Mayor"
  defp interval_name(10), do: "7ª Menor"
  defp interval_name(11), do: "7ª Mayor"
  defp interval_name(12), do: "Octava"
  defp interval_name(n) when n > 12, do: "#{n} semitonos"
  defp interval_name(n), do: "#{n} semitonos"

  defp interval_abbrev(0), do: "P1"
  defp interval_abbrev(1), do: "m2"
  defp interval_abbrev(2), do: "M2"
  defp interval_abbrev(3), do: "m3"
  defp interval_abbrev(4), do: "M3"
  defp interval_abbrev(5), do: "P4"
  defp interval_abbrev(6), do: "TT"
  defp interval_abbrev(7), do: "P5"
  defp interval_abbrev(8), do: "m6"
  defp interval_abbrev(9), do: "M6"
  defp interval_abbrev(10), do: "m7"
  defp interval_abbrev(11), do: "M7"
  defp interval_abbrev(12), do: "P8"
  defp interval_abbrev(_n), do: "?"
end
