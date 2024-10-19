# Event Driven example

A simple example showing off the following architecture:

---

<p style="text-align:center;">Client &rarr; DbWorkerConsumer &rarr; DataUpdatedWorker &rarr; Client</p>

---

The idea is to simulate a simple CQRS system that could be containerized on docker using RabbitMQ as message broker.

* DbWorkerConsumer is the worker that listens to the queue and, for keep the project simple, simulate a database operation.
* DataUpdatedWorker is the worker that listens to the queue and, after a simulated update of the cache, sends the response to fanout. The Client is subscribed to the fanout and receives the response.

### Next steps
* Separate the listening consumer from the database worker