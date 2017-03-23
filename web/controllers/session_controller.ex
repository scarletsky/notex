defmodule Notex.SessionController do
  use Notex.Web, :controller
  alias Notex.User

  def logged_in?(conn), do: !!current_user(conn)

  def current_user(conn) do
    id = Plug.Conn.get_session(conn, :current_user)
    if id, do: Notex.Repo.get(User, id)
  end

  def index(conn, _params) do
    render conn, "login.html"
  end

  def create(conn, %{"session" => session_params}) do
    case login(session_params) do
      {:ok, user} ->
        conn
        |> put_session(:current_user, user.id)
        |> put_flash(:info, "Logged in.")
        |> redirect(to: "/")
      {:error} ->
        conn
        |> put_flash(:info, "Login failed")
        |> render("login.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session("current_user")
    |> put_flash(:info, "Logouted.")
    |> redirect(to: "/")
  end

  defp authenticate(user, password) do
    case user do
      nil -> false
      _   -> Comeonin.Bcrypt.checkpw(password, user.password)
    end
  end

  defp login(params) do
    user = Notex.Repo.get_by(User, email: params["email"])
    case authenticate(user, params["password"]) do
      true -> {:ok, user}
      _    -> :error
    end
  end
end