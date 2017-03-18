defmodule Notex.Note do
  use Notex.Web, :model

  schema "notes" do
    field :title, :string
    field :content, :string
    field :creator_id, :string
    field :is_secret, :boolean
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
