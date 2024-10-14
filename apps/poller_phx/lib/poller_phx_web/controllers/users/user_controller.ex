defmodule PollerPhxWeb.Users.UserController do
  use PollerPhxWeb, :controller
  alias PollerDal.Users

  action_fallback PollerPhxWeb.FallbackController

  def index(conn, _params) do
    users = Users.list_users()
    render(conn, "index.json", users: users)
  end

  def show(conn, %{"id" => id}) do
    user = Users.get_user!(id)
    render(conn, "show.json", user: user)
  end

end
