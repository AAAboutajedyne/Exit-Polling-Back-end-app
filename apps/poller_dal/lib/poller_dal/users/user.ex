
defmodule PollerDal.Users.User do
  alias Ecto.Changeset
  use Ecto.Schema
  import Ecto.Changeset

  @doc """
    + users:
      . admin@gmail.com && pass
      . aaayoub@gmail.com && pass
  """

  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
                            # -------------
                            # transient field, which is
                            # not persisted to the database
    field :password_hash, :string
    field :admin, :boolean, default: false

    timestamps()
  end

  def registration_changeset(user, params) do
    user
    |> cast(params, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_length(:password, min: 4)
    |> downcase_email()
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  def admin_changeset(user, params) do
    user
    |> cast(params, [:admin])
  end

  defp downcase_email(changeset) do
    case get_field(changeset, :email) do
      nil -> changeset
      email -> put_change(changeset, :email, String.downcase(email))
    end
  end

  defp put_password_hash(%Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, %{password_hash: Argon2.hash_pwd_salt(password)})
  end

  defp put_password_hash(changeset), do: changeset



end
