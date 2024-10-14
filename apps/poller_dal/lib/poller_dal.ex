defmodule PollerDal do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PollerDal.Repo
    ]

    Supervisor.start_link(children, [
      strategy: :one_for_one,
      name: PollerDal.App_Supervisor
    ])
  end
end
