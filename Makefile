#!/usr/bin/make -f

#-------------------------------------------------------------------------------
# Docker variables
#-------------------------------------------------------------------------------
DOCKER_IMAGE_NAME=fbarmes/rpi-prometheus
DOCKER_IMAGE_VERSION=$(shell cat VERSION)

#------------------------------------------------------------------------------
# script internals
#-------------------------------------------------------------------------------
#-- Absolute path to this Makefile
SCRIPT_DIR=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
PROMETHEUS_VERSION="2.5.0"
PROMETHEUS__URL="https://github.com/prometheus/prometheus/releases/download/v${PROMETHEUS_VERSION}/prometheus-${PROMETHEUS_VERSION}.linux-armv7.tar.gz"

#-------------------------------------------------------------------------------
# Default target (all)
#-------------------------------------------------------------------------------
.PHONY: all
all: echo deps docker

#-------------------------------------------------------------------------------
# clean target
#-------------------------------------------------------------------------------
.PHONY: clean
clean:
	rm -rf ${SCRIPT_DIR}/bin

#-------------------------------------------------------------------------------
# echo
#-------------------------------------------------------------------------------
echo:
	@echo "DOCKER_IMAGE_NAME=${DOCKER_IMAGE_NAME}"
	@echo "DOCKER_IMAGE_VERSION=${DOCKER_IMAGE_VERSION}"
	@echo "SCRIPT_DIR=${SCRIPT_DIR}"

#-------------------------------------------------------------------------------
# Gather dependencies
#-------------------------------------------------------------------------------
deps: bin/deps.done

bin/deps.done:
	mkdir -p ${SCRIPT_DIR}/bin
	wget ${PROMETHEUS__URL} --output-document ${SCRIPT_DIR}/bin/prometheus.tgz
	touch bin/deps.done

#-------------------------------------------------------------------------------
# Build docker image
#-------------------------------------------------------------------------------
docker:
	#-- register cpu emulation
	docker run --rm --privileged multiarch/qemu-user-static:register --reset

	#-- build image
	docker build \
	  --tag ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION} \
	  --file Dockerfile \
	  ${SCRIPT_DIR}

	#-- tag image as latest
	docker tag ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_VERSION} ${DOCKER_IMAGE_NAME}:latest
