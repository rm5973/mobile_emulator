#!/bin/bash

# Set display
export DISPLAY=:1

# Wait for X server to start
sleep 10

# Kill any existing VNC server
x11vnc -kill :1 2>/dev/null || true

# Wait a bit more to ensure X server is fully ready
sleep 2

# Start VNC server
x11vnc -display :1 -nopw -listen 0.0.0.0 -xkb -ncache 10 -ncache_cr -forever -shared -rfbport 5901