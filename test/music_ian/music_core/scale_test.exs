defmodule MusicIan.MusicCore.ScaleTest do
  use ExUnit.Case, async: true
  alias MusicIan.MusicCore.Scale

  describe "new/2" do
    test "generates C Major scale correctly" do
      # C4 is 60
      scale = Scale.new(60, :major)
      
      assert scale.root.midi == 60
      assert scale.type == :major
      
      # C Major: C, D, E, F, G, A, B
      # MIDI: 60, 62, 64, 65, 67, 69, 71
      expected_midis = [60, 62, 64, 65, 67, 69, 71]
      actual_midis = Enum.map(scale.notes, & &1.midi)
      
      assert actual_midis == expected_midis
      assert Enum.map(scale.notes, & &1.name) == ~w(C D E F G A B)
    end

    test "generates A Minor (Natural) scale correctly" do
      # A4 is 69
      scale = Scale.new(69, :natural_minor)
      
      # A Minor: A, B, C, D, E, F, G
      # Intervals: 0, 2, 3, 5, 7, 8, 10
      # MIDI: 69, 71, 72, 74, 76, 77, 79
      expected_midis = [69, 71, 72, 74, 76, 77, 79]
      actual_midis = Enum.map(scale.notes, & &1.midi)
      
      assert actual_midis == expected_midis
      assert Enum.map(scale.notes, & &1.name) == ~w(A B C D E F G)
    end

    test "generates C Blues scale correctly" do
      # C4 is 60
      scale = Scale.new(60, :blues)
      
      # C Blues: C, Eb, F, Gb, G, Bb
      # Intervals: 0, 3, 5, 6, 7, 10
      # MIDI: 60, 63, 65, 66, 67, 70
      expected_midis = [60, 63, 65, 66, 67, 70]
      actual_midis = Enum.map(scale.notes, & &1.midi)
      
      assert actual_midis == expected_midis
    end
  end

  describe "diatonic_triads/1" do
    test "generates correct triads for C Major" do
      scale = Scale.new(60, :major)
      triads = Scale.diatonic_triads(scale)
      
      assert length(triads) == 7
      
      # I: C Major
      assert Enum.at(triads, 0).quality == :major
      assert Enum.at(triads, 0).root.name == "C"
      
      # ii: D Minor
      assert Enum.at(triads, 1).quality == :minor
      assert Enum.at(triads, 1).root.name == "D"
      
      # iii: E Minor
      assert Enum.at(triads, 2).quality == :minor
      
      # IV: F Major
      assert Enum.at(triads, 3).quality == :major
      
      # V: G Major
      assert Enum.at(triads, 4).quality == :major
      
      # vi: A Minor
      assert Enum.at(triads, 5).quality == :minor
      
      # vii°: B Diminished
      assert Enum.at(triads, 6).quality == :diminished
    end
  end

  describe "diatonic_sevenths/1" do
    test "generates correct seventh chords for C Major" do
      scale = Scale.new(60, :major)
      sevenths = Scale.diatonic_sevenths(scale)
      
      assert length(sevenths) == 7
      
      # I: C Maj7
      assert Enum.at(sevenths, 0).quality == :major7
      
      # ii: D m7
      assert Enum.at(sevenths, 1).quality == :minor7
      
      # V: G 7
      assert Enum.at(sevenths, 4).quality == :dominant7
      
      # vii°: B m7b5
      assert Enum.at(sevenths, 6).quality == :minor7b5
    end
  end
end
