IMAGE_NAME=android
-include $(FLAVOUR)/.env

.PHONY: help

help:
	@echo "Android Docker image builder"
	@echo "Available flavours: sdk, tools, ndk"
	@echo ""
	@echo "Usage:"
	@echo "  [FLAVOUR=flavour] make env: Update versions in .env"
	@echo "  [FLAVOUR=flavour] make build: Build Docker image"
	@echo "  [FLAVOUR=flavour] make test: Runs Docker image tests"
	@echo "  [FLAVOUR=flavour] make clean: Kills and deletes all instances of Docker image"
	@echo "  [FLAVOUR=flavour DOCKER_REGISTRY=registry] make push: Push the Docker image registry"
	@echo ""


# Make env rules

env:
ifdef FLAVOUR
	sh "$(FLAVOUR)/update_env.sh" > "$(FLAVOUR)/.env"

else
	# We need the base image to be built before the rest
	(export FLAVOUR=sdk; rm -f "sdk/.env" && make env && make build)
	(export FLAVOUR=tools; rm -f "tools/.env" && make env)
	(export FLAVOUR=ndk; rm -f "ndk/.env" && make env)
endif

build:
ifdef FLAVOUR
	docker build $(FLAVOUR) \
		$(DOCKER_BUILD_OPTS) \
		--build-arg ANDROID_SDK_VERSION="$(ANDROID_SDK_VERSION)" \
		--build-arg BUILD_TOOLS_VERSION="$(BUILD_TOOLS_VERSION)" \
		--build-arg PLATFORM_VERSION="$(PLATFORM_VERSION)" \
		--build-arg NDK_VERSION="$(NDK_VERSION)" \
		--build-arg CMAKE_VERSION="$(CMAKE_VERSION)" \
		--tag "$(IMAGE_NAME):$(FLAVOUR)" \
		--tag "$(IMAGE_NAME):$(IMAGE_VERSION)"

else
	FLAVOUR=sdk make build
	FLAVOUR=tools make build
	FLAVOUR=ndk make build
	docker tag $(IMAGE_NAME):sdk $(IMAGE_NAME):latest
endif

test:
ifdef FLAVOUR
	$(FLAVOUR)/test.sh

else
	FLAVOUR=sdk make test
	FLAVOUR=tools make test
	FLAVOUR=ndk make test
	test.sh
endif

clean:
ifdef FLAVOUR
	rm -f $(FLAVOUR)/.env
	docker rmi -f "$(IMAGE_NAME):$(FLAVOUR)" || true
	docker rmi -f "$(IMAGE_NAME):$(IMAGE_VERSION)" || true

else
	FLAVOUR=sdk make clean
	FLAVOUR=tools make clean
	FLAVOUR=ndk make clean
	docker rmi -f "$(IMAGE_NAME):latest" || true
	docker system prune -af
endif

push:
ifndef FLAVOUR
	@echo "FLAVOUR env variable required for push"
	exit 1
endif
ifndef DOCKER_REGISTRY
	@echo "DOCKER_REGISTRY env variable required for push"
	exit 1
endif
	docker tag "$(IMAGE_NAME):$(FLAVOUR)" "$(DOCKER_REGISTRY)/$(IMAGE_NAME):$(FLAVOUR)"
	docker tag "$(IMAGE_NAME):$(FLAVOUR)" "$(DOCKER_REGISTRY)/$(IMAGE_NAME):$(IMAGE_VERSION)"
	docker push "$(DOCKER_REGISTRY)/$(IMAGE_NAME):$(FLAVOUR)"
	docker push "$(DOCKER_REGISTRY)/$(IMAGE_NAME):$(IMAGE_VERSION)"