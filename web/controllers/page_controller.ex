defmodule Notex.PageController do
  use Notex.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
