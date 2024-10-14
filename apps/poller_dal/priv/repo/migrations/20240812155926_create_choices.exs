defmodule PollerDal.Repo.Migrations.CreateChoices do
  use Ecto.Migration

  def change do
    create table("choices") do
      add :description, :string
      add :party, :integer
      add :votes, :integer
      add :question_id, references(:questions, on_delete: :delete_all)
                                             # ----------------------
                                             # if question is deleted all its associated
                                             # choices should be deleted
      timestamps()
    end

    create index("choices", [:question_id])
  end
end
