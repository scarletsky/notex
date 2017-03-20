defmodule Notex.Note do
  use Notex.Web, :model

  schema "notes" do
    field :title, :string
    field :content, :string
    field :creator_id, :integer
    field :is_secret, :boolean
    many_to_many :tags, Notex.Tag, join_through: Notex.NoteTag
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :content, :creator_id])
    |> validate_required([])
  end
end
