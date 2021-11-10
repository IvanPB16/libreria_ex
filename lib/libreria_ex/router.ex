defmodule LibreriaEx.Router do

  defmacro live_router(path, opts \\ []) do
    quote bind_quoted: binding() do
      scope path, alias: false, as: false do
        import Phoenix.LiveView.Router, only: [live: 4]
        opts = []

        # All helpers are public contracts and cannot be changed
        live "/", Phoenix.LiveDashboard.PageLive, :home, opts
      end
    end
  end

end
