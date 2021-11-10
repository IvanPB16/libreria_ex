defmodule CompileTime do
  defmacro compile() do
    IO.puts("Tiempo de compilación otra vez")
  end
end

defmodule LibreriaEx do
  require CompileTime
  CompileTime.compile()

  def sayHello(), do: IO.puts("Hello world")

end
