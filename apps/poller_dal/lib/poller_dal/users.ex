defmodule PollerDal.Users do
  alias PollerDal.Repo
  alias PollerDal.Users.User
  import Ecto.Query, warn: false

  def list_users(), do:
    Repo.all(User)

  def get_user!(user_id), do:
    Repo.get!(User, user_id)

  def get_user_by_email(email), do:
    Repo.get_by(User, email: String.downcase(email))

  def create_user(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  def put_admin(%User{} = user, admin \\ true) do
    user
    |> User.admin_changeset(%{admin: admin})
    |> Repo.update()
  end

  def authenticate(email, password) do
    user = get_user_by_email(email)
    cond do
      user && Argon2.verify_pass(password, user.password_hash) ->
        {:ok, user}

      user ->
        {:error, :bad_password}

      true ->
        {:error, :bad_email}
    end
  end

end
