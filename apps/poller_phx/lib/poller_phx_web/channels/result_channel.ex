defmodule PollerPhxWeb.ResultChannel do
  use PollerPhxWeb, :channel
  alias Poller.{PollServer, PubSub}
  require Logger

  @district_votes_update_event_name "district_votes_update"

  @impl true
  def join("district:" <> district_id, _params, socket) do
    case Integer.parse(district_id) do
      {id, ""} ->
        socket = assign(socket, :district_id, id)
        PubSub.subscribe_to_district(district_id)   #<== with this, ResultChannel processes
                                                    # become a PubSub subscriber

        if PollServer.alive?(id) do
          poll = PollServer.get_poll(id)
          {:ok, %{"id" => id, "latestVotes" => poll.votes}, socket}
          #     ------------------------------------------
          #                  reply object
        else
          {:ok, socket}
        end

      _ ->
        {:error, %{reason: "Invalid district!"}}
    end
  end

  @impl true
  def handle_info({@district_votes_update_event_name, choice_id, votes}, socket) do
    Logger.info("[ResultChannel] handle_info district_votes_update: choice_id:#{choice_id}, new vote: #{votes}")
    push(socket, district_votes_update_event_name(), %{choice_id: choice_id, votes: votes})
    {:noreply, socket}
  end

  @impl true
  def terminate(_reason, socket) do
    district_id = socket.assigns.district_id
    PubSub.unsubscribe_from_district(district_id)
    Logger.info("terminating #{district_id}")
  end

  def district_votes_update_event_name(), do: @district_votes_update_event_name

end
