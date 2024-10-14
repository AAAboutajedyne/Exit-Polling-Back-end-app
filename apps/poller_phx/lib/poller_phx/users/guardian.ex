defmodule PollerPhx.Users.Guardian do
  use Guardian, otp_app: :poller_phx
  # alias PollerDal.Users

  @impl Guardian
  def subject_for_token(user, _claims) do
    ## id and email
    # {:ok, %{"id" => to_string(user.id), "email" => user.email}}
    {:ok, to_string(user.id)}
  end

  @impl Guardian
  def resource_from_claims(%{"sub" => id}) do
    # user = Users.get_user!(id)
    {:ok, %{user_id: id}}
  rescue
    Ecto.NoResultsError -> {:error, :resource_not_found}
  end

end
