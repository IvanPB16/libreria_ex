defmodule LibreriaEx.PageNotFound do
  defexception [:message, plug_status: 404]
end

defmodule LibreriaEx.PageLive do
  @moduledoc false
  use LibreriaEx.Web, :live_view
  alias Phoenix.LiveView.Socket
  alias __MODULE__

  @impl true
  def mount(_arg0, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~L"""
      <h1>Hello world</h1>
    """
  end
end
