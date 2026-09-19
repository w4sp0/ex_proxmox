defmodule PVETest do
  use ExUnit.Case
  doctest PVE

  test "greets the world" do
    assert PVE.hello() == :world
  end
end
