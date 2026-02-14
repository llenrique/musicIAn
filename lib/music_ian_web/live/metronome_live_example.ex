defmodule MusicIanWeb.MetronomeExampleLive do
  @moduledoc """
  Example LiveView for controlling Yamaha YDP-105 metronome via MIDI.

  This demonstrates how to use MusicIan.MIDI.MetronomeController
  to send MIDI commands to toggle, set tempo, beat, and volume of the metronome.

  To use this:
  1. Add route: `live "/metronome", MetronomeExampleLive`
  2. Connect Yamaha YDP-105 via MIDI USB
  3. Navigate to http://localhost:4000/metronome
  """

  use MusicIanWeb, :live_view

  alias MusicIan.MIDI.MetronomeController

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:is_connected, false)
     |> assign(:metronome_enabled, false)
     |> assign(:tempo, 120)
     |> assign(:beat_type, :four)
     |> assign(:volume, 80)
     |> assign(:midi_output, nil)
     |> assign(:status_message, nil)}
  end

  @impl true
  def handle_event("toggle_metronome", _params, socket) do
    case MetronomeController.toggle_metronome(socket.assigns.midi_output) do
      {:ok, message} ->
        {:noreply,
         socket
         |> put_flash(:info, "🎵 #{message}")
         |> assign(:metronome_enabled, !socket.assigns.metronome_enabled)}

      {:error, reason} ->
        {:noreply, put_flash(socket, :error, "Error: #{reason}")}
    end
  end

  @impl true
  def handle_event("set_tempo", %{"tempo" => tempo_str}, socket) do
    with {tempo, _} <- Integer.parse(tempo_str),
         {:ok, message} <- MetronomeController.set_tempo(socket.assigns.midi_output, tempo) do
      {:noreply,
       socket
       |> put_flash(:info, "⏱️ #{message}")
       |> assign(:tempo, tempo)}
    else
      _error ->
        {:noreply, put_flash(socket, :error, "Error al establecer tempo")}
    end
  end

  @impl true
  def handle_event("set_beat", %{"beat" => beat_str}, socket) do
    beat_type = String.to_atom(beat_str)

    case MetronomeController.set_beat(socket.assigns.midi_output, beat_type) do
      {:ok, message} ->
        {:noreply,
         socket
         |> put_flash(:info, "🎵 #{message}")
         |> assign(:beat_type, beat_type)}

      {:error, reason} ->
        {:noreply, put_flash(socket, :error, "Error: #{reason}")}
    end
  end

  @impl true
  def handle_event("set_volume", %{"volume" => volume_str}, socket) do
    with {volume, _} <- Integer.parse(volume_str),
         {:ok, message} <- MetronomeController.set_volume(socket.assigns.midi_output, volume) do
      {:noreply,
       socket
       |> assign(:volume, volume)}
    else
      _error ->
        {:noreply, put_flash(socket, :error, "Error al establecer volumen")}
    end
  end

  @impl true
  def handle_event("connect_midi", _params, socket) do
    # TODO: Implement actual MIDI device detection and connection
    # For now, this is a placeholder
    {:noreply,
     socket
     |> put_flash(:info, "MIDI device detection coming soon")
     |> assign(:is_connected, true)
     |> assign(:midi_output, nil)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-gradient-to-br from-slate-50 to-slate-100 p-8">
      <div class="max-w-2xl mx-auto">
        <!-- Header -->
        <div class="mb-8">
          <h1 class="text-4xl font-bold text-slate-900 mb-2">🎵 Control de Metrónomo</h1>
          <p class="text-slate-600">Yamaha YDP-105 via MIDI</p>
        </div>

        <!-- Status Card -->
        <div class="bg-white rounded-lg shadow-lg p-6 mb-6">
          <div class="flex items-center justify-between mb-4">
            <span class="text-lg font-semibold text-slate-900">Estado de Conexión</span>
            <span class={[
              "text-sm font-bold px-4 py-2 rounded-full",
              if(@is_connected, do: "bg-green-100 text-green-700", else: "bg-red-100 text-red-700")
            ]}>
              <%= if @is_connected, do: "🎹 Conectado", else: "❌ No conectado" %>
            </span>
          </div>

          <button
            phx-click="connect_midi"
            disabled={@is_connected}
            class={[
              "w-full py-3 px-6 rounded-lg font-semibold transition-all",
              if(@is_connected,
                do: "bg-slate-200 text-slate-400 cursor-not-allowed",
                else: "bg-blue-600 hover:bg-blue-700 text-white cursor-pointer"
              )
            ]}
          >
            <%= if @is_connected, do: "✓ Conectado", else: "Detectar Dispositivo MIDI" %>
          </button>
        </div>

        <!-- Metronome Status -->
        <div class="bg-white rounded-lg shadow-lg p-6 mb-6">
          <div class="flex items-center justify-between mb-6">
            <span class="text-lg font-semibold text-slate-900">Estado del Metrónomo</span>
            <span class={[
              "text-lg font-bold",
              if(@metronome_enabled, do: "text-green-600", else: "text-slate-400")
            ]}>
              <%= if @metronome_enabled, do: "🎵 Activo", else: "⏸️ Inactivo" %>
            </span>
          </div>

          <button
            phx-click="toggle_metronome"
            disabled={!@is_connected}
            class={[
              "w-full py-3 px-6 rounded-lg font-semibold transition-all text-white",
              if(@is_connected,
                do: if(@metronome_enabled,
                  do: "bg-red-600 hover:bg-red-700",
                  else: "bg-green-600 hover:bg-green-700"
                ),
                else: "bg-slate-200 text-slate-400 cursor-not-allowed"
              )
            ]}
          >
            <%= if @metronome_enabled, do: "⏹️ Detener", else: "▶️ Iniciar" %>
          </button>
        </div>

        <!-- Controls -->
        <div class="bg-white rounded-lg shadow-lg p-6 space-y-6">
          <!-- Tempo Control -->
          <div>
            <label class="block text-sm font-semibold text-slate-900 mb-3">
              Tempo: <span class="text-purple-600 text-lg"><%= @tempo %> BPM</span>
            </label>
            <input
              type="range"
              min="30"
              max="300"
              value={@tempo}
              phx-change="set_tempo"
              name="tempo"
              disabled={!@is_connected}
              class="w-full h-3 bg-slate-200 rounded-lg appearance-none cursor-pointer disabled:opacity-50 disabled:cursor-not-allowed accent-purple-600"
            />
            <div class="flex justify-between text-xs text-slate-500 mt-2">
              <span>30 BPM</span>
              <span>300 BPM</span>
            </div>
          </div>

          <!-- Beat Selection -->
          <div>
            <label class="block text-sm font-semibold text-slate-900 mb-3">Compás</label>
            <select
              phx-change="set_beat"
              name="beat"
              disabled={!@is_connected}
              class="w-full px-4 py-3 text-sm border-2 border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-purple-500 focus:border-transparent disabled:opacity-50 disabled:cursor-not-allowed"
            >
              <option value="single" selected={@beat_type == :single}>1/4 - Un tiempo</option>
              <option value="two" selected={@beat_type == :two}>2/4 - Dos tiempos</option>
              <option value="three" selected={@beat_type == :three}>3/4 - Tres tiempos</option>
              <option value="four" selected={@beat_type == :four}>4/4 - Cuatro tiempos</option>
              <option value="six_eight" selected={@beat_type == :six_eight}>6/8 - Seis ocho</option>
            </select>
          </div>

          <!-- Volume Control -->
          <div>
            <label class="block text-sm font-semibold text-slate-900 mb-3">
              Volumen: <span class="text-purple-600"><%= round(@volume / 127 * 100) %>%</span>
            </label>
            <input
              type="range"
              min="0"
              max="127"
              value={@volume}
              phx-change="set_volume"
              name="volume"
              disabled={!@is_connected}
              class="w-full h-3 bg-slate-200 rounded-lg appearance-none cursor-pointer disabled:opacity-50 disabled:cursor-not-allowed accent-purple-600"
            />
          </div>
        </div>

        <!-- Info Section -->
        <div class="mt-8 bg-blue-50 border-l-4 border-blue-500 p-6 rounded">
          <p class="text-sm text-blue-900 leading-relaxed">
            <span class="font-semibold">💡 Nota:</span> Estos controles envían comandos MIDI a tu piano
            Yamaha YDP-105. El piano debe estar conectado via USB MIDI para que funcionen.
            <br /><br />
            <span class="text-xs">
              Cómo funciona: Se envían "Note On" messages que el piano interpreta como
              pulsaciones del botón FUNCTION + teclas específicas.
            </span>
          </p>
        </div>

        <% # Show connection warning if not connected %>
        <%= if !@is_connected do %>
          <div class="mt-8 bg-red-50 border-l-4 border-red-500 p-6 rounded">
            <p class="text-sm text-red-900 leading-relaxed">
              <span class="font-semibold">⚠️ No conectado:</span> Por favor conecta tu Yamaha YDP-105 via
              USB MIDI y haz clic en "Detectar Dispositivo MIDI" arriba.
            </p>
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end
