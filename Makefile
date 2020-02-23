EFAULT_GOAL := help
HELP_INDENT := "10"

# ref: https://postd.cc/auto-documented-makefile/
.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-$(HELP_INDENT)s\033[0m %s\n", $$1, $$2}'

.PHONY: setup
setup: ## Install requirement development tools to system and setup (not include Xcode 11.3)
	brew bundle
	pre-commit install

.PHONY: build
build: ## swift - build
	swift build

.PHONY: test
test: ## swift - test
	swift test

.PHONY: xcode
xcode: ## swift - generate xcode project
	swift package generate-xcodeproj

.PHONY: format
format: ## format sources by SwiftFormat
	swiftformat --config .swiftformat .

.PHONY: lint
lint: ## cocoapods - lint podspec
	bundle exec pod lib lint

.PHONY: release
release: ## cocoapods - release
	bundle exec pod trunk push

.PHONY: info
info: ## cocoapods - show trunk information
	bundle exec pod trunk info SwiftPrettyPrint

.PHONY: integration-test
integration-test: ## Integration test by Example app
	cd ./Example && \
	bundle exec pod update && \
	bundle exec fastlane test

# ----------------
# Trouble shooting
# ----------------
#
# When release to CocoaPods are missed:
#
# ```
# $ pod trunk delete SwiftPrettyPrint {version}
# $ make push
# ```
