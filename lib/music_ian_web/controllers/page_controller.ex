defmodule MusicIanWeb.PageController do
  use MusicIanWeb, :controller

  def home(conn, _params) do
    # The home page uses the sidebar layout, which expects an @active_tab assign.
    # Since this is a static controller render, we pass it in the render options.
    render(conn, :home, layout: {MusicIanWeb.Layouts, :sidebar}, active_tab: :home)
  end
end
