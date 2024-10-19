defmodule ClusterNodeTest do
  use ExUnit.Case
  doctest ClusterNode

  test "greets the world" do
    assert ClusterNode.hello() == :world
  end
end
