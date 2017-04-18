defmodule Notex.TagController do
  use Notex.Web, :controller

  require Logger

  alias Notex.Tag
  alias Notex.User

  plug Notex.Plug.Authenticate when action in [:create, :update, :delete]

  def index(conn, tag_params) do
    query = from t in Tag,
      where: like(t.name, ^"%#{tag_params["name"]}%"),
      select: t
    tags = Repo.all query
    render(conn, "index.json", tags: tags)
  end

  def create(conn, %{"tag" => tag_params}) do
    tag_params = Map.put(tag_params, "creator_id", get_session(conn, :current_user))
    changeset = Tag.changeset(%Tag{}, tag_params)

    case Repo.insert(changeset) do
      {:ok, tag} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", tag_path(conn, :show, tag))
        |> render("show.json", tag: tag)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Notex.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    tag = Repo.get!(Tag, id)
    render(conn, "show.json", tag: tag)
  end

  def update(conn, %{"id" => id, "tag" => tag_params}) do
    tag = Repo.get!(Tag, id)
    changeset = Tag.changeset(tag, tag_params)

    case Repo.update(changeset) do
      {:ok, tag} ->
        render(conn, "show.json", tag: tag)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Notex.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    tag = Repo.get!(Tag, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(tag)

    send_resp(conn, :no_content, "")
  end
end
