FROM android:sdk

# Image arguments
ARG NDK_VERSION
ARG CMAKE_VERSION

# Install NDK and CMake
RUN echo "Installing NDK version: $NDK_VERSION" && \
    yes | sdkmanager "ndk;$NDK_VERSION" > /dev/null && \
    echo "Installing CMAKE version: $CMAKE_VERSION" && \
    yes | sdkmanager "cmake;$CMAKE_VERSION" > /dev/null
ENV ANDROID_NDK_HOME "$ANDROID_SDK_ROOT/ndk/$NDK_VERSION"

# Start in $HOME/workspace
WORKDIR $HOME/workspace