defmodule BillGeneratorTest do
  use ExUnit.Case
  doctest BillGenerator

  test "greets the world" do
    assert BillGenerator.hello() == :world
  end
end
