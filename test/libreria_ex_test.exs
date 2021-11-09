defmodule LibreriaExTest do
  use ExUnit.Case
  doctest LibreriaEx

  test "greets the world" do
    assert LibreriaEx.hello() == :world
  end
end
