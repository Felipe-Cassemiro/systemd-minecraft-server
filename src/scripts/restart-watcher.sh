#!/bin/bash

SERVICE="minecraft.service"
WATCHER="minecraft-watcher.service"

# Wait for Minecraft to stop
echo "Waiting for Minecraft to stop..."
while systemctl is-active --quiet "$SERVICE"; do
    sleep 3
done

# When Minecraft stops, restart the watcher
echo "Minecraft stopped. The watcher will start in 20 seconds..."

sleep 20

systemctl start "$WATCHER"