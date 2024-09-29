defmodule Scavengr.LocationDb do
  use GenServer

  def start_link([]) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(_) do
    locations = [
      %{
        id: "a",
        prompt: "Write a sentence.",
        image: "IMG_4565.jpg"
      },
      %{
        id: "b",
        prompt: "Tell a secret.",
        image: "IMG_4566.jpg"
      },
      %{
        id: "c",
        prompt: "What is your favorite color?",
        image: "IMG_4567.jpg"
      }
    ]
    {:ok, locations}
  end

  def get_random_location() do
    GenServer.call(__MODULE__, :get_random_location)
  end

  @impl true
  def handle_call(:get_random_location, _from, locations) do
    random_index = Enum.random(0..(length(locations) - 1))
    {:reply, locations |> Enum.at(random_index), locations}
  end
end
