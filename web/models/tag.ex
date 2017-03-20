defmodule Notex.Tag do
  use Notex.Web, :model

  schema "tags" do
    field :name, :string
    field :aliases, {:array, :string}
    field :creator_id, :integer
    many_to_many :notes, Notex.Note, join_through: Notex.NoteTag
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
    |> validate_required([])
  end
end
