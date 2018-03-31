defmodule BrittleExUnitTest do
  use ExUnit.Case
  doctest BrittleExUnit

  test "greets the world" do
    assert BrittleExUnit.hello() == :world
  end
end
