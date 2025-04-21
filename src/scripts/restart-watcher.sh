#!/bin/bash

SERVICE="minecraft.service"
WATCHER="minecraft-watcher.service"

# Espera até o Minecraft parar
echo "Esperando o Minecraft parar..."
while systemctl is-active --quiet "$SERVICE"; do
    sleep 3
done

# Quando o Minecraft parar, reinicia o watcher
echo "Minecraft parou. O watcher será iniciado em 20 segundos..."

sleep 20

systemctl start "$WATCHER"