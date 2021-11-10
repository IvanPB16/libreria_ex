defmodule LibreriaEx.Router do

  defmacro live_router(path, opts \\ []) do
    quote bind_quoted: binding() do
      scope path, alias: false, as: false do
        import Phoenix.LiveView.Router, only: [live: 4]
        opts = LibreriaEx.Router.__options__(opts)

        # All helpers are public contracts and cannot be changed
        live "/", LibreriaEx.PageLive, :home, opts
        live "/:page", LibreriaEx.PageLive, :page, opts
      end
    end
  end

  def __options__(options) do
    live_socket_path = Keyword.get(options, :live_socket_path, "/live")

    csp_nonce_assign_key =
      case options[:csp_nonce_assign_key] do
        nil -> nil
        key when is_atom(key) -> %{img: key, style: key, script: key}
        %{} = keys -> Map.take(keys, [:img, :style, :script])
      end

    session_args = [
      csp_nonce_assign_key
    ]

    [
      session: {__MODULE__, :__session__, session_args},
      private: %{live_socket_path: live_socket_path, csp_nonce_assign_key: csp_nonce_assign_key},
      layout: {LibreriaEx.LayoutView, :root},
      as: :live_libreria_ex
    ]
  end

  def __session__(
        conn,
        csp_nonce_assign_key
      ) do

    {pages, requirements} =
      [
        home: {LibreriaEx.HomePage, %{}},
      ]
      |> Enum.map(fn {key, {module, opts}} ->
        {session, requirements} = initialize_page(module, opts)
        {{key, {module, session}}, requirements}
      end)
      |> Enum.unzip()

    %{
      "pages" => pages,
      "csp_nonces" => %{
        img: conn.assigns[csp_nonce_assign_key[:img]],
        style: conn.assigns[csp_nonce_assign_key[:style]],
        script: conn.assigns[csp_nonce_assign_key[:script]]
      }
    }
  end

  defp initialize_page(module, opts) do
    case module.init(opts) do
      {:ok, session} ->
        {session, []}

      {:ok, session, requirements} ->
        validate_requirements(module, requirements)
        {session, requirements}
    end
  end

  defp validate_requirements(module, requirements) do
    Enum.each(requirements, fn
      {key, value} when key in [:application, :module, :process] and is_atom(value) ->
        :ok

      other ->
        raise "unknown requirement #{inspect(other)} from #{inspect(module)}"
    end)
  end

end
