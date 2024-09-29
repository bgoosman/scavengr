defmodule Scavengr.LocationResponse do
  use Ecto.Schema
  import Ecto.Changeset

  schema "location_responses" do
    field :location_id, :string
    field :content, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(location_response, attrs) do
    location_response
    |> cast(attrs, [:location_id, :content])
    |> validate_required([:location_id, :content])
  end
end
