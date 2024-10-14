defmodule PollerPhxWeb.DistrictView do
  use PollerPhxWeb, :view
  alias PollerDal.Districts.District

  def render("index.json", %{districts: districts}) do
    %{"data" => render_many(districts, PollerPhxWeb.DistrictView, "district.json")}
  end

  def render("show.json", %{district: district}) do
    %{"data" => render_one(district, PollerPhxWeb.DistrictView, "district_with_questions.json")}
  end

  def render("district.json", %{district: %District{} = district}) do
    %{
      id: district.id,
      name: district.name,
      questions: render_many(district.questions, PollerPhxWeb.QuestionView, "question_ref.json")
    }
  end

  def render("district_with_questions.json", %{district: %District{} = district}) do
    %{
      id: district.id,
      name: district.name,
      questions: case district.questions do
        [%PollerDal.Questions.Question{} | _] ->
          render_many(district.questions, PollerPhxWeb.QuestionView, "question.json")

        # includes "%Ecto.Association.NotLoaded{} -> ..." clause
        _ -> []
      end
    }
  end

  def render("district_ref.json", %{district_id: district_id}) do
    %{
      href: Routes.district_url(PollerPhxWeb.Endpoint, :show, district_id)
      #     ------
      # PollerPhxWeb.Router.Helpers
    }
  end

end
