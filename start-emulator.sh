#!/bin/bash

# Set environment variables
export ANDROID_HOME=/opt/android-sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator
export DISPLAY=:1

# Wait for X server and VNC to be ready
sleep 10

# Start Android emulator
cd /home/android
emulator -avd android11 -no-audio -no-window -gpu swiftshader_indirect -no-snapshot -wipe-data