defmodule PollerPhxWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use PollerPhxWeb, :controller

  # This clause handles errors returned by Ecto's insert/update/delete.
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    # [ABOUT] 422 - Unprocessable Content: the request was well-formed but was unable to be followed due to semantic errors.
    |> put_status(422)
    |> put_view(PollerPhxWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  # This clause is an example of how to handle resources that cannot be found.
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(404)
    |> put_view(PollerPhxWeb.ErrorView)
    |> render(:"404")
  end
end
