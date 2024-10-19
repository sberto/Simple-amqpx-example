defmodule Client.Application do
  alias Amqpx.Helper
  import Supervisor.Spec, warn: false

  @app :client

  def start(_type, _args) do
    manager = get_child(:amqp_connection, &Helper.manager_supervisor_configuration/1)
    producer = get_child(:producer, &Helper.producer_supervisor_configuration/1)
    consumers = get_child(:consumers, &Helper.consumers_supervisor_configuration/1)

    children = [ manager, producer, consumers ] |> List.flatten()
    opts = [strategy: :one_for_one, name: Supervisor, max_restarts: 5] # set this accordingly with your consumers count, ex: max_restarts: n_consumer + 5
    Supervisor.start_link(children, opts)
  end

  defp get_child(key, helper_fun) do
    case Application.get_env(@app, key) do
      nil -> []
      config ->
        helper_fun.(config)
        |> case do
             [_|_] = children -> children
             child -> [child]
           end
    end
  end
end
