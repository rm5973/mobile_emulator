#!/bin/bash

# Set display
export DISPLAY=:1

# Wait for X server to start
sleep 15

# Check if X server is running
while ! xdpyinfo -display :1 >/dev/null 2>&1; do
    echo "Waiting for X server to start..."
    sleep 2
done

# Kill any existing VNC server
x11vnc -kill :1 2>/dev/null || true

# Wait a bit more to ensure X server is fully ready
sleep 5

echo "Starting VNC server..."
# Start VNC server