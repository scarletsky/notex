defmodule Notex.NoteView do
  use Notex.Web, :view

  def render("note.json", note) do
    %{id: note.id}
  end

  def render("error.json", note) do
    %{error: "errrrrrrr"}
  end

  def is_owner(conn, note) do
    Plug.Conn.get_session(conn, :current_user) == note.creator_id
  end
end
