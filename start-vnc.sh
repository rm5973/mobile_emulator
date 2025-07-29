#!/bin/bash

# Set display
export DISPLAY=:1

# Wait for X server to start
sleep 5

# Kill any existing VNC server
x11vnc -kill :1 2>/dev/null || true

# Start VNC server
x11vnc -display :1 -nopw -listen localhost -xkb -ncache 10 -ncache_cr -forever -shared