defmodule Notex.User do
  use Notex.Web, :model

  @required_fields ~w(email username password)

  schema "users" do
    field :email, :string
    field :username, :string
    field :password, :string
    field :is_authenticated, :boolean
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields)
    |> unique_constraint(:email)
    |> unique_constraint(:username)
  end
end
