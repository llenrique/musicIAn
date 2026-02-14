defmodule MusicIanWeb.MusicApiSocket do
  @moduledoc """
  Socket handler for /music_api WebSocket endpoint.
  Routes all connections to MusicApiChannel.
  """

  use Phoenix.Socket

  channel "music_api", MusicIanWeb.MusicApiChannel

  @impl true
  def connect(_params, socket, _connect_info) do
    {:ok, socket}
  end

  @impl true
  def id(_socket), do: nil
end
