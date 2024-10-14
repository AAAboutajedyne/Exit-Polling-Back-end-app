defmodule PollerPhxWeb.ChoiceController do
  use PollerPhxWeb, :controller
  alias PollerDal.Choices
  alias PollerDal.Choices.Choice
  alias Poller.PollSupervisor
  alias Poller.PollServer

  action_fallback PollerPhxWeb.FallbackController

  # get "/choices"
  def index_all(conn, _params) do
    choices = Choices.list_choices()
    render(conn, "index.json", choices: choices)
  end

  # get "/questions/:question_id/choices"
  def index(conn, %{"question_id" => question_id}) do
    choices = Choices.list_choices_by_question_id(question_id)
    render(conn, "index.json", choices: choices)
  end

  # get "/choices/:id"
  def show(conn, %{"id" => id}) do
    choice = Choices.get_choice!(id)
    render(conn, "show.json", choice: choice)
  end

  # post "/questions/:question_id/choices"
  def create(conn, %{"question_id" => question_id, "choice" => choice_params}) do
    with {:ok, %Choice{} = choice} <- Choices.create_choice(Map.put(choice_params, "question_id", question_id)) do
      conn
      |> put_status(201)   # created
      |> put_resp_header("Location", Routes.choice_url(conn, :show, choice))
      |> render("show.json", choice: choice)
    end
  end

  # put "/choices/:id"
  def update(conn, %{"id" => id, "choice" => choice_params}) do
    choice = Choices.get_choice!(id)

    with {:ok, %Choice{} = choice} <- Choices.update_choice(choice, choice_params) do
      render(conn, "show.json", choice: choice)
    end
  end

  # delete "/choices/:id"
  def delete(conn, %{"id" => id}) do
    choice = Choices.get_choice!(id)

    with {:ok, %Choice{}} <- Choices.delete_choice(choice) do
      send_resp(conn, 204, "")
    end
  end


  # put "/districts/:district_id/choices/:choice_id"
  def vote(conn, %{"district_id" => district_id, "choice_id" => choice_id}) do
    district_id = String.to_integer(district_id)
    choice_id = String.to_integer(choice_id)
    start_poll(district_id)
    PollServer.vote(district_id, choice_id)

    # [ALTERNATIVE] we're using Poller.PubSub instead of using
    # Phoenix native PubSub
    # poll = PollServer.vote(district_id, choice_id)
    # PollerPhxWeb.Endpoint.broadcast!(
    #   "district:" <> Integer.to_string(district_id),
    #   PollerPhxWeb.ResultChannel.district_votes_update_event_name(),
    #   %{choice_id: choice_id, votes: poll.votes[choice_id]}
    # )

    send_resp(conn, 204, "")
  end

  defp start_poll(district_id) do
    unless PollServer.alive?(district_id) do
      PollSupervisor.start_poll(district_id)
    end
  end

end
