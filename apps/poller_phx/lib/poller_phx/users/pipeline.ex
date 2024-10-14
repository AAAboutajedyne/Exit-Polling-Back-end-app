defmodule PollerPhx.Users.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :poller_phx,
    module: PollerPhx.Users.Guardian,
    error_handler: PollerPhx.Users.ErrorHandler

  ## if there is a session token, restrict it to an access token and validate it
  # plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}

  ## if there is an Authorization header (prefixed with `"Bearer "`), restrict it to an access token and validate it
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}

  ## load the user if either of the verifications worked
  plug Guardian.Plug.LoadResource, allow_blank: true
end
