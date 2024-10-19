defmodule Client do
  alias Amqpx.Gen.Producer

  def send_payload(payload) do
    Producer.publish("client_exchange", "to_cluster_node", payload)
  end
end
