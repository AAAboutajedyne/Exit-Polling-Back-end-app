defmodule PollerPhxWeb.QuestionController do
  use PollerPhxWeb, :controller
  alias PollerDal.Questions
  alias PollerDal.Questions.Question

  action_fallback PollerPhxWeb.FallbackController

  # get "/questions"
  def index_all(conn, _params) do
    questions = Questions.list_questions()
    render(conn, "index.json", questions: questions)
  end

  # get "/districts/:district_id/questions"
  def index(conn, %{"district_id" => district_id}) do
    questions = Questions.list_questions_by_district_id(district_id)
    render(conn, "index.json", questions: questions)
  end

  # get "/questions/:id"
  def show(conn, %{"id" => id}) do
    question = Questions.get_question!(id)
    render(conn, "show.json", question: question)
  end

  # post "/districts/:district_id/questions"
  def create(conn, %{"district_id" => district_id, "question" => question_params}) do
    with {:ok, %Question{} = question} <- Questions.create_question(Map.put(question_params, "district_id", district_id)) do
      conn
      |> put_status(201)   # created
      |> put_resp_header("Location", Routes.question_url(PollerPhxWeb.Endpoint, :show, question.id))
      |> render("show.json", question: question)
    end
  end

  # put "/questions/:id"
  def update(conn, %{"id" => id, "question" => question_params}) do
    question = Questions.get_question!(id)

    with {:ok, %Question{} = question} <- Questions.update_question(question, question_params) do
      render(conn, "show.json", question: question)
    end
  end

  # delete "/questions/:id"
  def delete(conn, %{"id" => id}) do
    question = Questions.get_question!(id)

    with {:ok, %Question{}} <- Questions.delete_question(question) do
      send_resp(conn, 204, "")
    end
  end

end
