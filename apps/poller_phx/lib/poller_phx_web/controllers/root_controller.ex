defmodule PollerPhxWeb.RootController do
  use PollerPhxWeb, :controller
  alias PollerPhx.Users.Guardian

  def index(conn, _params) do
    user_data = Guardian.Plug.current_resource(conn)
    token = Guardian.Plug.current_token(conn)
    IO.puts("user_data: #{inspect user_data}, token: #{inspect token}")
    conn
    |> json(%{message: "Welcome to Exit polling APi"})
  end

end
