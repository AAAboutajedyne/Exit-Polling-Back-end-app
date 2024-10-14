defmodule PollerDal.Questions.Question do
  use Ecto.Schema
  alias PollerDal.Choices.Choice
  alias PollerDal.Districts.District
  import Ecto.Changeset

  schema "questions" do
    field :description, :string
    has_many :choices, Choice, on_delete: :delete_all
    belongs_to :district, District

    timestamps()
  end

  def changeset(question, params) do
    question
    |> cast(params, [:description, :district_id])
    |> validate_required([:description])
    |> assoc_constraint(:district)
  end

end
