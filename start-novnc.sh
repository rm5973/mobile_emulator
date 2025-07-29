#!/bin/bash

# Wait for VNC server to be ready
sleep 10

echo "Waiting for VNC server on port 5901..."
while ! nc -z localhost 5901; do
    echo "VNC server not ready, waiting..."
    sleep 2
done

echo "VNC server is ready, starting noVNC..."

# Start noVNC web server
cd /opt/novnc
./utils/novnc_proxy --vnc localhost:5901 --listen 0.0.0.0:6080 --web /opt/novnc