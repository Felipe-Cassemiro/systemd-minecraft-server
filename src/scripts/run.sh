#!/bin/bash

# Configurações de memória
XMS=2G   # Memória inicial
XMX=4G   # Memória máxima

# Nome do arquivo JAR do servidor Fabric
FABRIC_JAR="fabric-server-launch.jar"

# Mensagem ao iniciar
echo "🔧 Iniciando servidor Fabric Minecraft 1.20.1..."
echo "🧠 Memória alocada: Inicial = $XMS / Máxima = $XMX"
echo "🚀 Executando $FABRIC_JAR"

# Comando para iniciar o servidor
java -Xms$XMS -Xmx$XMX -jar $FABRIC_JAR nogui

# Mensagem ao finalizar
echo "🛑 Servidor encerrado."