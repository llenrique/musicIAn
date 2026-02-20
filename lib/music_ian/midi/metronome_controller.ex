defmodule MusicIan.MIDI.MetronomeController do
  @moduledoc """
  Controls metronome functionality on Yamaha pianos (YDP-105, etc.) via MIDI.

  The YDP-105 metronome is controlled using the GRAND PIANO/FUNCTION button + specific keys:
  - C4 (MIDI 60): Toggle metronome on/off
  - D4-G4 (MIDI 62-67): Set tempo (using digit sequence)
  - C5-G5 (MIDI 72-79): Set beat/time signature

  Since MIDI cannot directly press physical buttons, we simulate this by sending:
  1. Note On for the "FUNCTION" equivalent (typically a program change or special message)
  2. Note On for the desired parameter key
  3. Note Off to release

  Reference: Yamaha YDP-105 Quick Operation Guide
  """

  require Logger

  # MIDI Note Numbers for Yamaha YDP-105 Metronome Control
  # C4 - Toggle metronome on/off
  @metronome_toggle_note 60

  # Default MIDI channel for metronome control
  # Channel 1 in MIDI terms (0-indexed)
  @default_channel 0

  # Velocity for function button simulation
  # Maximum velocity to ensure the piano recognizes it
  @function_velocity 127

  @doc """
  Enable/toggle the metronome on the connected Yamaha piano.

  The piano needs to support MIDI note input for function button simulation.
  This works by sending a Note On message to C4 (MIDI 60).

  ## Parameters
    - midi_output: The MIDI output device/process
    - channel: MIDI channel (0-15, default 0 for channel 1)

  ## Returns
    - :ok if successful
    - {:error, reason} if failed
  """
  def toggle_metronome(midi_output, channel \\ @default_channel) do
    Logger.info("🎵 Toggling Yamaha metronome (MIDI channel #{channel + 1})")

    with :ok <- send_note_on(midi_output, @metronome_toggle_note, @function_velocity, channel),
         :ok <- send_note_off(midi_output, @metronome_toggle_note, channel) do
      {:ok, "Metronome toggled"}
    else
      error -> {:error, error}
    end
  end

  @doc """
  Set the metronome tempo on a Yamaha piano (30-300 BPM typical).

  The YDP-105 uses a digit-based interface:
  - Press D4 then D5-D4 for digits (e.g., 120 BPM = D5 (1), D4 (2), D6 (0))
  - Each key press represents a digit from the tempo value

  ## Parameters
    - midi_output: The MIDI output device/process
    - tempo: BPM value (30-300 typical range)
    - channel: MIDI channel (0-15)

  ## Returns
    - :ok if successful
    - {:error, reason} if failed
  """
  def set_tempo(midi_output, tempo, channel \\ @default_channel) when is_integer(tempo) do
    if tempo < 30 or tempo > 300 do
      {:error, "Tempo must be between 30-300 BPM"}
    else
      Logger.info("⏱️  Setting Yamaha metronome tempo to #{tempo} BPM")
      digits = tempo_to_digits(tempo)
      Logger.debug("Tempo digits: #{inspect(digits)}")

      case send_tempo_digits(midi_output, digits, channel) do
        :ok -> {:ok, "Tempo set to #{tempo} BPM"}
        error -> {:error, error}
      end
    end
  end

  @doc """
  Set the beat pattern/time signature on a Yamaha piano.

  The YDP-105 has several beat patterns selectable via C5-G5:
  - C5 (MIDI 72): 1/4 (Single beat)
  - D5 (MIDI 74): 2/4
  - E5 (MIDI 76): 3/4
  - F5 (MIDI 77): 4/4
  - G5 (MIDI 79): 6/8
  - etc.

  ## Parameters
    - midi_output: The MIDI output device/process
    - beat_type: Atom representing beat pattern (:single, :two, :three, :four, :six_eight, etc.)
    - channel: MIDI channel (0-15)

  ## Returns
    - :ok if successful
    - {:error, reason} if failed
  """
  def set_beat(midi_output, beat_type, channel \\ @default_channel) do
    note = beat_type_to_note(beat_type)

    case note do
      nil ->
        {:error, "Invalid beat type: #{beat_type}"}

      midi_note ->
        Logger.info("🎵 Setting Yamaha metronome beat to #{beat_type}")

        with :ok <- send_note_on(midi_output, midi_note, @function_velocity, channel),
             :ok <- send_note_off(midi_output, midi_note, channel) do
          {:ok, "Beat pattern set to #{beat_type}"}
        else
          error -> {:error, error}
        end
    end
  end

  @doc """
  Set the metronome volume on a Yamaha piano.

  The YDP-105 uses A5-B5 to control volume:
  - Press multiple times to increase volume

  ## Parameters
    - midi_output: The MIDI output device/process
    - volume: 0-127 (standard MIDI volume range)
    - channel: MIDI channel (0-15)

  ## Returns
    - :ok if successful
    - {:error, reason} if failed
  """
  def set_volume(midi_output, volume, channel \\ @default_channel) when is_integer(volume) do
    if volume < 0 or volume > 127 do
      {:error, "Volume must be between 0-127"}
    else
      Logger.info("🔊 Setting Yamaha metronome volume to #{volume}")

      case send_control_change(midi_output, 7, volume, channel) do
        :ok -> {:ok, "Volume set to #{volume}"}
        error -> {:error, error}
      end
    end
  end

  # Private helper functions

  defp send_note_on(midi_output, note, velocity, channel) do
    message = {:note_on, channel, note, velocity}
    Logger.debug("Sending MIDI: #{inspect(message)}")

    case midi_output do
      nil ->
        {:error, "MIDI output not initialized"}

      pid when is_pid(pid) ->
        try do
          send(pid, message)
          :ok
        catch
          _kind, _reason ->
            {:error, "Failed to send MIDI message"}
        end

      _other ->
        {:error, "Invalid MIDI output device"}
    end
  end

  defp send_note_off(midi_output, note, channel) do
    message = {:note_off, channel, note, 0}
    Logger.debug("Sending MIDI: #{inspect(message)}")

    case midi_output do
      nil ->
        {:error, "MIDI output not initialized"}

      pid when is_pid(pid) ->
        try do
          send(pid, message)
          :ok
        catch
          _kind, _reason ->
            {:error, "Failed to send MIDI message"}
        end

      _other ->
        {:error, "Invalid MIDI output device"}
    end
  end

  defp send_control_change(midi_output, cc_number, value, channel) do
    message = {:control_change, channel, cc_number, value}
    Logger.debug("Sending MIDI CC: #{inspect(message)}")

    case midi_output do
      nil ->
        {:error, "MIDI output not initialized"}

      pid when is_pid(pid) ->
        try do
          send(pid, message)
          :ok
        catch
          _kind, _reason ->
            {:error, "Failed to send MIDI CC message"}
        end

      _other ->
        {:error, "Invalid MIDI output device"}
    end
  end

  @doc false
  defp tempo_to_digits(tempo) do
    tempo
    |> to_string()
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  @doc false
  defp send_tempo_digits(midi_output, digits, channel) do
    digits
    |> Enum.with_index()
    |> Enum.reduce(:ok, fn
      _digit, {:error, _} = error ->
        error

      {digit, _index}, :ok ->
        # Map digit (0-9) to MIDI note
        # Typically: D4 (62) = 0, E4 (64) = 1, F4 (65) = 2, G4 (67) = 3, A4 (69) = 4, etc.
        note = digit_to_note(digit)

        with :ok <- send_note_on(midi_output, note, @function_velocity, channel),
             # Small delay between digit presses
             :ok <- Process.sleep(100),
             :ok <- send_note_off(midi_output, note, channel) do
          :ok
        else
          error -> error
        end
    end)
  end

  @doc false
  defp digit_to_note(digit) when digit >= 0 and digit <= 9 do
    # Map digits 0-9 to MIDI notes
    # D4=62(0), E4=64(1), F4=65(2), G4=67(3), A4=69(4),
    # B4=71(5), C5=72(6), D5=74(7), E5=76(8), F5=77(9)
    notes = %{
      # D4
      0 => 62,
      # E4
      1 => 64,
      # F4
      2 => 65,
      # G4
      3 => 67,
      # A4
      4 => 69,
      # B4
      5 => 71,
      # C5
      6 => 72,
      # D5
      7 => 74,
      # E5
      8 => 76,
      # F5
      9 => 77
    }

    # Default to D4 if digit is invalid
    Map.get(notes, digit, 62)
  end

  @doc false
  defp beat_type_to_note(beat_type) do
    beatmap = %{
      # C5
      :single => 72,
      # D5
      :two => 74,
      # E5
      :three => 76,
      # F5
      :four => 77,
      # G5
      :six_eight => 79,
      # A5 (if supported)
      :three_eight => 81,
      # B5 (if supported)
      :cut_time => 83
    }

    Map.get(beatmap, beat_type)
  end
end
