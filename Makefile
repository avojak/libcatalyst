SHELL := /bin/bash

BUILD_DIR        := build
NINJA_BUILD_FILE := $(BUILD_DIR)/build.ninja

.DEFAULT_GOAL := all

.PHONY: all
all: lib test

$(NINJA_BUILD_FILE):
	meson build --prefix=/usr -Ddocumentation=true

.PHONY: lib
lib: $(NINJA_BUILD_FILE)
	ninja -C $(BUILD_DIR)

.PHONY: test
test: $(NINJA_BUILD_FILE)
	ninja -C $(BUILD_DIR) test

.PHONY: install
install: $(NINJA_BUILD_FILE)
	ninja -C $(BUILD_DIR) install

.PHONY: lint
lint:
	io.elementary.vala-lint

.PHONY: lint-fix
lint-fix:
	io.elementary.vala-lint --fix

.PHONY: clean
clean:
	rm -rf $(BUILD_DIR) builddir/