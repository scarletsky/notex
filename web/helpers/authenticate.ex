defmodule Notex.Plug.Authenticate do
    import Plug.Conn
    import Notex.Router.Helpers
    import Phoenix.Controller

    def init(opts) do
        opts
    end

    def call(conn, opts) do
        current_user = get_session(conn, :current_user)
        if current_user do
            conn |> assign(:current_user, current_user)
        else
            conn
            |> put_flash(:error, "You should login first.")
            |> redirect(to: session_path(conn, :index))
        end
    end
end
