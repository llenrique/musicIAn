defmodule MusicIan.MusicCore.Theory do
  @moduledoc """
  Pure domain logic for Music Theory analysis.
  Handles key signatures, accidentals, and contextual analysis of scales/modes.
  Independent of UI or Education logic.
  """

  alias MusicIan.MusicCore.Note

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
      {label, minor_label} = get_circle_labels(i)

      %{
        index: i,
        label: label,
        minor: minor_label,
        midi: midi,
        angle: angle
      }
    end
  end

  defp get_circle_labels(index) do
    # Standard Circle of Fifths Labels
    case index do
      0 -> {"C", "a"}
      1 -> {"G", "e"}
      2 -> {"D", "b"}
      3 -> {"A", "f#"}
      4 -> {"E", "c#"}
      5 -> {"B", "g#"}
      6 -> {"Gb", "eb"} # Or F#
      7 -> {"Db", "bb"} # Or C#
      8 -> {"Ab", "f"}
      9 -> {"Eb", "c"}
      10 -> {"Bb", "g"}
      11 -> {"F", "d"}
    end
  end

  @doc """
  Returns the standard VexFlow key signature string for a given root and scale type.
  """
  def determine_key_signature(root_note, scale_type, opts \\ []) do
    root_name = Note.new(root_note, opts).name

    case scale_type do
      :major -> root_name
      :lydian -> root_name # Lydian shares Major key sig (with accidentals handled separately)
      :mixolydian -> root_name
      :natural_minor -> root_name <> "m"
      :harmonic_minor -> root_name <> "m"
      :melodic_minor -> root_name <> "m"
      :dorian -> root_name <> "m"
      :phrygian -> root_name <> "m"
      :locrian -> root_name <> "m"
      :pentatonic_major -> root_name
      :pentatonic_minor -> root_name <> "m"
      :blues -> root_name <> "m"
      _ -> "C"
    end
  end

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
      key == "C" or key == "Am" -> %{}

      key in major_sharps ->
        count = Enum.find_index(major_sharps, & &1 == key) + 1
        sharps_order = ["F", "C", "G", "D", "A", "E", "B"]
        Enum.take(sharps_order, count) |> Map.new(& {&1, "#"})

      key in major_flats ->
        count = Enum.find_index(major_flats, & &1 == key) + 1
        flats_order = ["B", "E", "A", "D", "G", "C", "F"]
        Enum.take(flats_order, count) |> Map.new(& {&1, "b"})

      key in minor_sharps ->
        count = Enum.find_index(minor_sharps, & &1 == key) + 1
        sharps_order = ["F", "C", "G", "D", "A", "E", "B"]
        Enum.take(sharps_order, count) |> Map.new(& {&1, "#"})

      key in minor_flats ->
        count = Enum.find_index(minor_flats, & &1 == key) + 1
        flats_order = ["B", "E", "A", "D", "G", "C", "F"]
        Enum.take(flats_order, count) |> Map.new(& {&1, "b"})

      true -> %{}
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
  Returns a map with structural info.
  """
  def analyze_context(root, scale_type, scale_notes, use_flats) do
    # 1. Circle Context (relative to C)
    circle_text = analyze_circle_position(root)

    # 2. Accidentals Analysis
    altered_notes = Enum.filter(scale_notes, fn n ->
      String.contains?(n.name, "#") or String.contains?(n.name, "b")
    end)

    accidentals_count = length(altered_notes)
    altered_names = Enum.map(altered_notes, & &1.name) |> Enum.join(", ")
    acc_type = if use_flats, do: "bemoles (b)", else: "sostenidos (#)"

    key_sig_text = if accidentals_count == 0 do
      "Esta escala es 'natural', no tiene alteraciones (todas teclas blancas)."
    else
      base_text = "Tiene #{accidentals_count} #{acc_type} (#{altered_names})."
      explanation = explain_scale_character(scale_type)
      "#{base_text} #{explanation}"
    end

    # 3. Formula
    formula_text = get_scale_formula(scale_type)

    %{
      circle: circle_text,
      key_sig: key_sig_text,
      formula: formula_text
    }
  end

  defp analyze_circle_position(root) do
    case rem(root, 12) do
      0 -> "Centro tonal (Do). El punto de partida puro, sin alteraciones."
      7 -> "Dominante (Sol). Un paso a la derecha. Introduce el Fa#."
      2 -> "Dos pasos a la derecha (Re). Brillo creciente con Fa# y Do#."
      9 -> "Tres pasos a la derecha (La). Tonalidad brillante y enérgica."
      4 -> "Cuatro pasos a la derecha (Mi). Muy brillante, usada en guitarra."
      11 -> "Cinco pasos a la derecha (Si). Tensión armónica alta."
      6 -> "El Tritono (Fa#/Solb). El punto opuesto a Do. Máxima tensión."
      1 -> "Cinco pasos a la izquierda (Reb). Oscuro, cálido y romántico."
      8 -> "Cuatro pasos a la izquierda (Lab). Profundo y solemne."
      3 -> "Tres pasos a la izquierda (Mib). Heroico y majestuoso."
      10 -> "Dos pasos a la izquierda (Sib). Suave, común en vientos."
      5 -> "Subdominante (Fa). Un paso a la izquierda. Introduce el Sib."
      _ -> "Una tonalidad intermedia con color propio."
    end
  end

  defp explain_scale_character(scale_type) do
    case scale_type do
      :major -> "Sigue el patrón estándar W-W-H-W-W-W-H."
      :natural_minor -> "Relativa menor. Comparte armadura con su mayor."
      :harmonic_minor -> "Se eleva la 7ma nota accidentalmente para crear un acorde dominante."
      :melodic_minor -> "Se elevan 6ta y 7ma al subir para suavizar la conducción de voces."
      :blues -> "Añade notas de paso cromáticas (Blue Notes) para expresión."
      :dorian -> "Menor con la 6ta elevada, lo que le da un brillo especial."
      :mixolydian -> "Mayor con la 7ma rebajada, eliminando la tensión de la sensible."
      :lydian -> "Mayor con la 4ta elevada (#4), creando un sonido etéreo."
      :phrygian -> "Menor con la 2da rebajada (b2), sonido muy oscuro."
      _ -> "Las alteraciones definen su sonoridad única."
    end
  end

  defp get_scale_formula(scale_type) do
    case scale_type do
      :major -> "Patrón: T-T-S-T-T-T-S. La referencia absoluta de la música occidental."
      :natural_minor -> "Patrón: T-S-T-T-S-T-T. Baja la 3ra, 6ta y 7ma respecto a la Mayor."
      :harmonic_minor -> "Menor con 7ma elevada. Crea el sonido 'árabe' o 'clásico' característico."
      :melodic_minor -> "Sube 6ta y 7ma al subir. Suaviza la melodía para el jazz y clásica."
      :dorian -> "Menor con 6ta mayor. Menos triste, más 'funky' y medieval."
      :phrygian -> "Menor con 2da menor. El sonido del Flamenco y Metal."
      :lydian -> "Mayor con 4ta aumentada (#4). Sonido mágico, de película o sueño."
      :mixolydian -> "Mayor con 7ma menor (b7). El sonido del Rock y Blues clásico."
      :locrian -> "Disminuido. La escala más inestable y tensa de todas."
      :pentatonic_major -> "Solo 5 notas. Sin semitonos. Imposible sonar mal."
      :pentatonic_minor -> "Solo 5 notas. La base de la improvisación en Rock y Blues."
      :blues -> "Pentatónica menor + Blue Note (b5). El alma del Blues."
      _ -> "Una estructura interválica única."
    end
  end
end
