defmodule Notex.Repo.Migrations.CreateNote do
  use Ecto.Migration

  def change do
    create table(:notes) do
      add :title, :string
      add :content, :text
      add :creator_id, references(:users)
      add :is_secret, :boolean, default: false
      timestamps()
    end

  end
end
