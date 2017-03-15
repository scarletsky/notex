defmodule Notex.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :username, :string
      add :password, :string
      add :is_authenticated, :boolean, default: false
      timestamps()
    end

  end
end
