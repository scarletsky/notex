defmodule Notex.NoteTag do
  use Notex.Web, :model

  @primary_key false
  schema "notes_tags" do
    belongs_to :note, Note
    belongs_to :tag, Tag
    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> Ecto.Changeset.cast(params, [:note_id, :tag_id])
    |> Ecto.Changeset.validate_required([:note_id, :tag_id])
  end
end