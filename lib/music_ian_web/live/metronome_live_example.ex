defmodule MusicIanWeb.MetronomeExampleLive do
  @moduledoc """
  LiveView for testing Yamaha YDP-105 metronome control via Web MIDI API.

  This page allows you to:
  1. Connect to the piano via Web MIDI API (browser-based)
  2. Send MIDI Note On messages to control the metrónomo
  3. Test different MIDI notes to discover which ones activate functions

  Navigate to: http://localhost:4000/metronome
  """

  use MusicIanWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:is_connected, false)
     |> assign(:available_devices, [])
     |> assign(:selected_device, nil)
     |> assign(:tempo, 120)
     |> assign(:beat_type, :four)
     |> assign(:volume, 80)
     |> assign(:test_note, 60)
     |> assign(:test_velocity, 127)}
  end

  @impl true
  def handle_event("list_devices", _params, socket) do
    # The actual device listing happens in JavaScript via Web MIDI API
    {:noreply, socket}
  end

  @impl true
  def handle_event("connect_device", %{"device" => device_name}, socket) do
    {:noreply,
     socket
     |> assign(:selected_device, device_name)
     |> assign(:is_connected, true)
     |> put_flash(:info, "🎹 Dispositivo MIDI seleccionado: #{device_name}")}
  end

  @impl true
  def handle_event("send_note", %{"note" => note_str, "velocity" => velocity_str}, socket) do
    note = String.to_integer(note_str)
    velocity = String.to_integer(velocity_str)

    {:noreply,
     socket
     |> assign(:test_note, note)
     |> assign(:test_velocity, velocity)
     |> put_flash(:info, "📤 Enviando Note On: MIDI #{note}, Velocity #{velocity}")}
  end

  @impl true
  def handle_event("toggle_metronome", _params, socket) do
    # C#4 = MIDI 61
    {:noreply,
     socket
     |> put_flash(:info, "🎵 Intentando activar metrónomo (FUNCTION + C#4)...")}
  end

  @impl true
  def handle_event("set_tempo", %{"tempo" => tempo_str}, socket) do
    tempo = String.to_integer(tempo_str)

    {:noreply,
     socket
     |> assign(:tempo, tempo)
     |> put_flash(:info, "⏱️ Intentando establecer tempo a #{tempo} BPM...")}
  end

  @impl true
  def handle_event("set_beat", %{"beat" => beat_str}, socket) do
    beat_type = String.to_atom(beat_str)

    {:noreply,
     socket
     |> assign(:beat_type, beat_type)
     |> put_flash(:info, "🎵 Intentando cambiar compás a #{beat_str}...")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-gradient-to-br from-slate-50 to-slate-100 p-8">
      <div class="max-w-4xl mx-auto">
        <!-- Header -->
        <div class="mb-8">
          <h1 class="text-4xl font-bold text-slate-900 mb-2">🎹 Test Metrónomo Yamaha YDP-105</h1>
          <p class="text-slate-600">Prueba conexión MIDI y envío de comandos</p>
        </div>
        
    <!-- Connection Section -->
        <div class="bg-white rounded-lg shadow-lg p-6 mb-6">
          <div class="flex items-center justify-between mb-4">
            <span class="text-lg font-semibold text-slate-900">1. Conexión MIDI</span>
            <span class={[
              "text-sm font-bold px-4 py-2 rounded-full",
              if(@is_connected, do: "bg-green-100 text-green-700", else: "bg-red-100 text-red-700")
            ]}>
              {if @is_connected, do: "🎹 Conectado", else: "❌ No conectado"}
            </span>
          </div>

          <div id="device-select" phx-hook="MidiDeviceSelector" class="space-y-3">
            <select
              id="midi-devices"
              class="w-full px-4 py-3 border-2 border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
            >
              <option value="">-- Detectando dispositivos MIDI --</option>
            </select>
            <button
              onclick="window.midiDeviceSelector?.connect()"
              class="w-full py-3 px-6 rounded-lg font-semibold transition-all bg-blue-600 hover:bg-blue-700 text-white cursor-pointer"
            >
              Conectar a dispositivo seleccionado
            </button>
          </div>

          <div id="midi-status" class="mt-4 p-3 bg-slate-100 rounded text-sm text-slate-700">
            Esperando conexión MIDI...
          </div>
        </div>
        
    <!-- Test Section -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
          <!-- Quick Test -->
          <div class="bg-white rounded-lg shadow-lg p-6">
            <h2 class="text-xl font-bold text-slate-900 mb-4">2. Test Rápido - Notas Metrónomo</h2>
            <p class="text-xs text-slate-600 mb-3">
              Presiona FUNCTION en el piano y luego haz clic aquí:
            </p>
            <div class="space-y-3">
              <button
                onclick="window.midiDeviceSelector?.sendNote(72, 127, 'C5 (Do5) - MIDI 72 - METRÓNOMO')"
                class="w-full py-2 px-4 bg-red-600 hover:bg-red-700 text-white rounded-lg text-sm font-bold"
              >
                🎵 C5 (Do5) - MIDI 72 - METRÓNOMO
              </button>
              <button
                onclick="window.midiDeviceSelector?.sendNote(74, 127, 'D5 (Re5) - MIDI 74')"
                class="w-full py-2 px-4 bg-purple-600 hover:bg-purple-700 text-white rounded-lg text-sm"
              >
                D5 (Re5) - MIDI 74
              </button>
              <button
                onclick="window.midiDeviceSelector?.sendNote(76, 127, 'E5 (Mi5) - MIDI 76')"
                class="w-full py-2 px-4 bg-purple-600 hover:bg-purple-700 text-white rounded-lg text-sm"
              >
                E5 (Mi5) - MIDI 76
              </button>
              <button
                onclick="window.midiDeviceSelector?.sendNote(77, 127, 'F5 (Fa5) - MIDI 77')"
                class="w-full py-2 px-4 bg-purple-600 hover:bg-purple-700 text-white rounded-lg text-sm"
              >
                F5 (Fa5) - MIDI 77
              </button>
            </div>
          </div>
          
    <!-- Custom Note Test -->
          <div class="bg-white rounded-lg shadow-lg p-6">
            <h2 class="text-xl font-bold text-slate-900 mb-4">3. Test Personalizado</h2>
            <div class="space-y-3">
              <div>
                <label class="block text-sm font-semibold text-slate-900 mb-2">
                  Nota MIDI (0-127):
                </label>
                <input
                  type="number"
                  id="test-note"
                  value={@test_note}
                  min="0"
                  max="127"
                  class="w-full px-4 py-2 border-2 border-slate-200 rounded-lg"
                />
              </div>
              <div>
                <label class="block text-sm font-semibold text-slate-900 mb-2">
                  Velocidad (0-127):
                </label>
                <input
                  type="number"
                  id="test-velocity"
                  value={@test_velocity}
                  min="0"
                  max="127"
                  class="w-full px-4 py-2 border-2 border-slate-200 rounded-lg"
                />
              </div>
              <button
                onclick="window.midiDeviceSelector?.sendCustomNote()"
                class="w-full py-2 px-4 bg-green-600 hover:bg-green-700 text-white rounded-lg font-semibold"
              >
                Enviar Nota Custom
              </button>
            </div>
          </div>
        </div>
        
    <!-- Advanced Control Section -->
        <div class="bg-white rounded-lg shadow-lg p-6 mt-6">
          <h2 class="text-xl font-bold text-slate-900 mb-4">4. Control Avanzado</h2>

          <div class="grid grid-cols-1 lg:grid-cols-2 gap-4 mb-6">
            <!-- Metronome Toggle -->
            <div>
              <label class="block text-sm font-semibold text-slate-900 mb-2">Metrónomo</label>
              <button
                onclick="window.midiDeviceSelector?.toggleMetronome()"
                class="w-full py-2 px-4 bg-red-600 hover:bg-red-700 text-white rounded-lg text-sm"
              >
                Toggle (C#4)
              </button>
            </div>
            
    <!-- Tempo Control -->
            <div>
              <label class="block text-sm font-semibold text-slate-900 mb-2">
                Tempo: <span class="text-purple-600">{@tempo} BPM</span>
              </label>
              <input
                type="range"
                id="tempo-slider"
                min="30"
                max="300"
                value={@tempo}
                phx-change="set_tempo"
                name="tempo"
                class="w-full"
              />
            </div>
          </div>
          
    <!-- Beat Selection -->
          <div class="mb-6">
            <label class="block text-sm font-semibold text-slate-900 mb-2">Compás</label>
            <select
              id="beat-select"
              phx-change="set_beat"
              name="beat"
              class="w-full px-2 py-2 border-2 border-slate-200 rounded-lg text-sm"
            >
              <option value="single">1/4</option>
              <option value="two">2/4</option>
              <option value="three">3/4</option>
              <option value="four" selected>4/4</option>
              <option value="six_eight">6/8</option>
            </select>
          </div>
        </div>
        
    <!-- Program Change Test Section -->
        <div class="bg-white rounded-lg shadow-lg p-6 mt-6">
          <h2 class="text-xl font-bold text-slate-900 mb-4">5. Test Program Change (PC) Messages</h2>
          <p class="text-sm text-slate-600 mb-4">
            Prueba enviar diferentes Program Change messages. Algunos pianos usan esto para activar modos especiales.
          </p>

          <div class="space-y-3">
            <div class="grid grid-cols-2 lg:grid-cols-6 gap-2">
              <button
                onclick="window.midiDeviceSelector?.sendPC(0, 'PC 0')"
                class="py-2 px-2 bg-cyan-600 hover:bg-cyan-700 text-white rounded text-xs"
              >
                PC 0
              </button>
              <button
                onclick="window.midiDeviceSelector?.sendPC(1, 'PC 1')"
                class="py-2 px-2 bg-cyan-600 hover:bg-cyan-700 text-white rounded text-xs"
              >
                PC 1
              </button>
              <button
                onclick="window.midiDeviceSelector?.sendPC(5, 'PC 5')"
                class="py-2 px-2 bg-cyan-600 hover:bg-cyan-700 text-white rounded text-xs"
              >
                PC 5
              </button>
              <button
                onclick="window.midiDeviceSelector?.sendPC(10, 'PC 10')"
                class="py-2 px-2 bg-cyan-600 hover:bg-cyan-700 text-white rounded text-xs"
              >
                PC 10
              </button>
              <button
                onclick="window.midiDeviceSelector?.sendPC(20, 'PC 20')"
                class="py-2 px-2 bg-cyan-600 hover:bg-cyan-700 text-white rounded text-xs"
              >
                PC 20
              </button>
              <button
                onclick="window.midiDeviceSelector?.sendPC(50, 'PC 50')"
                class="py-2 px-2 bg-cyan-600 hover:bg-cyan-700 text-white rounded text-xs"
              >
                PC 50
              </button>
            </div>

            <div class="border-t border-slate-200 pt-4">
              <label class="block text-sm font-semibold text-slate-900 mb-2">
                PC Personalizado + C5:
              </label>
              <div class="flex gap-2">
                <input
                  type="number"
                  id="pc-number"
                  placeholder="PC #"
                  min="0"
                  max="127"
                  value="0"
                  class="flex-1 px-3 py-2 border-2 border-slate-200 rounded text-sm"
                />
                <button
                  onclick="window.midiDeviceSelector?.sendPCThenNote()"
                  class="flex-1 px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded text-sm font-semibold"
                >
                  Enviar PC + C5
                </button>
              </div>
              <p class="text-xs text-slate-500 mt-2">
                Envía PC personalizado, espera 100ms, luego envía C5 (MIDI 72)
              </p>
            </div>
          </div>
        </div>
        
    <!-- Brute Force Test Section -->
        <div class="bg-white rounded-lg shadow-lg p-6 mt-6">
          <h2 class="text-xl font-bold text-slate-900 mb-4">
            5. Brute Force - Test Todos los MIDI Messages
          </h2>
          <p class="text-sm text-slate-600 mb-4">
            Presiona FUNCTION en el piano y luego haz clic abajo. Se enviarán diferentes combinaciones de MIDI messages automáticamente.
            Observa en el piano y en midimonitor.com cuál activa el metrónomo.
          </p>

          <div class="space-y-3">
            <button
              onclick="window.midiDeviceSelector?.bruteForceAllNotes()"
              class="w-full py-3 px-4 bg-red-600 hover:bg-red-700 text-white rounded-lg font-semibold"
            >
              🔴 Brute Force: Enviar TODAS las notas (0-127)
            </button>

            <button
              onclick="window.midiDeviceSelector?.bruteForceAllCC()"
              class="w-full py-3 px-4 bg-orange-600 hover:bg-orange-700 text-white rounded-lg font-semibold"
            >
              🟠 Brute Force: Enviar TODOS los CC (0-127)
            </button>

            <button
              onclick="window.midiDeviceSelector?.bruteForceAllPC()"
              class="w-full py-3 px-4 bg-yellow-600 hover:bg-yellow-700 text-white rounded-lg font-semibold"
            >
              🟡 Brute Force: Enviar TODOS los PC (0-127)
            </button>

            <button
              onclick="window.midiDeviceSelector?.bruteForceSystemExclusive()"
              class="w-full py-3 px-4 bg-purple-600 hover:bg-purple-700 text-white rounded-lg font-semibold"
            >
              🟣 Brute Force: System Exclusive (SysEx)
            </button>

            <div class="border-t border-slate-200 pt-3 mt-3">
              <button
                onclick="window.midiDeviceSelector?.stopBruteForce()"
                class="w-full py-2 px-4 bg-slate-600 hover:bg-slate-700 text-white rounded-lg text-sm"
              >
                ⏹️ Detener Brute Force
              </button>
            </div>
          </div>

          <div class="mt-4 p-3 bg-yellow-50 border-l-4 border-yellow-500 rounded text-sm text-yellow-900">
            <strong>⚠️ Advertencia:</strong>
            El brute force enviará muchos mensajes MIDI. Esto puede tardar unos segundos. Mantén el log abierto para ver qué se envía.
          </div>
        </div>
        
    <!-- Control Change Test Section -->
        <div class="bg-white rounded-lg shadow-lg p-6 mt-6">
          <h2 class="text-xl font-bold text-slate-900 mb-4">6. Test Control Change (CC) Messages</h2>
          <p class="text-sm text-slate-600 mb-4">
            Prueba enviar diferentes Control Change (CC) messages para encontrar cuál activa el metrónomo.
            Abre midimonitor.com mientras pruebas para ver los mensajes MIDI.
          </p>

          <div class="space-y-3">
            <div class="grid grid-cols-2 lg:grid-cols-4 gap-2">
              <button
                onclick="window.midiDeviceSelector?.sendCC(7, 127, 'CC 7 (Volume)')"
                class="py-2 px-3 bg-orange-600 hover:bg-orange-700 text-white rounded text-xs"
              >
                CC 7 (Volume)
              </button>
              <button
                onclick="window.midiDeviceSelector?.sendCC(10, 64, 'CC 10 (Pan)')"
                class="py-2 px-3 bg-orange-600 hover:bg-orange-700 text-white rounded text-xs"
              >
                CC 10 (Pan)
              </button>
              <button
                onclick="window.midiDeviceSelector?.sendCC(64, 127, 'CC 64 (Sustain)')"
                class="py-2 px-3 bg-orange-600 hover:bg-orange-700 text-white rounded text-xs"
              >
                CC 64 (Sustain)
              </button>
              <button
                onclick="window.midiDeviceSelector?.sendCC(91, 127, 'CC 91 (Reverb)')"
                class="py-2 px-3 bg-orange-600 hover:bg-orange-700 text-white rounded text-xs"
              >
                CC 91 (Reverb)
              </button>
            </div>

            <div class="border-t border-slate-200 pt-4">
              <label class="block text-sm font-semibold text-slate-900 mb-2">CC Personalizado:</label>
              <div class="flex gap-2">
                <input
                  type="number"
                  id="cc-number"
                  placeholder="CC #"
                  min="0"
                  max="127"
                  value="7"
                  class="flex-1 px-3 py-2 border-2 border-slate-200 rounded text-sm"
                />
                <input
                  type="number"
                  id="cc-value"
                  placeholder="Value"
                  min="0"
                  max="127"
                  value="127"
                  class="flex-1 px-3 py-2 border-2 border-slate-200 rounded text-sm"
                />
                <button
                  onclick="window.midiDeviceSelector?.sendCustomCC()"
                  class="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded text-sm font-semibold"
                >
                  Enviar
                </button>
              </div>
            </div>
          </div>
        </div>
        
    <!-- Info Section -->
        <div class="mt-8 bg-blue-50 border-l-4 border-blue-500 p-6 rounded">
          <p class="text-sm text-blue-900 leading-relaxed">
            <span class="font-semibold">💡 Cómo usar:</span>
            <br /> 1. El piano debe estar conectado via USB MIDI a tu computadora <br />
            2. Haz clic en "Conectar a dispositivo seleccionado" <br />
            3. Prueba los botones para enviar MIDI Note On al piano <br />
            4. Abre midimonitor.com simultáneamente para ver qué MIDI se envía <br />
            5. Observa en el piano si responde a las diferentes notas
          </p>
        </div>
        
    <!-- Log Section -->
        <div class="mt-8 bg-white rounded-lg shadow-lg p-6">
          <h3 class="text-lg font-bold text-slate-900 mb-3">📊 Log</h3>
          <div
            id="midi-log"
            class="bg-slate-100 p-4 rounded text-sm font-mono max-h-64 overflow-y-auto"
          >
            <div class="text-slate-500">Log de eventos MIDI...</div>
          </div>
        </div>
      </div>
    </div>

    <script>
      // This script will be enhanced by the MidiDeviceSelector hook
    </script>
    """
  end
end
