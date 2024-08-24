using Confluent.Kafka;

namespace Debezium_Proj
{
    public class DebeziumConsumerService(ILogger<DebeziumConsumerService> logger, IConsumer<Ignore, string> consumer) : BackgroundService
    {
        private readonly ILogger<DebeziumConsumerService> _logger = logger;
        private readonly IConsumer<Ignore, string> _consumer = consumer;

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            _consumer.Subscribe("sqlserver.EmployeeTrainingDB.dbo.Employees");

            while (!stoppingToken.IsCancellationRequested)
            {
                var consumeResult = _consumer.Consume(stoppingToken);
                if (consumeResult != null)
                {
                    _logger.LogInformation($"Received message: {consumeResult.Message.Value}");
                    // Process the message (e.g., update local cache, trigger actions, etc.)
                }

                await Task.Delay(1000, stoppingToken);
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
