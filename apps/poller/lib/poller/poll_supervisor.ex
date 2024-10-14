defmodule Poller.PollSupervisor do
  use DynamicSupervisor
  alias Poller.PollServer

  def start_link(init_args) do
    DynamicSupervisor.start_link(__MODULE__, init_args, name: __MODULE__)
  end

  def start_poll(district_id) do
    spec = {PollServer, district_id}

    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  #---- Callbacks ------------------------------
  @impl true
  def init(_init_args) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

end
