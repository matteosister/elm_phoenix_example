defmodule ElmList.HomepageController do
  use ElmList.Web, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end
