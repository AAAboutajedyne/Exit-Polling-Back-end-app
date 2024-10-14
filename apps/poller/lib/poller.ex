defmodule Poller do
  use Application
  alias Poller.PollSupervisor

  @impl true
  def start(_type, _args) do
    children = [
      PollSupervisor,
      {Phoenix.PubSub, name: Poller.PubSub.server_name()}
    ]

    Supervisor.start_link(children, [
      strategy: :one_for_one,
      name: Poller.AppSupervisor
    ])
  end
end
