defmodule Notex.Repo.Migrations.CreateNotesTags do
  use Ecto.Migration

  def change do
    create table(:notes_tags, primary_key: false) do
      add :note_id, references(:notes, on_delete: :delete_all)
      add :tag_id, references(:tags, on_delete: :delete_all)
      timestamps()
    end
  end
end
