defmodule LibreriaEx do
  @moduledoc """
  Documentation for `LibreriaEx`.
  """

  @doc false
  defmacro __using__(_) do
    quote do
      import LibreriaEx.Operaciones
    end
  end

end
