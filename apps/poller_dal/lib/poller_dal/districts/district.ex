defmodule PollerDal.Districts.District do
  use Ecto.Schema
  alias PollerDal.Questions.Question
  import Ecto.Changeset

  schema "districts" do
    field :name, :string
    has_many :questions, Question, on_delete: :delete_all
    timestamps()
  end

  def changeset(district, params) do
    district
    |> cast(params, [:name])
    |> validate_required([:name])
    |> validate_length(:name, min: 2)
  end

end
