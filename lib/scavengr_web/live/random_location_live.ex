defmodule ScavengrWeb.RandomLocationLive do
  # In Phoenix v1.6+ apps, the line is typically: use MyAppWeb, :live_view
  use Phoenix.LiveView

  alias Scavengr.{Repo}
  alias ScavengrWeb.Components.Notifications.Normal

  import PetalComponents.Input
  import Flashy

  def render(assigns) do
    ~H"""
    <div :if={assigns[:form]} class="p-4 z-10 absolute bottom-1 w-full bg-white">
      <.form for={@form} phx-submit="submit" class="flex flex-col gap-2">
        <input type="hidden" name="location_id" value={@form.params["location_id"]} />
        <p>Find the prompt at this location.</p>
        <.input type="textarea" placeholder="Type your answer here." field={@form[:content]} />
        <div class="flex gap-1 w-full">
          <button phx-click="skip" class="p-4 bg-yellow-500 rounded-lg">Skip</button>
          <input type="submit" value="Save" class="p-4 bg-green-500 grow rounded-lg" />
        </div>
      </.form>
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
    |> assign(
      :form,
      %{"location_id" => location.id, "content" => ""}
      |> to_form()
    )
  end
end
