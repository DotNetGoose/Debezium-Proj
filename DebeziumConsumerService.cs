using Confluent.Kafka;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json;

namespace Debezium_Proj
{
    public class DebeziumConsumerService(ILogger<DebeziumConsumerService> logger, IConsumer<Ignore, string> consumer) : BackgroundService
    {
        private readonly ILogger<DebeziumConsumerService> _logger = logger;
        private readonly IConsumer<Ignore, string> _consumer = consumer;

        protected override async Task ExecuteAsync(CancellationToken cancellationToken)
        {
            _consumer.Subscribe("sqlserver.EmployeeTrainingDB.dbo.Employees");

            while (!cancellationToken.IsCancellationRequested)
            {
                var consumeResult = _consumer.Consume(cancellationToken);
                if (consumeResult.Message.Value != null)
                {
                    try
                    {
                        // Parse the message as JSON
                        var jsonMessage = JObject.Parse(consumeResult.Message.Value);

                        // Extract some key details for structured logging
                        var operation = jsonMessage["payload"]?["op"]?.ToString();
                        var tableName = jsonMessage["source"]?["table"]?.ToString();
                        var changeData = jsonMessage["payload"]?["after"]?.ToString(Formatting.Indented);

                        // Log the formatted message
                        _logger.LogInformation("Received {Operation} operation for table Employees. Data: {Data}",
                            operation, changeData);
                    }
                    catch (JsonReaderException ex)
                    {
                        _logger.LogError(ex, "Failed to parse Kafka message as JSON. Raw message: {Message}", consumeResult.Message.Value);
                    }
                }

                await Task.Delay(10, cancellationToken);
            }
        }
        public override void Dispose()
        {
            _consumer.Close();
            _consumer.Dispose();
            base.Dispose();
        }
    }
}
