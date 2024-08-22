using Confluent.Kafka;
using Debezium_Proj;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Register Kafka Consumer and Background Service
builder.Services.AddSingleton<IConsumer<Ignore, string>>(sp =>
{
    var config = new ConsumerConfig
    {
        GroupId = "employee-training-group",
        BootstrapServers = "localhost:9092",
        AutoOffsetReset = AutoOffsetReset.Earliest
    };

    return new ConsumerBuilder<Ignore, string>(config).Build();
});

builder.Services.AddHostedService<DebeziumConsumerService>();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
