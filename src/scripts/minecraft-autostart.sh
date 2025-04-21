#!/bin/bash

PORTA=25565
SERVICE_NAME="minecraft.service"

echo "Aguardando conexão na porta $PORTA..."

# Escuta uma única conexão, então executa a lógica
if nc -l -p "$PORTA" > /dev/null; then
  if systemctl is-active --quiet "$SERVICE_NAME"; then
    echo "Servidor já está rodando."
  else
    echo "Iniciando servidor..."
    systemctl start "$SERVICE_NAME"
  fi
fi

exit 0