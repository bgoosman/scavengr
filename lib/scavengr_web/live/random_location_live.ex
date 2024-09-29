defmodule ScavengrWeb.RandomLocationLive do
  # In Phoenix v1.6+ apps, the line is typically: use MyAppWeb, :live_view
  use Phoenix.LiveView

  alias Scavengr.{Repo}
  alias ScavengrWeb.Components.Notifications.Normal

  import Flashy

  def render(assigns) do
    ~H"""
    <div :if={assigns[:location]} class="p-4 z-10 absolute bottom-1 w-full bg-white">
      <div class="flex flex-col gap-2">
        <input type="hidden" name="location_id" value={@location.location_id} />
        <p>Find the prompt at this location.</p>
        <textarea placeholder="Type your answer here." />
        <div class="flex gap-1 w-full">
          <button phx-click="skip">Skip</button>
          <button phx-click="submit">Submit</button>
        </div>
      </div>
    </div>
    <img
      :if={assigns[:location]}
      src={"images/locations/#{@location.image}"}
      class="absolute top-0 left-0 w-full h-full object-cover z-0"
    />
    """
  end

  def mount(params, _session, socket) do
    if connected?(socket) do
      socket =
        if params["status"] == "success" do
          put_notification(socket, Normal.new(:info, "Message received."))
        else
          socket
        end

      {:ok, socket |> assign_next_location()}
    else
      {:ok, socket}
    end
  end

  def handle_params(params, uri, socket) do
    {:noreply, socket}
  end

  def handle_event("skip", _params, socket) do
    {:noreply, socket |> assign_next_location()}
  end

  def handle_event("submit", params, socket) do
    Scavengr.LocationResponse.changeset(%Scavengr.LocationResponse{}, params)
    |> Repo.insert()

    {:noreply,
     socket
     |> assign_next_location()
     |> put_notification(Normal.new(:info, "Message received."))}
  end

  def assign_next_location(socket) do
    location = Scavengr.LocationDb.get_random_location()

    socket
    |> assign(location: location)
  end
end
