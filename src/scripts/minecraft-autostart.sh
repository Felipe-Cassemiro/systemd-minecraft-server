#!/bin/bash

PORTA=25565
SERVICE_NAME="minecraft.service"

echo "Waiting for connection on port $PORTA..."

# Listens for a single connection, then executes the logic
if nc -l -p "$PORTA" > /dev/null; then
  if systemctl is-active --quiet "$SERVICE_NAME"; then
    echo "Server is already running."
  else
    echo "Starting server..."
    systemctl start "$SERVICE_NAME"
  fi
fi

exit 0