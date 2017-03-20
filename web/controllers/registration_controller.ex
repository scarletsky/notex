defmodule Notex.RegistrationController do
  use Notex.Web, :controller
  alias Notex.User
  import Ecto.Changeset, only: [put_change: 3]

  def index(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    case register(changeset) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Your account was created")
        |> redirect(to: "/")
      {:error, changeset} ->
        conn
        |> put_flash(:info, "Unabled to create account")
        |> render("index.html", changeset: changeset)
    end
  end

  defp register(changeset) do
    changeset
      |> put_change(:password, Comeonin.Bcrypt.hashpwsalt(changeset.params["password"]))
      |> Notex.Repo.insert()
  end

end