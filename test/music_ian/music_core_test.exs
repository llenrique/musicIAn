defmodule MusicIan.MusicCoreTest do
  use ExUnit.Case, async: true
  alias MusicIan.MusicCore

  describe "frequency_from_midi/1" do
    test "calculates correct frequency for A4" do
      assert MusicCore.frequency_from_midi(69) == 440.0
    end

    test "calculates correct frequency for C4 (Middle C)" do
      # C4 is 60. Frequency is approx 261.63
      assert_in_delta MusicCore.frequency_from_midi(60), 261.63, 0.01
    end

    test "calculates correct frequency for A5" do
      # A5 is 81 (69 + 12). Frequency should be 880.0
      assert MusicCore.frequency_from_midi(81) == 880.0
    end
  end

  describe "get_scale/2" do
    test "returns a scale struct" do
      scale = MusicCore.get_scale(60, :major)
      assert scale.type == :major
      assert length(scale.notes) == 7
    end
  end
end
