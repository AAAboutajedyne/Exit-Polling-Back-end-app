defmodule PollerDal.Questions do
  alias PollerDal.Repo
  alias PollerDal.Questions.Question
  import Ecto.Query, warn: false

  def list_questions() do
    from(
      q in Question,
      join: d in assoc(q, :district),
      left_join: c in assoc(q, :choices),
      preload: [district: d, choices: c]
    )
    |> Repo.all
  end

  def list_questions_by_district_id(district_id) do
    from(
      q in Question,
      left_join: c in assoc(q, :choices),
      where: q.district_id == ^district_id,
      preload: [choices: c]
    )
    |> Repo.all()
  end

  def get_question!(question_id) do
    from(
      q in Question,
      join: d in assoc(q, :district),
      left_join: c in assoc(q, :choices),
      where: q.id == ^question_id,
      preload: [district: d, choices: c]
    )
    |> Repo.one!
  end

  def create_question(attrs) do
    %Question{}
    |> Question.changeset(attrs)
    |> Repo.insert()
  end

  def update_question(%Question{} = question, attrs) do
    question
    |> Question.changeset(attrs)
    |> Repo.update()
  end

  def delete_question(%Question{} = question) do
    Repo.delete(question)
  end

end
