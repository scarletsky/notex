defmodule Notex.Repo.Migrations.AddUniqueIndexForUsers do
  use Ecto.Migration

  def up do
    create unique_index(:users, [:email])
    create unique_index(:users, [:username])
  end

  def down do
    drop unique_index(:users, [:email])
    drop unique_index(:users, [:username])
  end

end
