FROM adoptopenjdk/openjdk8:alpine-slim

# Image arguments
ARG ANDROID_SDK_VERSION 

# Env variables
ENV HOME /root
ENV ANDROID_HOME /opt/android

# Install dependencies
RUN apk add --no-cache bash git unzip wget && \
    apk add --virtual .rundeps $runDeps && \
    rm -rf /tmp/* && \
    rm -rf /var/cache/apk/*

# Download and install Android SDK
WORKDIR $ANDROID_HOME
RUN echo "Installing Android SDK version: $ANDROID_SDK_VERSION" && \
    wget -q https://dl.google.com/android/repository/sdk-tools-linux-${ANDROID_SDK_VERSION}.zip \
    -O android-sdk-tools.zip && \
    unzip -qq android-sdk-tools.zip && \
    rm android-sdk-tools.zip

# Update PATH with SDK binaries
ENV ANDROID_SDK_ROOT $ANDROID_HOME
ENV PATH $PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools

# Accept the SDK license and install platform tools
WORKDIR $HOME/.android
RUN touch repositories.cfg && \
    yes | sdkmanager --licenses > /dev/null && \
    echo "Installing platform tools: LATEST" && \
    sdkmanager 'platform-tools' > /dev/null && \
    sdkmanager --update

# Add default Gradle config
COPY gradle.properties $HOME/.gradle/gradle.properties

# Start in $HOME/workspace
WORKDIR $HOME/workspace