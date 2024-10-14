defmodule PollerPhxWeb.AuthController do
  use PollerPhxWeb, :controller
  alias PollerDal.Users
  alias PollerPhx.Users.Guardian

  def login(conn, %{"email" => email, "password" => password}) do
    Users.authenticate(email, password)
    |> login_reply(conn)
  end

  defp login_reply({:ok, user}, conn) do
    conn
    |> Guardian.Plug.sign_in(user, %{}, ttl: {10, :minute})
    |> put_status(201)
    |> then(fn conn ->
        json(conn, %{
          "token" => Guardian.Plug.current_token(conn)
      }) end)
  end

  defp login_reply({:error, :bad_email}, conn) do
    conn
    |> put_status(401)
    |> json(%{
      "errors" => %{
        "email" => ["bad email (not correct)"]
      }
    })
  end

  defp login_reply({:error, :bad_password}, conn) do
    conn
    |> put_status(401)
    |> json(%{
      "errors" => %{
        "password" => ["bad password (not correct)"]
      }
    })
  end

  defp login_reply({:error, _reason}, conn) do
    conn
    |> put_status(401)
    |> put_view(PollerPhxWeb.ErrorView)
    |> render(:"401")
  end

  def logout(conn, _params) do
    conn
    |> Guardian.Plug.sign_out()
    |> send_resp(201, "")
  end

end
