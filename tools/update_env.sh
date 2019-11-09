#!/bin/sh

# NOTE: This script requires the SDK image to be available

PLATFORM_VERSION=$(docker run -it android:sdk /bin/bash -c \
    "sdkmanager --list | grep 'platforms;android-[0-9][0-9]' | sort | awk '{print \$1;}' \
        | tail -1 | tr -d '\r' | tr -d '\n'")
BUILD_TOOLS_VERSION=$(docker run -it android:sdk /bin/bash -c \
    "sdkmanager --list | grep 'build-tools;' | sort | awk '{print \$1;}' \
        | tail -1 | tr -d '\r' | tr -d '\n'")
IMAGE_VERSION=$(docker run -it android:sdk /bin/bash -c \
    "printf \"$BUILD_TOOLS_VERSION\" | cut -d';' -f 2 | tr -d '\r' | tr -d '\n'")

echo "PLATFORM_VERSION=$PLATFORM_VERSION"
echo "BUILD_TOOLS_VERSION=$BUILD_TOOLS_VERSION"
echo "IMAGE_VERSION=tools-$IMAGE_VERSION"