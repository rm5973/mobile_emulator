#!/bin/bash

echo "=== Service Status Check ==="

# Check if container is running
echo "1. Container Status:"
docker ps | grep android-emulator

echo ""
echo "2. Service Processes:"
docker exec android-emulator ps aux | grep -E "(Xvfb|x11vnc|novnc|emulator|fluxbox)" | grep -v grep

echo ""
echo "3. Port Status:"
docker exec android-emulator netstat -tlnp | grep -E "(5901|6080)"

echo ""
echo "4. X Server Test:"
docker exec android-emulator bash -c 'export DISPLAY=:1 && xdpyinfo | head -5'

echo ""
echo "5. VNC Server Test:"
docker exec android-emulator bash -c 'ps aux | grep x11vnc | grep -v grep'

echo ""
echo "6. noVNC Process:"
docker exec android-emulator bash -c 'ps aux | grep novnc | grep -v grep'

echo ""
echo "7. Recent Logs:"
echo "--- Supervisor ---"
docker exec android-emulator tail -5 /var/log/supervisor/supervisord.log

echo ""
echo "--- VNC ---"
docker exec android-emulator tail -5 /var/log/supervisor/vnc.log 2>/dev/null || echo "No VNC logs"

echo ""
echo "--- noVNC ---"
docker exec android-emulator tail -5 /var/log/supervisor/novnc.log 2>/dev/null || echo "No noVNC logs"

echo ""
echo "--- Emulator ---"
docker exec android-emulator tail -5 /var/log/supervisor/emulator.log 2>/dev/null || echo "No emulator logs"

echo ""
echo "8. Test Web Access:"
curl -I http://localhost:6080 2>/dev/null || echo "Web interface not accessible"