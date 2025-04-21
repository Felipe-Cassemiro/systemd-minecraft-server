#!/bin/bash

# Memory settings
XMS=2G   # Initial memory
XMX=4G   # Maximum memory

# Name of the Fabric server JAR file
FABRIC_JAR="fabric-server-launch.jar"

# Startup message
echo "🔧 Starting Fabric Minecraft Server 1.20.1..."
echo "🧠 Allocated Memory: Initial = $XMS / Maximum = $XMX"
echo "🚀 Running $FABRIC_JAR"

# Command to start the server
java -Xms$XMS -Xmx$XMX -jar $FABRIC_JAR nogui

# Shutdown message
echo "🛑 Server stopped."