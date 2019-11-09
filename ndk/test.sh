#!/bin/sh

# Build an android sample app as a test
time docker run -it android:ndk /bin/bash -c '\
    git clone https://github.com/android/ndk-samples . && cd hello-jni && \
    ./gradlew assembleDebug -PCI --stacktrace'