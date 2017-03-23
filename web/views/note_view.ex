defmodule Notex.NoteView do
  use Notex.Web, :view

  def render("note.json", note) do
      %{id: note.id}
  end

  def render("error.json", note) do
      %{error: "errrrrrrr"}
  end
end
