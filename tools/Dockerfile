FROM android:sdk

# Image arguments
ARG PLATFORM_VERSION
ARG BUILD_TOOLS_VERSION

# Install the latest platform and build tools
RUN echo "Installing platform version: $PLATFORM_VERSION" && \
    yes | sdkmanager "$PLATFORM_VERSION" > /dev/null && \
    echo "Installing build tools version: $BUILD_TOOLS_VERSION" && \
    yes | sdkmanager "$BUILD_TOOLS_VERSION" > /dev/null

# Start in $HOME/workspace
WORKDIR $HOME/workspace