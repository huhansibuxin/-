TARGET := iphone:clang:latest:14.0
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

LIBRARY_NAME = WCUnlock

WCUnlock_FILES = Tweak.xm
WCUnlock_CFLAGS = -fobjc-arc
WCUnlock_LDFLAGS = -dynamiclib
WCUnlock_INSTALL_TARGET_PROCESSES = com.tencent.xin

include $(THEOS_MAKE_PATH)/library.mk
