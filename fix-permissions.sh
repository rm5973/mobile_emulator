#!/bin/bash

echo "Fixing common permission and access issues..."

# Fix KVM permissions
echo "1. Fixing KVM permissions..."
sudo chmod 666 /dev/kvm
sudo usermod -aG kvm $USER

# Check if user is in docker group
echo "2. Checking Docker group membership..."
groups $USER | grep docker
if [ $? -ne 0 ]; then
    echo "Adding user to docker group..."
    sudo usermod -aG docker $USER
    echo "Please logout and login again for group changes to take effect"
fi

# Restart Docker service
echo "3. Restarting Docker service..."
sudo systemctl restart docker

# Check firewall
echo "4. Checking firewall status..."
sudo ufw status
echo "If firewall is active, you may need to allow ports:"
echo "sudo ufw allow 6080"
echo "sudo ufw allow 5901"

echo ""
echo "Done! Now try rebuilding the container:"
echo "docker-compose down"
echo "docker-compose up --build -d"