.DEFAULT_TARGET = help

## help: Display list of commands
.PHONY: help
help: Makefile
	@sed -n 's|^##||p' $< | column -t -s ':' | sed -e 's|^| |'

## build: Build the OS image for a Raspberry Pi
.PHONY: build
build: export PI_HOSTNAME ?= raspberrypi
build: export PI_USERNAME ?= $(shell whoami)
build: export AUTHORIZED_KEYS_B64 = $(shell pass ssh/public-key | base64)
build: export WIFI_PASSWORD = $(shell pass wifi/password)
build: export WIFI_SSID = $(shell pass wifi/ssid)
build:
	vagrant up --provision-with=setup-build-env,build-image

## clean: Delete VM used for build
.PHONY: clean
clean:
	vagrant destroy --force
