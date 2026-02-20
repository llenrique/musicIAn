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
  Returns a map with structural info.
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

    %{
      circle: circle_text,
      key_sig: key_sig_text,
      formula: formula_text
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
end
