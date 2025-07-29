#!/bin/bash

# Set environment variables
export ANDROID_HOME=/opt/android-sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator
export DISPLAY=:1
export ANDROID_AVD_HOME=/home/android/.android/avd

# Wait for X server and VNC to be ready
sleep 20

# Check if X server is running
while ! xdpyinfo -display :1 >/dev/null 2>&1; do
    echo "Waiting for X server..."
    sleep 2
done

# Ensure ADB server is running
adb start-server

# Check if AVD exists
if [ ! -d "/home/android/.android/avd/android11.avd" ]; then
    echo "Creating AVD..."
    echo "no" | avdmanager create avd \
        --force \
        --name "android11" \
        --package "system-images;android-30;google_apis;x86_64" \
        --tag "google_apis" \
        --abi "x86_64"
fi

# Start Android emulator
cd /home/android
echo "Starting Android emulator..."
emulator -avd android11 \
  -no-audio \
  -no-window \
  -gpu swiftshader_indirect \
  -no-snapshot \
  -netdelay none \
  -netspeed full \