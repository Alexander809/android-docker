#!/bin/sh

# Build an android sample app as a test
time docker run -it android:tools /bin/bash -c '\
    git clone https://github.com/android/sunflower . && \
    ./gradlew assembleDebug -PCI --stacktrace'