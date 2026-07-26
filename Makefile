export TARGET = iphone:clang:latest:14.0
export ARCHS = arm64 arm64e

INSTALL_TARGET_PROCESSES = com.tencent.xin com.tencent.qy.xin
export THEOS_PACKAGE_SCHEME = rootless

TWEAK_NAME = WCUnlock

WCUnlock_FILES = Tweak.xm
WCUnlock_CFLAGS = -fobjc-arc

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
