# Android 11 Emulator Docker Container

This Docker container provides an Android 11 emulator accessible via VNC on port 6080.

## Prerequisites

### System Requirements
- Linux host system (Ubuntu 20.04+ recommended)
- Docker and Docker Compose installed
- Hardware virtualization support (Intel VT-x or AMD-V)
- At least 4GB RAM available (8GB+ recommended)
- KVM support enabled

### Check KVM Support
```bash
# Check if KVM is available
kvm-ok

# If not available, enable virtualization in BIOS/UEFI
# Then load KVM modules:
sudo modprobe kvm
sudo modprobe kvm_intel  # For Intel processors
# OR
sudo modprobe kvm_amd    # For AMD processors
```

### Install Docker and Docker Compose
```bash
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Logout and login again to apply group changes
```

## Quick Start

### Method 1: Using Docker Compose (Recommended)
```bash
# Clone or download the project files
# Navigate to the project directory

# Build and start the container
chmod +x build.sh
./build.sh
docker-compose up -d

# Check container status
docker-compose logs -f
```

### Method 2: Manual Docker Commands
```bash
# Build the image
docker build -t android-emulator:latest .

# Run the container
docker run -d \
  --name android-emulator \
  --privileged \
  --device /dev/kvm \
  -p 6080:6080 \
  -p 5901:5901 \
  android-emulator:latest
```

## Accessing the Emulator

### Web-based VNC (Recommended)
Open your web browser and navigate to:
```
http://localhost:6080
```

### Direct VNC Client
Use any VNC client to connect to:
```
localhost:5901
```

## Container Management

### Start/Stop Container
```bash
# Using Docker Compose
docker-compose up -d      # Start
docker-compose down       # Stop

# Using Docker directly
docker start android-emulator    # Start
docker stop android-emulator     # Stop
docker rm android-emulator       # Remove
```

### View Logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f android-emulator

# Emulator logs specifically
docker exec android-emulator tail -f /var/log/supervisor/emulator.log
```

### Access Container Shell
```bash
docker exec -it android-emulator bash
```

## Troubleshooting

### Common Issues

1. **KVM Permission Denied**
   ```bash
   sudo chmod 666 /dev/kvm
   # Or add user to kvm group:
   sudo usermod -aG kvm $USER
   ```

2. **Container Won't Start**
   ```bash
   # Check if KVM is available
   ls -la /dev/kvm
   
   # Check container logs
   docker-compose logs
   ```

3. **Emulator is Slow**
   - Ensure hardware acceleration is enabled
   - Increase container memory allocation
   - Check host system resources

4. **VNC Connection Issues**
   ```bash
   # Check if ports are accessible
   netstat -tlnp | grep 6080
   netstat -tlnp | grep 5901
   ```

### Performance Optimization

1. **Increase Memory**
   Edit the AVD configuration in the Dockerfile:
   ```
   echo "hw.ramSize=4096" >> /home/android/.android/avd/android11.avd/config.ini
   ```

2. **Enable Hardware Acceleration**
   Ensure KVM is properly configured and the container has access to `/dev/kvm`

3. **Adjust Display Settings**
   Modify Xvfb resolution in supervisord.conf:
   ```
   command=/usr/bin/Xvfb :1 -screen 0 1920x1080x24 -ac +extension GLX +render -noreset
   ```

## Customization

### Change Android Version
Modify the Dockerfile to use different system images:
```dockerfile
# For Android 12 (API 31)
sdkmanager "system-images;android-31;google_apis;x86_64"
```

### Add Additional Tools
Add packages to the Dockerfile:
```dockerfile
RUN apt-get update && apt-get install -y \
    your-additional-package \
    && rm -rf /var/lib/apt/lists/*
```

## Security Notes

- This container runs in privileged mode for KVM access
- VNC server has no password by default (suitable for local development only)
- For production use, configure VNC authentication and use HTTPS

## Resource Usage

- **CPU**: 2-4 cores recommended
- **RAM**: 4-8GB recommended
- **Disk**: ~10GB for container and emulator
- **Network**: Ports 5901 and 6080

## Support

If you encounter issues:
1. Check the troubleshooting section
2. Review container logs
3. Ensure all prerequisites are met
4. Verify KVM support is enabled