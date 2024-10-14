# Poller
- maintains in-memory state for the app.

- When an Exit poll is conducted, the results of the poll is stored in **PollServer(GenServer)**.
  - each district' poll is maintained by a **PollServer(GenServer)** instance; a **PollServer** stores a district' poll related struct.
- **PollSupervisor** behaves as **DynamicSupervisor**, and starts new PollServer instances on-demand by calling **start_poll/1** public function.

- **PollServers(GenServer)** and **PollSupervisor(Supervisor)** in this project allow the app to be very ***responsive*** and ***highly-concurrent***, because we're storing polling data in-memory which is orders of magnitude faster than having to constantly interact with the database.

- each **PollServer** instance periodically saves its poll' choices votes to the database. The poller project still interact with the database via **PollerDal** project, but in a way that minimizes the risk of overwhelming the database.

- Note: Questions and choices data need to be set before election day in a database (except for votes).

## Dependencies

The Poller project needs PubSub lib, to broadcast choice' votes update event when a vote is performed.

## Why not using Phoenix default PubSub instance ?

Indeed, the PollerPhx project already has a default PubSub instance in its application supervision tree. This instance is used internally by phoenix and we could use it if we decided to broadcast the votes update event from the PollerPhxWeb.ChoiceController.vote/2 action using PollerPhxWeb.Endpoint.broadcast/3 like so:

  ```Elixir
  # within PollerPhxWeb.ChoiceController.vote/2 controller' action
  PollerPhxWeb.Endpoint.broadcast!(
    "district:" <> Integer.to_string(district_id),
    "district_votes_update",
    %{choice_id: choice_id, votes: poll.votes[choice_id]}
  )

  # within PollerPhxWeb.ResultChannel
  @impl true
  def handle_info({"district_votes_update", choice_id, votes}, socket) do
    # ... here we hande the broadcasted message
  end
  ```

But, our design decision regarding Publishing/Subscribing votes changes is biased towards PollServer, which represents the source of truth. So, a choice' votes updated event is broadcasted from the corresponding PollServer as a result of a user vote, initiated by PollerPhxWeb.ChoiceController.vote/2 action. This is done by the phoenix_pubsub lib.


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `poller` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:poller, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/poller>.

