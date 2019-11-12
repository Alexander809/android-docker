# Android Docker Images
Docker images for building and testing Android applications using the Android SDK.

# Images Available
There are 3 flavours of images provided:
* `sdk`: barebones OpenJDK 8 + Android SDK + platform tools
* `tools`: `sdk` + the latest android platform + build tools
* `ndk`: `sdk` + the latest NDK tools

The `latest` tag will point to the latest `sdk` image built.

## Sample Usage
Clone a Git repo and build the Android project:
```sh
docker run -it owahltinez/android:latest /bin/bash -c '\
    git clone https://github.com/android/plaid . && \
    ./gradlew assembleDebug'
```

Clone a Git repo and run linter followed by unit tests:
```sh
docker run -it owahltinez/android:latest /bin/bash -c '\
    git clone https://github.com/android/plaid . && \
    ./gradlew check'
```

## Build Instructions
```sh
PROJECT_NAME=docker-android

# Clone repo
git clone https://github.com/owahltinez/$PROJECT_NAME && cd $PROJECT_NAME

# Build the SDK image
FLAVOUR=sdk make build

# Build the tools image
FLAVOUR=tools make build

# Build the NDK image
FLAVOUR=ndk make build
```

The versions of the packages used are determined by the `.env` file in each of
the subfolders. Don't edit the `.env` files directly, instead edit the
`update_env.sh` script (if necessary) and then run `make env`:
```sh
# Edit the .env generating script (if needed)
vi $FLAVOUR/update_env.sh

# Generate the new .env file
FLAVOUR=$FLAVOUR make env

# Compare the .env files
git diff $FLAVOUR/.env
```