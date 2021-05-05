# makefile

SHELL = /bin/bash

build:
	hugo
.PHONY: build

init:
	git config --global user.email "${GIT_USER_EMAIL}"
	git config --global user.name "${GIT_USER_NAME}"
	git clone ${REPO} public
	rm -rf public/*
.PHONY: init

publish:
	cd public && \
		git add -A
	cd public && \
		git commit -a -m \
		"Rebuilding website: $(shell date +%Y-%M-%d) $(shell date +%H:%m:%S)"
	cd public && \
		git push origin ${MAIN_BRANCH}
.PHONY: publish
