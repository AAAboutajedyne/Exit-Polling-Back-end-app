defmodule PollerPhx.Users.ErrorHandler do
  @behaviour Guardian.Plug.ErrorHandler
  import Plug.Conn
  import Phoenix.Controller

  def auth_error(conn, { _type, _reason }, _opts) do
    # body = to_string(type)
    conn
    |> put_status(401)
    |> json(%{
      # "message" => body
      "message" => "Unauthorized/unauthenticated - the user does not provide valid authentication credentials for the target resource."
    })
  end


end
