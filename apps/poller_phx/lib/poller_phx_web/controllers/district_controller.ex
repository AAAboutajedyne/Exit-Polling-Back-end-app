defmodule PollerPhxWeb.DistrictController do
  use PollerPhxWeb, :controller
  alias PollerDal.Districts
  alias PollerDal.Districts.District

  action_fallback PollerPhxWeb.FallbackController

  def index(conn, _params) do
    districts = Districts.list_districts()
    render(conn, "index.json", districts: districts)
  end

  def show(conn, %{"id" => id}) do
    district = Districts.get_district!(id)
    render(conn, "show.json", district: district)
  end

  def create(conn, %{"district" => district_params}) do
    with {:ok, %District{} = district} <- Districts.create_district(district_params) do
      conn
      |> put_status(201)   # created
      |> put_resp_header("Location", Routes.district_url(conn, :show, district))
      |> render("show.json", district: district)
    end
  end

  def update(conn, %{"id" => id, "district" => district_params}) do
    district = Districts.get_district!(id)

    with {:ok, %District{} = district} <- Districts.update_district(district, district_params) do
      render(conn, "show.json", district: district)
    end
  end

  def delete(conn, %{"id" => id}) do
    district = Districts.get_district!(id)

    with {:ok, %District{}} <- Districts.delete_district(district) do
      send_resp(conn, 204, "")
    end
  end

end
