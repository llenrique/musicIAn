defmodule MusicIan.MusicCore.ChordTest do
  use ExUnit.Case, async: true
  alias MusicIan.MusicCore.Chord

  describe "new/2" do
    test "generates C Major triad" do
      # C4 = 60
      chord = Chord.new(60, :major)
      
      # C, E, G -> 60, 64, 67
      expected = [60, 64, 67]
      actual = Enum.map(chord.notes, & &1.midi)
      
      assert actual == expected
      assert chord.quality == :major
    end

    test "generates C Minor 7" do
      # C4 = 60
      chord = Chord.new(60, :minor7)
      
      # C, Eb, G, Bb -> 60, 63, 67, 70
      expected = [60, 63, 67, 70]
      actual = Enum.map(chord.notes, & &1.midi)
      
      assert actual == expected
    end
  end

  describe "invert/2" do
    test "first inversion of C Major" do
      chord = Chord.new(60, :major) # C, E, G
      inverted = Chord.invert(chord, 1)
      
      # Should be E, G, C(up octave) -> 64, 67, 72
      expected = [64, 67, 72]
      actual = Enum.map(inverted.notes, & &1.midi)
      
      assert actual == expected
      assert inverted.inversion == 1
    end

    test "second inversion of C Major" do
      chord = Chord.new(60, :major) # C, E, G
      inverted = Chord.invert(chord, 2)
      
      # Should be G, C(up), E(up) -> 67, 72, 76
      expected = [67, 72, 76]
      actual = Enum.map(inverted.notes, & &1.midi)
      
      assert actual == expected
    end
  end
end
