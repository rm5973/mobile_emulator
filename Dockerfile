FROM ubuntu:20.04

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Set environment variables
ENV ANDROID_HOME=/opt/android-sdk
ENV PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator
ENV DISPLAY=:1
ENV VNC_PORT=5901
ENV NOVNC_PORT=6080

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    unzip \
    openjdk-11-jdk \
    xvfb \
    x11vnc \
    fluxbox \
    supervisor \
    python3 \
    python3-pip \
    git \
    qemu-kvm \
    libvirt-daemon-system \
    libvirt-clients \
    bridge-utils \
    cpu-checker \
    pulseaudio \
    socat \
    x11-utils \
    netcat \
    && rm -rf /var/lib/apt/lists/*

# Install noVNC for web-based VNC access
RUN git clone https://github.com/novnc/noVNC.git /opt/novnc && \
    git clone https://github.com/novnc/websockify /opt/novnc/utils/websockify && \
    chmod +x /opt/novnc/utils/novnc_proxy && \
    ln -s /opt/novnc/vnc.html /opt/novnc/index.html

# Create android user
RUN useradd -m -s /bin/bash android && \
    usermod -aG kvm android && \
    usermod -aG audio android

# Create Android SDK directory
RUN mkdir -p $ANDROID_HOME && chown -R android:android $ANDROID_HOME

# Switch to android user
USER android
WORKDIR /home/android

# Download and install Android SDK Command Line Tools
RUN wget -q https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip -O cmdline-tools.zip && \
    unzip cmdline-tools.zip && \
    mkdir -p $ANDROID_HOME/cmdline-tools && \
    mv cmdline-tools $ANDROID_HOME/cmdline-tools/latest && \
    rm cmdline-tools.zip

# Accept licenses and install Android SDK components
RUN yes | sdkmanager --licenses && \
    sdkmanager "platform-tools" "platforms;android-30" "build-tools;30.0.3" && \
    sdkmanager "system-images;android-30;google_apis;x86_64" && \
    sdkmanager "emulator"

# Create AVD (Android Virtual Device)
RUN echo "no" | avdmanager create avd \
    --force \
    --name "android11" \
    --package "system-images;android-30;google_apis;x86_64" \
    --tag "google_apis" \
    --abi "x86_64"

# Configure AVD settings for better performance
RUN mkdir -p /home/android/.android/avd/android11.avd && \
    echo "hw.gpu.enabled=yes" >> /home/android/.android/avd/android11.avd/config.ini && \
    echo "hw.gpu.mode=swiftshader_indirect" >> /home/android/.android/avd/android11.avd/config.ini && \
    echo "hw.ramSize=2048" >> /home/android/.android/avd/android11.avd/config.ini && \
    echo "vm.heapSize=256" >> /home/android/.android/avd/android11.avd/config.ini && \
    echo "hw.keyboard=yes" >> /home/android/.android/avd/android11.avd/config.ini && \
    echo "hw.mainKeys=no" >> /home/android/.android/avd/android11.avd/config.ini

# Switch back to root for supervisor setup
USER root

# Create supervisor configuration
RUN mkdir -p /var/log/supervisor

# Copy configuration files
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY start-vnc.sh /usr/local/bin/start-vnc.sh
COPY start-emulator.sh /usr/local/bin/start-emulator.sh
COPY start-novnc.sh /usr/local/bin/start-novnc.sh

# Make scripts executable
RUN chmod +x /usr/local/bin/start-vnc.sh /usr/local/bin/start-emulator.sh /usr/local/bin/start-novnc.sh

# Expose VNC and noVNC ports
EXPOSE 5901 6080

# Set the default command
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]