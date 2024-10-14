defmodule PollerPhxWeb.QuestionView do
  use PollerPhxWeb, :view
  alias PollerPhxWeb.QuestionView
  alias PollerDal.Questions.Question

  def render("index.json", %{questions: questions}) do
    %{"data" => render_many(questions, QuestionView, "question.json")}
  end

  def render("show.json", %{question: question}) do
    %{"data" => render_one(question, QuestionView, "question_with_choices.json")}
  end

  def render("question.json", %{question: %Question{} = question}) do
    %{
      id: question.id,
      description: question.description,
      district: render_one(question.district_id, PollerPhxWeb.DistrictView, "district_ref.json", as: :district_id),
      choices: case question.choices do
        [%PollerDal.Choices.Choice{} | _] ->
          render_many(question.choices, PollerPhxWeb.ChoiceView, "choice_ref.json")
        # includes "%Ecto.Association.NotLoaded{} -> ..." clause
        _ -> []
      end

      # district:
      #   case question.district do
      #     %District{} -> render_one(question.district, DistrictView, "district.json")

      #     ## includes "%Ecto.Association.NotLoaded{} -> ..." clause
      #     _ -> nil
      #   end

      # choices: question.choices
    }
  end

  def render("question_with_choices.json", %{question: %Question{} = question}) do
    %{
      id: question.id,
      description: question.description,
      district: render_one(question.district_id, PollerPhxWeb.DistrictView, "district_ref.json", as: :district_id),
      choices: case question.choices do
        [%PollerDal.Choices.Choice{} | _] ->
          render_many(question.choices, PollerPhxWeb.ChoiceView, "choice.json")
        _ -> []
      end
    }
  end

  def render("question_ref.json", %{question: %Question{} = question}) do
    %{
      href: Routes.question_url(PollerPhxWeb.Endpoint, :show, question.id)
      #     ------
      # PollerPhxWeb.Router.Helpers
    }
  end

  def render("question_ref.json", %{question_id: question_id}) do
    %{
      href: Routes.question_url(PollerPhxWeb.Endpoint, :show, question_id)
      #     ------
      # PollerPhxWeb.Router.Helpers
    }
  end


end
