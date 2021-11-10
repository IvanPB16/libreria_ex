defmodule Curry do
  defmacro defc({name, context, args} = clause, do: expression) do
    body = create_fun(args, expression)

    quote do
      def unquote(clause), do: unquote(expression)
      def unquote({name, context, []}), do: unquote(body)
    end
  end

  defp create_fun([h | t], expression) do
    rest = create_fun(t, expression)
    quote do
      fn unquote(h) -> unquote(rest) end
    end
  end


  defp create_fun([], expression) do
    quote do
      unquote(expression)
    end
  end

end
