defmodule PollerPhxWeb.ChoiceView do
  use PollerPhxWeb, :view
  alias PollerPhxWeb.ChoiceView
  alias PollerDal.Choices.Choice

  def render("index.json", %{choices: choices}) do
    %{"data" => render_many(choices, ChoiceView, "choice.json")}
  end

  def render("show.json", %{choice: choice}) do
    %{"data" => render_one(choice, ChoiceView, "choice.json")}
  end

  def render("choice.json", %{choice: %Choice{} = choice}) do
    %{
      id: choice.id,
      description: choice.description,
      party: choice.party,
      votes: choice.votes,
      question: render_one(choice.question_id, PollerPhxWeb.QuestionView, "question_ref.json", as: :question_id),
    }
  end

  def render("choice_ref.json", %{choice: %Choice{} = choice}) do
    %{
      href: Routes.choice_url(PollerPhxWeb.Endpoint, :show, choice.id)
      #     ------
      # PollerPhxWeb.Router.Helpers
    }
  end

end
