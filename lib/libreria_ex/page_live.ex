defmodule LibreriaEx.PageNotFound do
  defexception [:message, plug_status: 404]
end

defmodule LibreriaEx.PageLive do
  @moduledoc false
  use LibreriaEx.Web, :live_view
  alias Phoenix.LiveView.Socket
  alias LibreriaEx.PageBuilder
  alias __MODULE__

  defstruct links: [],
            nodes: [],
            refresher?: true,
            refresh: 15,
            refresh_options: for(i <- [1, 2, 5, 15, 30], do: {"#{i}s", i}),
            timer: nil

  @impl true
  def mount(%{"page" => page} = params, %{"pages" => pages} = session, socket) do
    case Enum.find(pages, :error, fn {key, _} -> Atom.to_string(key) == page end) do
      {_id, {module, page_session}} ->
        assign_mount(socket, module, pages, page_session, params, session)

      :error ->
        raise Phoenix.LiveDashboard.PageNotFound, "unknown page #{inspect(page)}"
    end
  end

  @impl true
  def mount(_arg0, _session, socket) do
    {:ok, socket}
  end

  defp assign_mount(socket, module, pages, page_session, params, session) do
    IO.inspect session
    %{
      "csp_nonces" => csp_nonces
    } = session

    page = %PageBuilder{module: module}
    socket = assign(socket, page: page, menu: %PageLive{}, csp_nonces: csp_nonces)

    with %Socket{redirected: nil} = socket <- assign_params(socket, params) do
      socket
      #|> init_schedule_refresh()
      |> maybe_apply_module(:mount, [params, page_session], &{:ok, &1})
    else
      %Socket{} = redirected_socket -> {:ok, redirected_socket}
    end
  end

  defp assign_params(socket, params) do
    update_page(socket, params: params, info: params["info"], route: route(params))
  end

  defp route(%{"page" => page}), do: String.to_existing_atom(page)

  defp update_page(socket, assigns) do
    update(socket, :page, fn page ->
      Enum.reduce(assigns, page, fn {key, value}, page ->
        Map.replace!(page, key, value)
      end)
    end)
  end

  # defp init_schedule_refresh(socket) do
  #   if connected?(socket) and socket.assigns.menu.refresher? do
  #     schedule_refresh(socket)
  #   else
  #     socket
  #   end
  # end

  defp maybe_apply_module(socket, fun, params, default) do
    if function_exported?(socket.assigns.page.module, fun, length(params) + 1) do
      apply(socket.assigns.page.module, fun, params ++ [socket])
    else
      default.(socket)
    end
  end

  @impl true
  def render(assigns) do
    ~L"""
      <div class="container">
        <h1>Un saludo desde la libreria de elixir</h1>
      </div>
    """
  end
end
