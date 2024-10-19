defmodule ClusterNode.DbWorkerConsumer do
  @moduledoc nil
  @behaviour Amqpx.Gen.Consumer

  alias Amqpx.Basic
  alias Amqpx.Helper

  @config Application.get_env(:cluster_node, __MODULE__)
  @queue Application.get_env(:cluster_node, __MODULE__)[:queue]

  def setup(channel) do
    IO.inspect("Setting up #{__MODULE__}")
    # here you can declare your queues and exchanges
    Helper.declare(channel, @config)
    Basic.consume(channel, @queue, self()) # Don't forget to start consuming here!

    {:ok, %{}}
  end

  def handle_message(payload, meta, state) do
    IO.puts("Received message: #{payload}")
    IO.puts("Change data...")
    :timer.sleep(1000)
    Amqpx.Gen.Producer.publish("data_changed", "", payload)
    IO.puts("Data changed!")
    {:ok, state}
  end
end