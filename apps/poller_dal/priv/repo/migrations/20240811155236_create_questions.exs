defmodule PollerDal.Repo.Migrations.CreateQuestions do
  use Ecto.Migration

  def change do
    create table("questions") do
      add :description, :string

      add :district_id, references(:districts, on_delete: :delete_all)
                                             # ----------------------
                                             # if district is deleted all its associated
                                             # questions should be deleted
      timestamps()
    end

    create index("questions", [:district_id])
  end
end
