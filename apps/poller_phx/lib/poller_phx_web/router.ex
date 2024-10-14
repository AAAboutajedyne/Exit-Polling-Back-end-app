defmodule PollerPhxWeb.Router do
  use PollerPhxWeb, :router
  import PollerPhx.Users.Plugs

  pipeline :api do
    plug :accepts, ["json"]
    # plug :fetch_session
  end

  pipeline :auth do
    plug PollerPhx.Users.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/auth", PollerPhxWeb do
    pipe_through [:api, :auth]

    post "/login", AuthController, :login
    post "/logout", AuthController, :logout
  end

  scope "/", PollerPhxWeb do
    pipe_through [:api, :auth]

    get "/", RootController, :index
  end

  scope "/api", PollerPhxWeb.Users, as: :users do
    pipe_through :api

    resources "/users", UserController, only: [:index, :show]
  end

  scope "/api", PollerPhxWeb do
    pipe_through [:api, :auth]

    resources "/districts", DistrictController, only: [:index, :show] do
    # Or
    # scope "/districts" do
    #   get "/", DistrictController, :index     ##[USED_BY] React app
    #   get "/:id", DistrictController, :show
    # end

      resources "/questions", QuestionController, only: [:index]
      # Or
      # get  "/districts/:district_id/questions", QuestionController, :index  ##[USED_BY] React app
    end

    resources "/questions", QuestionController, only: [:show] do
    # Or
    # get "/questions/:id", QuestionController, :show
      resources "/choices", ChoiceController, only: [:index]
      # Or
      # get "/questions/:question_id/choices", ChoiceController, :index   ##[USED_BY] React app
    end

    get "/choices/:id", ChoiceController, :show

    # to get all questions in all districts
    get "/questions", QuestionController, :index_all

    # to get all choices in all questions
    get "/choices", ChoiceController, :index_all
  end

  #-- admin protected resources -----------------------------------------
  scope "/api", PollerPhxWeb do
    pipe_through [:api, :auth,    :ensure_auth,     :valid_user,      :admin_user]
    #                   -----     ------------      -----------       -----------
    #             get token from  ensures we got   searches user      ensures the searched
    #             authorization   a valid token    from jwt resource  user is an admin user
    #             header                           user id
    # pipe_through [:api]

    resources "/districts", DistrictController, only: [:create, :update, :delete] do
    # Or
    # scope "/districts" do
    #   post "/", DistrictController, :create
    #   put "/:id", DistrictController, :update
    #   delete "/:id", DistrictController, :delete
    # end

      resources "/questions", QuestionController, only: [:create]
      # Or
      # post "/districts/:district_id/questions", QuestionController, :create
    end

    resources "/questions", QuestionController, only: [:update, :delete] do
    # Or
    # put "/questions/:id", QuestionController, :update
    # delete "/questions/:id", QuestionController, :delete

      resources "/choices", ChoiceController, only: [:create]
      # Or
      # post "/questions/:question_id/choices", ChoiceController, :create
    end

    resources "/choices", ChoiceController, only: [:update, :delete]
    # Or
    # put "/choices/:id", ChoiceController :update
    # delete "/choices/:id", ChoiceController :delete

  end


  #-- valid user protectd resources ----------------
  scope "/api", PollerPhxWeb do
    pipe_through [:api, :auth,    :ensure_auth,     :valid_user]
    #                   -----     ------------      -----------
    #             get token from  ensures we got   searches user
    #             authorization   a valid token    from jwt resource
    #             header                           user id

    put "/districts/:district_id/choices/:choice_id", ChoiceController, :vote
  end




  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: PollerPhxWeb.Telemetry
    end
  end
end
