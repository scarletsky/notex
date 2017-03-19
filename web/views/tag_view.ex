defmodule Notex.TagView do
  use Notex.Web, :view

  def render("index.json", %{tags: tags}) do
    %{data: render_many(tags, Notex.TagView, "tag.json")}
  end

  def render("show.json", %{tag: tag}) do
    %{data: render_one(tag, Notex.TagView, "tag.json")}
  end

  def render("tag.json", %{tag: tag}) do
    %{id: tag.id}
  end
end
