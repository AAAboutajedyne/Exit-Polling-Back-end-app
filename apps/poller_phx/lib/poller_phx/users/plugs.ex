defmodule PollerPhx.Users.Plugs do
  import Plug.Conn
  import Phoenix.Controller
  alias PollerDal.Users

  def valid_user(conn, _opts) do
    user_data = Guardian.Plug.current_resource(conn)
    user = Users.get_user!(user_data.user_id)
    assign(conn, :current_user, user)
  rescue
    _ ->
      conn
      |> put_status(401)
      |> json(%{
        "message" => "Unauthorized/unauthenticated - not valid user !"
      })
      |> halt()

  end

  def admin_user(conn, _opts) do
    cond do
      conn.assigns.current_user && conn.assigns.current_user.admin ->
        conn
      true ->
        conn
        |> put_status(403)
        |> json(%{
          "message" => "Forbidden - 'admin' authorization required to acces this resource!"
        })
        |> halt()
    end
  end


end
