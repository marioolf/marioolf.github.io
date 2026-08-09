SHELL := /usr/bin/env bash

.PHONY: setup-theme new-post serve build

setup-theme:
	git submodule update --init --recursive

new-post:
	@if [[ -z "$(TITLE)" ]]; then \
		echo 'Usage: make new-post TITLE="My New Post"'; \
		exit 1; \
	fi
	@./scripts/new-post.sh "$(TITLE)"

serve:
	hugo server -D

build:
	hugo