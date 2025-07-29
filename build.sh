#!/bin/bash

echo "Building Android Emulator Docker Image..."
echo "This may take 15-30 minutes depending on your internet connection."

# Build the Docker image
docker build -t android-emulator:latest .

echo "Build completed!"
echo ""
echo "To run the container:"
echo "  docker-compose up -d"
echo ""
echo "Or run directly:"
echo "  docker run -d --privileged --device /dev/kvm -p 6080:6080 -p 5901:5901 android-emulator:latest"
echo ""
echo "Access the emulator:"
echo "  Web VNC: http://localhost:6080"
echo "  Direct VNC: localhost:5901"