defmodule Notex.Router do
  use Notex.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Notex do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    resources "/registrations", RegistrationController, only: [:index, :create]
    get  "/login", SessionController, :index
    post "/login", SessionController, :create
    delete "/logout", SessionController, :delete

    resources "/notes", NoteController
    resources "/tags", TagController, except: [:new, :edit]
  end

  # Other scopes may use custom stacks.
  # scope "/api", Notex do
  #   pipe_through :api
  # end
end
