#!/bin/sh

# Kafka Connect endpoint
CONNECT_URL="http://localhost:8083"

# Path to the connector configuration file
CONNECTOR_CONFIG_FILE="/scripts/connector.json"

# Wait for the service at $1 to become available
HOST="localhost"
PORT="8083"
TIMEOUT=60

echo "Waiting for $HOST:$PORT to become available..."

# Wait for Kafka Connect to be ready using curl
until curl -s --head "$HOST:$PORT" | head -n 1 | grep "HTTP/1.[01] [23].." > /dev/null; do
  sleep 1
  TIMEOUT=$((TIMEOUT-1))
  if [ "$TIMEOUT" -le 0 ]; then
    echo "Timeout waiting for $HOST:$PORT"
    exit 1
  fi
done

echo "$HOST:$PORT is available"

# Create the connector
echo "Creating connector..."
curl -s -X POST -H "Content-Type: application/json" --data "@$CONNECTOR_CONFIG_FILE" $CONNECT_URL/connectors

echo "Connector setup complete."
