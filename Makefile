.PHONY: build build-win build-win-nsis build-mac install dev clean

ROOT := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
NODE_VERSION := 22.14.0
LOCAL_DIR := $(ROOT).local
DIST_URL := https://nodejs.org/dist/v$(NODE_VERSION)

UNAME_S := $(shell uname -s | tr '[:upper:]' '[:lower:]')
UNAME_M := $(shell uname -m)

ifeq ($(UNAME_S),darwin)
  ifeq ($(UNAME_M),arm64)
    NODE_OS_ARCH := darwin-arm64
  else ifeq ($(UNAME_M),x86_64)
    NODE_OS_ARCH := darwin-x64
  endif
else ifeq ($(UNAME_S),linux)
  ifeq ($(UNAME_M),x86_64)
    NODE_OS_ARCH := linux-x64
  else ifeq ($(UNAME_M),aarch64)
    NODE_OS_ARCH := linux-arm64
  endif
endif

ifndef NODE_OS_ARCH
  $(error Unsupported platform: $(UNAME_S) $(UNAME_M))
endif

NODE_TARBALL := node-v$(NODE_VERSION)-$(NODE_OS_ARCH).tar.gz
NODE_DIR := $(LOCAL_DIR)/node-v$(NODE_VERSION)-$(NODE_OS_ARCH)
NODE := $(NODE_DIR)/bin/node
NPM_CLI := $(NODE_DIR)/lib/node_modules/npm/bin/npm-cli.js
NPM := $(NODE) $(NPM_CLI)

# npm / node_modules/.bin の shebang (#!/usr/bin/env node) がローカル Node を使うようにする
export PATH := $(NODE_DIR)/bin:$(PATH)

build: build-win build-win-nsis build-mac

build-win: install
	$(NPM) run build:win

build-win-nsis: install
	$(NPM) run build:win-nsis

build-mac: install
	$(NPM) run build:mac

install: $(NODE)
	$(NPM) install

dev: install
	$(NPM) start

$(NODE):
	mkdir -p $(LOCAL_DIR)
	curl -fsSL $(DIST_URL)/$(NODE_TARBALL) -o $(LOCAL_DIR)/$(NODE_TARBALL)
	tar -xzf $(LOCAL_DIR)/$(NODE_TARBALL) -C $(LOCAL_DIR)
	rm -f $(LOCAL_DIR)/$(NODE_TARBALL)

clean:
	rm -rf $(LOCAL_DIR) node_modules dist build
