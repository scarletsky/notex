defmodule Notex.Repo.Migrations.AddDefaultUsernameForUsers do
  use Ecto.Migration
  import Ecto.Query

  def up do
        from(u in Notex.User,
          update: [set: [username: fragment("substring(? from '^(.*\\?)@')", u.email)]])
        |> Notex.Repo.update_all([])
  end

  def down do
      Notex.Repo.update_all(Notex.User, set: [username: nil])
  end
end
