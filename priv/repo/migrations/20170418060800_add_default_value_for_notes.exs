defmodule Notex.Repo.Migrations.AddDefaultValue do
  use Ecto.Migration

  def up do
    alter table(:notes) do
      modify :title, :text, default: ""
      modify :content, :text, default: ""
    end

  end

  def down do
    alter table(:notes) do
      modify :title, :text, default: nil
      modify :content, :text, default: nil
    end
  end
end
