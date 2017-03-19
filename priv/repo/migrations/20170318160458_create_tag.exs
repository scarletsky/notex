defmodule Notex.Repo.Migrations.CreateTag do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :name, :string
      add :alias, {:array, :string}
      add :creator_id, references(:users)
      timestamps()
    end

  end
end
