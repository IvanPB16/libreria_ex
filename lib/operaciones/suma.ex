defmodule LibreriaEx.Operaciones do
  @moduledoc """
  The functions of this module can be used to perform basic operations.
  """
  def suma(number1, number2) do
    number1 + number2
  end

  def resta(number1, number2) do
    number1 - number2
  end

  def multiplicacion(number1, number2) do
    number1 * number2
  end

  def division(_number1, number2) when number2 == 0, do: 0

  def division(number1, number2) do
    number1 / number2
  end

end
