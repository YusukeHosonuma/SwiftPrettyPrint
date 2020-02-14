.PHONY: xcode
xcode:
	swift package generate-xcodeproj

.PHONY: build
build:
	swift build

.PHONY: test
test:
	swift test

format:
	swiftformat --config .swiftformat .
