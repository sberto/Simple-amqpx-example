defmodule Client.Consumer do
  @moduledoc nil
  @behaviour Amqpx.Gen.Consumer

  alias Amqpx.Basic
  alias Amqpx.Helper

  @config Application.get_env(:client, __MODULE__)
  @queue Application.get_env(:client, __MODULE__)[:queue]

  def setup(channel) do
    IO.inspect("Setting up consumer")
    # here you can declare your queues and exchanges
    Helper.declare(channel, @config)
    Basic.consume(channel, @queue, self()) # Don't forget to start consuming here!

    {:ok, %{}}
  end

  def handle_message(payload, meta, state) do
    IO.puts("Received message: #{payload}")
    {:ok, state}
  end
end