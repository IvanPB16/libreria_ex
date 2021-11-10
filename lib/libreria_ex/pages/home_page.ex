defmodule LibreriaEx.HomePage do
  use LibreriaEx.PageBuilder

  def mount(_params, session, socket) do
  {:ok, socket}
  end

  #def render_page(_assigns), do: raise("this page is special cased to use render/2 instead")

  def render(assigns) do
    ~L"""
      <div class="message">
        <h1>Welcome to LibreriaEx</h1>
      </div>
    """
  end
end
