#!/bin/bash

echo "=== Android Emulator Docker Troubleshooting ==="
echo ""

# Check if container is running
echo "1. Checking container status..."
docker ps | grep android-emulator
if [ $? -eq 0 ]; then
    echo "✅ Container is running"
else
    echo "❌ Container is not running"
    echo "Run: docker-compose up -d"
    exit 1
fi

echo ""

# Check port accessibility
echo "2. Checking port accessibility..."
netstat -tlnp | grep 6080
if [ $? -eq 0 ]; then
    echo "✅ Port 6080 is listening"
else
    echo "❌ Port 6080 is not accessible"
fi

netstat -tlnp | grep 5901
if [ $? -eq 0 ]; then
    echo "✅ Port 5901 is listening"
else
    echo "❌ Port 5901 is not accessible"
fi

echo ""

# Check container logs
echo "3. Recent container logs:"
echo "--- VNC Logs ---"
docker exec android-emulator tail -n 10 /var/log/supervisor/vnc.log 2>/dev/null || echo "VNC logs not available"

echo ""
echo "--- noVNC Logs ---"
docker exec android-emulator tail -n 10 /var/log/supervisor/novnc.log 2>/dev/null || echo "noVNC logs not available"

echo ""
echo "--- Emulator Logs ---"
docker exec android-emulator tail -n 10 /var/log/supervisor/emulator.log 2>/dev/null || echo "Emulator logs not available"

echo ""

# Check processes inside container
echo "4. Processes running inside container:"
docker exec android-emulator ps aux | grep -E "(vnc|emulator|Xvfb)" | grep -v grep

echo ""

# Test VNC connection
echo "5. Testing VNC connection..."
curl -s http://localhost:6080 > /dev/null
if [ $? -eq 0 ]; then
    echo "✅ noVNC web interface is accessible"
else
    echo "❌ noVNC web interface is not accessible"
fi

echo ""
echo "=== Access URLs ==="
echo "Web VNC: http://localhost:6080"
echo "Direct VNC: localhost:5901"
echo ""
echo "=== Quick Fixes ==="
echo "1. Restart container: docker-compose restart"
echo "2. Rebuild container: docker-compose down && docker-compose up --build -d"
echo "3. Check firewall: sudo ufw status"
echo "4. Check browser console for errors (F12)"