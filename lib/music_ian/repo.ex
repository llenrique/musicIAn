defmodule MusicIan.Repo do
  use Ecto.Repo,
    otp_app: :music_ian,
    adapter: Ecto.Adapters.Postgres
end
