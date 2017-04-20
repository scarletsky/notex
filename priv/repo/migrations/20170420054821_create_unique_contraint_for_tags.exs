defmodule Notex.Repo.Migrations.CreateUniqueContraintForTags do
  use Ecto.Migration

  def up do
    create unique_index(:tags, [:name])
  end

  def down do
    drop unique_index(:tags, [:name])
  end
end
