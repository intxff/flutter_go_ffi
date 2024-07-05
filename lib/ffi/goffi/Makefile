MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
MKFILE_DIR := $(dir $(MKFILE_PATH))
MACOS_SDK_PATH = $(MKFILE_DIR)MacOSX14.2.sdk
TARGET_DIR := $(MKFILE_DIR)build
ANDROID_NDK_HOME := /home/icarus/Android/Sdk/ndk/26.1.10909125
BUILD_TAGS := "with_quic,with_dhcp,with_ech,with_utls,with_clash_api"

# libs of singbox
DESKTOP_DIR := $(MKFILE_DIR)cmd
ANDROID_DIR := $(MKFILE_DIR)android
VERSION := 1.9.0
lib_linux_amd64: 
	cd $(DESKTOP_DIR) && \
		go mod tidy && \
		CGO_ENABLED=1 \
		GOOS=linux \
		GOARCH=amd64 \
		CC="zig cc -target x86_64-linux-gnu.2.18" \
		CXX="zig c++ -target x86_64-linux-gnu.2.18" \
		go build -trimpath -buildmode=c-shared \
		-o $(TARGET_DIR)/libgoffi.so \
		main.go
lib_linux_arm64: 
	cd $(DESKTOP_DIR) && \
		go mod tidy && \
		CGO_ENABLED=1 \
		GOOS=linux \
		GOARCH=arm64 \
		PKG_CONFIG_LIBDIR=/usr/lib/aarch64-linux-gnu/pkgconfig \
		CC="zig cc -target aarch64-linux-gnu.2.18 -isystem /usr/include -L/usr/lib/aarch64-linux-gnu" \
		CXX="zig c++ -target aarch64-linux-gnu.2.18 -isystem /usr/include -L/usr/lib/aarch64-linux-gnu" \
		go build -trimpath -buildmode=c-shared \
		-ldflags "-X 'sing.LibVersion=$(VERSION)'" \
		-tags $(BUILD_TAGS) \
		-o $(TARGET_DIR)/libsingbox_linux_arm64_$(VERSION).so \
		main.go
lib_windows_amd64: 
	cd $(DESKTOP_DIR) && \
		go mod tidy && \
		CGO_ENABLED=1 \
		GOOS=windows \
		GOARCH=amd64 \
		CC="zig cc -target x86_64-windows-gnu" \
		CXX="zig c++ -target x86_64-windows-gnu" \
		go build -trimpath -buildmode=c-shared \
		-ldflags "-X 'sing.LibVersion=$(VERSION)'" \
		-tags $(BUILD_TAGS) \
		-o $(TARGET_DIR)/libsingbox_windows_amd64_$(VERSION).so \
		main.go
lib_macos_amd64: 
	cd $(DESKTOP_DIR) && \
		go mod tidy && \
		CGO_ENABLED=1 \
		GOOS=darwin \
		GOARCH=amd64 \
		CGO_LDFLAGS="--sysroot ${MACOS_SDK_PATH} -F/System/Library/Frameworks -L${MACOS_SDK_PATH}/usr/lib" \
		CC="zig cc -target x86_64-macos-none -isysroot ${MACOS_SDK_PATH} -iwithsysroot /usr/include -iframeworkwithsysroot /System/Library/Frameworks" \
		CXX="zig c++ -target x86_64-macos-none -isysroot ${MACOS_SDK_PATH} -iwithsysroot /usr/include -iframeworkwithsysroot /System/Library/Frameworks" \
		go build -trimpath -buildmode=c-shared \
		-o $(TARGET_DIR)/libgoffi_macos_amd64.so \
		main.go
lib_macos_arm64: 
	cd $(DESKTOP_DIR) && \
		go mod tidy && \
		CGO_ENABLED=1 \
		GOOS=darwin \
		GOARCH=arm64 \
		CGO_LDFLAGS="--sysroot ${MACOS_SDK_PATH} -F/System/Library/Frameworks -L${MACOS_SDK_PATH}/usr/lib" \
		CC="zig cc -target aarch64-macos-none -isysroot ${MACOS_SDK_PATH} -iwithsysroot /usr/include -iframeworkwithsysroot /System/Library/Frameworks" \
		CXX="zig c++ -target aarch64-macos-none -isysroot ${MACOS_SDK_PATH} -iwithsysroot /usr/include -iframeworkwithsysroot /System/Library/Frameworks" \
		go build -trimpath -buildmode=c-shared \
		-o $(TARGET_DIR)/libgoffi_macos_arm64.so \
		main.go
lib_android_aar:
	mkdir -p build
	cd $(ANDROID_DIR) && \
		go mod tidy && \
		go install golang.org/x/mobile/cmd/gomobile@latest && \
		go get golang.org/x/mobile/bind && \
		gomobile init && \
		ANDROID_NDK_HOME=$(ANDROID_NDK_HOME) gomobile bind \
		-trimpath \
		-ldflags "-X 'sing.LibVersion=$(VERSION)'" \
		-androidapi 21 \
		-target android \
		-tags $(BUILD_TAGS) \
		-javapkg "lib" \
		-o $(TARGET_DIR)/libsingbox_$(VERSION).aar "singbox"
