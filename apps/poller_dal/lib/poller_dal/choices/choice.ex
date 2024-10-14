defmodule PollerDal.Choices.Choice do
  use Ecto.Schema
  alias PollerDal.Questions.Question
  import Ecto.Changeset

  schema "choices" do
    field :description, :string
    field :party, Ecto.Enum, values: [democrate: 0, republican: 1], default: :democrate
    field :votes, :integer, default: 0
    belongs_to :question, Question
    timestamps()
  end

  def changeset(choice, params) do
    choice
    |> cast(params, [:description, :party, :votes, :question_id])
    |> validate_required([:description])
    |> assoc_constraint(:question)
  end

end
