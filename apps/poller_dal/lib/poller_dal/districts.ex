defmodule PollerDal.Districts do
  alias PollerDal.Repo
  alias PollerDal.Districts.District
  import Ecto.Query, warn: false

  def list_districts() do
    from(
      d in District,
      left_join: q in assoc(d, :questions),
      preload: [questions: q]
    )
    |> Repo.all()
  end

  def get_district!(id) do
    from(
      d in District,
      left_join: q in assoc(d, :questions),
      where: d.id == ^id,
      preload: [questions: q]
    )
    |> Repo.one!
  end

  def create_district(attrs) do
    %District{}
    |> District.changeset(attrs)
    |> Repo.insert()
  end

  def update_district(%District{} = district, attrs) do
    district
    |> District.changeset(attrs)
    |> Repo.update()
  end

  def delete_district(%District{} = district) do
    Repo.delete(district)
  end

end
