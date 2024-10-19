# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

config :client,
       amqp_connection: [
         username: "guest",
         password: "guest",
         host: "localhost",
         port: 5_000,
         virtual_host: "/",
         heartbeat: 30,
         connection_timeout: 10_000,
         obfuscate_password: false, # default is true
       ]

config :client, :producer, %{
  publisher_confirms: false,
  publish_timeout: 0,
  exchanges: [
    %{name: "client_exchange", type: :direct, opts: [durable: true]}
  ]
}

config :client, consumers: [
                  %{
                    handler_module: Client.Consumer,
                    prefetch_count: 100,
                    backoff: 10_000
                  }
]

config :client, Client.Consumer, %{
  queue: "client_queue",
  exchanges: [
    %{name: "cluster_node_exchange", type: :direct, routing_keys: [""], opts: [durable: true]}
  ],
  opts: [
    durable: true,
    arguments: [
    ]
  ]
}

######################################
config :cluster_node,
       amqp_connection: [
         username: "guest",
         password: "guest",
         host: "localhost",
         port: 5_000,
         virtual_host: "/",
         heartbeat: 30,
         connection_timeout: 10_000,
         obfuscate_password: false, # default is true
       ]

config :cluster_node, consumers:
  [
                        %{
                          handler_module: ClusterNode.DbWorkerConsumer,
                          prefetch_count: 100,
                          backoff: 10_000
                        },
                        %{
                          handler_module: ClusterNode.DataUpdateConsumer,
                          prefetch_count: 100,
                          backoff: 10_000
                        }
]


config :cluster_node, ClusterNode.DbWorkerConsumer, %{
  queue: "cluster_node_queue",
  exchanges: [
    %{name: "client_exchange", type: :direct, routing_keys: ["to_cluster_node"], opts: [durable: true]}
  ],
  opts: [
    durable: true,
    arguments: [
    ]
  ]
}

config :cluster_node, ClusterNode.DataUpdateConsumer, %{
  queue: "data_changed_queue",
  exchanges: [
    %{name: "data_changed", type: :fanout, opts: [durable: true]}
  ],
  opts: [
    durable: true,
    arguments: [
    ]
  ]
}

config :cluster_node, :producer, %{
  publisher_confirms: false,
  publish_timeout: 0,
  exchanges: [
    %{name: "data_changed", type: :fanout, opts: [durable: true]},
    %{name: "cluster_node_exchange", type: :direct, opts: [durable: true]},
  ]
}

