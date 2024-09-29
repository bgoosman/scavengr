defmodule Scavengr.Repo do
  use Ecto.Repo,
    otp_app: :scavengr,
    adapter: Ecto.Adapters.Postgres
end
