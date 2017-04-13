defmodule Notex.Note do
  use Notex.Web, :model
  alias Notex.Repo

  schema "notes" do
    field :title, :string
    field :content, :string
    field :creator_id, :integer
    field :is_secret, :boolean
    many_to_many :tags, Notex.Tag, join_through: Notex.NoteTag, on_replace: :delete
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :content, :creator_id])
    |> put_assoc(:tags, parse_tags(params["tag_ids"]))
    |> validate_required([])
  end

  defp parse_tags(tag_ids) do
    (tag_ids || [])
    |> Enum.map(fn tid -> Repo.get(Notex.Tag, tid) end)
  end
end
