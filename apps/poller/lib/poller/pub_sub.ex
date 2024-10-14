
defmodule Poller.PubSub do
  alias Phoenix.PubSub
  @server_name :poller
  @district_votes_update_event_name "district_votes_update"

  @moduledoc """
    this module uses phoenix_pubsub lib, to broadcast choice' votes updated event
    from the corresponding PollServer as a result of a user vote, initiated by PollerPhxWeb.ChoiceController.vote/2 action

    iex> alias Poller.PubSub
    iex> Poller.PubSub

    iex> PubSub.subscribe_to_district 1
    :ok
    iex> PubSub.broadcast_district_votes(1, 2, 50)
    :ok
    iex> flush()
    {:district_votes_update, 2, 50}
    :ok

    iex> PubSub.unsubscribe_from_district 1
    :ok
    iex> PubSub.broadcast_district_votes(1, 2, 50)
    :ok
    iex> flush()
    :ok
  """

  def district_topic(district_id), do: "district:#{district_id}"

  def subscribe_to_district(district_id) do
    topic = district_topic(district_id)
    PubSub.subscribe(server_name(), topic)  #<== subscribes the caller to
                                            # the PubSub provided topic
  end

  def unsubscribe_from_district(district_id) do
    topic = district_topic(district_id)
    PubSub.unsubscribe(server_name(), topic)  #<== unsubscribes the caller from
                                              # the PubSub provided topic
  end

  def broadcast_district_votes(district_id, choice_id, new_votes) do
    topic = district_topic(district_id)
    PubSub.broadcast(           #<== broadcasts message on given topic
      server_name(),            # across the whole cluster
      topic,
      {district_votes_update_event_name(), choice_id, new_votes}
    )
  end

  def server_name(), do: @server_name
  def district_votes_update_event_name(), do: @district_votes_update_event_name
end
