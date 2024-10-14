defmodule PollerPhxWeb.Users.UserView do
  use PollerPhxWeb, :view
  alias PollerPhxWeb.Users.UserView
  alias PollerDal.Users.User

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: %User{} = user}) do
    %{
      id: user.id,
      email: user.email,
      admin: user.admin
    }
  end
end
