defmodule MusicIan.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MusicIanWeb.Telemetry,
      MusicIan.Repo,
      {DNSCluster, query: Application.get_env(:music_ian, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: MusicIan.PubSub},
      # Start a worker by calling: MusicIan.Worker.start_link(arg)
      # {MusicIan.Worker, arg},
      # Start to serve requests, typically the last entry
      MusicIanWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MusicIan.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MusicIanWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
