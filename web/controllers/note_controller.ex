defmodule Notex.NoteController do
  use Notex.Web, :controller

  require Logger

  alias Notex.Note
  alias Notex.Tag

  def index(conn, _params) do
    notes = Repo.all(Note)
    render(conn, "index.html", notes: notes)
  end

  def new(conn, _params) do
    changeset = Note.changeset(%Note{})
    conn
      |> assign(:changeset, changeset)
      |> render("new.html")
  end

  def create(conn, %{"note" => note_params}) do
    Logger.debug inspect note_params
    changeset = Note.changeset(%Note{}, note_params)

    case Repo.insert(changeset) do
      {:ok, note} ->
        note = create_note_tag(note, note_params["tag_ids"])
        conn
        |> put_flash(:info, "Note created successfully.")
        |> redirect(to: note_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end

  end

  defp create_note_tag(note, tag_ids) do
    query = from t in Tag,
      where: t.id in ^tag_ids,
      select: t

    tags = Repo.all(query)

    changeset = note
      |> Repo.preload(:tags)
      |> Ecto.Changeset.change()
      |> Ecto.Changeset.put_assoc(:tags, tags)

    case Repo.update(changeset) do
      {:ok, note} ->
        note
      {:error, changeset} ->
        render("error.json", changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    note = Repo.get!(Note, id)
    render(conn, "show.html", note: note)
  end

  def edit(conn, %{"id" => id}) do
    note = Repo.get!(Note, id) |> Repo.preload(:tags)
    changeset = Note.changeset(note)
    render(conn, "edit.html", note: note, changeset: changeset)
  end

  def update(conn, %{"id" => id, "note" => note_params}) do
    note = Repo.get!(Note, id) |> Repo.preload(:tags)
    changeset = Note.changeset(note, note_params)
      |> update_note_tags_association(note_params["tag_ids"])

    case Repo.update(changeset) do
      {:ok, note} ->
        conn
        |> put_flash(:info, "Note updated successfully.")
        |> redirect(to: note_path(conn, :show, note))
      {:error, changeset} ->
        render(conn, "edit.html", note: note, changeset: changeset)
    end
  end

  defp update_note_tags_association(changeset, tag_ids) do
    if tag_ids do
      tags = Repo.all(
        from t in Tag,
          where: t.id in ^tag_ids,
          select: t
      )
      Ecto.Changeset.put_assoc(changeset, :tags, tags)
    else
      changeset
    end
  end

  def delete(conn, %{"id" => id}) do
    note = Repo.get!(Note, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(note)

    conn
    |> put_flash(:info, "Note deleted successfully.")
    |> redirect(to: note_path(conn, :index))
  end
end
