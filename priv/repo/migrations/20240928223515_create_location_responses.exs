defmodule Scavengr.Repo.Migrations.CreateLocationResponses do
  use Ecto.Migration

  def change do
    create table(:location_responses) do
      add :location_id, :string
      add :content, :string

      timestamps(type: :utc_datetime)
    end
  end
end
